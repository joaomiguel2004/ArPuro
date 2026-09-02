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
