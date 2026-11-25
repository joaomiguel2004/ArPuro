# Registro de Uso de IA — Projeto ArPuro

Este documento registra como o grupo usou Inteligência Artificial Generativa (IAGen) no desenvolvimento do aplicativo na Unidade II. Ele reúne os prompts que deram melhor resultado, os erros que a IA cometeu e como cada um foi corrigido, além da justificativa das bibliotecas adotadas.

A IA foi usada como **ferramenta de apoio**. Todo código gerado foi testado no emulador e ajustado pelo integrante responsável antes de entrar na branch `dev`. Nenhum trecho foi aceito sem que o grupo entendesse o que ele faz.

---

## 1. Onde a IA foi usada

O código da aplicação foi produzido com apoio de IA nas sprints de **17/11** e **24/11**. A tabela relaciona cada commit ao que foi gerado.

| Commit | Integrante | Ferramenta | O que foi gerado com IA |
| :---: | :--- | :--- | :--- |
| `30faffb` / `27fa7da` | William Estevam | Gemini | Estrutura base em camadas, tema, splash, Home (semáforo AQI), modal do índice AQI e tela de Perfil; ajuste do projeto Android |
| `e4ca64e` | João Miguel | Claude Code | Aba Saúde (check-in respiratório, alerta sazonal, recomendações do dia), modal de previsão sazonal e suporte web |
| `ae986a7` | José Victor | GitHub Copilot & Claude Code | Tela de Mapa (marcadores, filtros, busca, detalhe do foco) e tela Nova Denúncia (categoria, anonimato, pré-visualização) |
| `9b27f4f` / `b9eebc5` | Rian Vinícius | Claude Code | Tela de câmera em tela cheia, captura de GPS e horário, integração da foto com a Nova Denúncia; correção do build Android |
| `1b21cf1` | Manuel Luan | Claude Code | Modal de sucesso com XP após o envio e estado offline da Nova Denúncia |
| Sprint 3 | João Miguel | Claude Code | Autenticação anônima na splash, perfil local com XP e nível (`shared_preferences`), cache do último índice com timeout de 10 s e correção dos testes para rodar sem rede, GPS e Firebase |

Fora do código, a IA também apoiou a revisão de textos da documentação. Os diagramas de 10/11 (casos de uso, classes, banco de dados, mapeamento Dart e fluxograma) foram feitos pelo grupo, sem IA.

---

## 2. Prompts mais eficientes

O que mais melhorou as respostas foi dar à IA o **contexto do projeto** (stack, estrutura de pastas, cores) e o **protótipo de alta fidelidade** como referência, e pedir uma tela por vez. Pedidos amplos ("faça o app") geravam código genérico, fora do protótipo e difícil de revisar.

### 2.1 Contexto fixo enviado no início de cada sessão

```text
Você está me ajudando no ArPuro, um app Flutter/Dart de qualidade do ar e
denúncia de focos de poluição. Regras do projeto:
- Arquitetura por feature: lib/features/<feature>/{data,domain,presentation,widgets}.
- Cores e tema ficam em lib/core/theme (AppColors, AppTheme). Não use cores soltas.
- Modo claro e alto contraste (o app é usado na rua, sob o sol).
- Textos da interface em português do Brasil.
- Gerenciamento de estado com Riverpod.
- Cada widget reutilizável em um arquivo próprio dentro de widgets/.
Antes de escrever código, liste os arquivos que vai criar ou alterar.
```

### 2.2 Gerar uma tela a partir do protótipo

```text
Segue o print da tela "<nome>" do nosso protótipo de alta fidelidade.
Implemente essa tela em lib/features/<feature>/presentation/<nome>_screen.dart,
quebrando os blocos visuais em widgets separados em widgets/.
Respeite espaçamentos, raios de borda e hierarquia de texto do protótipo.
Use dados de exemplo fixos por enquanto, mas deixe-os em um único lugar
para trocarmos depois pelo Firestore.
```

Funcionou bem porque a imagem do protótipo eliminou a ambiguidade visual e o pedido de "dados em um único lugar" deixou o código pronto para a integração com o banco (ex.: `MapScreen.defaultMapReports`).

### 2.3 Integrar recurso nativo (câmera e GPS)

