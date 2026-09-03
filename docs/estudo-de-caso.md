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

A análise dos cenários reais de uso orienta as decisões de desenvolvimento da seguinte forma:

* **Ambiente:**
  * *Situação:* Áreas urbanas externas como ruas, calçadas, praças e margens de rios ou córregos.
  * *O que isso muda no app:* A interface precisa de botões grandes e espaçados para uso confortável enquanto a pessoa se desloca ou caminha em vias públicas.

* **Momento de utilização:**
  * *Situação:* Logo cedo pela manhã para consulta diária, ou de forma esporádica e pontual no instante em que o usuário flagra uma queimada, lixo ou esgoto.
  * *O que isso muda no app:* As duas principais tarefas (checar o semáforo e abrir a câmera para notificar) devem estar disponíveis imediatamente na primeira tela.

* **Condições do usuário:**
  * *Situação:* Pessoas em movimento (caminhando), segurando o celular com apenas uma mão, ou pacientes que já estão com tosse e falta de ar.
  * *O que isso muda no app:* O botão de notificação deve ser de fácil alcance para o polegar e a navegação não pode exigir esforço físico ou tarefas complexas.

* **Dispositivo:**
  * *Situação:* Smartphones básicos e intermediários de entrada, com memória limitada e baterias modestas.
  * *O que isso muda no app:* O código deve ser leve, consumindo pouca memória RAM e acionando o GPS e a câmera de forma otimizada para não travar o aparelho.

* **Conectividade:**
  * *Situação:* Conexão 3G/4G instável ou inexistente perto de rios e áreas periféricas, além de planos com franquia de dados curta.
  * *O que isso muda no app:* O aplicativo salva denúncias e dados em modo offline e aguarda uma conexão Wi-Fi para sincronizar as fotos pesadas sem consumir a franquia móvel do usuário.

* **Iluminação:**
  * *Situação:* Luz solar direta e intensa ao ar livre.
  * *O que isso muda no app:* Foco obrigatório em modo claro, fontes nítidas e paleta semafórica com alto contraste para permitir leitura mesmo com reflexo do sol na tela.

* **Nível de atenção:**
  * *Situação:* Atenção dividida e baixa. O usuário está atento ao movimento da rua, ao trânsito ou ao caminho em que está pisando.
  * *O que isso muda no app:* Informações passadas em símbolos e cores, evitando blocos longos de texto que exijam leitura atenta no meio da rua.

* **Situação de urgência:**
  * *Situação:* Moderada a alta. O ativista quer bater a foto e guardar o celular rapidamente para não se expor na rua, e o asmático em início de crise precisa saber o que fazer sem perder tempo.
  * *O que isso muda no app:* Implementação da regra dos 3 toques para registro rápido da denúncia e exibição imediata de dicas de alívio e proteção respiratória.

* **Outras condições específicas:**
  * *Situação:* Risco de constrangimento ou retaliação ao apontar crimes ambientais praticados no próprio bairro.
  * *O que isso muda no app:* Garantia de denúncia 100% anônima, sem a necessidade de criação de cadastros obrigatórios ou exibição do nome do autor.

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

