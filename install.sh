#!/bin/bash

gvm_script_url="https://raw.githubusercontent.com/fbarrella/gvm/main/gvm.sh"

download_and_install () {
	echo " "

	curl -k $gvm_script_url -o "$HOME/gvm.sh"

	if [ ! -f "$HOME/.bashrc" ]; then
		echo " "
		echo "Não foi encontrado o arquivo '.bashrc', portanto este será criado agora..."

		touch "$HOME/.bashrc"

		echo " "
		echo "Arquivo '.bashrc' criado!"
	else
		echo " "
		echo "Localizado arquivo '.bashrc'!"
	fi

	echo "alias gvm='~/gvm.sh'" >> "$HOME/.bashrc"

	echo " "
	echo "Instalação concluída com sucesso!"
	echo " "
	echo "Reinicie o terminal e digite 'gvm -v' para validar a instalação..."
	echo "Para mais informações, acesse https://github.com/fbarrella/gvm e leia a documentação completa."
	echo " "
	echo "Pressione ENTER para finalizar."
	read exitkey
}

echo " "
echo "Deseja baixar e instalar o Go Version Manager? (y/n)"
read -p ">" yn

download_and_install
