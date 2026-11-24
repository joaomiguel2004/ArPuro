import { createHash } from 'node:crypto';
import { initializeApp } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { logger } from 'firebase-functions';
import { onRequest } from 'firebase-functions/v2/https';

initializeApp();

const REGION = 'southamerica-east1';
const UPSTREAM_TIMEOUT_MS = 10_000;
const CACHE_FRESH_FOR_MS = 10 * 60_000;
const MAX_STALE_CACHE_MS = 24 * 60 * 60_000;
const CACHE_COLLECTION = 'airQualityCache';
const SOURCE_LABEL = 'Open-Meteo · estimativa do modelo CAMS ENSEMBLE';
const OPEN_METEO_URL = 'https://air-quality-api.open-meteo.com/v1/air-quality';

type Pollutant =
  | 'pm10'
  | 'pm25'
  | 'ozone'
  | 'carbonMonoxide'
  | 'nitrogenDioxide'
  | 'sulphurDioxide';

type BandId = 'good' | 'moderate' | 'poor' | 'veryPoor' | 'severe';
type RiskId = 'low' | 'moderate' | 'high' | 'critical';

interface HourlySample {
  time: Date;
  pm10: number | null;
  pm25: number | null;
  carbonMonoxide: number | null;
  nitrogenDioxide: number | null;
  sulphurDioxide: number | null;
  ozone: number | null;
}

interface Subindex {
  index: number;
  pollutant: Pollutant;
}

interface ForecastPoint {
  time: string;
  index: number;
  band: BandId;
}

interface Recommendation {
  category: 'activity' | 'sensitive_groups' | 'pollutant';
  title: string;
  description: string;
}

interface AirQualityResponse {
  index: number;
  band: BandId;
  bandDescription: string;
  risk: RiskId;
  riskGuidance: string;
  dominantPollutant: string;
  observedAt: string;
  isStale: boolean;
  sourceLabel: string;
  forecast: ForecastPoint[];
  recommendations: Recommendation[];
}

interface CachedResponse {
  response: AirQualityResponse;
  cachedAt: number;
}

interface Breakpoint {
  concentrationStart: number;
  concentrationEnd: number;
  indexStart: number;
  indexEnd: number;
}

const POLLUTANT_LABELS: Record<Pollutant, string> = {
  pm10: 'MP₁₀',
  pm25: 'MP₂,₅',
  ozone: 'Ozônio',
  carbonMonoxide: 'Monóxido de carbono',
  nitrogenDioxide: 'Dióxido de nitrogênio',
  sulphurDioxide: 'Dióxido de enxofre',
};

