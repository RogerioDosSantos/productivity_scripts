#!/bin/bash

iotedge::GetConnectionString()
{
  echo "HostName=iotedge-services-hub-dev.azure-devices.net;DeviceId=c8c3c110-7d48-468b-a7fa-ed6d148afc2e::294ef369-4c9c-4ad4-8aea-91af0b741b38;SharedAccessKey=zcjAO1OQUFSUoja1Hh4S6hsnT6s1ihT1uzBbdjjB3MQ="
}

iotedge::GetDeviceCode()
{
  echo "hnxpwmq2"
}

iotedge::GetUserInstructions()
{
  echo ""
}

iotedge::GetHostName()
{
  echo \"$HOSTNAME\"
}

iotedge::GetProxyUrl()
{
  echo "##proxy_url##"
}

iotedge::InstallScriptDependencies()
{
  echo "Bootstrap - Installing script dependencies ..." 
  sudo apt-get update 
  sudo apt-get install -y \
    curl \
    grep \
    sed
  echo "Bootstrap - Installing script dependencies ... Done"
  return 0
}

iotedge::IsProgramInstalled()
{
  local in_program_name="$1"
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
  if [ "$(iotedge::IsProgramInstalled "docker")" == "true" ]; then
    echo "Moby/Docker already available"
    echo "- Moby/Docker Version:"  
    sudo docker version 
    return 0
  fi
  echo "Bootstrap - Installing Moby Engine ..." 
  sudo apt-get update 
  sudo apt-get install -y \
    moby-engine \
    moby-cli 
  echo "- Moby/Docker Version:"  
  sudo docker version 
  echo "Bootstrap - Installing Moby Engine ... Done"
  return 0
}

iotedge::AddMicrosoftRepository()
{
  #Usage: AddMicrosoftRepository
  echo "Bootstrap - Adding MicroSoft Repositories ..."
  echo "- Adding Product List"
  local osRelease="$(grep -i 'ubuntu' /etc/os-release)"
  if [[ ("${osRelease}" != "") ]] ; then
    local version="$(grep '18.04' /etc/os-release)"
    if [[ ("${version}" != "") ]]; then
      echo "-- OS Version: Ubuntu 18.04"
      sudo curl https://packages.microsoft.com/config/ubuntu/18.04/multiarch/prod.list > ./microsoft-prod.list
    fi
    version="$(grep '16.04' /etc/os-release)"
    if [[ ("${version}" != "") ]]; then
	  echo "-- OS Version: Ubuntu 16.04"
      sudo curl https://packages.microsoft.com/config/ubuntu/16.04/multiarch/prod.list > ./microsoft-prod.list
    fi
  else
    osRelease="$(grep -i 'stretch' /etc/os-release)"
    if [[ ("${osRelease}" != "") ]]; then
	  echo "-- OS Version: Raspbian Stretch"
      sudo curl https://packages.microsoft.com/config/debian/stretch/multiarch/prod.list > ./microsoft-prod.list
    fi
  fi
  sudo cp ./microsoft-prod.list /etc/apt/sources.list.d/
  echo "- Adding Trusted GNU Privacy Guard (GPG)"
  sudo curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo cp ./microsoft.gpg /etc/apt/trusted.gpg.d/
  echo "Bootstrap - Adding MicroSoft Repositories ... Done"
  return 0
}

iotedge::InstallIoTEdge()
{
  # Usage: InstallIoTEdge
  sudo echo "Bootstrap - Installing IoTEdge ..." 
  if [ "$(iotedge::IsProgramInstalled "iotedge")" == "true" ]; then 
    echo "- IoTEdge already available"
    echo "- IoTEdge Version:"  
    sudo iotedge --version 
    echo "Bootstrap - Installing IoTEdge ... Done"
    return 0
  fi
  iotedge::AddMicrosoftRepository
  iotedge::InstallMobyEngine
  sudo apt-get update 
  sudo apt-get install -y \
    iotedge 
  echo "- IoTEdge Version:"  
  sudo iotedge --version 
  echo "Bootstrap - Installing IoTEdge ... Done"
  return 0
}

