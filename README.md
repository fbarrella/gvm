# :brazil:[PT-BR] gvm - Go Version Manager

**gvm** é um aplicativo de linha de comando que permite instalar e gerenciar várias versões da linguagem de programação Go em seu sistema. Ele é escrito em script shell e tem os seguintes recursos:
- **Verificar e instalar** a versão mais recente do binário Go do site oficial.
- **Instalar e/ou alternar para** uma determinada versão do Go a partir da base de binários da google.
- **Desinstalar** uma determinada versão do Go e remover os arquivos e diretórios relacionados.
- **Alternar versão** do Go ativa no sistema.
- **Verificar e instalar atualizações** remotas do **gvm** a partir do repositório GitHub.
- **Retornar a versão ativa** do Go no sistema do usuário.
- **Retornar a versão do gvm** em si.

## Instalação
Para instalar o **gvm**, você precisa copiar e executar a linha de comando abaixo no seu terminal.

```shell
bash <(curl -sk https://raw.githubusercontent.com/fbarrella/gvm/main/install.sh)
```

Imediatamente será iniciado a instalação da ferramenta em seu computador. Siga as instruções e reinicie o terminal para concluir.

Após a instalação, utilize o comando `gvm -v` para validar se tudo ocorreu bem.

## Uso
Para usar o **gvm**, você pode executar o comando `gvm` em seu terminal. Isso mostrará um menu com as opções disponíveis, como:

```
Go Version Manager v1.1.0

1) Instalar versão do Go mais recente
2) Escolher e instalar versão do Golang
3) Alternar versão do Go ativa no sistema
4) Escolher e desinstalar versão do Golang
5) Visualizar versão do Go ativa no sistema
6) Checar por atualizações do GVM...
7) Sair
```

Você pode digitar o número da opção que deseja executar e seguir as instruções.
Alternativamente, você também pode usar parâmetros junto com o comando `gvm` para executar algumas das opções diretamente. Os parâmetros disponíveis são:
- `gvm [versão]`: Isso verificará localmente a versão fornecida e decidirá se deve instalá-la ou apenas alternar para ela. Você também pode usar a flag `-y` logo após a versão para pular a solicitação de confirmação, como `gvm -y 1.17.2`.
- `gvm -U` ou `gvm --update`: Isso verificará e instalará atualizações do programa em si a partir do repositório GitHub.
- `gvm -A` ou `gvm --active`: Isso verificará e retornará a versão ativa do Go no sistema do usuário.
- `gvm -v` ou `gvm --version`: Isso verificará e retornará a versão do programa em si.
Por exemplo, você pode executar o comando `gvm -A` para ver a saída como:

```
A versão ativa do Go no sistema é: 1.17.2
```

## Licença
**gvm** está licenciado sob a Licença MIT. Você pode encontrar o texto completo da licença no repositório GitHub.

-------

# :us:[ENG] gvm - Go Version Manager

**gvm** is a command line application that allows you to install and manage multiple versions of the Go programming language on your system. It is written in shell script and has the following features:
- **Check and install** the latest version of the Go binary from the official website.
- **Install and/or switch to** a specific version of Go from the google binary base.
- **Uninstall** a specific version of Go and remove the related files and directories.
- **Switch active version** of Go on the system.
- **Check and install updates** of the **gvm** from the GitHub repository.
- **Return the active version** of Go on the user's system.
- **Return the version of gvm** itself.

## Installation
To install **gvm**, you need to copy and run the command line below in your terminal.

```shell
bash <(curl -sk https://raw.githubusercontent.com/fbarrella/gvm/main/install.sh)
```

The installation of the tool on your computer will start immediately. Follow the instructions and restart the terminal to complete.

After installation, use the command `gvm -v` to validate if everything went well.

## Usage
To use **gvm**, you can run the command `gvm` in your terminal. This will show a menu with the available options, such as:

```
Go Version Manager v1.1.0

1) Install latest version of Go
2) Choose and install version of Golang
3) Switch version of Go active on the system
4) Choose and uninstall version of Golang
5) View version of Go active on the system
6) Check for GVM updates...
7) Exit
```

You can type the number of the option you want to execute and follow the instructions.
Alternatively, you can also use parameters along with the command `gvm` to execute some of the options directly. The available parameters are:
- `gvm [version]`: This will check locally the provided version and decide whether to install it or just switch to it. You can also use the flag `-y` right after the version to skip the confirmation request, like `gvm -y 1.17.2`.
- `gvm -U` or `gvm --update`: This will check and install updates of the program itself from the GitHub repository.
- `gvm -A` or `gvm --active`: This will check and return the active version of Go on the user's system.
- `gvm -v` or `gvm --version`: This will check and return the version of the program itself.
For example, you can run the command `gvm -A` to see the output like:

```
The active version of Go on the system is: 1.17.2
```

## License
**gvm** is licensed under the MIT License. You can find the full text of the license in the GitHub repository.
