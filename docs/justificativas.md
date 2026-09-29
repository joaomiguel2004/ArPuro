# 2.4 Justificativas

## Projeto ArPuro – Saúde Ambiental

As decisões de interface e arquitetura do ArPuro foram definidas a partir das necessidades identificadas na pesquisa, das características das personas, dos requisitos do sistema, do benchmark realizado e das condições reais de utilização previstas para o aplicativo.

O projeto possui dois perfis principais de usuários: **Mariana Costa**, ativista e articuladora comunitária que utiliza o aplicativo principalmente em campo para registrar ocorrências ambientais, e **Lucas Silveira**, usuário com asma que consulta regularmente a qualidade do ar para decidir sobre atividades ao ar livre. Mariana foi definida como a persona prioritária por representar o cenário de uso mais exigente em relação a conectividade, iluminação, mobilidade, desempenho e privacidade.

As decisões apresentadas a seguir procuram atender simultaneamente às necessidades desses usuários e às restrições estabelecidas para o projeto.

---

### 1. Escolha das cores

A interface utiliza uma paleta predominantemente clara, com o **verde** como uma das principais cores da identidade visual, associado à natureza, ao meio ambiente, à saúde e à qualidade do ar. O modo claro também foi priorizado devido ao contexto de uso externo, em que o aplicativo pode ser utilizado sob luz solar direta.

Além da identidade visual, as cores possuem uma função informativa por meio do **Semáforo do Ar**, que traduz o nível de risco respiratório em uma representação visual simples:

- **Verde:** risco baixo;
- **Amarelo:** risco moderado;
- **Vermelho:** risco crítico.

Essa escolha permite transformar informações técnicas, como o AQI, em uma indicação que pode ser compreendida rapidamente mesmo por usuários que não possuem conhecimentos sobre qualidade do ar.

O sistema de cores também é acompanhado por **textos, ícones e valores numéricos**, evitando que a informação dependa exclusivamente da percepção das cores. Essa decisão atende à necessidade de acessibilidade para usuários com daltonismo e facilita a interpretação das informações.

A escolha das cores também foi influenciada pelo benchmark realizado, no qual o sistema de semáforo utilizado por soluções de monitoramento da qualidade do ar foi identificado como uma referência visual eficiente para comunicar níveis de risco.

**Relação com o projeto e os usuários:** o sistema de cores permite que Lucas identifique rapidamente se as condições são adequadas para atividades externas e ajuda Mariana a interpretar informações ambientais rapidamente durante o uso em campo, inclusive sob iluminação intensa.

---

### 2. Tipografia

A interface utiliza uma hierarquia tipográfica para diferenciar informações principais, títulos, valores, descrições e informações complementares.

Os dados mais importantes recebem maior destaque visual. Na tela inicial, por exemplo, o valor do **AQI**, sua classificação e o risco respiratório são apresentados antes das informações complementares. Dessa forma, o usuário consegue identificar rapidamente a situação do ar sem precisar interpretar um grande volume de texto.

A tipografia também prioriza boa legibilidade, considerando que o aplicativo pode ser utilizado em smartphones de entrada e sob luz solar direta. Textos importantes devem permanecer claros sobre os fundos utilizados e as informações não devem depender de fontes pequenas.

A linguagem utilizada também procura evitar excesso de termos técnicos. Em vez de apresentar somente índices ou unidades científicas, o sistema traduz os dados em mensagens práticas, como **“Qualidade Boa”**, **“Risco Respiratório Baixo”** e recomendações de saúde.

**Relação com o projeto e os usuários:** a hierarquia facilita a consulta rápida realizada por Lucas antes de sair para praticar atividades físicas e também reduz o esforço de leitura de Mariana enquanto utiliza o aplicativo na rua.

---

### 3. Organização das informações

As informações são organizadas em blocos e cartões, permitindo separar os diferentes tipos de conteúdo e estabelecer uma ordem de prioridade.

Na tela inicial, a informação principal é a condição atual do ar, apresentada por meio do AQI, sua classificação e o risco respiratório. No mapa, são disponibilizados recursos para buscar regiões, visualizar ocorrências, utilizar filtros e identificar alertas ambientais.