iotedge::StopService()
{
    # Usage StopService <service_name>
    local service_name="$1"
	  echo "Bootstrap - Stopping ${service_name} service ..."
	  local index=0
	  local max_retries=10
	  while [ $index -lt $max_retries ]; do
      local status="$(systemctl is-active ${service_name})"
      if [ "$status" == "inactive" ]; then 
        echo "- Service ${service_name} stopped with success."
        echo "Bootstrap - Stopping ${service_name} service ... Done"
        return 0
      fi
      echo "- Trying to stop ${service_name} service (${index} of ${max_retries})"
      sudo systemctl stop "${service_name}"
      sleep 3
      let index++
	  done
    echo "- Could not stop service ${service_name}."
	  echo "Bootstrap - Stopping ${service_name} service ... Done"
    return 1
}

iotedge::StartService()
{
    # Usage StartService <service_name>
    local service_name="$1"
	  echo "Bootstrap - Starting ${service_name} service ..."
	  local index=0
	  local max_retries=10
	  while [ $index -lt $max_retries ]; do
      local status="$(systemctl is-active ${service_name})"
      if [ "$status" == "active" ]; then 
        echo "- Service ${service_name} started with success."
        echo "Bootstrap - Starting ${service_name} service ... Done"
        return 0
      fi
      echo "- Trying to start ${service_name} service (${index} of ${max_retries})"
      sudo systemctl start "${service_name}"
      sleep 3
      let index++
	  done
    echo "- Could not start service ${service_name}."
	  echo "Bootstrap - Starting ${service_name} service ... Done"
    return 1
}

iotedge::ConfigureServiceProperty()
{
  # Usage ConfigureServiceProperty <service_name> <session> <property> <value>
  local service_name="$1"
  local session="$1"
  echo "Bootstrap - Configuring Proxy on the ${service_name} service ..."
	local proxy_url="$(iotedge::GetProxyUrl)"
  echo "- Proxy URL: ${proxy_url}"
  local overwite_file_dir="/etc/systemd/system/${service_name}.service.d"
  local overwite_file_path="${overwite_file_dir}/override.conf"
  sudo  mkdir -p "${overwite_file_dir}"
	if [[ ! -e ${overwite_file_path} ]] ; then
		echo "- Overrride Config (override.conf) created."
    sudo echo '[Service]' > "${overwite_file_path}"
    sudo echo "Environment='https_proxy=${proxy_url}'" >> /etc/systemd/system/docker.service.d/override.conf
		echo "- Overrride Config (override.conf) created."
	fi
	local envString="Environment"
	if  grep -i $envString  /etc/systemd/system/docker.service.d/override.conf  ; then
    echo "- Proxy already exists on the Overrride Config (override.conf)."
	else	
	fi
	sudo systemctl daemon-reload
	sudo systemctl restart docker
  echo "Bootstrap - Configuring Proxy on the Moby Service ... Done"
}

iotedge::SetProxyEnvironment()
{
  echo "Bootstrap - Setting Proxy Environment ... "
  local proxy_url="$(iotedge::GetProxyUrl)"
	# local no_proxy=".dev.wonderware.com.localhost,127.0.0.1"
  # echo "- HTTP Proxy: ${proxy_url}"
  echo "- HTTPS Proxy: ${proxy_url}"
  # echo "- No Proxy: ${no_proxy}"
  if [[ ("${proxy_url}" != "") ]] ; then
    echo "- No proxy configuration changed."
    echo "Bootstrap - Setting Proxy Environment ... Done"
    return 0
  fi
	local proxyString="https_proxy"
	if  grep -i $proxyString  ~/.bashrc  ; then
		echo "-- Proxy already exists"
	else
	   sudo echo "https_proxy=${proxy_url}" >> ~/.bashrc
	   sudo echo 'export https_proxy' >> ~/.bashrc
	fi
  echo "-- Current Bash Configuration:"
	source ~/.bashrc
  echo "Bootstrap - Setting Proxy Environment ... Done"
  return 0
}

