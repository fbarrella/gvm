- [Documentation for English speakers](https://github.com/fbarrella/gvm/blob/main/README.eng.md)

--------

# [PT-BR :brazil:] gvm - Go Version Manager

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
