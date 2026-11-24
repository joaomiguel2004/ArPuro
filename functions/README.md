# Backend do IQAr do ArPuro

A função HTTP `airQuality` recebe latitude e longitude, consulta as variáveis
horárias do Open-Meteo no servidor, calcula o IQAr brasileiro e devolve a faixa,
o risco, as recomendações de saúde e os pontos da previsão. O último resultado
por localização é persistido no Firestore; se a fonte falhar, a função devolve
esse resultado com `isStale: true` por até 24 horas. Depois desse limite, informa
indisponibilidade em vez de exibir um índice antigo demais.

O cálculo segue a Orientação Técnica do IQAr do MMA (janeiro de 2025), associada
à Resolução CONAMA nº 506/2024. Como a fonte configurada é uma estimativa do
modelo CAMS via Open-Meteo, o resultado não deve ser apresentado como medição
oficial de uma estação.

## Emulador local

Instale Node.js 22, Firebase CLI e JDK 21 ou superior. O emulador do Firestore
usa Java; versões anteriores ao Java 21 não são aceitas pela versão atual do
Firebase CLI. Compile as Functions antes de iniciar os emuladores:

```powershell
cd functions
npm install
npm run build
cd ..
firebase emulators:start --project demo-arpuro --only functions,firestore
```

No Android Emulator, abra um segundo terminal na raiz do projeto e inicie o app
com a URL do backend:

```powershell
flutter run --dart-define=AIR_QUALITY_API_URL=http://10.0.2.2:5001/demo-arpuro/southamerica-east1/airQuality
```

`10.0.2.2` é o endereço do computador host visto pelo Android Emulator. Em um
aparelho Android físico, conecte o celular e o computador ao mesmo Wi-Fi e use
o IPv4 do computador (consulte `ipconfig`). Por exemplo, troque o endereço da
URL pelo IP local, como neste comando:

```powershell
flutter run --dart-define=AIR_QUALITY_API_URL=http://192.168.1.34:5001/demo-arpuro/southamerica-east1/airQuality
```

Substitua `192.168.1.34` pelo IPv4 real do computador. O emulador de Functions
está vinculado à rede local para esse teste; permita a porta 5001 no Firewall
do Windows se solicitado e faça isso apenas em uma rede privada confiável.

O `--dart-define` é obrigatório: o app mostra “serviço de qualidade do ar ainda
não foi configurado” quando a URL não é passada ao iniciar/compilar. Se executar
pelo botão Run do IDE, inclua o mesmo argumento na configuração de execução.
HTTP sem TLS fica habilitado apenas nos builds de debug; a versão publicada deve
usar HTTPS. Para iOS Simulator ou desktop, use `127.0.0.1`.

## Implantação

Associe um projeto Firebase com `firebase use <project-id>`, habilite o Cloud
Firestore e implante com `firebase deploy --only functions:airQuality`. A
implantação do Cloud Functions exige o plano Blaze vinculado a uma conta de
cobrança; configure alertas de orçamento antes de publicar. Depois,
configure o app com a URL exibida para a função:

```powershell
flutter run --dart-define=AIR_QUALITY_API_URL=https://southamerica-east1-<project-id>.cloudfunctions.net/airQuality
```

O app não inicializa Firebase no cliente para consumir o índice: a integração é
HTTP e o endereço é configurado por `AIR_QUALITY_API_URL`. A posição mais recente
fica no armazenamento local do aparelho; somente as coordenadas necessárias
para a consulta são enviadas ao backend.

Antes de disponibilizar publicamente, proteja a função com Firebase App Check
ou autenticação e configure controles de abuso/limite de requisições. CORS não é
um mecanismo de autenticação.
