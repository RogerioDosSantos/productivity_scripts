
source ./_log.sh

wsl::InstallPrograms()
{
  # Usage: InstallPrograms

  echo "Installing/Updating programs ... "
  sudo apt-get update \
  && sudo apt-get install -y \
      build-essential \
      cgdb \
      clang \
      clang-format \
      clang-tidy \
      clang-tools-5.0 \
      cmake \
      cppcheck \
      default-jre \
      doxygen \
      editorconfig \
      encfs \
      exuberant-ctags \
      figlet \
      git \
      git-lfs \
      graphviz \
      jq \
      m4 \
      nodejs \
      npm \
      pandoc \
      python-dev \
      python-pip \
      python3-bs4 \
      rsync \
      silversearcher-ag \
      sysstat \
      tree \
      valgrind \
      vim-gtk \
  && sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-5.0 100 \
  && pip install python-language-server \
  && sudo npm -y install -g \
      typescript \
      heroku \
  && echo "Installing/Updating programs - DONE"
}

wsl::PrepareLinks()
{
  # Usage: PrepareLinks

  local us_roger_environment_dir
  read -p "Enter roger environment folder (Default: /c/Users/roger/git/roger): " us_roger_environment_dir
  us_roger_environment_dir=${us_roger_environment_dir:-/c/Users/roger/git/roger}

  echo -ne "Creating Linux links ..."
  rm ~/roger || ln -s ${us_roger_environment_dir} ~/roger
  rm ~/temp || ln -s ~/roger/temp ~/temp
  rm ~/wiki || ln -s ~/roger/projects/wiki ~/wiki
  rm ~/projects || ln -s ~/roger/projects ~/projects
  rm ~/.bashrc || ln -s ~/roger/devops/linux_environment/src/environment/linux/bashrc_roger ~/.bashrc
  rm ~/.editorconfig || ln -s ~/roger/devops/linux_environment/src/environment/editorconfig/editorconfig ~/.editorconfig
  rm ~/.gitconfig || ln -s ~/roger/devops/linux_environment/src/environment/git/gitconfig ~/.gitconfig
  rm ~/.marvim || ln -s ~/roger/devops/linux_environment/src/environment/marvim ~/.marvim
  rm ~/.syntastic_cpp_config || ln -s ~/roger/devops/linux_environment/src/environment/syntastic/syntastic_cpp_config_schneider ~/.syntastic_cpp_config
  rm ~/.tmux || ln -s ~/roger/devops/linux_environment/src/environment/tmux/tmux ~/.tmux
  rm ~/.tmux.conf || ln -s ~/roger/devops/linux_environment/src/environment/tmux/tmux.conf ~/.tmux.conf
  rm ~/.vim || ln -s ~/roger/devops/linux_environment/src/environment/vim/vim ~/.vim
  rm ~/.vimrc || ln -s ~/roger/devops/linux_environment/src/environment/vim/vimrc ~/.vimrc
  rm ~/.vimrc_plugins || ln -s ~/roger/devops/linux_environment/src/environment/vim/vimrc_plugins ~/.vimrc_plugins
  rm ~/.vimrc_commands || ln -s ~/roger/devops/linux_environment/src/environment/vim/vimrc_commands ~/.vimrc_commands
  rm ~/.vimrc_mapping || ln -s ~/roger/devops/linux_environment/src/environment/vim/vimrc_mapping ~/.vimrc_mapping
  rm ~/.ctags || ln -s ~/roger/devops/linux_environment/src/environment/ctags/ctags ~/.ctags
  rm ~/.script_profile || ln -s ~/roger/devops/linux_environment/src/environment/profiles/script_profile_aveva ~/.script_profile
  echo "DONE"
}

wsl::Execute()
{
  # Usage: Execute <in:program_path> [<parameters>...]

  if [ "${g_caller_dir}" != "" ]; then
    pushd "${g_caller_dir}" > /dev/null
  fi

  local shell_command="cmd.exe /C $@"
  log::Log "info" "5" "Shell Command" "${shell_command}"
  cmd.exe /C $@

  if [ "${g_caller_dir}" != "" ]; then
    popd
  fi

  return 0
}

wsl::GetShortNamePath()
{
  # Usage: GetShortNamePath <in:windows_file_path>
  local in_windows_file_path="$1"

  local shell_command="cmd.exe /C _windows_short_name_path.bat "${in_windows_file_path}""
  log::Log "info" "5" "Shell Command" "${shell_command}"

  cmd.exe /C _windows_short_name_path.bat "${in_windows_file_path}"
}

wsl::ConvertLinuxPathToWindowsPath()
{
  # Usage: ConvertLinuxPathToWindowsPath <in:path>
  local in_path=$1

  log::Log "info" "5" "Linux Path" "${in_path}"

  in_path=${in_path/\//}
  in_path=${in_path/mnt\//}
  in_path=${in_path/\//:\/}
  log::Log "info" "5" "Windows Path" "${in_path}"
  in_path=$(wsl::GetShortNamePath "${in_path}")
  echo "${in_path}"
  return 0
}

