# Personas: Projeto ArPuro

---

## Persona 1: Mariana Costa

* **Nome fictício:** Mariana Costa
* **Perfil/contexto:** 31 anos, Engenheira Ambiental e articuladora comunitária. Percorre a pé margens de rios urbanos, valões e bairros periféricos para fiscalizar áreas de esgoto a céu aberto, lixões clandestinos e queimadas urbanas. Utiliza um smartphone Android de entrada com armazenamento restrito e depende de plano de dados móveis pré-pago econômico.
* **Objetivos:** 
  * Registrar denúncias ambientais auditáveis (com foto e coordenadas geográficas exatas) para exigir providências do poder público e de secretarias municipais.
  * Gerar um banco de dados aberto e transparente para embasar a atuação de coletivos de bairro.
* **Necessidades:** 
  * Agilidade extrema no envio para não precisar parar a caminhada nem se expor em vias públicas.
  * Envio 100% anônimo para resguardar sua segurança pessoal contra retaliações e conflitos com infratores locais.
  * Salvamento local dos registros em áreas periféricas com sinal de celular precário.
  * Política de transferência que aguarde conexão Wi-Fi para não consumir seus dados móveis com upload de imagens pesadas.
* **Dores:** 
  * Canais públicos de ouvidoria burocráticos, lentos e que exigem formulários extensos com CPF obrigatório.
  * Aplicativos que travam ou reiniciam devido ao alto consumo de memória RAM em smartphones básicos.
  * Telas escuras ou com baixo contraste que ficam totalmente ilegíveis sob luz solar direta no meio da rua.
* **Comportamentos:** 
  * Opera o aparelho em movimento, frequentemente segurando-o com apenas uma das mãos enquanto caminha.
  * Ao identificar um foco de poluição, quer bater a foto, registrar o ponto e guardar o aparelho no bolso em poucos segundos para evitar chamar atenção.
* **Relação com o aplicativo:** 
  * Utiliza o app em campo de forma pontual e focada na notificação rápida através da Regra dos 3 Toques (`Abrir > Notificar Foco > Foto e Envio`).
  * Depende da capacidade de registrar em modo offline e da sincronização automática em segundo plano restrita às redes Wi-Fi.

---

## Persona 2: Lucas Silveira

* **Nome fictício:** Lucas Silveira
* **Perfil/contexto:** 24 anos, designer gráfico residente em região urbana de tráfego intenso. Convive com asma brônquica moderada desde a infância e tenta manter uma rotina diária de atividades físicas ao ar livre (caminhadas e corridas leves) no início da manhã.
* **Objetivos:** 
  * Praticar exercícios físicos na rua sem sofrer crises agudas de tosse ou broncoespasmo.
  * Prever com antecedência os dias críticos de tempo seco, estiagem e fumaça para planejar sua rotina preventiva.
* **Necessidades:** 
  * Avaliação imediata do risco atmosférico do dia logo cedo, traduzida em linguagem direta e sem jargões de laboratório.
  * Orientações práticas e acolhedoras de autocuidado (ex.: necessidade de carregar bombinha de alívio, usar máscara ou transferir a atividade para ambiente fechado).
* **Dores:** 
  * Aplicativos de clima tradicionais que indicam apenas chuva e temperatura, omitindo níveis de poeira fina (MP10) e gases tóxicos.
  * Relatórios técnicos complexos repletos de siglas incompreensíveis (µg/m³, ppm, índices AQI internacionais descontextualizados).
  * Crises asmáticas inesperadas e idas desnecessárias a prontos-socorros causadas por corridas em horários de pico de poluição ou ar seco severo.
* **Comportamentos:** 
  * Consulta o smartphone logo ao acordar, ainda em casa antes de sair para treinar ou trabalhar.
  * Prioriza interfaces visuais e limpas que comuniquem a informação essencial em uma única olhada.
* **Relação com o aplicativo:** 
  * Usuário recorrente matinal da tela inicial do "Semáforo do Dia", assimilando o nível de segurança do ar em menos de 2 segundos.
  * Utiliza a tela de Orientações de Proteção e a Calculadora de Risco Sazonal para ajustar horários de corrida e planejar medidas de proteção respiratória.

---

## Persona Prioritária e Justificativa

### Persona Prioritária: Mariana Costa

A escolha de **Mariana Costa** como persona prioritária é justificada pelos seguintes critérios:

1. **Condições Extremas de Operação:** A Mariana utiliza o aplicativo no pior cenário técnico e ergonômico previsto no projeto: em ambiente externo com sol a pino (exigindo alto contraste e modo claro), caminhando em vias públicas (exigindo botões amplos e uso com uma mão), em áreas periféricas com conexão de dados móveis fraca ou nula e em smartphone de entrada com memória e processamento limitados. Ao atender plenamente às restrições severas do uso de campo da Mariana, a aplicação automaticamente atenderá com excelência ao cenário doméstico e controlado do Lucas.
2. **Validação Rigorosa das Restrições Arquiteturais:** A jornada da Mariana é a que põe à prova os pilares centrais do desenvolvimento móvel do projeto: a aplicação estrita da **Regra de Ouro dos 3 Toques**, o fluxo de **resiliência offline nativa**, a política de **sincronização exclusiva em redes Wi-Fi** para preservação da franquia de dados e a garantia incontornável de **anonimato no registro**.
3. **Alimentação do Ecossistema Colaborativo:** O ArPuro depende do engajamento comunitário para mapear a cidade. É a atuação da Mariana em campo que insere as denúncias com fotos e coordenadas no mapa colaborativo. Sem a alimentação desses dados hiperlocais de queimadas, esgoto e córregos poluídos, perde-se a base empírica que alerta a comunidade e que fundamenta a prevenção dos pacientes crônicos representados pelo Lucas.