```text
Crie a tela de câmera em tela cheia do protótipo usando o pacote camera.
Requisitos:
- Pedir a localização com geolocator assim que a tela abrir, sem travar a câmera.
- Tratar permissão negada, câmera indisponível e app indo para segundo plano.
- Permitir escolher da galeria como alternativa.
- Devolver um objeto CapturedPhoto (arquivo, horário, latitude, longitude)
  via Navigator.pop.
- Adicionar as permissões necessárias no AndroidManifest.
Explique cada estado de erro que você tratou.
```

Pedir explicitamente os casos de falha fez a IA gerar os estados `loading`, `ready`, `denied` e `unavailable` e o tratamento do ciclo de vida da câmera, que normalmente ficam de fora.

### 2.4 Pedir testes junto com a funcionalidade

```text
Escreva testes de widget para esse fluxo. Os testes não podem depender
de câmera ou GPS reais: injete as dependências pelo construtor para que
possam ser substituídas por versões falsas.
```

Esse prompt originou o parâmetro `openCamera` da `HomeScreen` e o `_FakeLocationService` dos testes, que permitem testar o fluxo sem o hardware.

### 2.5 Diagnóstico de erro de build

```text
O build Android falha com este erro (log completo abaixo).
Explique a causa antes de propor a correção e diga quais versões de
pacotes estão envolvidas. Não altere código que não tenha relação com o erro.
<log>
```

Pedir a causa antes da correção evitou que a IA saísse alterando arquivos aleatórios até o erro sumir.

---

## 3. Erros gerados pela IA e como foram resolvidos

| # | Erro gerado pela IA | Como o grupo identificou | Solução adotada | Commit |
| :---: | :--- | :--- | :--- | :---: |
| 1 | O primeiro commit subiu arquivos gerados automaticamente e específicos da máquina (`ios/Flutter/ephemeral/`, `Generated.xcconfig` com caminhos `C:\Users\...`, `gradle-wrapper.jar`) e o `.gitignore` sugerido ignorava o `pubspec.lock`. | Os colegas não conseguiam rodar o projeto depois do `git pull`: faltavam arquivos do Android e as versões dos pacotes variavam entre as máquinas. | `.gitignore` substituído pelo padrão do Flutter, `pubspec.lock` passou a ser versionado e os arquivos de plataforma foram recriados. | `27fa7da` |
| 2 | O projeto Android gerado usava a **embedding v1**, removida nas versões atuais do Flutter, e o build falhava. | Erro no `flutter run` informando o uso da embedding v1 descontinuada. | Pasta `android/` recriada com `flutter create --platforms=android .`, com `MainActivity` estendendo `io.flutter.embedding.android.FlutterActivity` e Gradle em Kotlin DSL (`.kts`). | `27fa7da` |
| 3 | A IA sugeriu o pacote `camera` na versão `0.11.x`, que puxa o `camera_android_camerax 0.6.30`. Essa versão não compila em JDKs recentes (`class file for androidx.concurrent.futures.CallbackToFutureAdapter not found`). | O build Android quebrou logo após a integração da câmera. | Leitura do changelog do pacote e atualização para `camera ^0.12.2`, que traz o `camera_android_camerax 0.7.6+1` com a correção. | `b9eebc5` |
| 4 | A IA gerou as dependências do Firebase no `pubspec.yaml`, mas não a configuração (`firebase_options.dart`, `google-services.json`). Com `Firebase.initializeApp()` ativo, o app fechava ao abrir. | Tela branca e exceção `[core/no-app]` no primeiro teste. | Configuração feita com `flutterfire configure` (gera `firebase_options.dart` e `google-services.json`) e inicialização reativada com `DefaultFirebaseOptions.currentPlatform`. | `3f96c74` |
| 5 | O mapa gerado pelo Copilot é um **mapa simulado** desenhado com `CustomPaint`, e não o Google Maps exigido pelo aditivo. As posições dos marcadores são proporções da tela, não coordenadas reais. | Revisão do código comparando com o aditivo da Unidade II. | Mantido como protótipo navegável. A troca por `google_maps_flutter` com coordenadas reais e agrupamento de marcadores está na Sprint 4. | `ae986a7` (pendente) |
| 6 | O estado offline da Nova Denúncia é apenas visual: o parâmetro `isOffline` não está ligado a nenhuma detecção de rede nem a uma fila local. | A própria IA indicou a limitação em comentário no código, e o grupo confirmou na revisão. | Mantido como base de interface. A detecção de conectividade e a fila offline-first entram na Sprint 4. | `1b21cf1` (pendente) |
| 7 | Os primeiros testes de widget tentavam abrir a câmera e o GPS reais e falhavam no `flutter test`, que não tem acesso a plugins nativos. | Testes quebrando com `MissingPluginException`. | Injeção de dependências: `HomeScreen.openCamera` e `CameraScreen.locationService` recebem versões falsas nos testes. | `9b27f4f` |
| 8 | Depois da integração com a API, a `HomeScreen` passou a depender do Riverpod e da rede, mas os testes antigos continuaram montando a tela sem `ProviderScope`. Três testes quebraram na `dev`. | `flutter test` falhando com `No ProviderScope found` e chamadas reais ao GPS. | Criado `test/helpers/test_app.dart`, que sobrescreve os providers de localização, da API e da autenticação com versões falsas. | Sprint 3 |

