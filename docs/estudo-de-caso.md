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
Hoje em dia, quem tem problemas respiratórios graves (como asma e bronquite) não sabe exatamente quando o ar da rua está perigoso para respirar. Ao mesmo tempo, moradores e ativistas que veem um esgoto vazando, um córrego sujo ou queimadas no bairro não encontram um jeito simples, anônimo e rápido de registrar e denunciar essa situação direto pelo celular.

### Por que esse problema é relevante?
A poluição do ar e da água causa crises respiratórias graves e enche os postos de saúde e prontos-socorros com casos que poderiam ser evitados. Segundo a OMS, poeira fina ($MP_{10}$) e ozônio causam tosse e falta de ar mesmo em quantidades baixas. Além disso, rios poluídos e lixões perto de casa soltam mau cheiro e bactérias no ar, piorando a vida das pessoas que moram nas redondezas. Se as pessoas tivessem informação simples a tempo, poderiam se proteger melhor.

### Qual é a principal necessidade que a solução deverá atender?
Explicar a qualidade do ar de um jeito que qualquer pessoa entenda sem precisar ser cientista, e dar uma ferramenta rápida para qualquer cidadão tirar foto de um foco de poluição e mandar a localização na hora.

---

## 2.2. Público e Usuários
 
### 1. Pessoas com Problemas Respiratórios (Asma e Bronquite)
* **Quem é:** Pessoas de qualquer idade que sofrem com crises de falta de ar causadas por tempo seco, poeira e fumaça.
* **Relação com o aplicativo:** Vão usar o app todo dia de manhã para saber como está o ar da cidade.
* **Necessidades:** Saber se é seguro sair de casa, se podem fazer caminhada ou exercício e quais cuidados tomar no dia (levar bombinha, usar máscara, fechar janelas).
* **Situação de uso:** Logo cedo, ao acordar, antes de sair para o trabalho, escola ou parque.

### 2. Ativistas e Moradores Engajados
* **Quem é:** Pessoas que participam de ações no bairro e se preocupam em cuidar de praças, rios e áreas verdes.
* **Relação com o aplicativo:** Vão usar o app de vez em quando, na hora em que encontrarem sujeira ou poluição na rua.
* **Necessidades:** Um jeito rápido de tirar foto da sujeira e marcar no mapa sem burocracia, além de poder mandar a denúncia de forma anônima para evitar problemas.
* **Situação de uso:** Caminhando na rua, perto de córregos ou praças, usando o celular no sol forte.

### 3. Professores de Ciências e Biologia
* **Quem é:** Professores de escolas da região que ensinam sobre meio ambiente e saúde.
* **Relação com o aplicativo:** Vão usar como ferramenta nas aulas para mostrar a realidade do bairro para os alunos.
* **Necessidades:** Ver o mapa com os pontos de poluição da cidade de forma simples para mostrar aos estudantes e montar projetos práticos.
* **Situação de uso:** Em sala de aula ou em caminhadas com os alunos para discutir saneamento básico e cuidados com o ar.

### 4. Profissionais da Saúde e Pesquisadores
* **Quem é:** Funcionários de postos de saúde, secretarias municipais e pessoas que estudam a saúde da cidade.
* **Relação com o aplicativo:** Vão consultar os dados e relatórios gerados pelas pessoas.
* **Necessidades:** Poder baixar relatórios e ver em quais bairros existem mais problemas para planejar ações de limpeza e campanhas de vacinação/atendimento.
* **Situação de uso:** No trabalho diário e no planejamento de ações públicas de saúde e meio ambiente.
  
---

  ## 2.3. Contexto de Uso

A análise dos cenários reais de interação revela severas implicações de engenharia móvel:

* **Ambiente e Iluminação:**
  * *Situação:* As pessoas vão usar o app na rua, em praças e perto de córregos, muitas vezes debaixo do sol do meio-dia.
  * *O que isso muda no app:* O visual tem que priorizar o **modo claro**, com letras legíveis e bastante contraste de cores para ninguém precisar forçar a vista na claridade.
* **Momento, Atenção e Pressa:**
  * *Situação:* Quem está andando na rua quer resolver a denúncia rápido para não ficar moscando com o celular na mão.
  * *O que isso muda no app:* O fluxo de denúncia tem que ser direto ao ponto (regra dos 3 toques: Abrir > Clicar em Notificar > Tirar foto e Enviar). Além disso, a tela inicial precisa mostrar o risco do dia com um semáforo colorido de fácil entendimento.
* **Aparelhos dos Usuários:**
  * *Situação:* Muita gente usa celulares simples e mais antigos, com pouca memória e bateria limitada.
  * *O que isso muda no app:* O aplicativo precisa ser leve, sem travamentos ou telas cheias de firulas, usando a câmera e o GPS sem gastar a bateria inteira.
* **Internet e Conexão:**
  * *Situação:* Em fundos de vale e na beira de córregos o sinal de celular costuma ser ruim ou sumir totalmente. Além disso, o pacote de dados móveis do usuário pode acabar.
  * *O que isso muda no app:* O app precisa **funcionar sem internet (offline)**. O usuário consegue tirar a foto e marcar o ponto no mapa offline, e o app espera o celular conectar ao Wi-Fi para enviar tudo de uma vez sem gastar o 4G da pessoa.

---

## 2.4. Objetivo e Proposta de Valor

* **O que o aplicativo quer entregar:**  
  Um aplicativo fácil de usar que junta um painel do ar do dia (como uma previsão do tempo da saúde) com um mapa colaborativo onde qualquer pessoa pode avisar onde tem poluição na cidade.
  