// Faixas da Orientação Técnica do IQAr do MMA (jan/2025), alinhada à
// Resolução CONAMA 506/2024. Concentrações são arredondadas antes do cálculo.
const BREAKPOINTS: Record<Pollutant, Breakpoint[]> = {
  pm10: [
    { concentrationStart: 0, concentrationEnd: 45, indexStart: 0, indexEnd: 40 },
    { concentrationStart: 46, concentrationEnd: 100, indexStart: 41, indexEnd: 80 },
    { concentrationStart: 101, concentrationEnd: 150, indexStart: 81, indexEnd: 120 },
    { concentrationStart: 151, concentrationEnd: 250, indexStart: 121, indexEnd: 200 },
    { concentrationStart: 251, concentrationEnd: 600, indexStart: 201, indexEnd: 400 },
  ],
  pm25: [
    { concentrationStart: 0, concentrationEnd: 15, indexStart: 0, indexEnd: 40 },
    { concentrationStart: 16, concentrationEnd: 50, indexStart: 41, indexEnd: 80 },
    { concentrationStart: 51, concentrationEnd: 75, indexStart: 81, indexEnd: 120 },
    { concentrationStart: 76, concentrationEnd: 125, indexStart: 121, indexEnd: 200 },
    { concentrationStart: 126, concentrationEnd: 300, indexStart: 201, indexEnd: 400 },
  ],
  ozone: [
    { concentrationStart: 0, concentrationEnd: 100, indexStart: 0, indexEnd: 40 },
    { concentrationStart: 101, concentrationEnd: 130, indexStart: 41, indexEnd: 80 },
    { concentrationStart: 131, concentrationEnd: 160, indexStart: 81, indexEnd: 120 },
    { concentrationStart: 161, concentrationEnd: 200, indexStart: 121, indexEnd: 200 },
    { concentrationStart: 201, concentrationEnd: 800, indexStart: 201, indexEnd: 400 },
  ],
  carbonMonoxide: [
    { concentrationStart: 0, concentrationEnd: 9, indexStart: 0, indexEnd: 40 },
    { concentrationStart: 9.1, concentrationEnd: 11, indexStart: 41, indexEnd: 80 },
    { concentrationStart: 11.1, concentrationEnd: 13, indexStart: 81, indexEnd: 120 },
    { concentrationStart: 13.1, concentrationEnd: 15, indexStart: 121, indexEnd: 200 },
    { concentrationStart: 15.1, concentrationEnd: 50, indexStart: 201, indexEnd: 400 },
  ],
  nitrogenDioxide: [
    { concentrationStart: 0, concentrationEnd: 200, indexStart: 0, indexEnd: 40 },
    { concentrationStart: 201, concentrationEnd: 240, indexStart: 41, indexEnd: 80 },
    { concentrationStart: 241, concentrationEnd: 320, indexStart: 81, indexEnd: 120 },
    { concentrationStart: 321, concentrationEnd: 1130, indexStart: 121, indexEnd: 200 },
    { concentrationStart: 1131, concentrationEnd: 3750, indexStart: 201, indexEnd: 400 },
  ],
  sulphurDioxide: [
    { concentrationStart: 0, concentrationEnd: 40, indexStart: 0, indexEnd: 40 },
    { concentrationStart: 41, concentrationEnd: 50, indexStart: 41, indexEnd: 80 },
    { concentrationStart: 51, concentrationEnd: 125, indexStart: 81, indexEnd: 120 },
    { concentrationStart: 126, concentrationEnd: 800, indexStart: 121, indexEnd: 200 },
    { concentrationStart: 801, concentrationEnd: 2620, indexStart: 201, indexEnd: 400 },
  ],
};

export const airQuality = onRequest(
  {
    region: REGION,
    cors: true,
    timeoutSeconds: 20,
    maxInstances: 10,
  },
  async (request, response) => {
    response.set('Cache-Control', 'no-store');
    if (request.method !== 'GET') {
      response.set('Allow', 'GET').status(405).json({ error: 'method_not_allowed' });
      return;
    }

    const latitude = parseCoordinate(request.query.latitude, -90, 90);
    const longitude = parseCoordinate(request.query.longitude, -180, 180);
    if (latitude === null || longitude === null) {
      response.status(400).json({
        error: 'invalid_coordinates',
        message: 'Informe latitude e longitude válidas em WGS84.',
      });
      return;
    }

    const cacheId = cacheKey(latitude, longitude);
    const cached = await readCache(cacheId);
    const cacheAge = cached === null
      ? Number.POSITIVE_INFINITY
      : Math.max(0, Date.now() - cached.cachedAt);

    if (cached !== null && cacheAge < CACHE_FRESH_FOR_MS) {
      response.status(200).json(withCurrentStaleness(cached.response));
      return;
    }

    try {
      const result = await fetchAndCalculate(latitude, longitude);
      await writeCache(cacheId, result);
      response.status(200).json(result);
    } catch (error) {
      logger.warn('Falha ao atualizar a qualidade do ar.', {
        error: error instanceof Error ? error.message : String(error),
      });
      if (cached !== null && cacheAge <= MAX_STALE_CACHE_MS) {
        response.status(200).json({ ...cached.response, isStale: true });
        return;
      }
      response.status(502).json({
        error: 'air_quality_unavailable',
        message: 'Não foi possível obter dados de qualidade do ar neste momento.',
      });
    }
  },
);

