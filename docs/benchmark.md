# 3. Benchmark

Para fundamentar o desenvolvimento do **ArPuro**, foram analisadas 3 soluções existentes no mercado que abordam aspectos do monitoramento ambiental, saúde respiratória e engajamento cívico.

---

### Solução 1: IQAir (AirVisual)
Aplicativo focado no monitoramento da qualidade do ar em tempo real e previsão de poluição com foco em saúde.

* **Principais funcionalidades:** 
  * Monitoramento do Índice de Qualidade do Ar (AQI) em tempo real via estações e satélites.
  * Previsão da qualidade do ar para os próximos dias e alertas de poluição.
  * Recomendações de saúde personalizadas (ex: uso de máscara, fechar janelas).
* **Pontos positivos:** 
  * Cobertura global e alta precisão dos dados ambientais.
  * Interface visual muito clara baseada em código de cores (sistema semáforo).
* **Pontos negativos:** 
  * Modelo de interação passivo (o usuário apenas consome dados, sem opção de reportar problemas).
  * Não monitora poluição da água ou focos de contaminação hídrica/esgoto.
* **Aspectos de interface/experiência:** 
  * Design limpo e moderno, centrado no painel principal com indicadores visuais imediatos e ícones intuitivos para grupos de risco.
* **O que pode ser aproveitado ou melhorado:** 
  * **Aproveitar:** O sistema de código de cores (semáforo) para indicar o nível de risco à saúde respiratória de forma instantânea.
  * **Melhorar:** Dar voz ativa ao usuário para que ele possa reportar a origem da poluição, em vez de apenas visualizar os dados.

---

### Solução 2: Colab
Plataforma brasileira de tecnologia cívica que conecta cidadãos às prefeituras para gestão e zeladoria urbana.

* **Principais funcionalidades:** 
  * Publicação de demandas urbanas (buracos, lixo acumulado, esgoto) georreferenciadas e com foto.
  * Acompanhamento do status de resolução da solicitação pelo poder público.
  * Enquetes e consultas públicas municipais.
* **Pontos positivos:** 
  * Forte apelo de cidadania ativa e geolocalização precisa das ocorrências.
  * Fluxo simples de envio de fotos e descrição do problema.
* **Pontos negativos:** 
  * Exige cadastro completo do usuário (ausência de anonimato), o que pode inibir denúncias de infrações ambientais graves.
  * Não possui foco em saúde nem monitora métricas de qualidade do ar ou água.
* **Aspectos de interface/experiência:** 
  * Interface no estilo "feed social", onde é possível visualizar publicações de outros cidadãos em um mapa ou lista interativa.
* **O que pode ser aproveitado ou melhorado:** 
  * **Aproveitar:** O fluxo prático de fotografar, georreferenciar e categorizar um problema comunitário no mapa.
  * **Melhorar:** Permitir o envio totalmente anônimo para proteger o usuário e filtrar o foco das denúncias especificamente para a saúde e poluição ambiental.

---

### Solução 3: Swim Guide
Aplicativo voltado para a verificação da qualidade da água e balneabilidade de praias, rios e lagos.

* **Principais funcionalidades:** 
  * Informação do status da água (própria/imprópria) usando sinalização por cores.
  * Mapeamento de praias e pontos de água mais próximos via GPS.
  * Opção para que cidadãos reportem poluição em corpos d'água.
* **Pontos positivos:** 
  * Especializado no impacto ambiental e recreativo da qualidade da água.
  * Identificação visual direta de locais seguros vs. contaminados no mapa.
* **Pontos negativos:** 
  * Totalmente isolado do impacto do ar e de doenças respiratórias.
  * Depende fortemente de dados governamentais que nem sempre são atualizados com frequência em rios e córregos urbanos.
* **Aspectos de interface/experiência:** 
  * Navegação baseada em mapas com marcadores em formato de bandeiras (verdes ou vermelhas), facilitando a identificação rápida.
* **O que pode ser aproveitado ou melhorado:** 
  * **Aproveitar:** A abordagem de monitoramento hídrico direto no mapa para identificar córregos e rios poluídos.
  * **Melhorar:** Integrar esses dados hídricos ao impacto do ar, criando uma visão holística da saúde ambiental da cidade.

---

## O que nosso aplicativo poderá fazer de diferente ou melhor?

O **ArPuro** se diferencia no mercado ao integrar em uma única solução a **inteligência passiva de dados** e a **ação colaborativa cívica**, com foco exclusivo na **saúde respiratória e ambiental**:

1. **Correlação Única entre Ar, Água e Saúde:** Enquanto os concorrentes tratam a qualidade do ar, a poluição da água e a saúde como temas isolados, o ArPuro conecta esses três pilares no mesmo ecossistema.
2. **Denúncias Anônimas e Georreferenciadas:** Diferente de plataformas cívicas tradicionais (como o Colab), o ArPuro garante o anonimato do cidadão. Isso elimina o receio de retaliações ao reportar focos de poluição, queimadas ilegais ou esgoto a céu aberto.
3. **Mapeamento Ativo vs. Monitoramento Passivo:** Ao contrário de apps como o IQAir, que se limitam a mostrar a qualidade do ar captada por estações distantes, o ArPuro permite mapear o microclima local e os problemas pontuais de poluição do bairro através de fotos e geolocalização enviadas em tempo real pela própria comunidade.
4. **Painel Semáforo Integrado à Ação:** O usuário não apenas consulta o risco diário para sua saúde respiratória via semáforo, mas encontra no mesmo aplicativo o mecanismo imediato para notificar e combater a causa raiz daquela poluição.
