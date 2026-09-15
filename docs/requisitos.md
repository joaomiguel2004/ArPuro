### 2.1 Funcionalidades

#### Funcionalidade 1
* **Nome:** Painel de Risco Respiratório (Semáforo do Ar)
* **Descrição:** Exibição imediata na tela inicial do nível de risco respiratório local (Verde = Baixo, Amarelo = Moderado, Vermelho = Crítico) baseado no Índice de Qualidade do Ar (AQI) atualizado via API geolocalizada.
* **Necessidade do usuário que atende:** Permite que pessoas com doenças respiratórias (asma, rinite, bronquite) tomem decisões rápidas no início do dia sobre realizar atividades ao ar livre ou usar medicação preventiva.
* **Justificativa:** É a funcionalidade central de prevenção passiva do aplicativo, oferecendo valor imediato e contínuo ao usuário assim que abre o app.

---

#### Funcionalidade 2
* **Nome:** Mapeamento Colaborativo de Focos de Poluição
* **Descrição:** Interface baseada em mapa interativo onde cidadãos registram e visualizam denúncias ambientais (queimadas, córregos poluídos, descarte de lixo, vazamento de esgoto) georreferenciadas.
* **Necessidade do usuário que atende:** Permite que a comunidade exponha e acompanhe os problemas ambientais do seu próprio bairro que não aparecem nos canais oficiais ou estações governamentais.
* **Justificativa:** Transforma o aplicativo de um mero visualizador de dados em uma plataforma ativa de engajamento cívico em tempo real.

---

#### Funcionalidade 3
* **Nome:** Captura e Registro com Foto e Geolocalização
* **Descrição:** Fluxo prático dentro do app que aciona a câmera para captura instantânea do foco de poluição, vinculando automaticamente as coordenadas de GPS do dispositivo.
* **Necessidade do usuário que atende:** Garante rapidez e veracidade na denúncia, evitando a necessidade de digitar endereços complexos ou preencher formulários extensos.
* **Justificativa:** Reduz o atrito no registro de ocorrências no momento em que o usuário presenciou a infração ambiental.

---

#### Funcionalidade 4
* **Nome:** Envio de Denúncias com Garantia de Anonimato
* **Descrição:** Opção que permite o envio do reporte de poluição sem vincular qualquer Dado Pessoal Identificável (PII), endereço de e-mail ou cadastro obrigatório.
* **Necessidade do usuário que atende:** Protege o cidadão contra retaliações ao denunciar infrações de empresas, vizinhos ou descartes clandestinos em comunidades.
* **Justificativa:** Remove a principal barreira de medo do usuário, maximizando o volume e a honestidade das denúncias registradas.

---

#### Funcionalidade 5
* *Nome:* Validação Comunitária de Denúncias ("Efeito Waze")
* *Descrição:* Botões de interação no mapa onde outros usuários próximos à ocorrência podem confirmar a veracidade do foco de poluição ("Eu também vi isso") ou indicar que o problema foi resolvido ("Não existe mais").
* *Necessidade do usuário que atende:* Garante que a comunidade consulte um mapa confiável com dados reais e atualizados por vizinhos.
* *Justificativa:* Mecanismo indispensável para filtrar spams e falsas denúncias em plataformas colaborativas anônimas.

---

#### Funcionalidade 6
* *Nome:* Dicas Personalizadas de Saúde e Prevenção
* *Descrição:* Exibição de cards informativos com orientações práticas de saúde condicionadas ao nível do semáforo do dia e ao perfil do usuário (ex: idosos, praticantes de esportes, pais de crianças).
* *Necessidade do usuário que atende:* Orienta o usuário sobre ações concretas para mitigar crises respiratórias (ex: "Umidifique o quarto", "Evite exercícios entre 10h e 16h").
* *Justificativa:* Conecta o indicador ambiental diretamente com o cuidado com a saúde, reforçando a proposta de valor healthtech.

---

#### Funcionalidade 7
* *Nome:* Sistema de Notificações de Alerta de Risco
* *Descrição:* Envio de notificações push configuráveis quando a qualidade do ar na região do usuário atingir níveis críticos (Amarelo ou Vermelho).
* *Necessidade do usuário que atende:* Mantém o usuário protegido sem a necessidade de abrir o aplicativo manualmente todos os dias.
* *Justificativa:* Aumenta a retenção e o engajamento do usuário, agindo como um tutor passivo de saúde.

---

#### Funcionalidade 8
* *Nome:* Histórico e Filtro de Ocorrências Locais
* *Descrição:* Ferramenta de busca e filtragem no mapa para visualizar denúncias por tipo de poluição (Ar, Água, Lixo/Esgoto) ou por período (últimas 24h, última semana).
* *Necessidade do usuário que atende:* Permite que moradores e pesquisadores entendam os problemas recorrentes de uma região específica.
* *Justificativa:* Fornece inteligência de dados locais para embasar cobranças comunitárias ou ações de órgãos ambientais.

---

### 2.2 Requisitos funcionais