async function fetchAndCalculate(
  latitude: number,
  longitude: number,
): Promise<AirQualityResponse> {
  const url = new URL(OPEN_METEO_URL);
  url.search = new URLSearchParams({
    latitude: String(latitude),
    longitude: String(longitude),
    hourly: 'pm10,pm2_5,carbon_monoxide,nitrogen_dioxide,sulphur_dioxide,ozone',
    past_days: '2',
    forecast_days: '1',
    timezone: 'auto',
  }).toString();

  const upstream = await fetch(url, {
    signal: AbortSignal.timeout(UPSTREAM_TIMEOUT_MS),
    headers: { Accept: 'application/json' },
  });
  if (!upstream.ok) {
    throw new Error(`Open-Meteo respondeu com HTTP ${upstream.status}.`);
  }

  const payload = asObject(await upstream.json());
  const hourly = asObject(payload.hourly);
  const offsetSeconds = typeof payload.utc_offset_seconds === 'number'
    ? payload.utc_offset_seconds
    : 0;
  const samples = parseSamples(hourly, offsetSeconds);
  if (samples.length === 0) {
    throw new Error('Open-Meteo não retornou amostras horárias válidas.');
  }

  const now = new Date();
  const currentTarget = latestSampleAtOrBefore(samples, now);
  if (currentTarget === null) {
    throw new Error('Não há amostras atuais para calcular o IQAr.');
  }
  const current = calculateAt(samples, currentTarget);
  if (current === null) {
    throw new Error('Ainda não há horas suficientes para calcular o IQAr.');
  }

  const forecast: ForecastPoint[] = [];
  for (const hoursAhead of [3, 6, 9, 12]) {
    const target = new Date(currentTarget.getTime() + hoursAhead * 60 * 60_000);
    const projection = calculateAt(samples, target);
    if (projection !== null) {
      forecast.push({
        time: projection.observedAt.toISOString(),
        index: projection.index,
        band: bandForIndex(projection.index),
      });
    }
  }

  const band = bandForIndex(current.index);
  const risk = riskForIndex(current.index);
  const observedAt = current.observedAt;
  return {
    index: current.index,
    band,
    bandDescription: bandDescription(band),
    risk,
    riskGuidance: riskGuidance(risk),
    dominantPollutant: POLLUTANT_LABELS[current.pollutant],
    observedAt: observedAt.toISOString(),
    isStale: now.getTime() - observedAt.getTime() > 2 * 60 * 60_000,
    sourceLabel: SOURCE_LABEL,
    forecast,
    recommendations: recommendationsFor(band, current.pollutant, current.index),
  };
}

function parseSamples(
  hourly: Record<string, unknown>,
  utcOffsetSeconds: number,
): HourlySample[] {
  const times = Array.isArray(hourly.time) ? hourly.time : [];
  const pm10 = asArray(hourly.pm10);
  const pm25 = asArray(hourly.pm2_5);
  const carbonMonoxide = asArray(hourly.carbon_monoxide);
  const nitrogenDioxide = asArray(hourly.nitrogen_dioxide);
  const sulphurDioxide = asArray(hourly.sulphur_dioxide);
  const ozone = asArray(hourly.ozone);

  return times.flatMap((value, index) => {
    if (typeof value !== 'string') return [];
    const localTimestamp = Date.parse(`${value}:00Z`);
    if (!Number.isFinite(localTimestamp)) return [];
    return [{
      time: new Date(localTimestamp - utcOffsetSeconds * 1000),
      pm10: numberAt(pm10, index),
      pm25: numberAt(pm25, index),
      carbonMonoxide: numberAt(carbonMonoxide, index),
      nitrogenDioxide: numberAt(nitrogenDioxide, index),
      sulphurDioxide: numberAt(sulphurDioxide, index),
      ozone: numberAt(ozone, index),
    }];
  }).sort((a, b) => a.time.getTime() - b.time.getTime());
}