iotedge::ConfigureProxyOnTheIoTEdgeService()
{
  echo "Bootstrap - Configuring Proxy on the IoTEdge Service ..."
  echo "- Current IoTEdge Service Configuration:"
  sudo systemctl cat iotedge
	local envString="Environment"
	local proxy_url="$(iotedge::GetProxyUrl)"
	if [[ ! -e /etc/systemd/system/iotedge.service.d/override.conf ]] ; then
		echo "- Creating Overrride Config (override.conf)."
		sudo mkdir -p /etc/systemd/system/iotedge.service.d
		sudo touch /etc/systemd/system/iotedge.service.d/override.conf
		echo "- Overrride Config (override.conf) created."
	fi
	if grep -i $envString  /etc/systemd/system/iotedge.service.d/override.conf  ; then
    echo "- Proxy already exists on the Overrride Config (override.conf)."
	else
		sudo echo '[Service]' > /etc/systemd/system/iotedge.service.d/override.conf
		sudo echo "Environment='https_proxy=${proxy_url}'" >> /etc/systemd/system/iotedge.service.d/override.conf
	fi	 
  #TODO(Roger) - Create a Stop, Start and Restart function. Also ensure that we stop the IoTEdge Service in the beginning and start it in the end.
	sudo systemctl restart iotedge
  echo "Bootstrap - Configuring Proxy on the IoTEdge Service ... Done"
}

iotedge::ConfigureProxyOnTheMobyService()
{
  echo "Bootstrap - Configuring Proxy on the Moby Service ..."
	local envString="Environment"
	local proxy_url="$(iotedge::GetProxyUrl)"
	if [[ ! -e /etc/systemd/system/docker.service.d/override.conf ]] ; then
		sudo  mkdir -p /etc/systemd/system/docker.service.d
		sudo touch /etc/systemd/system/docker.service.d/override.conf
		echo "- Overrride Config (override.conf) created."
	fi
	if  grep -i $envString  /etc/systemd/system/docker.service.d/override.conf  ; then
    echo "- Proxy already exists on the Overrride Config (override.conf)."
	else	
	   sudo echo '[Service]' > /etc/systemd/system/docker.service.d/override.conf
	   sudo echo "Environment='https_proxy=${proxy_url}'" >> /etc/systemd/system/docker.service.d/override.conf
	fi
	sudo systemctl daemon-reload
	sudo systemctl restart docker
  echo "Bootstrap - Configuring Proxy on the Moby Service ... Done"
}

iotedge::ConfigureEdgeDevice()
{
  # Usage: ConfigureEdgeDevice <in:connection_string>
  local in_connection_string="$1"
  local host_name="$(iotedge::GetHostName)"
  echo "Bootstrap - Configuring Edge Device ..." 
  echo "- Operative System:" cat /etc/os-release
  echo "- Desired Connection String: ${in_connection_string}"
  echo "- Current Configuration:"
  sudo cat /etc/iotedge/config.yaml 
  echo "- Creating new configuration:"
  sudo echo '#IoTEdge Configuration' > ./iotedge_config.yaml
  sudo echo 'provisioning:' >> ./iotedge_config.yaml
  sudo echo '  source: "manual"' >> ./iotedge_config.yaml
  sudo echo "  device_connection_string: '${in_connection_string}'" >> ./iotedge_config.yaml
  sudo echo '#certificates:' >> ./iotedge_config.yaml
  sudo echo '  #device_ca_cert: "/etc/iotedge/iot-edge-device-ca-EdgeDeviceCA-full-chain.cert.pem"' >> ./iotedge_config.yaml
  sudo echo '  #device_ca_pk: "/etc/iotedge/iot-edge-device-ca-EdgeDeviceCA.key.pem"' >> ./iotedge_config.yaml
  sudo echo '  #trusted_ca_certs: "/etc/iotedge/azure-iot-test-only.root.ca.cert.pem"' >> ./iotedge_config.yaml
  sudo echo 'agent:' >> ./iotedge_config.yaml
  sudo echo '  name: "edgeAgent"' >> ./iotedge_config.yaml
  sudo echo '  type: "docker"' >> ./iotedge_config.yaml
  sudo echo '  env: {}' >> ./iotedge_config.yaml
  sudo echo '  config:' >> ./iotedge_config.yaml
  sudo echo '    image: "mcr.microsoft.com/azureiotedge-agent:1.0"' >> ./iotedge_config.yaml
  sudo echo '    auth: {}' >> ./iotedge_config.yaml
  sudo echo "hostname: ${host_name}" >> ./iotedge_config.yaml
  sudo echo 'connect:' >> ./iotedge_config.yaml
  sudo echo '  management_uri: "unix:///var/run/iotedge/mgmt.sock"' >> ./iotedge_config.yaml
  sudo echo '  workload_uri: "unix:///var/run/iotedge/workload.sock"' >> ./iotedge_config.yaml
  sudo echo 'listen:' >> ./iotedge_config.yaml
  sudo echo '  management_uri: "fd://iotedge.mgmt.socket"' >> ./iotedge_config.yaml
  sudo echo '  workload_uri: "fd://iotedge.socket"' >> ./iotedge_config.yaml
  sudo echo 'homedir: "/var/lib/iotedge"' >> ./iotedge_config.yaml
  sudo echo 'moby_runtime:' >> ./iotedge_config.yaml
  sudo echo '  uri: "unix:///var/run/docker.sock"' >> ./iotedge_config.yaml
  sudo echo "- Updating Configuration"
  sudo cp ./iotedge_config.yaml /etc/iotedge/config.yaml 

  #TODO(Roger) - Check why we have this comment and what are the consequences
# The following DNS configuration gives a false positive on the iotedge check.
# If the file doesn't exist iotedge throws a DNS warning message, but if the file
# exists it will show an OK message, even when the IP is empty or incorrect.
#  echo '{"dns": ["x.x.x.x"]}' > ./dnsconfig-daemon.json
#  sudo cp ./dnsconfig-daemon.json /etc/docker/

  echo "- Updated Configuration:"
  sudo cat /etc/iotedge/config.yaml 
  echo "Bootstrap - Configuring Edge Device ... Done"
  return 0
}

