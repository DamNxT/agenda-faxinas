# Agenda de Faxinas — Documento do Projeto

> Este arquivo descreve o projeto inteiro. Leia antes de começar cada nova etapa.

## Objetivo

Aplicativo Android de uso pessoal para uma diarista (faxineira) que também faz
doces para vender. Ela tem vários clientes e às vezes se confunde sobre qual casa
ir em cada dia. O app deve:

- Organizar a agenda de faxinas (quem atender em cada dia).
- Mostrar quanto ela ganhou por dia e por mês (faxinas + doces).

### Exemplo real de agenda

- Cliente A: toda segunda e quinta
- Cliente B: toda terça
- Clientes C e D: quarta-feira, a cada 15 dias

## Tecnologia

- Flutter (Dart), somente Android.
- Banco de dados local no celular: SQLite com o pacote **drift**.
- Sem servidor, sem login, sem internet.
- Tudo em português do Brasil.
- Interface para pessoa idosa ou pouco acostumada com tecnologia:
  letras grandes, botões grandes, poucas telas, cores com bom contraste.

## Modelo de dados

| Tabela (drift)        | Campos                                                                                   |
|-----------------------|------------------------------------------------------------------------------------------|
| `clientes`            | id, nome, endereço (opcional), valor padrão da diária                                    |
| `regras_recorrencia`  | id, cliente, dias da semana (um ou mais), intervalo em semanas, data de início, data de fim (opcional) |
| `excecoes`            | id, regra, data original, nova data (vazia = cancelada)                                  |
| `atendimentos_avulsos`| id, cliente, data, valor                                                                 |
| `registros_diaria`    | id, cliente, data, valor recebido                                                        |
| `vendas_doces`        | id, data, quantidade levada, valor total vendido                                         |

Detalhes:

- **Regra de recorrência**: intervalo em semanas `1` = toda semana, `2` = a cada
  15 dias. A **data de início** é necessária para saber em quais semanas cai o
  "a cada 15 dias". Dias da semana usam o padrão do Dart: 1 = segunda ... 7 = domingo.
- **Exceção**: move ou cancela **uma** data de uma regra sem alterar as semanas
  seguintes. Se `nova_data` estiver vazia, a faxina daquele dia foi cancelada.
  Só pode existir uma exceção por regra + data original.
- **Atendimento avulso**: faxina única, que não segue regra.
- **Registro de diária**: o valor que foi realmente recebido naquele dia.
- **Venda de doces**: data, quantidade levada e valor total vendido.

### Decisões técnicas

- Dinheiro é guardado em **centavos** (número inteiro) para evitar erros de
  arredondamento. Ex.: R$ 150,00 = `15000`.
- Datas são guardadas como texto (`store_date_time_values_as_text` no
  `build.yaml`), sempre à meia-noite, pois só o dia importa.
- Chaves estrangeiras ligadas (`PRAGMA foreign_keys = ON`).
- Apagar um cliente apaga junto suas regras, exceções e atendimentos avulsos.
- Um cliente que já tem **registros de diária** não pode ser apagado (para não
  perder o histórico de ganhos).

## Regra importante

**Não gravar no banco todas as datas futuras.** As datas da agenda devem ser
**calculadas** a partir das regras de recorrência, aplicando as exceções por cima,
e somando os atendimentos avulsos.

### Como o "a cada 15 dias" é calculado

Conta-se quantas semanas (de segunda a domingo) existem entre a semana da data de
início e a semana do dia. Se o número for múltiplo do intervalo, a faxina acontece.
Ex.: quarta a cada 15 dias começando em 07/10/2026 → 07/10, 21/10, 04/11, ...,
16/12, 30/12, 13/01/2027. Testes em `test/dados/calculo_agenda_test.dart`.

Faxina "só desta vez" usa o valor padrão da diária do cliente.

## Regras de design (seguir em todas as etapas)

Estilo minimalista, calmo e muito legível, para uma pessoa com pouca
familiaridade com tecnologia, usando o celular na rua e às vezes sob sol forte.

### Onde fica cada coisa
- **Tema central:** `lib/tema/tema_app.dart` (`CoresApp`, `MedidasApp`,
  `TextosApp` e `criarTemaApp()`). **Nunca** escreva uma cor, tamanho de letra ou
  canto direto na tela: use estas constantes ou o `Theme.of(context)`.
- **Componentes prontos** (`lib/widgets/`):
  - `BotaoPrincipal` (+ `RodapeBotao` para fixar no rodapé): botão grande,
    largura total. `tipo: TipoBotao.secundario` = só contorno.
  - `CartaoFaxina`: avatar, nome, endereço, valor em R$, detalhe, situação
    (marcada / recebida / cancelada), borda laranja de hoje e botões de ação.
  - `CampoValor`: campo de dinheiro com "R$", teclado numérico e validação.
  - `EstadoVazio`: ícone, título, explicação do próximo passo e botão opcional.
  - `AvatarCliente`: círculo colorido com a inicial (a cor é sempre a mesma
    para o mesmo nome).
  - `avisos.dart`: `confirmarAcao` (antes de excluir), `mostrarAviso`
    (com `aoDesfazer` mostra "Desfazer") e `explicar` (aviso com "Entendi").
  - `TituloCampo` e `TelaVazia` (tela que ainda será feita).

### Paleta
| Uso | Cor | Constante |
|---|---|---|
| Fundo | `#FAF8F5` | `CoresApp.fundo` |
| Texto principal | `#1F2933` | `CoresApp.texto` |
| Texto de apoio | `#52606D` | `CoresApp.textoSecundario` |
| Botões e destaques | `#2F6F6B` | `CoresApp.principal` |
| Destaque de "hoje" | `#D9822B` | `CoresApp.hoje` |
| Sucesso / dinheiro recebido | `#2E7D32` | `CoresApp.sucesso` |
| Erro / cancelado | `#B3261B` | `CoresApp.erro` |

