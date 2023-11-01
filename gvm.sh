#!/bin/bash

latest_ver="1.21.3"
itauproxy="[SEU PROXY AQUI]"
go_root_addr="C:\Users\\$USERNAME\AppData\Local\Go"
go_path_addr="C:\Users\\$USERNAME\Go Workspaces"
go_bash_root_addr="$HOME/AppData/Local/Go"
go_path_root_addr="$HOME/Go Workspaces"

unzd () {
    if [[ $# != 1 ]]
    then
        echo 'Aponte um arquivo para descompactar.'
        return 1
    fi

    target="${1%.zip}"

    mkdir -p $target

    echo ""
    echo "Descompactando arquivos, aguarde um momento..."
    echo ""

    unzip -d "$target" -q "$1"

    echo ""
    echo "Arquivos descompactados! Confira o resultado no endereço '$target'"
    echo ""
}

install_go_latest () {
    echo "A versão mais recente mapeada do Go é a $latest_ver..."
    echo ""

    install_go_version $latest_ver
}

install_go_version () {
    local go_version=$1
    local flag_jump=$2
    local url_prefix="https://dl.google.com/go/go"
    local url_suffix=".windows-amd64.zip"

    if [ -z "$flag_jump" ] || [ "$flag_jump" != "-y" ]
    then
        echo "Deseja instalar a versão $go_version do Go? (y/n)"
	    read -p ">" yn

        case $yn in 
            [Yy]*)
                echo "";;
            *)
                echo ""
                echo "Saindo do programa..."
                return 1;;
        esac
    fi

    if [ -z "$go_version" ] #test if parameter exists
    then
        echo "Nenhuma versão indicada para instalação..."
    else
        is_installed=$(check_if_installed "$go_version")

        if [[ ! "$is_installed" = "true" ]]
        then
            clear

            version_url="$url_prefix$go_version$url_suffix" # https://dl.google.com/go/go...windows-amd64.zip
            installation_path="$go_bash_root_addr/$go_version.zip" # /c/Users/USERNAME/AppData/Local/Go/...zip"

            echo "Instalando a versão $go_version do binario do GoLang..."

            if [ ! -d "$go_bash_root_addr" ]
            then
                mkdir -p $go_bash_root_addr
            fi

            mkdir -p "$go_path_root_addr/$go_version"

            curl -k -x $itauproxy $version_url -o $installation_path

            unzd $installation_path
            rm -rf $installation_path
            
            echo "Instalação concluída com sucesso!"
        else
            echo "Versão já encontrada no sistema! Abortando instalação..."
        fi

        echo ""
        echo "Selecionar $go_version como a versão ativa no sistema? (Yy/Nn)"
        read -p ">" yn

        case $yn in 
		[Yy]*)
			set_active_version $go_version "-y";;
		*)
			echo "Tudo feito. Para alternar a versão do Go ativa, execute o programa novamente.";;
	    esac
    fi
}

select_installed_version () {
    # mapeando diretorios locais
    local dir_arr=($go_bash_root_addr/*/)

    dir_arr=("${dir_arr[@]%/}")
    dir_arr=("${dir_arr[@]##*/}")
    dir_arr+=("Cancelar")

    PS3="> "

    select dir in "${dir_arr[@]}"
    do
        echo "${dir}"
        break
    done
}

set_active_version () {
    local go_version=$1
    local flag_jump=$2

    if [ -z "$flag_jump" ] || [ "$flag_jump" != "-y" ]
    then
        echo "Deseja alterar a versão ativa do Go para a $go_version? (y/n)"
	    read -p ">" yn

        case $yn in 
            [Yy]*)
                echo "";;
            *)
                echo ""
                echo "Saindo do programa..."
                return 1;;
        esac
    fi

    if [ -z "$go_version" ]
    then
        echo "Nenhuma versão indicada para instalação..."
    else
        echo ""
        echo "Verificando a existência do endereço do binário na variável PATH..."
        echo ""

        path_var_contents=$(/c/Windows/System32/cmd.exe //c echo %PATH%)

        if [[ ! "$path_var_contents" == *"$go_root_addr"* ]]
        then
            echo ""
            echo "*************************************************"
            echo "|                   ATENÇÃO!                    |"
            echo "|  Não foi encontrada a referência ao endereço  |"
            echo "|  do binário do Go na variável PATH! Para que  |"
            echo "|  seja possivel utilizar o GoLang no terminal  |"
            echo "|  pesquise e abra o editor de variáveis de am- |"
            echo "|  biente (selecione as variáveis para sua con- |"
            echo "|  ta) e edite a variável PATH fazendo a inclu- |"
            echo "|  são de uma nova linha contendo o endereço:   |"
            echo "|                %GOROOT%\bin                   |"
            echo "*************************************************"
            echo ""
            echo ""
            echo "A ativação do Go no ambiente foi suspensa."
            echo "Adicione a variável conforme indicado, reabra o terminal e tente novamente."
        else
            echo "Variável verificada! Apontando GOROOT e GOPATH pra nova versão..."

            /c/Windows/System32/cmd.exe //c setx GOROOT "$go_root_addr\\$go_version\\go"
            /c/Windows/System32/cmd.exe //c setx GOPATH "$go_path_addr\\$go_version"

            echo ""
            echo "Tudo feito! A versão do Go ativa no momento é a $go_version."
            echo "Reabra o terminal para poder utilizar a nova versão ativa."
        fi
    fi
}

check_if_installed () {
    local go_version=$1
    local is_installed="false"

    if [ -z "$go_version" ]
    then
        echo "Nenhuma versão apontada..."
    else
        [ -d "$go_bash_root_addr/$go_version" ] && is_installed="true"
    fi

    echo "$is_installed"
}

go_version=$1
reVALIDATE='-?[a-z]'

if [ ! -z "$2" ]
then
    flag=$1
    go_version=$2
fi

if [ ! -z "$go_version" ] && [[ ! "$go_version" =~ $reVALIDATE ]] && [[ "$go_version" != "-" ]]
then
    is_installed=$(check_if_installed "$go_version")

    if [[ "$is_installed" = "true" ]]
    then
        set_active_version $go_version $flag
    else
        install_go_version $go_version $flag
    fi
else
    clear

    echo "Go Version Manager v1.0.0"
    echo ""
    echo "1) Instalar versão do Go mais recente"
    echo "2) Instalar versão específica"
    echo "3) Alternar versão do Go ativa no sistema"
    echo "4) Sair"
    echo ""
    read -p ">" yn

    case $yn in 
            1)
                echo ""
                install_go_latest;;
            2)
                echo ""
                echo "Digite a versão desejada pra instalação:"
                read -p ">" desired_ver

                echo ""
                install_go_version $desired_ver;;
            3)
                echo ""
                echo "Essas são as versões do Go encontradas em seu sistema. Qual deseja ativar?"
                echo ""

                desired_ver=$(select_installed_version)
                
                if [ "$desired_ver" != "Cancelar" ]
                then
                    echo ""
                    set_active_version $desired_ver
                else
                    echo ""
                    echo "Operação cancelada. Saindo do programa..."
                fi
                ;;
            *)
                echo ""
                echo "Saindo do programa...";;
        esac
fi
