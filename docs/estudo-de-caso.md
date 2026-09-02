# Análise do Estudo de Caso: Projeto ArPuro

**Disciplina:** Programação para Dispositivos Móveis  
**Projeto:** ArPuro  
**Arquivo de Referência:** `docs/estudo-de-caso.md`  

---

## 1. Objetivo do Trabalho

O objetivo deste documento é apresentar a análise crítica e estruturada do estudo de caso do projeto ArPuro. Esta análise visa demonstrar a compreensão aprofundada da equipe quanto ao problema socioambiental e sanitário identificado, seus usuários e perfis de comportamento, seus contextos operacionais reais de utilização em campo, seus objetivos e proposta de valor, bem como o mapeamento rigoroso de suas restrições arquiteturais e requisitos móveis (limitação de 4 telas principais, regra de ouro dos 3 toques, resiliência offline com sincronização exclusiva em Wi-Fi e execução fluida em smartphones de entrada). O documento consolida a base teórica e de engenharia de software indispensável para balizar as etapas seguintes de prototipação visual e desenvolvimento prático da aplicação móvel.

---

## 2.1. Problema

### Qual problema o aplicativo pretende ajudar a solucionar?
O aplicativo aborda a desconexão crônica entre a vigilância em saúde respiratória individual e a qualidade real do ar e dos corpos hídricos urbanos. No cotidiano das cidades, a população vulnerável (especialmente portadores de doenças respiratórias crônicas) e os ativistas ambientais carecem de instrumentos integrados para mensurar a toxicidade ambiental invisível (como materiais particulados e ozônio) e para denunciar, de forma célere e georreferenciada, focos pontuais de poluição (córregos contaminados, esgoto a céu aberto, queimadas e lixões clandestinos).

### Por que esse problema é relevante?
A poluição do ar e da água representa uma das principais causas de internações de urgência e morbimortalidade evitável em centros urbanos. Segundo a OMS, partículas finas ($MP_{10}$) e ozônio troposférico não possuem limiares seguros de inalação, induzindo estresse oxidativo, broncoespasmos imediatos e declínio crônico da função pulmonar. Concomitantemente, a proliferação de cianobactérias e a emissão de aerossóis de esgoto em córregos urbanos degradam a saúde comunitária periférica. A falta de dados acessíveis sobrecarrega os serviços públicos de saúde com atendimentos que poderiam ser mitigados com ações preventivas simples.

### Qual é a principal necessidade que a solução deverá atender?
Traduzir métricas ambientais laboratoriais complexas em alertas profiláticos acionáveis para a rotina da população vulnerável, paralelamente à criação de um canal ágil e de baixíssima fricção para mapeamento georreferenciado e denúncia cidadã de passivos ecológicos.

## 2.2. Público e Usuários
 
### 1. Pacientes com Doenças Respiratórias Crônicas (Asma e Bronquite)
* **Quem é:** Indivíduos de faixas etárias variadas que convivem com hiper-reatividade brônquica crônica e alta suscetibilidade a variações de umidade e particulados em suspensão.
* **Relação com o aplicativo:** Usuários de perfil consultivo contínuo (uso diário/matinal).
* **Necessidades:** Saber antecipadamente se a qualidade do ar externa oferece risco de descompensação clínica, se devem evitar atividades físicas e quais precauções tomar (uso de máscara, bombinha à mão, fechamento de janelas).
* **Situação de uso:** Ao acordar ou antes de planejar deslocamentos a pé, exercícios físicos e rotinas diárias de saída de casa.
 
### 2. Ativistas Ambientais e Comunidade Engajada
* **Quem é:** Integrantes de coletivos ecológicos, lideranças de bairro e cidadãos comprometidos com a preservação de mananciais e fiscalização urbana.
* **Relação com o aplicativo:** Usuários de perfil ativo/colaborativo (alimentadores do mapa de focos de poluição).
* **Necessidades:** Registrar denúncias em campo com rapidez, respaldo fotográfico e coordenadas precisas de GPS, sem exposição da sua identidade física (garantia de anonimato).
* **Situação de uso:** Durante caminhadas, inspeções de bacias hidrográficas, deslocamentos em praças e margens de rios ao constatar irregularidades.
 
### 3. Educadores (Professores de Ciências e Biologia)
* **Quem é:** Professores do ensino fundamental, médio e técnico voltados à formação cidadã e consciência ecológica.
* **Relação com o aplicativo:** Usuários de perfil pedagógico e multiplicadores comunitários.
* **Necessidades:** Visualizar e demonstrar dados ambientais locais consolidados, conectando conteúdos teóricos curriculares com o mapa de problemas reais do território escolar.
* **Situação de uso:** Em sala de aula ou em atividades de campo pedagógicas para debate sobre saneamento básico, qualidade do ar e ciência cidadã.
 
### 4. Gestores Públicos de Saúde e Pesquisadores
* **Quem é:** Técnicos de secretarias municipais de saúde/meio ambiente e acadêmicos de epidemiologia e ecologia urbana.
* **Relação com o aplicativo:** Consumidores de dados agregados e receptores de dados públicos abertos.
* **Necessidades:** Ter acesso a relatórios e dados espaciais exportáveis para subsidiar tomadas de decisão, fiscalização sanitária e alocação preventiva de insumos médicos.
* **Situação de uso:** Em computadores e sistemas administrativos ao analisar relatórios de focos territoriais e curvas de morbidade respiratória sazonal.
  
---

  ## 2.3. Contexto de Uso

A análise dos cenários reais de interação revela severas implicações de engenharia móvel:

