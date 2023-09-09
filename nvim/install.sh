get_distro()
{
    case "$(lsb_release -is)" in
        Fedora*)    install_cmd="sudo dnf install"
    esac
    cmd=${install_cmd}
}

OS="$(uname -s)"
case "${OS}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
esac

echo ${machine}

case "${machine}" in
    Mac*)       install_cmd="brew install";;
    Linux*)     install_cmd=get_distro;;
esac

echo ${install_cmd}

command="${install_cmd} neovim"
echo "Running '${command}'"
eval " $command"
eval "mkdir ~/.config/nvim"
eval "ln -s ./* ~/.config/nvim/"

