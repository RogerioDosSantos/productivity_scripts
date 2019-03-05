#/usr/bin/env bash

source ./_log.sh

bootstrap::BootstrapCpp()
{
  # Usage: BootstrapCpp <in:project_dir> <in:template_dir>
  local in_project_dir="$1"
  local in_template_dir="${2:-$(pwd -P)/../templates}"

  log::Log "info" "5" "Project Dir" "${in_project_dir}"
  log::Log "info" "5" "Templates Dir" "${in_template_dir}"
  log::Log "info" "5" "Creating minimal cpp project" ""
  pushd "${in_project_dir}"
  if [ -e "./README.md" ]; then
    cp "./README.md" "./README.bkp"
  fi

  cp "${in_template_dir}/readme/readme_project_cpp.md" ./README.md
  cp "${in_template_dir}/git/gitignore_projects_folder" ./.gitignore
  cp "${in_template_dir}/cmake/conan_cpp_project.cmake" ./CMakeLists.txt
  cp "${in_template_dir}/conan/conan_cpp_project.py" ./conanfile.py
  mkdir -p build 
  cp "${in_template_dir}/docker/build_cpp_project_windows.docker" ./build/build_windows.docker
  cp "${in_template_dir}/docker/docker_compose_build_windows.yaml" ./build/docker_compose_build_windows.yaml
  mkdir -p include 
  mkdir -p src 
  cp "${in_template_dir}/cpp/boost_program_options.cpp" ./src/main.cpp
  popd
  log::Log "info" "5" "Creating minimal cpp project" "DONE"
}