* *Ambiente e Iluminação:*
  * Condição: O aplicativo será operado com frequência em ambientes externos (vias públicas, parques, praças e margens de rios sob sol pleno).
  * Implicações: A interface deve adotar prioritariamente o *modo claro*, tipografia robusta e paleta de alto contraste cromático para evitar que a tela fique ilegível sob reflexo solar.
* *Momento, Nível de Atenção e Urgência:*
  * Condição: Usuários em movimento (caminhando) ou em trânsito exigem tomadas de decisão imediatas sem dispersão.
  * Implicações: A ação principal de notificação de poluição deve ser resolvida em fluxo ultra-rápido (regra dos 3 toques: Abrir > Notificar foco > Tirar foto > Enviar). A tela principal não pode exigir leitura minuciosa de textos, baseando-se no semáforo visual verde/amarelo/vermelho/cinza.
* *Dispositivo e Hardware:*
  * Condição: Usuários operando smartphones básicos/de entrada, com sensores limitados e restrição de memória/processamento.
  * Implicações: A arquitetura do app deve priorizar componentes nativos leves, sem animações pesadas, garantindo inicialização ágil e baixo consumo de bateria ao acionar sensores de Câmera e GPS.
* *Conectividade:*
  * Condição: Em margens de córregos e áreas periféricas, o sinal de rede 3G/4G/5G costuma ser instável ou inexistente, e ativistas frequentemente contam com franquias de dados móveis limitadas.
  * Implicações: A aplicação deve operar em *modo offline* para registro de fotos e coordenadas no banco local (cache). A sincronização pesada de pacotes e mapas deve ser configurada para ocorrer preferencialmente ou exclusivamente quando houver conexão Wi-Fi disponível.

---

## 2.4. Objetivo e Proposta de Valor

*O que o aplicativo pretende oferecer:*  
Um ecossistema móvel intuitivo composto por um painel de alerta biomédico-ambiental e uma rede colaborativa de monitoramento territorial cidadão.

*Qual benefício proporciona ao usuário:*  
O ArPuro transforma indicadores poluentes abstratos em ações práticas de preservação à saúde, concedendo previsibilidade e segurança a pessoas asmáticas e portadoras de bronquite, enquanto confere voz ativa e poder de fiscalização anônimo e georreferenciado à cidadania para cobrar o saneamento ambiental de suas comunidades.

---


## 2.5. Personalidade, Identidade e Experiência

* *Palavras Conceituais:* $MP_{10}$, Ozônio, Asma, Bronquite, Cianobactérias, Córregos, Saneamento Básico, Poluição, Queimadas, Saúde Ambiental.
  * Influência na Solução: Devem orientar os metadados de classificação no cadastro do formulário de foco e os critérios de busca e filtragem do mapa colaborativo.
* *Personalidade da Identidade:* Ecológica, científica e cidadã.
  * Influência na Solução: Visual estruturado com tons naturais de verde, terra (marrom, alaranjado) e ícones botânicos/orgânicos, transmitindo credibilidade científica e engajamento comunitário.
* *Tom da Interface e da Experiência do Usuário:* Cívica, educativa e serena (estilo "boletim meteorológico da saúde").
  * Influência na Solução: Não adotar alertas sensacionalistas de terror ou pânico. O design precisa instruir pedagogicamente sobre riscos e apontar medidas de alívio preventivo imediatas.
* *Forma como deseja ser lembrado:* "O termômetro que mede a febre do planeta e a nossa."
  * Influência na Solução: O design do semáforo do dia deve comunicar que a febre ambiental externa está intrinsecamente ligada à resposta inflamatória do corpo humano.

---

## 2.6. Funcionalidades e Características Já Definidas

| Funcionalidade / Característica | Necessidade Atendida |
| :--- | :--- |
| *1. Semáforo do Dia (Qualidade do ar imediata)* | Atende à necessidade do paciente crônico de verificar, em segundos e sem esforço cognitivo, o grau de toxicidade atmosférica para decidir sobre sua rotina diária de saída. |
| *2. Tradução de Índices Técnicos ($MP_{10}$/Ozônio)* | Atende à necessidade de acessibilidade comunicacional, convertendo dados laboratoriais em linguagem cidadã direta (ex: "Ar bom hoje para correr"). |
| *3. Mapa Colaborativo de Focos de Poluição* | Atende à necessidade de ativistas e comunidade de visualizar e mapear córregos degradados, lixões clandestinos e esgoto a céu aberto na cidade. |
| *4. Formulário de Notificação com Foto e GPS* | Atende à necessidade de ativistas e cidadãos de registrar evidências fáticas e geoespaciais dos focos de poluição de forma célere em campo. |
| *5. Envio Anônimo de Denúncias* | Atende à necessidade de proteção, segurança e privacidade do cidadão ao apontar irregularidades ambientais no bairro. |
| *6. Calculadora de Risco Sazonal e Regional* | Atende à necessidade profilática do usuário asmático de antecipar o risco associado a estações críticas (estiagem/inverno vs. radiação/ozônio no verão). |
| *7. Orientações e Dicas de Proteção Respiratória* | Atende à necessidade de mitigação prática de crises (fechar janelas, higienização de mucosas, uso de máscara, bombinha preventiva). |
| *8. Cache e Operação Offline com Sincronização via Wi-Fi* | Atende à necessidade operacional de campo em áreas com sinal celular instável, preservando o plano de dados móveis do usuário. |
| *9. Exportação de Dados para o Poder Público* | Atende à necessidade de transparência, ciência cidadã e integração institucional com secretarias municipais e prefeituras. |

---
