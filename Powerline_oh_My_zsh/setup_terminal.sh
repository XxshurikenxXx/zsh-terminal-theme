#!/bin/bash

# Function to check if a command is available
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages on Debian-based systems
install_debian() {
    sudo apt-get update
    sudo apt-get install -y "$1"
}

# Function to install packages on Red Hat-based systems
install_redhat() {
    sudo yum install -y "$1"
}

# Check the type of operating system
if [ -f /etc/debian_version ]; then
    OS="debian"
elif [ -f /etc/redhat-release ]; then
    OS="redhat"
else
    echo "Unsupported operating system"
    exit 1
fi

# Function to check necessary programs
check_programs() {
    for program in git wget; do
        if command_exists "$program"; then
            echo "$program is already installed"
        else
            echo "$program is not installed. Installing..."
            if [ "$OS" = "debian" ]; then
                install_debian "$program"
            elif [ "$OS" = "redhat" ]; then
                install_redhat "$program"
            fi
        fi
    done
}

# Function to check necessary terminal (zsh)
check_terminal() {
    if command_exists zsh; then
        echo "zsh is already installed"
    else
        echo "zsh is not installed. Installing..."
        if [ "$OS" = "debian" ]; then
            install_debian zsh
        elif [ "$OS" = "redhat" ]; then
            install_redhat zsh
        fi
        echo "Changing default shell to zsh..."
        chsh -s /bin/zsh
    fi
}

# Function to check necessary themes (Powerline)
check_themes() {
    if command_exists powerline; then
        echo "Powerline is already installed"
    else
        echo "Powerline is not installed. Installing..."
        if [ "$OS" = "debian" ]; then
            install_debian powerline
        elif [ "$OS" = "redhat" ]; then
            install_redhat powerline
        fi
    fi
}

# Install Oh My Zsh and configure Agnoster theme
setup_oh_my_zsh() {
    echo "Installing Oh My Zsh..."
    sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    echo "Configuring Agnoster theme in ~/.zshrc..."
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="agnoster"/' ~/.zshrc
    echo "Configuring Agnoster theme in .zshrc..."
    sed -i 's/ZSH_THEME=".*"/ZSH_THEME="agnoster"/' .zshrc
}

# Menu options
while true; do
    echo "Select an option:"
    echo "1. Check necessary programs (git and wget)"
    echo "2. Check necessary terminal (zsh)"
    echo "3. Check necessary themes (Powerline)"
    echo "4. Install Oh My Zsh and configure Agnoster theme"
    echo "5. Exit"
    read -p "Option: " option
    case $option in
        1)
            check_programs
            ;;
        2)
            check_terminal
            ;;
        3)
            check_themes
            ;;
        4)
            setup_oh_my_zsh
            ;;
        5)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done