* **RF01 — Obtenção de Localização:** O sistema deve obter a localização via GPS do dispositivo para carregar os dados de qualidade do ar da região atual.
* **RF02 — Exibição do Semáforo:** O sistema deve exibir na tela inicial o painel "Semáforo" com o nível de risco (Verde, Amarelo, Vermelho) e o índice AQI atualizado.
* **RF03 — Captura de Mídia:** O sistema deve permitir que o usuário tire uma foto diretamente pelo aplicativo para anexar ao registro de denúncia.
* **RF04 — Registro de Coordenadas:** O sistema deve registrar automaticamente as coordenadas geográficas (latitude e longitude) no momento da criação da denúncia.
* **RF05 — Categorização de Ocorrências:** O sistema deve disponibilizar um seletor com categorias pré-definidas para a denúncia (Queimada, Córrego Poluído, Esgoto a Céu Aberto, Lixo Acumulado, Outros).
* **RF06 — Envio Anônimo:** O sistema deve permitir a publicação de denúncias de forma anônima, sem exigir login ou fornecimento de dados pessoais.
* **RF07 — Exibição de Mapa Interativo:** O sistema deve renderizar um mapa interativo exibindo marcadores personalizados para cada categoria de poluição reportada.
* **RF08 — Validação por Terceiros:** O sistema deve permitir que usuários próximos a um marcador confirmem a denúncia existente ("Eu também vi isso").
* **RF09 — Sinalização de Resolução:** O sistema deve permitir que usuários sinalizem a resolução ou inexistência de um ponto de poluição registrado.
* **RF10 — Exibição de Guias de Saúde:** O sistema deve exibir cards de recomendações de saúde adequados ao nível de risco exibido no painel inicial.
* **RF11 — Filtragem de Dados:** O sistema deve permitir a filtragem de ocorrências no mapa por tipo de contaminação e intervalo de tempo.
* **RF12 — Emissão de Alertas Push:** O sistema deve disparar notificações push locais quando o índice do ar atingir o nível Vermelho (Crítico).
* **RF13 — Busca de Localidades:** O sistema deve permitir que o usuário busque no mapa por endereços ou bairros específicos além de sua localização atual. 

---

### 2.3 Requisitos não funcionais

* *RNF01 — Usabilidade:* O usuário deve conseguir consultar a qualidade do ar da sua região e o painel de semáforo na tela principal em no máximo 1 (uma) interação após abrir o app.
* *RNF02 — Segurança e privacidade (LGPD):* O aplicativo não deve armazenar metadados identificáveis das fotos capturadas e deve garantir que denúncias anônimas não possuam vínculo com o IP ou ID único do dispositivo no banco de dados.
* *RNF03 — Desempenho:* O carregamento inicial dos marcadores de denúncias no mapa não deve ultrapassar 3 segundos sob conexões 4G/Wi-Fi convencionais.
* *RNF04 — Conectividade:* Em caso de ausência de conexão com a internet, o aplicativo deve permitir a captura da denúncia em modo offline e sincronizá-la assim que a conexão for reestabelecida.
* *RNF05 — Compatibilidade e Dispositivos:* O aplicativo deve ser desenvolvido de forma responsiva para rodar nos sistemas operacionais Android (a partir da versão 8.0) e iOS (a partir da versão 14.0).
* *RNF06 — Acessibilidade:* As cores do sistema "Semáforo" e dos marcadores do mapa devem acompanhar rotulagem textual e ícones distintos, garantindo a acessibilidade para usuários daltônicos (conformidade com WCAG).

---

### 2.4 CRUD

Operações de dados referente à entidade principal **Denúncia de Poluição**:

* **C — Criadas:** **Necessário.** O usuário cria novos registros de focos de poluição enviando foto, localização, categoria e descrição opcional.
* **R — Consultadas:** **Necessário.** Qualquer cidadão pode consultar e visualizar as denúncias espalhadas no mapa e no feed do aplicativo.
* **U — Atualizadas:** **Necessário (Parcial/Controlado).** A atualização dos dados ocorre de forma colaborativa: usuários incrementam o contador de confirmações ("Eu também vi isso") ou alteram o status do ponto para "Sinalizado como Resolvido".
* **D — Excluídas:** **Não aplicável diretamente ao usuário comum.**
  * *Justificativa:* Para preservar a integridade histórica dos dados e evitar que infratores apaguem denúncias de terceiros, usuários comuns não têm permissão para deletar registros. A exclusão é restrita à moderação interna do sistema quando uma denúncia atinge um limite crítico de sinalizações de spam ou após expiração automática de prazo (30 dias sem novas confirmações).

---

### 2.5 Priorização

* **Essenciais (Indispensáveis para a proposta principal):**
  * Painel de Risco Respiratório (Semáforo do Ar)
  * Mapeamento Colaborativo de Focos de Poluição
  * Captura e Registro com Foto e Geolocalização
  * Envio de Denúncias com Garantia de Anonimato

* **Importantes (Agregam valor, mas não são fundamentais):**
  * Validação Comunitária de Denúncias ("Efeito Waze")
  * Dicas Personalizadas de Saúde e Prevenção
  * Sistema de Notificações de Alerta de Risco

* **Secundárias (Podem ser desenvolvidas posteriormente):**
  * Histórico e Filtro de Ocorrências Locais