function calculateAt(
  samples: HourlySample[],
  target: Date,
): { index: number; pollutant: Pollutant; observedAt: Date } | null {
  const subindices: Subindex[] = [];
  const pm10 = averageFor(samples, target, 24, (sample) => sample.pm10);
  if (pm10 !== null) addSubindex(subindices, 'pm10', pm10);
  const pm25 = averageFor(samples, target, 24, (sample) => sample.pm25);
  if (pm25 !== null) addSubindex(subindices, 'pm25', pm25);
  // A resolução define O3 e CO pela máxima média móvel de 8h do dia,
  // e NO2 pela máxima média horária; usamos a janela móvel das últimas 24h.
  const ozone = maximumRollingAverageFor(
    samples,
    target,
    24,
    8,
    (sample) => sample.ozone,
  );
  if (ozone !== null) addSubindex(subindices, 'ozone', ozone);
  const carbonMonoxide = maximumRollingAverageFor(
    samples,
    target,
    24,
    8,
    (sample) => sample.carbonMonoxide,
  );
  if (carbonMonoxide !== null) {
    // Open-Meteo returns CO in µg/m³; the Brazilian IQAr table uses ppm.
    addSubindex(subindices, 'carbonMonoxide', carbonMonoxide / 1145);
  }
  const nitrogenDioxide = maximumFor(
    samples,
    target,
    24,
    (sample) => sample.nitrogenDioxide,
  );
  if (nitrogenDioxide !== null) {
    addSubindex(subindices, 'nitrogenDioxide', nitrogenDioxide);
  }
  const sulphurDioxide = averageFor(
    samples,
    target,
    24,
    (sample) => sample.sulphurDioxide,
  );
  if (sulphurDioxide !== null) {
    addSubindex(subindices, 'sulphurDioxide', sulphurDioxide);
  }
  if (subindices.length === 0) return null;
  subindices.sort((a, b) => b.index - a.index);

  const observedAt = latestSampleAtOrBefore(samples, target);
  if (observedAt === null) return null;
  return {
    index: subindices[0].index,
    pollutant: subindices[0].pollutant,
    observedAt,
  };
}

function averageFor(
  samples: HourlySample[],
  target: Date,
  hours: number,
  select: (sample: HourlySample) => number | null,
): number | null {
  const start = target.getTime() - hours * 60 * 60_000;
  const values = samples
    .filter((sample) => sample.time.getTime() > start && sample.time <= target)
    .map(select);
  if (values.length !== hours || values.some((value) => value === null)) {
    return null;
  }
  return values.reduce<number>((sum, value) => sum + (value ?? 0), 0) / hours;
}

function maximumRollingAverageFor(
  samples: HourlySample[],
  target: Date,
  windowHours: number,
  hours: number,
  select: (sample: HourlySample) => number | null,
): number | null {
  const start = target.getTime() - windowHours * 60 * 60_000;
  const averages: number[] = [];
  for (const sample of samples) {
    if (sample.time.getTime() < start || sample.time > target) continue;
    const average = averageFor(samples, sample.time, hours, select);
    if (average !== null) averages.push(average);
  }
  return averages.length === 0 ? null : Math.max(...averages);
}

function maximumFor(
  samples: HourlySample[],
  target: Date,
  hours: number,
  select: (sample: HourlySample) => number | null,
): number | null {
  const start = target.getTime() - hours * 60 * 60_000;
  const values = samples
    .filter((sample) => sample.time.getTime() > start && sample.time <= target)
    .map(select)
    .filter((value): value is number => value !== null);
  return values.length === 0 ? null : Math.max(...values);
}

