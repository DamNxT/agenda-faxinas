# Como instalar, rodar e gerar o APK (guia para iniciante)

Este guia supõe um computador com **Windows 10/11**. No fim há notas para Mac e Linux.
Reserve umas 2 horas na primeira vez (os downloads são grandes, ~10 GB).

---

## Parte 1 — Instalar as ferramentas (só uma vez)

### 1.1 Git
1. Baixe em <https://git-scm.com/download/win> e instale clicando em **Next** em tudo.

### 1.2 Android Studio (traz o "Android SDK", necessário para gerar apps Android)
1. Baixe em <https://developer.android.com/studio> e instale com as opções padrão.
2. Abra o Android Studio. Na primeira vez ele mostra um assistente
   (**Setup Wizard**): escolha **Standard** e deixe baixar tudo.
3. Na tela inicial, clique em **More Actions → SDK Manager**:
   - Aba **SDK Tools**: marque **Android SDK Command-line Tools (latest)** e clique em **Apply**.

### 1.3 Flutter
1. Siga o guia oficial: <https://docs.flutter.dev/get-started/install/windows/mobile>
   (resumo: baixe o arquivo `.zip` do Flutter e extraia em `C:\dev\flutter`).
   - **Não** extraia dentro de `C:\Program Files` (dá problema de permissão).
2. Coloque o Flutter no **PATH** (para o Windows achar o comando `flutter`):
   - Aperte a tecla Windows, digite **variáveis de ambiente** e abra
     "Editar as variáveis de ambiente para sua conta".
   - Selecione **Path** → **Editar** → **Novo** → digite `C:\dev\flutter\bin` → **OK**.
3. Feche e abra de novo o terminal (**PowerShell**) e rode:
   ```
   flutter doctor
   ```
4. Aceite as licenças do Android (responda `y` em todas as perguntas):
   ```
   flutter doctor --android-licenses
   ```
5. Rode `flutter doctor` de novo. O importante é ter **[√]** em
   *Flutter* e *Android toolchain*. Avisos sobre Chrome, Visual Studio ou
   "Windows" podem ser ignorados (o app é só para Android).

### 1.4 (Opcional, recomendado) VS Code
Editor de código mais leve que o Android Studio.
Baixe em <https://code.visualstudio.com> e instale a extensão **Flutter**.

---

## Parte 2 — Baixar o projeto e preparar

No PowerShell:
```
cd C:\dev
git clone <URL-DO-REPOSITORIO> agenda_faxinas
cd agenda_faxinas
flutter pub get
```
(`flutter pub get` baixa as bibliotecas que o app usa, como o banco de dados drift.)

Para conferir que está tudo certo, rode os testes automáticos:
```
flutter test
```
Deve aparecer **All tests passed!** no final.

---

## Parte 3 — Rodar o app no celular pelo cabo USB

### 3.1 Ligar o "modo desenvolvedor" no celular (só uma vez)
1. No celular, abra **Configurações → Sobre o telefone**
   (em alguns aparelhos: **Sobre o telefone → Informações do software**).
2. Toque **7 vezes** em **Número da versão** (ou "Número de compilação").
   Aparece a mensagem "Você agora é um desenvolvedor".
3. Volte para **Configurações → Sistema → Opções do desenvolvedor**
   (em Samsung fica no fim do menu de Configurações).
4. Ative **Depuração USB**.

### 3.2 Conectar
1. Ligue o celular no computador com o cabo USB
   (use um cabo que transmite dados, não só de carregar).
2. No celular, aparece "Permitir depuração USB?": marque
   **Sempre permitir neste computador** e toque em **Permitir**.
3. No PowerShell, rode:
   ```
   flutter devices
   ```
   O nome do seu celular deve aparecer na lista.
   - Não apareceu? Troque o cabo/porta USB, desbloqueie a tela do celular e,
     na notificação "USB", escolha **Transferência de arquivos**.
     Em alguns aparelhos no Windows é preciso instalar o driver USB do fabricante.

### 3.3 Rodar
Dentro da pasta do projeto:
```
flutter run
```
A primeira vez demora bastante (vários minutos). Depois o app abre sozinho no celular.

Com o `flutter run` aberto, no terminal:
- tecle **r** para recarregar depois de mudar o código (hot reload);
- tecle **q** para sair.

### 3.4 O que conferir no app (teste manual desta etapa)
1. O ícone se chama **Agenda de Faxinas**.
2. A tela inicial mostra o título **Agenda de Faxinas** e 4 botões grandes
   e coloridos: **Clientes**, **Agenda**, **Ganhos**, **Doces**.
3. Toque em cada botão: abre uma tela com o título certo e uma mensagem.
   Em **Clientes** deve aparecer "Nenhum cliente cadastrado ainda."
   (isso prova que o banco de dados abriu corretamente).
4. A seta de voltar (no topo) ou o botão voltar do celular retorna ao início.