iotedge::DownloadCertificates()
{
  #TODO(Roger) - Redo this function
  echo "Bootstrap - Downloading Certificates ..."
	DATE_NOW=$(date -Ru | sed 's/\+0000/GMT/')
	AZ_VERSION="2018-03-28"
	AZ_BLOB_URL="https://edgecertstore.blob.core.windows.net"
	AZ_BLOB_CONTAINER="certs"
	AZ_BLOB_TARGET="${AZ_BLOB_URL}/${AZ_BLOB_CONTAINER}/"
	AZ_SAS_TOKEN="?sv=2019-02-02&ss=b&srt=sco&sp=rl&se=2100-01-01T04:14:36Z&st=2019-11-01T19:14:36Z&spr=https&sig=6ajti4OqTPax0kZWRCkqfMTj4M33CDUVhc5bEkpXG5k%3D"
	curl -v -H "x-ms-date: ${DATE_NOW}" -H "x-ms-version: ${AZ_VERSION}" -H "x-ms-blob-type: BlockBlob" -f "${AZ_BLOB_TARGET}azure-iot-test-only.root.ca.cert.pem${AZ_SAS_TOKEN}" -o azure-iot-test-only.root.ca.cert.pem
	curl -v -H "x-ms-date: ${DATE_NOW}" -H "x-ms-version: ${AZ_VERSION}" -H "x-ms-blob-type: BlockBlob" -f "${AZ_BLOB_TARGET}iot-edge-device-ca-EdgeDeviceCA-full-chain.cert.pem${AZ_SAS_TOKEN}" -o iot-edge-device-ca-EdgeDeviceCA-full-chain.cert.pem
	curl -v -H "x-ms-date: ${DATE_NOW}" -H "x-ms-version: ${AZ_VERSION}" -H "x-ms-blob-type: BlockBlob" -f "${AZ_BLOB_TARGET}iot-edge-device-ca-EdgeDeviceCA.key.pem${AZ_SAS_TOKEN}" -o iot-edge-device-ca-EdgeDeviceCA.key.pem
  echo "Bootstrap - Downloading Certificates ... Done"
  return 0
}

iotedge::Bootstrap()
{
  echo "AVEVA Bootstrap"
  local device_code="$(iotedge::GetDeviceCode)"
  local device_connection_string="$(iotedge::GetConnectionString)"
  local user_instructions="$(iotedge::GetUserInstructions)"
  echo "- Device Code: ${device_code}"
  if [[ ("${user_instructions}" != "") ]] ; then
    echo "- Could not install/configure iotedge. Please follow the instructions below for more details:"
    echo "${user_instructions}"
    return 1
  fi
  iotedge::SetProxyEnvironment
  iotedge::InstallScriptDependencies
  iotedge::InstallIoTEdge
  iotedge::ConfigureProxyOnTheIoTEdgeService
  iotedge::ConfigureProxyOnTheMobyService
  #iotedge::DownloadCertificates
  iotedge::ConfigureEdgeDevice "${device_connection_string}"
  iotedge::RestartIoTEdge
}

iotedge::Bootstrap 