A área de Saúde concentra informações relacionadas à condição do ar, percepção dos sintomas, recomendações e tendências sazonais. Já o Perfil reúne informações relacionadas ao usuário, perfil de saúde, privacidade e notificações.

Essa organização segue uma lógica de:

**informação principal → interpretação → recomendação → detalhes adicionais.**

A disposição também procura evitar que o usuário precise navegar por várias telas para executar tarefas essenciais. O estudo de caso determina que as principais tarefas, como consultar o Semáforo do Dia e iniciar uma denúncia, estejam disponíveis imediatamente.

**Relação com o projeto e os usuários:** a organização atende à necessidade de Lucas de compreender rapidamente as condições ambientais e à necessidade de Mariana de localizar rapidamente a função de denúncia durante o uso em campo.

---

### 4. Navegação

A navegação foi planejada para manter as funções principais facilmente acessíveis, utilizando uma estrutura simplificada com as áreas **Início, Mapa, Saúde e Perfil**, além do acesso destacado à função de registro de ocorrências.

A navegação também considera a **Regra dos 3 Toques**, estabelecida como uma restrição do projeto para o registro de focos de poluição. O fluxo deve permitir que o usuário abra a função de denúncia, acesse a câmera, registre a ocorrência e encaminhe os dados com o mínimo de interações possível.

A simplificação da navegação é especialmente importante porque Mariana pode utilizar o aplicativo enquanto caminha, segurando o smartphone com apenas uma mão e mantendo parte da atenção voltada para o ambiente ao seu redor.

Os elementos de navegação também devem evitar menus escondidos e caminhos longos para as funções essenciais. O usuário precisa conseguir consultar o risco do ar e iniciar uma denúncia rapidamente.

**Relação com o projeto e os usuários:** a navegação foi estruturada para reduzir o esforço cognitivo e físico durante o uso, atendendo principalmente à condição de uso em campo da persona prioritária e à necessidade de consulta rápida de Lucas.

---

### 5. Componentes

O protótipo utiliza componentes de interface relacionados diretamente às funcionalidades e aos requisitos do ArPuro, entre eles:

- barra de navegação inferior;
- botão de ação para registro de ocorrências;
- cartões de informação;
- indicador de AQI;
- Semáforo do Ar;
- indicadores de sincronização;
- indicador de estado offline;
- campo de busca por região ou bairro;
- filtros por categoria de ocorrência;
- mapa colaborativo;
- alertas de risco;
- câmera para registro de ocorrências;
- seleção da categoria da denúncia;
- informações de coordenadas GPS;
- indicadores de progresso;
- perfil de saúde;
- configurações de privacidade;
- notificações de risco;
- mensagens de confirmação após o registro.

A utilização de componentes recorrentes cria consistência visual e permite que o usuário reconheça padrões de interação ao navegar pelo aplicativo.

O botão relacionado à denúncia recebe destaque por representar uma das funcionalidades essenciais do projeto. O mapa e os filtros permitem consultar as ocorrências ambientais, enquanto o AQI e o Semáforo do Ar representam a principal informação preventiva de saúde.

**Relação com o projeto e os usuários:** os componentes foram selecionados para apoiar as tarefas principais identificadas nos requisitos: consultar o risco ambiental, localizar ocorrências, registrar uma denúncia com foto e GPS e receber orientações de saúde.

---

### 6. Acessibilidade

A acessibilidade foi considerada principalmente por meio de **contraste, legibilidade, hierarquia visual, linguagem simples, ícones e redundância de informações**.

O sistema de Semáforo do Ar não depende exclusivamente das cores para comunicar o risco. As categorias são acompanhadas por textos, valores e elementos visuais distintos, permitindo que usuários com daltonismo também consigam interpretar as informações.

O modo claro e o alto contraste foram priorizados devido ao contexto de utilização em ambientes externos com luz solar direta. Fontes legíveis e elementos suficientemente destacados reduzem as dificuldades de leitura nesse cenário.

A linguagem também foi simplificada para evitar que usuários precisem compreender conceitos técnicos relacionados à qualidade do ar. O AQI é apresentado acompanhado de sua classificação e possui uma tela específica explicando o significado do índice e suas faixas.

