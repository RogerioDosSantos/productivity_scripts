#/usr/bin/env bash

source ./_log.sh

bootstrap::BootstrapCpp()
{
  # Usage: BootstrapCpp <in:project_dir> [<in:template_dir>]
  local in_project_dir="$1"
  local in_template_dir="${2:-$(pwd -P)/../code_collection}"

  log::Log "info" "5" "Project Dir" "${in_project_dir}"
  log::Log "info" "5" "Templates Dir" "${in_template_dir}"
  log::Log "info" "5" "Creating minimal cpp project" ""
  pushd "${in_project_dir}" > /dev/null
  if [ -e "./README.md" ]; then
    cp "./README.md" "./README.bkp"
  fi

  cp "${in_template_dir}/readme/readme_project_cpp.md" ./README.md
  cp "${in_template_dir}/git/gitignore_cpp_project" ./.gitignore
  cp "${in_template_dir}/cmake/conan_cpp_project.cmake" ./CMakeLists.txt
  cp "${in_template_dir}/conan/conan_cpp_project.py" ./conanfile.py
  mkdir -p build 
  cp "${in_template_dir}/docker/build_cpp_project_windows.docker" ./build/build_windows.docker
  cp "${in_template_dir}/docker/docker_compose_build_windows.yaml" ./build/docker_compose_build_windows.yaml
  mkdir -p include 
  mkdir -p src 
  cp "${in_template_dir}/cpp/boost_program_options.cpp" ./src/main.cpp
  log::Log "info" "1" "Project Structure" ""
  pwd
  tree .
  popd > /dev/null
  log::Log "info" "5" "Creating minimal cpp project" "DONE"
}

bootstrap::Bootstrap()
{
  # Usage: Bootstrap <in:project_type> <in:project_dir>
  local in_project_type="$1"
  local in_project_dir="$2"

  pushd "${in_project_dir}" > /dev/null
  local project_dir="$(pwd -P)"
  popd > /dev/null

  case ${in_project_type} in
      "cpp") 
        bootstrap::BootstrapCpp ${project_dir}
        ;;
      *) 
        echo "Project Type not found. Type: ${in_project_type}"
        ;;
  esac
}


