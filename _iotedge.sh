#!/usr/bin/env bash

iotedge::InstallScriptDependencies()
{
  # Usage: InstallDependencies
  # Check if the iotedge is installed
  echo "Installing script dependencies ..." 
  sudo apt-get update 
  sudo apt-get install -y \
    curl \
    grep 
  echo "Installing script dependencies ... DONE"
  return 0
}

iotedge::IsProgramInstalled()
{
  # Usage: IsProgramInstalled <in:program_name>
  local in_program_name="$1"
  # local programs="$(compgen -c "${in_program_name}")"
  local programs="$(which "${in_program_name}")"
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
  if [ "$(iotedge::IsProgramInstalled "docker")" == "true" ]; then
    echo "Moby/Docker already available"
    echo "- Moby/Docker Version:"  
    sudo docker version 
    return 0
  fi
  echo "Installing Moby Engine ..." 
  sudo apt-get update 
  sudo apt-get install -y \
    moby-engine \
    moby-cli 
  echo "- Moby/Docker Version:"  
  sudo docker version 
  echo "Installing Moby Engine ... DONE"
  return 0
}

iotedge::AddMicrosoftRepository()
{
  #Usage: AddMicrosoftRepository
  echo "Adding MicroSoft Repositories ..."
  echo "- Product List"
  curl https://packages.microsoft.com/config/ubuntu/18.04/multiarch/prod.list > ./microsoft-prod.list
  sudo cp ./microsoft-prod.list /etc/apt/sources.list.d/
  echo "- Trusted GPG"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo cp ./microsoft.gpg /etc/apt/trusted.gpg.d/
  echo "Adding MicroSoft Repositories ... DONE"
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
  iotedge::AddMicrosoftRepository
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
  echo "- Current Configuration:"
  sudo cat /etc/iotedge/config.yaml 
  echo "- Creating new configuration:"
  echo '#IoTEdge Configuration' > ./iotedge_config.yaml
  echo 'provisioning:' >> ./iotedge_config.yaml
  echo '  source: "manual"' >> ./iotedge_config.yaml
  echo '  device_connection_string: "HostName=iotedge-services-hub-dev.azure-devices.net;DeviceId=b2c1b367-b79c-4629-82d7-787614661ed2::b7f99764-f776-456c-6ae3-08d72005ac0b;SharedAccessKey=Q0RjMNuUI9R5g3rKHwwIsL5qTppwqe823sS+OtWSHik="' >> ./iotedge_config.yaml
  echo 'agent:' >> ./iotedge_config.yaml
  echo '  name: "edgeAgent"' >> ./iotedge_config.yaml
  echo '  type: "docker"' >> ./iotedge_config.yaml
  echo '  env: {}' >> ./iotedge_config.yaml
  echo '  config:' >> ./iotedge_config.yaml
  echo '    image: "mcr.microsoft.com/azureiotedge-agent:1.0"' >> ./iotedge_config.yaml
  echo '    auth: {}' >> ./iotedge_config.yaml
  echo 'hostname: "qa-bootstrap"' >> ./iotedge_config.yaml
  echo 'connect:' >> ./iotedge_config.yaml
  echo '  management_uri: "unix:///var/run/iotedge/mgmt.sock"' >> ./iotedge_config.yaml
  echo '  workload_uri: "unix:///var/run/iotedge/workload.sock"' >> ./iotedge_config.yaml
  echo 'listen:' >> ./iotedge_config.yaml
  echo '  management_uri: "fd://iotedge.mgmt.socket"' >> ./iotedge_config.yaml
  echo '  workload_uri: "fd://iotedge.socket"' >> ./iotedge_config.yaml
  echo 'homedir: "/var/lib/iotedge"' >> ./iotedge_config.yaml
  echo 'moby_runtime:' >> ./iotedge_config.yaml
  echo '  uri: "unix:///var/run/docker.sock"' >> ./iotedge_config.yaml
  echo "- Updating Configuration"
  sudo cp ./iotedge_config.yaml /etc/iotedge/config.yaml 
  echo "- Updated Configuration:"
  sudo cat /etc/iotedge/config.yaml 
  echo "- Restarting IoTEdge Runtime in 10 seconds"
  sleep 10
  sudo systemctl restart iotedge
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

