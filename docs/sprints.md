# Planejamento do Desenvolvimento em Sprints — ArPuro

O desenvolvimento da Unidade II foi dividido em **sprints semanais**. As aulas são às quartas-feiras e cada sprint termina na **terça-feira anterior à aula, até 23h59**, quando ocorre o checkpoint com a professora. A entrega final é em 02/12, então a última sprint termina em 01/12.

O código é desenvolvido em branches de cada integrante, integrado na branch `dev` por pull request e depois levado para a `main`.

## Visão geral

| Sprint | Prazo | Foco | Status |
| :---: | :---: | :--- | :---: |
| 1 | Até 10/11 | Modelagem técnica do aplicativo | Concluída |
| 2 | Até 17/11 | Estrutura do projeto e telas principais | Concluída |
| 3 | Até 24/11 | Firebase com acesso anônimo, API de qualidade do ar e documentação de planejamento | Em andamento |
| 4 | Até 01/12 | Funcionalidades do aditivo, testes e entrega final | Planejada |

---

## Sprint 1 — Até 10/11 · Concluída

**Objetivo:** modelar o aplicativo antes de começar o código, já considerando as novas regras do aditivo.

| Entrega | Responsável | Commit |
| :--- | :--- | :---: |
| Diagrama de casos de uso atualizado | William Estevam | `43518af` |
| Mapeamento do domínio Dart | Rian Vinícius | `6e598bc` |
| Diagrama de classes | João Miguel | `b8993ec` |
| Modelagem do banco de dados (Firestore) | Manuel Luan | `3f4a9af` |
| Fluxograma de telas | José Victor | `d236ef7`, `a8c011c`, `6570840` |

**Resultado:** todos os artefatos de modelagem do item b) da avaliação foram entregues na pasta `/docs`.

---

## Sprint 2 — Até 17/11 · Concluída

**Objetivo:** criar o projeto Flutter e implementar as telas principais fiéis ao protótipo de alta fidelidade.

| Entrega | Responsável | Commit |
| :--- | :--- | :---: |
| Estrutura base em camadas, tema, splash, Home (semáforo AQI), modal do índice e Perfil | William Estevam | `30faffb` |
| Correção do projeto Android (embedding v2) e do `.gitignore` | William Estevam | `27fa7da` |
| Aba Saúde, modal de previsão sazonal e suporte web | João Miguel | `e4ca64e` |
| Mapa de focos (marcadores, filtros, busca, detalhe) e tela Nova Denúncia | José Victor | `ae986a7` |
| Câmera em tela cheia com GPS e integração com a Nova Denúncia | Rian Vinícius | `9b27f4f` |
| Correção do build Android da câmera | Rian Vinícius | `b9eebc5` |
| Modal de sucesso com XP e estado offline da Nova Denúncia | Manuel Luan | `1b21cf1` |
| Atualização do README e do CHANGELOG | João Miguel | `c04ccd8`, `fa53339`, `59fe77c` |

**Resultado:** o fluxo principal já pode ser navegado no app: Home → Câmera → Nova Denúncia → Enviar → Mapa. Foram criados testes automatizados de navegação, câmera e denúncia. Os dados ainda são fixos no código.

**Pendências levadas para as próximas sprints:** Firebase ainda não configurado, mapa simulado em vez do Google Maps e estado offline apenas visual (ver `docs/uso-de-ia.md`).

---

## Sprint 3 — Até 24/11 · Em andamento

**Objetivo:** conectar o app ao Firebase com acesso anônimo, consumir a API de qualidade do ar e documentar o planejamento.

| Entrega | Item da avaliação |
| :--- | :---: |
| Registro de uso de IA (`docs/uso-de-ia.md`) | b) vi |
| Escopo do projeto (`docs/escopo.md`) | d) i |
| EAP simplificada (`docs/eap.md`) | d) ii |
| Planejamento em sprints (este documento) | d) iii |
| Configuração do Firebase (`flutterfire configure`) e inicialização no `main.dart` | a) ii |
| Autenticação anônima automática na splash (`signInAnonymously()`), sem tela de login | a) ii, e) i |
| Perfil local: nome padrão "Usuário" editável, XP e nível ganhos por denúncia, salvos só no aparelho (`shared_preferences`) | RF06, RNF02 |
| Consumo da API de qualidade do ar (HTTP + JSON) no semáforo da Home | Aditivo |
| Cache do último índice com timeout de 10 s e aviso "Desatualizado" | Aditivo |
| Classificação automática de risco (baixo, moderado, alto, crítico) | Aditivo |
| Providers do Riverpod para os dados da Home | Aditivo |
| Atualização do README e do CHANGELOG | c) ii |

---

## Sprint 4 — Até 01/12 · Planejada

**Objetivo:** concluir as funcionalidades do aditivo, garantir a qualidade e preparar a entrega final.

| Entrega | Item da avaliação |
| :--- | :---: |
| CRUD de denúncias no Firestore (criar, listar, confirmar e marcar como resolvida) | a) iv |
| Compressão da foto, remoção do EXIF e upload ao Firebase Storage com loading | Aditivo |
| Fila offline-first de denúncias e detecção de conexão | Aditivo |
| Google Maps com marcadores coloridos e agrupamento de focos | Aditivo |
| Favoritos, histórico diário, gráficos e alertas de piora | Aditivo |
| Exportação dos dados em PDF | Aditivo |
| Revisão e ampliação dos testes automatizados (mínimo de três) | Aditivo |
| Revisão final da documentação, README e CHANGELOG | b), c) ii |
| Apresentação para a defesa em 02/12 | Observação 2 |

---

## Rotina das sprints

1. **Quarta-feira (aula):** checkpoint com a professora e divisão das tarefas da semana.
2. **Durante a semana:** cada integrante desenvolve na própria branch e abre pull request para a `dev`.
3. **Até terça-feira, 23h59:** revisão dos pull requests, teste no emulador, merge na `main` e atualização do CHANGELOG.