### 3.5 Teste da etapa 1 — Clientes
1. Toque em **Clientes**. Com a lista vazia aparece "Nenhum cliente cadastrado ainda."
2. Toque em **Novo cliente**, preencha *Nome* = `Cliente A`, *Valor da diária* = `150`
   e toque em **Salvar**. Volta para a lista com "Cliente A — Diária: R$ 150,00"
   e a mensagem "Cliente salvo!".
3. Cadastre mais um com endereço (ex.: `Cliente B`, `Rua das Flores, 10`, `180,50`).
   A lista fica em ordem alfabética e mostra o endereço embaixo.
4. Toque em **Salvar** com o nome vazio ou valor `abc`: aparecem mensagens em vermelho
   e nada é salvo.
5. Toque num cliente para **editar**: os campos vêm preenchidos. Mude o valor e salve.
6. Ainda na edição, toque em **Excluir cliente** → aparece "Excluir cliente?".
   Toque **Não, voltar** (nada acontece). Repita e toque **Sim, excluir**: ele some da lista.
7. **Dados salvos de verdade:** feche o app por completo (botão de apps recentes do
   Android → arraste o app para cima) e abra de novo. Os clientes continuam lá.

### 3.6 Teste da etapa 2 — Agenda
Antes, cadastre em **Clientes**: `Cliente A` (com endereço `Rua das Flores, 10`),
`Cliente B`, `Cliente C` e `Cliente D`.

1. Toque em **Agenda**. No topo aparece a data de hoje e "Hoje você tem:".
   Sem faxinas, aparece "Nenhuma faxina. Dia livre!".
2. **Faxina fixa — Cliente A, segunda e quinta:** toque em **Nova faxina** →
   **Faxina FIXA** → escolha `Cliente A` → toque em **Segunda** e **Quinta** (ficam
   verdes) → deixe **Toda semana** → em "A partir de qual dia?" deixe hoje.
   O quadro "Confira as próximas faxinas" mostra as próximas segundas e quintas.
   Toque em **Salvar**: aparece "Faxina fixa salva!".
3. **Cliente B, terça, toda semana:** mesma coisa, escolhendo só **Terça**.
4. **Clientes C e D, quarta a cada 15 dias:** crie para `Cliente C` com **Quarta** e
   **A cada 15 dias**. Confira no quadro que as datas pulam de 14 em 14 dias.
   Faça o mesmo para `Cliente D` (mesma data de início, se as duas são no mesmo dia).
5. **Semana:** cada dia aparece numa linha. Os dias com faxina ficam verdes, com o
   nome dos clientes. Hoje tem borda preta grossa e a palavra "HOJE".
   Use as setas **<** e **>** para ver outras semanas: Cliente C aparece numa
   quarta, some na seguinte e volta na outra. "Voltar para hoje" volta à semana atual.
6. **Mês:** toque em **Mês**. Os dias com faxina ficam verdes. Passe para os meses
   seguintes (inclusive dezembro → janeiro) e veja que as quartas de 15 em 15 dias
   continuam certas.
7. **Tocar num dia** (na semana ou no mês) mostra os clientes daquele dia, com
   endereço e "Fixa: toda semana", "Fixa: a cada 15 dias" ou "Só desta vez".
   Toque em **Fechar**.
8. **Faxina só desta vez:** **Nova faxina** → **Faxina SÓ DESTA VEZ** → escolha um
   cliente → toque na data e escolha outro dia → **Salvar**. Ela aparece só naquele
   dia, e não nas semanas seguintes.
9. Feche o app por completo e abra de novo: as faxinas continuam lá.

### 3.7 Teste do tema visual
1. Abra o app. Ele começa na aba **Hoje**, com a data por extenso numa faixa com
   borda laranja à esquerda.
   - Sem clientes: aparece "Vamos começar?" com o botão **Cadastrar clientes**.
   - Com clientes, mas sem faxina hoje: aparece "Dia livre!" com o botão **Abrir agenda**.
   - Com faxina hoje: um cartão grande por cliente, com o círculo colorido da
     inicial, o nome, o endereço e o valor em destaque (ex.: "R$ 150,00").
     Dica: para ver os cartões, crie na Agenda uma faxina **só desta vez** para hoje.
2. Embaixo fica a barra com **Hoje, Agenda, Ganhos e Mais**, sempre com ícone e
   texto. A aba aberta fica marcada.
3. Em **Mais**: Clientes, Doces, Backup e Configurações. Doces, Backup e
   Configurações ainda só explicam o que virá.
4. Crie uma faxina na Agenda. O aviso embaixo traz o botão **Desfazer**. Toque
   nele e a faxina some ("Pronto, a faxina foi apagada.").
5. Exclua um cliente. Antes de apagar, aparecem os dois botões grandes, um
   embaixo do outro.
6. **Teste no sol:** leve o celular para fora, com o brilho normal, e confira
   se dá para ler tudo sem esforço.
7. **Letra maior:** em Configurações do Android → Tela → Tamanho da fonte,
   aumente a letra. O app acompanha e continua sem cortar textos.