function addSubindex(
  result: Subindex[],
  pollutant: Pollutant,
  rawConcentration: number,
): void {
  const index = indexFor(pollutant, rawConcentration);
  if (index !== null) result.push({ index, pollutant });
}

function indexFor(pollutant: Pollutant, rawConcentration: number): number | null {
  if (!Number.isFinite(rawConcentration) || rawConcentration < 0) return null;
  const concentration = roundConcentration(
    rawConcentration,
    pollutant === 'carbonMonoxide',
  );
  const ranges = BREAKPOINTS[pollutant];
  if (concentration > ranges[ranges.length - 1].concentrationEnd) return 400;

  for (const range of ranges) {
    if (
      concentration >= range.concentrationStart &&
      concentration <= range.concentrationEnd
    ) {
      const interpolated = range.indexStart +
        ((range.indexEnd - range.indexStart) /
          (range.concentrationEnd - range.concentrationStart)) *
        (concentration - range.concentrationStart);
      return roundHalfToEven(interpolated);
    }
  }
  return null;
}

function roundConcentration(value: number, oneDecimal: boolean): number {
  return oneDecimal
    ? roundHalfToEven(value * 10) / 10
    : roundHalfToEven(value);
}

function roundHalfToEven(value: number): number {
  const lower = Math.floor(value);
  const fraction = value - lower;
  if (Math.abs(fraction - 0.5) < 1e-9) {
    return lower % 2 === 0 ? lower : lower + 1;
  }
  return Math.round(value);
}

function bandForIndex(index: number): BandId {
  if (index <= 40) return 'good';
  if (index <= 80) return 'moderate';
  if (index <= 120) return 'poor';
  if (index <= 200) return 'veryPoor';
  return 'severe';
}

function riskForIndex(index: number): RiskId {
  if (index <= 40) return 'low';
  if (index <= 80) return 'moderate';
  if (index <= 120) return 'high';
  return 'critical';
}

function bandDescription(band: BandId): string {
  switch (band) {
    case 'good':
      return 'Qualidade boa na escala brasileira do IQAr.';
    case 'moderate':
      return 'Grupos sensíveis podem apresentar tosse seca e cansaço.';
    case 'poor':
      return 'Toda a população pode apresentar sintomas; grupos sensíveis podem ter efeitos mais sérios.';
    case 'veryPoor':
      return 'Toda a população pode apresentar agravamento dos sintomas; grupos sensíveis podem ter efeitos ainda mais graves.';
    case 'severe':
      return 'Há risco de manifestações graves de doenças respiratórias e cardiovasculares, especialmente para grupos sensíveis.';
  }
}

function riskGuidance(risk: RiskId): string {
  switch (risk) {
    case 'low':
      return 'Mantenha os cuidados habituais e acompanhe as atualizações do índice.';
    case 'moderate':
      return 'Pessoas sensíveis devem observar sintomas como tosse seca e cansaço.';
    case 'high':
      return 'Reduza a exposição prolongada ao ar livre e fique atento a sintomas respiratórios.';
    case 'critical':
      return 'Evite atividades ao ar livre e siga as orientações das autoridades de saúde.';
  }
}