| Funcionalidade | Necessidade atendida |
| :--- | :--- |
| **Semáforo do dia (qualidade do ar e risco)** | Permite que pessoas com asma e bronquite batam o olho e saibam na hora se o ar está seguro para respirar antes de sair de casa. |
| **Tradução de índices técnicos ($MP_{10}$)** | Substitui termos e números difíceis por avisos simples do cotidiano (como "Ar bom hoje para correr"), tornando a informação compreensível para qualquer usuário. |
| **Mapa colaborativo de focos de poluição** | Mostra onde vizinhos e ativistas marcaram problemas na cidade (esgoto a céu aberto, córregos sujos, queimadas e lixo acumulado). |
| **Formulário de notificação com foto e GPS** | Permite ao cidadão registrar provas em imagem e a localização exata do problema ambiental de forma rápida pelo celular. |
| **Notificação anônima** | Protege quem faz a denúncia, garantindo segurança e privacidade para que o morador não sofra represálias no bairro. |
| **Calculadora de risco do ar por época do ano e região** | Ajuda pessoas sensíveis a se prepararem com antecedência para épocas mais críticas (como estiagem ou calor intenso). |
| **Dicas de proteção respiratória** | Fornece orientações práticas do que fazer na hora (usar máscara, fechar janelas em horários de pico, carregar a bombinha) para evitar crises. |
| **Formulário de sintomas respiratórios e alerta de pico** | Permite acompanhar tosse e falta de ar, avisando o usuário quando houver subida repentina de poluentes. |
| **Uso offline com sincronização exclusiva via Wi-Fi** | Permite tirar fotos e salvar pontos mesmo em locais sem sinal de celular, além de não gastar o pacote de dados móveis do usuário. |
| **Base de dados pública e exportável para prefeituras** | Dá transparência às informações coletadas e permite cobrar melhorias e fiscalização dos órgãos públicos. |

---
 
## 2.7. Restrições e Condições

* **Quantidade de telas:** O protótipo deve ter no máximo 4 telas principais (Semáforo do Dia, Focos de Poluição, Formulário com Foto/GPS e Orientações de Proteção).
* **Número de interações:** A ação principal (notificar foco) deve ser resolvida em até 3 toques (Abrir > Tocar em "Notificar foco" > Tirar foto > Enviar).
* **Dispositivos:** Deve rodar de forma leve e fluida em smartphones básicos com suporte a geolocalização.
* **Versão do sistema operacional:** Compatível com versões amplamente distribuídas em aparelhos de entrada, garantindo que recursos nativos funcionem sem exigir as versões mais recentes do sistema.
* **Tamanho do aplicativo:** O app precisa ser leve e compacto para não sobrecarregar o armazenamento limitado de celulares mais simples.
* **Privacidade:** O usuário deve ter a opção garantida de registrar notificações de forma totalmente anônima.
* **Armazenamento:** Precisa permitir o download prévio do mapa de focos na memória interna do aparelho para viabilizar o uso quando não houver conexão.
* **Conectividade:** Funciona offline para registro de denúncias e restringe a sincronização de dados e mapas exclusivamente ao Wi-Fi para poupar os dados móveis.
* **Navegação:** Direta, simplificada e sem menus escondidos, facilitando o acesso rápido às 4 telas e garantindo a notificação imediata.
* **Acessibilidade:** Uso obrigatório do semáforo com cores universais (do verde-limão ao cinza-escuro) e tradução de siglas técnicas para frases do cotidiano que qualquer pessoa consiga entender.
* **Ambiente de utilização:** Ruas, margens de rios e praças, exigindo foco prioritário em modo claro e alto contraste para garantir leitura fácil sob sol direto.
* **Outras condições específicas:** Uso obrigatório de recursos de hardware como Câmera e GPS, além do compromisso de gerar dados públicos e exportáveis para prefeituras.
 
---
 
## 2.8. Pontos de Atenção
 
Os **3 aspectos mais importantes para o sucesso do aplicativo** identificados pelo grupo são:
 
1. **A denúncia tem que ser rápida de verdade (Regra dos 3 toques na rua):**  
   Se o usuário estiver andando na rua debaixo de sol e o app pedir para preencher formulários compridos, ele vai desistir na hora. O processo de abrir, bater a foto e enviar precisa ser quase automático.

2. **O app tem que salvar tudo sem internet:**  
   Muitos córregos e lixões ficam em lugares com sinal fraco de celular. Se o aplicativo depender de internet boa na hora para salvar a foto, o morador não vai conseguir avisar do problema onde mais importa. Poder salvar tudo offline e enviar só no Wi-Fi é o que vai fazer o app funcionar de verdade.

3. **Linguagem acolhedora e direta (Sem assustar as pessoas):**  
   Quem tem asma só quer saber: "posso sair na rua agora sem passar mal?". O app precisa responder isso com cores intuitivas e conselhos claros, sem ficar jogando números difíceis que só confundem e assustam o usuário.