* **Benefício real para quem usa:**  
  Para quem tem asma, traz tranquilidade ao avisar com antecedência se é seguro sair na rua. Para quem quer ver a cidade limpa, dá um jeito seguro e sem enrolação de cobrar providências da prefeitura tirando fotos de onde tem problema.

---

## 2.5. Personalidade, Identidade e Experiência

* **Palavras Conceituais ($MP_{10}$, Ozônio, Asma, Bronquite, Cianobactérias, Córregos, Saneamento Básico, Poluição, Queimadas, Saúde Ambiental):**  
  * *Como entra no app:* Essas palavras vão virar filtros simples no mapa e opções fáceis de marcar no formulário de denúncia.
* **Estilo Visual (Ecológico, Confiável e Cidadão):**  
  * *Como entra no app:* Cores que lembram a natureza (tons de verde, marrom e laranja suave) e ícones de folhas, passando a sensação de um app sério, mas amigável e comunitário.
* **Tom de Voz do App (Educativo e Tranquilo):**  
  * *Como entra no app:* O app precisa parecer um "boletim do tempo da saúde". A ideia não é criar pânico quando o ar estiver ruim, mas sim dar dicas úteis e acolhedoras para a pessoa se cuidar (exemplo: "Hoje o ar está seco, beba bastante água e prefira caminhar em lugares fechados").
* **Como o app quer ser lembrado:** *"O termômetro que mede a febre do planeta e a nossa."*  
  * *Como entra no app:* Mostrar que se a cidade e as águas estão doentes, a respiração de todo mundo sofre junto.

---

## 2.6. Funcionalidades e Características Já Definidas

| Funcionalidade | Para que serve no dia a dia? |
| :--- | :--- |
| **1. Semáforo do Dia (Qualidade do ar)** | Permite que quem tem asma ou bronquite bata o olho e saiba na hora se o ar do dia está perigoso ou tranquilo. |
| **2. Tradução de Índices Técnicos ($MP_{10}$)** | Troca termos científicos difíceis por avisos simples (como *"Ar bom hoje para correr"*). |
| **3. Mapa Colaborativo de Focos de Poluição** | Mostra em um mapa onde os vizinhos marcaram esgoto a céu aberto, córregos sujos e entulho. |
| **4. Notificação com Foto e GPS** | Facilita provar o problema com foto e localização exata direto pelo celular. |
| **5. Envio de Denúncia Anônima** | Protege quem está denunciando para que ninguém sofra perseguição ou constrangimento no bairro. |
| **6. Calculadora de Risco por Época do Ano** | Avisa com antecedência sobre épocas mais críticas (como meses secos de inverno ou dias de calor extremo). |
| **7. Dicas de Proteção Respiratória** | Ensina medidas fáceis para evitar crises (usar máscara na rua, fechar janelas de casa em horários de pico). |
| **8. Uso Offline com Sincronização via Wi-Fi** | Deixa o usuário tirar a foto mesmo sem internet na rua e guarda os dados para enviar só quando achar uma rede Wi-Fi. |
| **9. Dados Públicos Exportáveis para Prefeituras** | Permite juntar todas as denúncias para cobrar os órgãos públicos com dados reais em mãos. |

---
 
## 2.7. Restrições e Condições
 
* **Limite de Telas:** O aplicativo precisa ter no máximo **4 telas principais** (Semáforo do Dia, Mapa de Poluição, Tela de Denúncia com Foto/GPS e Dicas de Cuidados).
* **Regra dos 3 Toques:** Fazer uma denúncia não pode demorar mais que 3 toques na tela (Abrir o app > Clicar em Notificar > Tirar a foto e Enviar).
* **Aparelhos Suportados:** O aplicativo precisa funcionar bem em celulares básicos, sem travar nem fechar sozinho.
* **Internet e Dados:** Precisa salvar coisas na memória do celular para abrir sem sinal e sincronizar fotos preferencialmente via Wi-Fi.
* **Privacidade:** Ninguém deve ser obrigado a se identificar para registrar uma denúncia.
* **Cores e Visibilidade:** O semáforo colorido é obrigatório (verde-limão para ar bom até cinza-escuro para ar muito ruim) e a tela tem que ser legível mesmo sob sol forte.
* **Sensores Necessários:** O aplicativo precisa de permissão de Câmera e GPS para funcionar direito.
 
---
 
## 2.8. Pontos de Atenção
 
Os **3 aspectos mais importantes para o sucesso do aplicativo** identificados pelo grupo são:
 
1. **A denúncia tem que ser rápida de verdade (Regra dos 3 toques na rua):**  
   Se o usuário estiver andando na rua debaixo de sol e o app pedir para preencher formulários compridos, ele vai desistir na hora. O processo de abrir, bater a foto e enviar precisa ser quase automático.

2. **O app tem que salvar tudo sem internet:**  
   Muitos córregos e lixões ficam em lugares com sinal fraco de celular. Se o aplicativo depender de internet boa na hora para salvar a foto, o morador não vai conseguir avisar do problema onde mais importa. Poder salvar tudo offline e enviar só no Wi-Fi é o que vai fazer o app funcionar de verdade.

3. **Linguagem acolhedora e direta (Sem assustar as pessoas):**  
   Quem tem asma só quer saber: "posso sair na rua agora sem passar mal?". O app precisa responder isso com cores intuitivas e conselhos claros, sem ficar jogando números difíceis que só confundem e assustam o usuário.
