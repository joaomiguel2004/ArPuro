# Escopo do Projeto — ArPuro

## 1. Visão geral

O ArPuro é um aplicativo móvel em **Flutter/Dart com Firebase** que conecta a saúde respiratória da população à qualidade do ar. Ele funciona como um "boletim meteorológico da saúde": informa em linguagem simples o risco de respirar o ar local, sugere medidas de proteção e permite que o cidadão notifique focos de poluição com foto e GPS.

## 2. Objetivo

Entregar até **01/12/2026** um aplicativo funcional que:

1. Mostre o risco do ar da região em formato de semáforo, a partir de uma API pública.
2. Permita notificar focos de poluição em até 3 toques, com foto, GPS e opção de anonimato.
3. Exiba os focos notificados em um mapa colaborativo.
4. Oriente o usuário com dicas de proteção de acordo com o risco do dia.

## 3. Personas atendidas

| Persona | Perfil | Uso principal | O que o escopo entrega para ela |
| :--- | :--- | :--- | :--- |
| **Mariana Costa** (prioritária) | Engenheira ambiental e articuladora comunitária, com Android de entrada e plano pré-pago | Esporádico, para notificar focos durante o trabalho de campo | Notificação rápida com câmera e GPS, anonimato, mapa de focos, fotos comprimidas, funcionamento offline e exportação de dados |
| **Lucas Silveira** | Designer com asma moderada que corre ao ar livre | Diário, para checar o ar antes de sair | Semáforo do dia, risco em linguagem simples, guia de saúde, previsão sazonal e alertas de piora |

Os demais públicos do estudo de caso (professores, gestores públicos e pesquisadores) são atendidos pelo mapa público, pelas estatísticas e pela exportação de dados.

## 4. Dentro do escopo

### 4.1 Funcionalidades

| Módulo | Funcionalidades | Requisitos |
| :--- | :--- | :--- |
| **Acesso anônimo** | Autenticação anônima e automática pelo Firebase Auth ao abrir o app, sem tela de login, cadastro ou dado pessoal (ver seção 5.1) | Avaliação a) ii, RF06 |
| **Semáforo do ar** | Índice AQI via API pública (HTTP + JSON); tradução do MP10 em linguagem simples; classificação de risco (baixo, moderado, alto, crítico); cache com aviso "Desatualizado" se a API cair ou passar de 10 s; atualização automática | RF01, RF02 |
| **Notificação de focos** | Câmera e galeria; GPS e horário automáticos; categoria; envio anônimo; compressão da imagem e remoção do EXIF; upload para o Firebase Storage com estado de carregamento; fila offline-first | RF03, RF04, RF05, RF06, RNF02, RNF04 |
| **Mapa colaborativo** | Focos no Google Maps com marcadores coloridos por categoria; agrupamento de marcadores; filtro por categoria; busca por bairro; confirmação "Eu também vi isso" e sinalização de resolvido | RF07, RF08, RF09, RF11, RF13 |
| **Saúde e proteção** | Guia de saúde por nível de risco; check-in de sintomas respiratórios; previsão sazonal | RF10 |
| **Perfil local e gamificação** | Perfil guardado só no aparelho, com nome padrão "Usuário" que pode ser trocado por um apelido; XP e nível ganhos a cada denúncia; contadores de denúncias e validações; perfil de saúde e notificações (ver seção 5.1) | Aditivo Unidade II |
| **Dados ambientais** | Favoritos de locais monitorados; histórico diário e gráficos; exportação em PDF | Aditivo Unidade II |
| **Alertas** | Alertas personalizados de piora da qualidade do ar | RF12 |

### 4.2 Requisitos técnicos

- Stack obrigatória: Dart, Flutter, Firebase Authentication (modo anônimo) e Cloud Firestore.
- Gerenciamento de estado com Riverpod.
- Arquitetura em camadas (Presentation, Domain e Data), organizada por feature.
- Modo claro e alto contraste para leitura sob o sol.
- No mínimo três testes automatizados.
- Execução em Android, inclusive em aparelhos básicos com GPS.

### 4.3 Entregáveis

- Código-fonte no repositório GitHub da equipe.
- Documentação técnica em `/docs`: casos de uso, diagrama de classes, modelagem do banco, mapeamento Dart ↔ Firestore, fluxo de navegação, registro de uso de IA, escopo, EAP e sprints.
- `README.md` com as responsabilidades reais de cada integrante e `CHANGELOG.md` atualizado.
- Apresentação e defesa do projeto em 02/12 e 09/12.