### Lições aprendidas

- **Conferir versões de pacotes no pub.dev.** A IA tende a sugerir versões antigas, que eram as mais comuns quando ela foi treinada (erro 3).
- **Revisar o `git status` antes de commitar código gerado.** A IA não sabe quais arquivos são locais da máquina (erro 1).
- **Dependência adicionada não é funcionalidade pronta.** Pacote no `pubspec.yaml` não significa integração configurada (erro 4).
- **Comparar a entrega com o aditivo, não só com o protótipo.** A tela pode estar fiel ao design e ainda não cumprir a regra de negócio (erros 5 e 6).

---

## 4. Justificativa das bibliotecas

### Em uso

| Biblioteca | Versão | Por que foi escolhida |
| :--- | :---: | :--- |
| `flutter_riverpod` | ^2.6.1 | O aditivo exige Provider, Riverpod ou Bloc. Escolhemos o Riverpod por não depender do `BuildContext`, ser verificado em tempo de compilação e facilitar a substituição de dependências nos testes. |
| `firebase_core` | ^3.15.2 | Base obrigatória para usar qualquer serviço do Firebase (stack obrigatória da disciplina). |
| `firebase_auth` | ^5.7.0 | Exigido pela stack da disciplina. Usamos só a **autenticação anônima**: o app entra sozinho, sem login nem dado pessoal, e o UID gerado protege as regras de segurança do Firestore sem identificar o usuário. |
| `cloud_firestore` | ^5.6.12 | Banco de dados da stack obrigatória. Tem cache local e escrita offline nativos, o que ajuda no requisito offline-first das denúncias. |
| `camera` | ^0.12.2 | Controle total da câmera (preview em tela cheia, flash, troca de lente) para reproduzir a tela do protótipo, o que o `image_picker` não oferece. |
| `image_picker` | ^1.1.2 | Alternativa para escolher foto da galeria quando a câmera não está disponível ou a permissão foi negada. Já reduz a qualidade da imagem (`imageQuality: 85`). |
| `geolocator` | ^13.0.4 | Obtém latitude e longitude para georreferenciar a denúncia, com tratamento de permissão e de GPS desligado. É o pacote de localização mais mantido do ecossistema Flutter. |
| `cupertino_icons` | ^1.0.8 | Ícones padrão do Flutter para iOS. |
| `http` | ^1.5.0 | Chamadas ao backend de qualidade do ar e leitura do JSON, com timeout de 10 segundos. |
| `shared_preferences` | ^2.5.6 | Perfil local (nome, XP e nível), último índice de qualidade do ar e última localização, guardados só no aparelho. |
| `flutter_lints` | ^6.0.0 | Regras de análise estática recomendadas pelo time do Flutter, para manter o código gerado por IA dentro de um padrão. |

### Previstas para as próximas sprints

| Biblioteca | Finalidade |
| :--- | :--- |
| `google_maps_flutter` | Mapa real com marcadores coloridos e agrupamento de focos. |
| `firebase_storage` | Upload das fotos das denúncias. |
| `flutter_image_compress` | Compressão da foto e remoção dos metadados EXIF antes do upload. |
| `connectivity_plus` | Detecção de conexão para o modo offline e a sincronização apenas com Wi-Fi. |
| `fl_chart` | Gráficos de histórico e estatísticas ambientais. |
| `pdf` | Exportação dos dados para prefeituras. |
