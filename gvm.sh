#!/bin/bash

gvm_ver="1.0.0"
latest_ver="1.21.3"
proxy="-x [SEU PROXY AQUI]"
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
        version_url="$url_prefix$go_version$url_suffix" # https://dl.google.com/go/go...windows-amd64.zip
        installation_path="$go_bash_root_addr/$go_version.zip" # /c/Users/USERNAME/AppData/Local/Go/...zip"

        version_exists=$(validate_url_exists "$version_url")

        if [[ ! "$version_exists" == "true" ]]
        then
            err_message=(
                " "
                "*************************************************"
                "|                   ATENÇÃO!                    |"
                "|                                               |"
                "|  A versão indicada não pôde ser obtida da ba- |"
                "|  se de arquivos da Google!                    |"
                "|                                               |"
                "|  Verifique se a versão está correta ou avali- |"
                "|  e se houve erro de digitação. Consulte a pá- |"
                "|  gina com as versões corretas disponiveis no  |"
                "|  endereço:                                    |"
                "|                                               |"
                "|  https://go.dev/dl/                           |"
                "|                                               |"
                "*************************************************"
                " "
                " "
                "A instalação do Go foi suspensa."
                "Verifique a versão conforme indicado e execute o programa novamente."
            )

            print_message "${err_message[@]}"

            return 1
        fi

        is_installed=$(check_if_installed "$go_version")

        if [[ ! "$is_installed" == "true" ]]
        then
            clear

            echo "Instalando a versão $go_version do binario do GoLang..."

            if [ ! -d "$go_bash_root_addr" ]
            then
                mkdir -p $go_bash_root_addr
            fi

            mkdir -p "$go_path_root_addr/$go_version"

            curl -k $proxy $version_url -o $installation_path

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

        goroot_var_name="%GOROOT%"
        goroot_var_contents=$(/c/Windows/System32/cmd.exe //c echo "$goroot_var_name")
        path_var_contents=$(/c/Windows/System32/cmd.exe //c echo %PATH%)

        if [ "$goroot_var_contents" != "$goroot_var_name" ] && [[ ! "$path_var_contents" == *"$goroot_var_contents"* ]]
        then
            err_message=(
                " "
                "*************************************************"
                "|                   ATENÇÃO!                    |"
                "|  Não foi encontrada a referência ao endereço  |"
                "|  do binário do Go na variável PATH! Para que  |"
                "|  seja possivel utilizar o GoLang no terminal  |"
                "|  pesquise e abra o editor de variáveis de am- |"
                "|  biente (selecione as variáveis para sua con- |"
                "|  ta) e edite a variável PATH fazendo a inclu- |"
                "|  são de uma nova linha contendo o endereço:   |"
                "|                %GOROOT%\bin                   |"
                "*************************************************"
                " "
                " "
                "A ativação do Go no ambiente foi suspensa."
                "Adicione a variável conforme indicado, reabra o terminal e tente novamente."
            )

            print_message "${err_message[@]}"

            return 1
        elif [ "$goroot_var_contents" == "$goroot_var_name" ]
        then
            /c/Windows/System32/cmd.exe //c 1>nul setx GOROOT "$go_root_addr"
            /c/Windows/System32/cmd.exe //c 1>nul setx GOPATH "$go_path_addr"
            
            err_message=(
                " "
                "*************************************************"
                "|                   ATENÇÃO!                    |"
                "|                                               |"
                "|  A variavel GOROOT não foi encontrada presen- |"
                "|  te no sistema.                               |"
                "|  Como medida de segurança, será feita a cria- |"
                "|  ção da variavel no sistema, mas a alteração  |"
                "|  da versão ativa não será executada.          |"
                "|                                               |"
                "|  Execute o programa novamente para que a ver- |"
                "|  são ativa seja alternada dentro dos critéri- |"
                "|  os necessários.                              |"
                "*************************************************"
                " "
                " "
                "A ativação do Go no ambiente foi suspensa."
                "Conforme indicado, reabra o terminal e tente novamente."
            )

            print_message "${err_message[@]}"

            return 1
        fi

        echo "Variável verificada! Apontando GOROOT e GOPATH pra nova versão..."

        /c/Windows/System32/cmd.exe //c setx GOROOT "$go_root_addr\\$go_version\\go"
        /c/Windows/System32/cmd.exe //c setx GOPATH "$go_path_addr\\$go_version"

        echo ""
        echo "Tudo feito! A versão do Go ativa no momento é a $go_version."
        echo "Reabra o terminal para poder utilizar a nova versão ativa."
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

print_message () {
    local test_if_empty="$1"

    if [ -z "${test_if_empty}" ]
    then
        echo "Nenhuma mensagem para exibir..."
    else
        local message=("$@")

        for line in "${message[@]}"
        do
            echo "$line"
        done
    fi
}

validate_url_exists () {
    local url=$1
    local exists="false"

    if [ ! -z "$url" ]
    then
        if curl -k $proxy --output /dev/null --silent --fail -r 0-0 "$url"; then
            exists="true"
        fi
    fi

    echo "$exists"
}

validate_if_version_is_active () {
    local go_version=$1
    local is_active="false"

    active_version=$(/c/Windows/System32/cmd.exe //c echo %GOROOT%)
    active_version=("${active_version%\\go}")
    active_version=("${active_version##*\\}")

    if [ ! -z "$go_version" ] && [ "$go_version" == "$active_version" ]
    then
        is_active="true"
    elif [ -z "$go_version" ]
    then
        echo "Nenhuma versão pra validar..."

        return 1
    fi

    echo $is_active
}

uninstall_go_version () {
    local go_version=$1
    local flag_jump=$2

    if [ -z "$flag_jump" ] || [ "$flag_jump" != "-y" ]
    then
        echo "Deseja realizar a remoção da versão $go_version do Golang? (y/n)"
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

    if [ ! -z $go_version ]
    then
        is_active=$(validate_if_version_is_active $go_version)
        is_installed=$(check_if_installed $go_version)

        if [ "$is_active" == "true" ]
        then
            warning_message=(
                " "
                "*************************************************"
                "|                   ATENÇÃO!                    |"
                "|                                               |"
                "|  A versão indicada pra desinstalação é a ver- |"
                "|  são que está ativa atualmente no sistema!    |"
                "|                                               |"
                "|  Para sua segurança, troque a versão do Go a- |"
                "|  tiva no sistema, e execute o programa outra  |"
                "|  vez...                                       |"
                "|                                               |"
                "*************************************************"
                " "
                " "
                "Deseja alterar a versão ativa do Go?"
            )

            print_message "${warning_message[@]}"
            read -p ">" yn

            case $yn in 
                [Yy]*)
                    echo ""
                    echo "Essas são as versões do Go encontradas em seu sistema. Qual deseja ativar?"
                    echo ""

                    desired_ver=$(select_installed_version)
                    
                    if [ ! -z "$desired_ver" ] && [ "$desired_ver" != "Cancelar" ]
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
                    echo "Saindo do programa..."
                    return 1;;
            esac

            return 1
        fi

        if [ "$is_installed" == "false" ]
        then
            err_message=(
                " "
                "*************************************************"
                "|                   ATENÇÃO!                    |"
                "|                                               |"
                "|  A versão apontada para desinstalação não pô- |"
                "|  de ser detectada no sistema. Verifique se a  |"
                "|  mesma realmente foi instalada, ou se ela se  |"
                "|  encontra em outro diretório diferente do pa- |"
                "|  drão do Go Version Manager.                  |"
                "|                                               |"
                "*************************************************"
                " "
                " "
                "A remoção do Go foi suspensa."
                "Valide a versão a remover e tente novamente."
            )

            print_message "${err_message[@]}"

            return 1
        fi

        #procedimento de deleção...
        echo "Remoção em construção..."
    fi
}

print_gvm_version () {
    echo ""
    echo "Go Version Manager version $gvm_ver"
    echo ""
    echo "Uma ferramenta by Squad Vanguarda."
}

run () {
    go_version=$1
    reVALIDATE='-?[a-z]'

    if [ ! -z "$2" ]
    then
        flag=$1
        go_version=$2
    fi

    if [ ! -z "$1" ] && ([[ "$1" == "-v" ]] || [[ "$1" == "--version" ]])
    then
        print_gvm_version

        return 1
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
        echo "2) Escolher e instalar versão do Golang"
        echo "3) Alternar versão do Go ativa no sistema"
        echo "4) Escolher e desinstalar versão do Golang"
        echo "5) Sair"
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
                
                if [ ! -z "$desired_ver" ] && [ "$desired_ver" != "Cancelar" ]
                then
                    echo ""
                    set_active_version $desired_ver
                else
                    echo ""
                    echo "Operação cancelada. Saindo do programa..."
                fi
                ;;
            4)
                echo ""
                echo "Digite a versão a ser removida:"
                read -p ">" desired_ver

                uninstall_go_version $desired_ver "-y";;
            *)
                echo ""
                echo "Saindo do programa...";;
        esac
    fi
}

run $1 $2