## 5. Fora do escopo

### 5.1 Decisão de projeto: aplicativo anônimo

O estudo de caso determina que o usuário deve poder notificar anonimamente, e o RF06 e o RNF02 proíbem exigir login ou guardar dados que identifiquem quem denunciou. Por isso o ArPuro **não tem login, cadastro nem identidade de usuário**.

Para cumprir a exigência de usar o Firebase Authentication sem ferir o anonimato, o app usa a **autenticação anônima** do Firebase:

- Ao abrir o app, a splash chama `signInAnonymously()` sem nenhuma ação do usuário.
- O Firebase gera um UID aleatório que não está ligado a nome, e-mail, telefone ou conta.
- O UID serve apenas para as regras de segurança do Firestore (só usuários autenticados pelo app podem gravar).
- O UID **não é gravado nas denúncias**, para que não seja possível ligar uma denúncia a quem a fez.

Assim, a "tela de login" pedida no item e) i é substituída pela splash com entrada anônima automática.

#### Perfil local e gamificação

Para engajar o usuário sem identificá-lo, o app tem um perfil com XP que existe **somente no aparelho**:

- Todo usuário começa como **"Usuário"**. Se quiser, pode trocar por um nome ou apelido na tela de Perfil.
- Cada denúncia enviada soma XP e faz o usuário subir de nível. O modal "Alerta Registrado!" mostra o XP ganho.
- Nome, XP, nível, contadores e preferências ficam guardados localmente (`shared_preferences`) e **nunca são enviados ao Firebase**. As denúncias continuam anônimas mesmo para quem colocou o próprio nome.
- Não há backup: se o usuário trocar de celular, formatar ou apagar os dados do app, o perfil e o progresso são perdidos.

### 5.2 Itens fora do escopo

| Item | Motivo |
| :--- | :--- |
| Login, cadastro, recuperação de senha e login social | O app é anônimo por definição do estudo de caso (seção 5.1). |
| Envio de nome, e-mail, foto ou qualquer dado pessoal ao servidor | Contraria o RNF02 (LGPD) e o compromisso de anonimato. O apelido opcional fica só no aparelho. |
| Backup ou sincronização do perfil entre aparelhos | Sem conta, não há como ligar dois aparelhos ao mesmo usuário. O perfil e o XP são perdidos ao trocar de celular ou formatar. |
| Ranking entre usuários | Exigiria enviar nome e XP ao servidor, o que quebraria o anonimato. |
| Versão iOS publicada | O grupo não tem Mac para compilar e assinar. O código é multiplataforma, mas os testes serão feitos só no Android. |
| Publicação nas lojas (Play Store / App Store) | Não é exigida pela disciplina. |
| Monitoramento da qualidade da água | Faz parte da missão, mas as APIs públicas não oferecem dados por bairro. Fica para uma versão futura. |
| Moderação manual de denúncias | Será substituída pela validação comunitária (confirmar ou sinalizar como resolvido). |
| Exclusão de denúncias pelo usuário | Decisão do CRUD da Unidade I: preservar o histórico e impedir que infratores apaguem registros. |
| Sensores próprios de medição | O app usa dados públicos e notificações dos cidadãos. |

## 6. Restrições

- **Prazo:** entregas semanais até terça-feira 23h59; entrega final até 01/12/2026.
- **Equipe:** 5 integrantes, em paralelo com outras disciplinas.
- **Custo zero:** apenas planos gratuitos (Firebase Spark, cota gratuita do Google Maps, API pública de qualidade do ar).
- **Dados móveis:** fotos comprimidas antes do upload e sincronização do mapa offline apenas com Wi-Fi.
- **Uso de IA:** permitido, desde que registrado em `docs/uso-de-ia.md` e compreendido por todo o grupo.

## 7. Critérios de aceite

- O app compila e roda no emulador Android sem erros.
- A notificação de um foco é concluída em até 3 toques: abrir → câmera → enviar.
- Se a API de qualidade do ar falhar, o app mostra o último dado salvo com o aviso "Desatualizado".
- Uma denúncia feita sem internet é enviada automaticamente quando a conexão volta.
- O app abre e funciona sem pedir login ou dado pessoal; o perfil começa como "Usuário".
- Nome, XP e nível ficam só no aparelho e não aparecem em nenhum documento do Firestore.
- Nenhum documento de denúncia no Firestore guarda o UID ou outro dado que identifique o usuário.
- Pelo menos três testes automatizados passam no `flutter test`.