function recommendationsFor(
  band: BandId,
  pollutant: Pollutant,
  index: number,
): Recommendation[] {
  const activityDescription: Record<BandId, string> = {
    good: 'As condições são favoráveis às atividades habituais ao ar livre.',
    moderate: 'Considere reduzir esforço prolongado ao ar livre se houver desconforto.',
    poor: 'Reduza o esforço prolongado ao ar livre; pessoas sensíveis devem limitar a exposição.',
    veryPoor: 'Evite atividades prolongadas ao ar livre e reduza a exposição à poluição.',
    severe: 'Evite atividades ao ar livre e acompanhe os alertas das autoridades locais.',
  };
  const sensitiveGroupsDescription: Record<BandId, string> = {
    good: 'Não são esperados efeitos relevantes à saúde nesta faixa do IQAr.',
    moderate: 'Crianças, idosos e pessoas com doenças respiratórias ou cardíacas podem sentir tosse seca e cansaço.',
    poor: 'Grupos sensíveis podem apresentar efeitos mais sérios; procure orientação de saúde se os sintomas piorarem.',
    veryPoor: 'Grupos sensíveis devem reduzir a exposição; procure atendimento se houver falta de ar ou piora dos sintomas.',
    severe: 'Grupos sensíveis têm maior risco de efeitos graves; siga orientações das autoridades de saúde.',
  };

  return [
    {
      category: 'activity',
      title: 'Atividades ao ar livre',
      description: activityDescription[band],
    },
    {
      category: 'sensitive_groups',
      title: 'Grupos sensíveis',
      description: sensitiveGroupsDescription[band],
    },
    {
      category: 'pollutant',
      title: 'Poluente com maior subíndice',
      description: `${POLLUTANT_LABELS[pollutant]} determinou o maior subíndice do IQAr (${index}) nesta estimativa.`,
    },
  ];
}

function latestSampleAtOrBefore(
  samples: HourlySample[],
  target: Date,
): Date | null {
  for (let index = samples.length - 1; index >= 0; index -= 1) {
    if (samples[index].time <= target) return samples[index].time;
  }
  return null;
}

function parseCoordinate(value: unknown, min: number, max: number): number | null {
  if (typeof value !== 'string' || value.trim() === '') return null;
  const coordinate = Number(value);
  if (!Number.isFinite(coordinate) || coordinate < min || coordinate > max) {
    return null;
  }
  return coordinate;
}

function cacheKey(latitude: number, longitude: number): string {
  const roundedCoordinates = `${latitude.toFixed(3)}|${longitude.toFixed(3)}`;
  return createHash('sha256').update(roundedCoordinates).digest('hex');
}

function withCurrentStaleness(
  cached: AirQualityResponse,
): AirQualityResponse {
  const observedAt = Date.parse(cached.observedAt);
  return {
    ...cached,
    isStale: cached.isStale ||
      !Number.isFinite(observedAt) ||
      Date.now() - observedAt > 2 * 60 * 60_000,
  };
}

async function readCache(cacheId: string): Promise<CachedResponse | null> {
  try {
    const snapshot = await getFirestore()
      .collection(CACHE_COLLECTION)
      .doc(cacheId)
      .get();
    if (!snapshot.exists) return null;
    const data = snapshot.data();
    if (
      data === undefined ||
      typeof data.cachedAt !== 'number' ||
      data.response === undefined
    ) {
      return null;
    }
    return {
      response: data.response as AirQualityResponse,
      cachedAt: data.cachedAt,
    };
  } catch (error) {
    logger.warn('Cache Firestore indisponível para qualidade do ar.', {
      error: error instanceof Error ? error.message : String(error),
    });
    return null;
  }
}

async function writeCache(
  cacheId: string,
  response: AirQualityResponse,
): Promise<void> {
  try {
    await getFirestore().collection(CACHE_COLLECTION).doc(cacheId).set({
      response,
      cachedAt: Date.now(),
    });
  } catch (error) {
    logger.warn('Não foi possível persistir o cache do IQAr.', {
      error: error instanceof Error ? error.message : String(error),
    });
  }
}

function asObject(value: unknown): Record<string, unknown> {
  if (value === null || typeof value !== 'object' || Array.isArray(value)) {
    throw new Error('Resposta JSON inválida da fonte de qualidade do ar.');
  }
  return value as Record<string, unknown>;
}

function asArray(value: unknown): unknown[] {
  return Array.isArray(value) ? value : [];
}

function numberAt(values: unknown[], index: number): number | null {
  const value = values[index];
  return typeof value === 'number' && Number.isFinite(value) && value >= 0
    ? value
    : null;
}
