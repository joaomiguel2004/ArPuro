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

## 3. Análise de Diferenciais Competitivos (Oceano Azul)

**O que torna o ArPuro único:**
A maior lacuna do mercado atual é que **dados ambientais são separados da ação cidadã**. O IQAir diz ao usuário que o ar está ruim, mas o usuário não tem como reportar que o ar está ruim porque há um terreno baldio queimando lixo na esquina. O ArPuro resolve isso ao unir a **informação passiva** (o painel semáforo) com a **ação ativa** (o mapa colaborativo de denúncias).

Além disso, o **anonimato** é um trunfo gigante. Em muitas comunidades, denunciar despejo ilegal de esgoto industrial ou lixo pode gerar retaliações por parte de infratores locais ou empresas. O anonimato destrava o volume de denúncias.

---

## 4. Desafios e Recomendações Estratégicas

1. **Validação das Denúncias (Efeito Waze):** O maior risco de mapas colaborativos anônimos é o *spam* ou falsas denúncias.
   * *Ação:* Implemente um sistema de validação pela própria comunidade (ex: botões de "Eu também vi isso" ou "Não está mais aqui", similar ao Waze) ou exija que a foto seja tirada na hora pelo app (sem upload da galeria) para garantir veracidade com os metadados de GPS.
2. **Gamificação e Retenção:** Usuários saudáveis podem esquecer de abrir o app se a qualidade do ar estiver boa.
   * *Ação:* Crie um sistema de recompensas ou "karma" cívico para os usuários que mais mapeiam focos de poluição (mesmo sendo anônimos para o público, eles podem ter um ranking interno).
3. **Fonte dos Dados Base:** O "semáforo" diário precisa de dados confiáveis antes mesmo das denúncias dos usuários.
   * *Ação:* Integre APIs gratuitas de qualidade do ar e clima (como OpenWeatherMap, Copernicus ou órgãos ambientais locais) para garantir que o app já tenha utilidade no "Dia 1", antes da comunidade começar a gerar fotos.