### 3.8 Erros comuns
| O que aparece | O que fazer |
|---|---|
| Erro `Android sdkmanager did not install NDK` | Abra o terminal e instale o NDK necessário rodando: `& "$env:ANDROID_HOME\cmdline-tools\latest\bin\sdkmanager.bat" 'ndk/28.2.13676358'` (ou a versão indicada no erro). |
| Erro `Several environment variables contain different paths` (`ANDROID_PREFS_ROOT`) | Remova a variável `ANDROID_PREFS_ROOT` no PowerShell executando: `[Environment]::SetEnvironmentVariable("ANDROID_PREFS_ROOT", $null, "User")`. |
| Erro `Restricted method in java.lang.System` / Java 25 | Adicione `--enable-native-access=ALL-UNNAMED` ao parâmetro `org.gradle.jvmargs` no arquivo `android/gradle.properties`. |
| `flutter devices` não mostra o celular | Desbloqueie a tela, troque o cabo (alguns só carregam), aceite "Permitir depuração USB", escolha "Transferência de arquivos" na notificação USB. |
| `INSTALL_FAILED_UPDATE_INCOMPATIBLE` ou "conflito de pacote" | O app instalado foi assinado em outro computador. Desinstale (perde os dados de teste) e instale de novo. |
| "App não instalado" ao abrir o APK | Libere "instalar apps desconhecidos" para o app usado (Arquivos, WhatsApp, Drive). Se já existir outra versão assinada em outro PC, veja a linha acima. |
| Agenda: Cliente de 15 em 15 dias aparece na semana "errada" | A conta começa na semana da **data de início**. Crie a faxina de novo escolhendo como data de início um dia da semana em que ela realmente vai. |
| Agenda: faxina fixa não aparece em dias passados | Normal: ela só aparece a partir da data de início. |
| Agenda: "Você ainda não cadastrou nenhum cliente" | Cadastre o cliente primeiro na tela Clientes. |
| Play Protect avisa "app não seguro" | Normal para apps fora da Play Store: **Mais detalhes → Instalar mesmo assim**. |
| `Gradle ... failed` / `Could not resolve` na primeira compilação | Falha de internet ao baixar bibliotecas. Confira a conexão e rode `flutter run` de novo. |
| `No Android SDK found` / licenças | Rode `flutter doctor --android-licenses` e aceite tudo. |
| Erro com `banco_dados.g.dart` depois de mudar tabelas | Rode `dart run build_runner build`. |
| Tela vermelha com erro (no modo `flutter run`) | Copie o texto do terminal e me envie. |
| Teclado cobre o botão Salvar | Role a tela para cima, ou feche o teclado com o botão voltar. |
| Os clientes sumiram | Acontece se o app foi desinstalado (ou "Limpar dados" nas Configurações). Atualizar por cima **não** apaga. |

---

## Parte 4 — Gerar o arquivo APK (para instalar sem cabo)

1. Na pasta do projeto:
   ```
   flutter build apk --release
   ```
2. O arquivo fica em:
   ```
   build\app\outputs\flutter-apk\app-release.apk
   ```
3. Passe o arquivo para o celular da sua mãe (cabo USB, Google Drive,
   ou WhatsApp "enviar como documento").
4. No celular, toque no arquivo. O Android vai pedir para
   **permitir instalar apps desta fonte** — permita e toque em **Instalar**.
   Pode aparecer um aviso do Google Play Protect: toque em
   **Mais detalhes → Instalar mesmo assim** (é normal para apps fora da Play Store).

### Atenção: atualizações e "assinatura" do APK
Por enquanto o APK é assinado com uma chave de teste que fica **no seu computador**.
Para instalar uma versão nova por cima da antiga (sem perder os dados),
gere sempre o APK **no mesmo computador**. Se o Android disser que o app
"não pode ser instalado" / "conflito de pacote", **não desinstale** o app antigo
sem antes fazer backup — desinstalar apaga os dados. Numa etapa futura vamos
criar uma chave própria e o backup (etapa 7).

---

## Comandos úteis

| Comando                          | Para que serve                                         |
|----------------------------------|--------------------------------------------------------|
| `flutter doctor`                 | Confere se as ferramentas estão instaladas             |
| `flutter pub get`                | Baixa as bibliotecas do projeto                        |
| `flutter devices`                | Lista celulares conectados                             |
| `flutter run`                    | Instala e abre o app no celular conectado              |
| `flutter test`                   | Roda os testes automáticos                             |
| `flutter analyze`                | Procura erros e problemas no código                    |
| `flutter build apk --release`    | Gera o arquivo APK                                     |
| `dart run build_runner build`    | Regera `banco_dados.g.dart` depois de mudar as tabelas |

---

## Mac ou Linux
Os passos são os mesmos, mudando só a instalação do Flutter:
- Mac: <https://docs.flutter.dev/get-started/install/macos/mobile-android>
- Linux: <https://docs.flutter.dev/get-started/install/linux/android>

No Linux, os caminhos usam `/` em vez de `\`.
