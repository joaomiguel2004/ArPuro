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