- Todo texto tem contraste mínimo de **4,5:1** com o fundo onde aparece. A
  conferência é automática em `test/tema/tema_app_test.dart`. Toda cor nova
  precisa entrar nesse teste.
- **O laranja de "hoje" não pode ser cor de texto** (o contraste dele com o
  fundo é 2,8:1). Use-o só como borda ou fundo, com texto escuro (`CoresApp.texto`)
  por cima.
- Branco só vai em cima de `principal`, `sucesso`, `erro` ou das cores dos avatares.

### Letras e tamanhos
- Fonte padrão do Android (Roboto), que já vem no celular. Nenhuma fonte é
  baixada da internet; se um dia trocar, a nova fonte deve ir dentro do app (`assets`).
- Nenhum texto menor que **18 sp**. O texto normal tem 20 sp e os títulos vão de 24 a 32 sp.
- Valores em reais usam `TextosApp.valor` (28 sp, extranegrito). Valor já
  recebido usa `TextosApp.valorRecebido` (verde).
- Qualquer coisa que se toca tem no mínimo **48 dp**. Botões têm 56 dp, e o
  botão principal tem 64 dp com cantos de 16. Cartões têm cantos de 20.
- Os testes de tela usam `androidTapTargetGuideline` e `textContrastGuideline`
  para conferir isso.

### Estrutura
- Barra de navegação inferior com 4 abas, **sempre com ícone e texto**: Hoje,
  Agenda, Ganhos e Mais (`lib/telas/estrutura/tela_principal.dart`).
- "Mais" tem Clientes, Doces, Backup e Configurações.
- A tela inicial é **Hoje**: data por extenso e cartões grandes das faxinas do
  dia, com nome, endereço e valor.
- Telas abertas a partir de uma aba ocupam a tela toda e têm a seta de voltar.

### Linguagem e comportamento
- Português simples, sem termos técnicos. Exemplos: "Mudar só esta vez",
  "Não, voltar", "Sim, excluir", "Entendi", "Desfazer".
- **Ações destrutivas** (excluir) sempre usam `confirmarAcao`. Os botões ficam
  um embaixo do outro, com "Não, voltar" em cima e o vermelho embaixo.
- **Ações reversíveis** (criar faxina e, no futuro, mudar ou cancelar uma data,
  marcar como recebido) mostram `mostrarAviso(..., aoDesfazer: ...)`.
- **Telas e listas vazias** usam `EstadoVazio`, explicando o próximo passo.
- Uma ação principal por tela, no rodapé (`RodapeBotao`).

## Funcionalidades (feitas em etapas)

1. Cadastro de clientes
2. Agenda por dia e por semana, com criação de faxina fixa ou avulsa
3. Mover ou cancelar uma data sem afetar as seguintes
4. Registro do valor da diária e resumo mensal de ganhos
5. Registro de venda de doces, somado ao resumo mensal
6. Lembrete diário com notificação e voz falando o nome do cliente do dia
7. Backup dos dados

### Situação atual

- [x] Etapa 0: projeto criado, banco com todas as tabelas, tela inicial com menu
  (Clientes, Agenda, Ganhos, Doces) e telas vazias.
- [x] Etapa 1: cadastro de clientes (lista, novo, editar, excluir com confirmação).
- [x] Etapa 2: agenda (hoje no topo, semana em lista, mês em calendário, toque no
  dia mostra os clientes, nova faxina fixa ou só desta vez).
- [x] Tema visual e componentes base (paleta, letras, barra inferior com
  Hoje/Agenda/Ganhos/Mais, tela Hoje, componentes reutilizáveis).
- [ ] Etapas 3 a 7.

## Estrutura de pastas

```
lib/
  main.dart                 # ponto de entrada: abre o banco e inicia o app
  app.dart                  # MaterialApp, tema e idioma pt-BR
  dados/banco/
    tabelas.dart            # definição das tabelas
    conversores.dart        # conversão da lista de dias da semana
    banco_dados.dart        # classe BancoDados (drift)
    banco_dados.g.dart      # GERADO pelo build_runner (não editar à mão)
  dados/agenda/calculo_agenda.dart  # CÁLCULO das datas (regras + exceções + avulsos)
  dados/repositorios/       # operações do banco por assunto (clientes, agenda)
  util/dinheiro.dart        # formatar "R$ 150,00" e converter texto -> centavos
  util/datas.dart           # contas com datas e nomes dos dias/meses em português
  tema/tema_app.dart        # TEMA CENTRAL: cores, letras, medidas, componentes
  tema/contraste.dart       # cálculo de contraste (usado nos testes)
  telas/
    estrutura/              # barra inferior com as 4 abas
    hoje/                   # aba Hoje (tela inicial)
    mais/                   # aba Mais (Clientes, Doces, Backup, Configurações)
    backup/ configuracoes/  # ainda vazias
    clientes/               # lista + formulário (novo/editar/excluir)
    agenda/                 # agenda, calendário e nova faxina (fixa/avulsa)
    ganhos/ doces/
  widgets/                  # componentes reutilizáveis (ver "Regras de design")
test/
  dados/                    # testes do banco e repositórios
  telas/                    # testes das telas
  util/                     # testes de funções auxiliares
  tema/                     # contraste das cores e tamanhos de letra
  widgets/                  # testes dos componentes
```

Ao mudar `tabelas.dart`, rode `dart run build_runner build` para regerar
`banco_dados.g.dart`, aumente `schemaVersion` e escreva a migração.
