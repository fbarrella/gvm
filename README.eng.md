# [ENG :us:] gvm - Go Version Manager

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
