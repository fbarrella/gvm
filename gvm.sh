#!/bin/bash

gvm_ver="1.1.3"
go_root_addr="C:\Users\\$USERNAME\AppData\Local\Go"
go_path_addr="C:\Users\\$USERNAME\Go Workspaces"
go_bash_root_addr="$HOME/AppData/Local/Go"
go_bash_path_addr="$HOME/Go Workspaces"

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
    echo "Encontrando a versão mais mais recente do Go..."
    echo " "

    local go_repo_url="https://go.dev/dl/"
    local regex_filter="<a class=\"download downloadBox\" href=\"/dl/go\K[0-9].*(?=.windows-amd64.msi)"
    local proxy=$(get_proxy_info)
    local latest_ver=$(curl -L -k $proxy -v $go_repo_url --silent 2>&1 | grep -oP "$regex_filter")

    if [ "$latest_ver" == "" ]
    then
        echo " "
        echo "Erro ao tentar recuperar versão go Go mais recente!"
        echo ""
        echo ""
        echo "Saindo do programa."

        return 1
    fi

    echo ""
    echo "A versão mais recente mapeada do Go é a $latest_ver..."
    echo ""

    install_go_version "$latest_ver" "" "$proxy"
}

install_go_version () {
    local go_version=$1
    local flag_jump=$2
    local proxy=$3
    local url_prefix="https://dl.google.com/go/go"
    local url_suffix=".windows-amd64.zip"

    if [ -z "$proxy" ]
    then
    	proxy=$(get_proxy_info)
    fi

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

        version_exists=$(validate_url_exists "$version_url" "$proxy")

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

            mkdir -p "$go_bash_path_addr/$go_version"

            curl -k $proxy $version_url -o $installation_path

            unzd $installation_path
            rm -rf $installation_path
            
            echo "Instalação concluída com sucesso!"
        else
            echo "Versão já encontrada no sistema! Abortando instalação..."
        fi

        echo ""
        echo "Selecionar $go_version como a versão ativa no sistema? (y/n)"
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
    local proxy=$2
    local exists="false"

    if [ ! -z "$proxy" ]
    then
    	proxy=$(get_proxy_info)
    fi

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

get_proxy_info() {
    proxy_var_name="%GVM_PROXY%"
    proxy_var_content=$(/c/Windows/System32/cmd.exe //c echo $proxy_var_name)
    proxy=""

    if [ "$proxy_var_content" != "$proxy_var_name" ]
    then
        proxy=" -x $proxy_var_content "

        echo " " >$(tty)
    	echo "Validando conexão através de proxy..." >$(tty)

    	test_url="https://raw.githubusercontent.com/fbarrella/gvm/main/gvm.sh"
    	proxy_test=$(curl -v --silent $proxy $remote_file_url 2>&1)

    	if [[ "$proxy_test" =~ "SSL certificate problem" ]]
    	then
    	    echo " " >$(tty)
	        echo "A conexão teste falhou e a execução do programa pode não funcionar corretamente," >$(tty)
            echo "deseja seguir sem o uso do proxy? (y/n)" >$(tty)
	        read -p ">" ynopt

    	    case $ynopt in
                [Yy]*)
             	    echo " " >$(tty)
              	    echo "Desconsiderando proxy..." >$(tty)
		            proxy=""
                    ;;
                *)
              	    echo "" >$(tty)
               	    echo "Utilizando proxy mesmo assim..." >$(tty)
               	    ;;
      	    esac
    	fi
    fi

    echo $proxy
}

validate_if_update_is_needed () {
    prevent_cache=$(date +%s)
    remote_file_url="https://raw.githubusercontent.com/fbarrella/gvm/main/gvm.sh?$prevent_cache"
    proxy=$(get_proxy_info)

    echo " "
    echo "Procurando por atualizações..."

    remote_ver=$(curl -v --silent $proxy $remote_file_url 2>&1 | grep -oP 'gvm_ver="\K[0-9].*[^"]')

    if [ "$remote_ver" == "" ]
    then
        echo " "
        echo "Erro ao tentar recuperar versão remota da ferramenta!"
        echo ""
        echo ""
        echo "Saindo do programa."

        return 1
    fi

    if [ "$remote_ver" != "$gvm_ver" ]
    then
        echo " "
        echo "Uma atualização é necessária!"
        echo " "
        echo "Deseja atualizar o Go Version Manager pra versão $remote_ver? (y/n)"
        read -p ">" yn

        case $yn in
            [Yy]*)
                local output_file="/c/Users/$USERNAME/gvm.sh"
                local backup_file="/c/Users/$USERNAME/gvm_old.sh"

                if [ -f "$backup_file" ]; then
                    rm -rf $backup_file
                fi

                echo " "
                echo "Criando backup da versão atual na mesma pasta..."
                echo " "

                cp $output_file $backup_file

                rm -rf $output_file

                curl -k $proxy $remote_file_url -o $output_file

                echo " "
                echo "GVM v$remote_ver instalado! Execute novamente, ou utilize o comando 'gvm -v' para"
                echo "consultar a versão atual do programa."
                echo " "
                echo " "
                echo "Aperte ENTER pra encerrar..."
                read key_exit
                ;;
            *)
                echo ""
                echo "Saindo do programa..."
                return 1;;
        esac
    else
        echo " "
        echo "Você já está utilizando a versão mais recente go GVM (v$gvm_ver)."
    fi
}

get_go_active_version () {
    local go_active_ver=$(go env | grep -oP 'GOVERSION=go\K[0-9].*')

    echo " "
    echo "A versão do Golang ativa no sistema é a '$go_active_ver'."
    echo " "
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
        echo "Remoção em progresso..."
        echo " "

        goroot_deletion_path="$go_bash_root_addr/$go_version"
        gopath_deletion_path="$go_bash_path_addr/$go_version"

        rm -rf "$goroot_deletion_path"
        rm -rf "$gopath_deletion_path"

        sleep 1

        if [ ! -d "$goroot_deletion_path" ] && [ ! -d "$gopath_deletion_path" ]
        then
            echo "Sucesso! A versão '$go_version' já foi removida do seu sistema operacional!"
            echo "Execute o programa novamente caso queira alterar a versão ativa..."
            echo " "
            echo "Pressione ENTER para encerrar"
            read exitkey
        else
            echo "Falha! A versão '$go_version' não foi removida corretamente."
            echo "Execute o programa outra vez e tente novamente..."
            echo " "
            echo "Pressione ENTER para encerrar"
            read exitkey
        fi
    fi
}

print_gvm_version () {
    echo ""
    echo "Go Version Manager version $gvm_ver"
    echo ""
    echo "Uma ferramenta by Vanguarda."
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

    if [ ! -z "$1" ] && ([[ "$1" == "-U" ]] || [[ "$1" == "--update" ]])
    then
        validate_if_update_is_needed

        return 1
    fi

    if [ ! -z "$1" ] && ([[ "$1" == "-A" ]] || [[ "$1" == "--active" ]])
    then
        get_go_active_version

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

        echo "Go Version Manager v$gvm_ver"
        echo ""
        echo "1) Instalar versão do Go mais recente"
        echo "2) Escolher e instalar versão do Golang"
        echo "3) Alternar versão do Go ativa no sistema"
        echo "4) Escolher e desinstalar versão do Golang"
        echo "5) Visualizar versão do Go ativa no sistema"
        echo "6) Checar por atualizações do GVM..."
        echo "7) Sair"
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
            5)
                get_go_active_version ;;
            6)
                validate_if_update_is_needed ;;
            *)
                echo ""
                echo "Saindo do programa...";;
        esac
    fi
}

run $1 $2
