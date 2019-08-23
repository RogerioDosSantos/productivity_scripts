#!/usr/bin/env bash

iotedge::InstallScriptDependencies()
{
  # Usage: InstallDependencies
  # Check if the iotedge is installed
  echo "Installing script dependencies ..." 
  sudo apt-get update 
  sudo apt-get install -y \
    curl \
    grep \
    compgen \
  echo "Installing script dependencies ... DONE"
  return 0
}

iotedge::IsProgramInstalled()
{
  # Usage: IsProgramInstalled <in:program_name>
  local in_program_name="$1"
  local programs="$(compgen -c "${in_program_name}")"
  if [[ "${programs}" == *"${in_program_name}"*  ]]; then
    echo "true"
    return 0
  fi
  echo "false"
  return 0
}

iotedge::InstallMobyEngine()
{
  # Usage: InstallMobyEngine
  if [ "$(iotedge::IsProgramInstalled "docker") == "true" " ]; then
    echo "Moby/Docker already available"
    echo "- Moby/Docker Version:"  
    sudo docker version 
    return 0
  fi
  echo "Installing Moby Engine ..." 
  sudo apt-get update 
  sudo apt-get install -y \
    moby-engine \
    moby-cli \
  echo "- Moby/Docker Version:"  
  sudo docker version 
  echo "Installing Moby Engine ... DONE"
  return 0
}

iotedge::InstallIoTEdge()
{
  # Usage: InstallIoTEdge
  if [ "$(iotedge::IsProgramInstalled "iotedge")" == "true" ]; then 
    echo "IoTEdge already available"
    echo "- IoTEdge Version:"  
    sudo iotedge --version 
    return 0
  fi
  sudo echo "Installing IoTEdge ..." 
  iotedge::InstallMobyEngine
  apt-get update 
  sudo apt-get install -y \
      iotedge 
  echo "- IoTEdge Version:"  
  sudo iotedge --version 
  echo "Installing IoTEdge ... DONE"
  return 0
}

iotedge::ConfigureEdgeDevice()
{
  # Usage: ConfigureEdgeDevice
  echo "Configuring Edge Device ..." 
  sudo cat /etc/iotedge/config.yaml 
  echo "Configuring Edge Device ... DONE"
  return 0
}

iotedge::Bootstrap()
{
  echo "Bootstrap"
  iotedge::InstallScriptDependencies
  iotedge::InstallIoTEdge
  iotedge::ConfigureEdgeDevice
}

iotedge::Bootstrap