O aplicativo também oferece recursos relacionados às necessidades de saúde dos usuários, incluindo configurações de perfil para **asmáticos, crianças e idosos**, além de notificações e recomendações relacionadas ao risco ambiental.

O modo anônimo também representa uma decisão de acessibilidade relacionada à segurança e à inclusão, pois permite que usuários que tenham receio de retaliações possam participar do sistema sem expor sua identidade.

**Relação com o projeto e os usuários:** essas decisões permitem que diferentes perfis de usuários compreendam as informações ambientais, inclusive em condições de iluminação desfavoráveis, e consigam utilizar o sistema sem depender de conhecimentos técnicos ou de identificação pública.

---

### 7. Decisões relacionadas ao contexto de uso

O contexto de uso foi um dos principais fatores considerados na definição da interface.

A persona prioritária, Mariana Costa, utiliza o aplicativo principalmente em **ruas, margens de rios, córregos, praças e bairros periféricos**, muitas vezes enquanto caminha e segurando o smartphone com apenas uma mão. Ela pode utilizar um smartphone de entrada, possuir armazenamento limitado e depender de um plano de dados móveis econômico.

Por esse motivo, a interface foi pensada para:

- permitir interação rápida;
- utilizar botões e áreas de toque fáceis de alcançar;
- funcionar em modo claro;
- apresentar informações de maneira visual;
- reduzir textos extensos durante tarefas rápidas;
- consumir poucos recursos;
- funcionar em condições de conectividade instável;
- permitir o registro offline;
- preservar o anonimato do usuário.

O funcionamento offline é especialmente importante para o registro de denúncias. Quando não houver conexão, a ocorrência deve ser armazenada localmente no dispositivo e posteriormente sincronizada quando houver conectividade adequada.

A documentação do projeto também estabelece que a sincronização deve ocorrer **exclusivamente por Wi-Fi**, evitando que o envio de fotos e outros dados consuma a franquia de internet móvel do usuário.

O uso do GPS também é importante nesse contexto, pois permite registrar automaticamente as coordenadas do foco de poluição sem exigir que Mariana digite manualmente um endereço.

Para Lucas, o contexto de uso é diferente: ele consulta o aplicativo principalmente pela manhã, antes de sair para caminhar ou correr. Por isso, a tela inicial precisa apresentar imediatamente o risco atmosférico e as recomendações de saúde.

**Relação com o projeto e os usuários:** as decisões consideram tanto o uso pontual e externo de Mariana quanto o uso recorrente e preventivo de Lucas, mantendo como prioridade as condições mais exigentes representadas pela persona prioritária.

---

### 8. Arquitetura do sistema

A arquitetura do ArPuro deve atender às funcionalidades de monitoramento ambiental, saúde, geolocalização, denúncia colaborativa e funcionamento offline.

De forma geral, o sistema pode ser organizado em três partes principais: **interface**, **camada de aplicação** e **dados/integrações**.

```text
┌────────────────────────────────────┐
│          INTERFACE MOBILE          │
│                                    │
│  Início | Mapa | Saúde | Perfil    │
│  Denúncia | Alertas | Orientações  │
└──────────────────┬─────────────────┘
                   │
                   ▼
┌────────────────────────────────────┐
│        CAMADA DE APLICAÇÃO         │
│                                    │
│ • AQI / Semáforo do Ar             │
│ • Alertas de saúde                 │
│ • Gerenciamento de denúncias       │
│ • Categorias de ocorrências        │
│ • Anonimato                        │
│ • Regras de sincronização          │
│ • Validação comunitária            │
└──────────────────┬─────────────────┘
                   │
          ┌────────┴─────────┐
          ▼                  ▼
┌───────────────────┐ ┌────────────────────┐
│ ARMAZENAMENTO      │ │ INTEGRAÇÕES       │
│ LOCAL              │ │                   │
│                    │ │ • GPS             │
│ • Denúncias        │ │ • Câmera          │
│ • Fotos            │ │ • API de AQI      │
│ • Fila offline     │ │ • Rede / Wi-Fi    │
└───────────────────┘ └────────────────────┘
