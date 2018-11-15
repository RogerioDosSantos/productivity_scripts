# Bash scripts

This repository contains all set of the bash scripts code that allow increase in productivity as well provides tools
that ca be accessed in a easier way that typing long command lines.

The scripts that should be exposed have its callers with help for each commands. 

The scripts also provide profile configuration file that allow to configure common properties so you will not need the
type it over and over again

## Profiles

By default the profile is located at the `~/.script_profile`

Everytime that an script call a profileable property that it depends on, it will execute the following sequence:

- Check if a property was set during the command call. If was, it will use the property set. If not will continue the
  checks.
- Check if a property is on the profile. If was it will the profile property. If not will user set a default hard coded
  value for the property, will add the default propety value in the profile and will use the default value.

In this way, every property that is called in the command will superseed the property that is on the profile that will
superseed the default hard code default property value set on the script.

## Callers

Below you will find the current scripts callers and its help documentation.

### devops

Responsible to all items related to *Development and Operations*. E.g.: Start servers, configuration of environments,
etc.

```bash
devops --<options> --<command> [<command_options>]
 
- Options:
--log_enable (-le) : Enable log
--log_show (-ls) : Show log
--log_level (-ll) <level>: Define the Log Level (Default: 5)
 
- Commands:
--help (h) : Display this command help
--setup_scripts (-ss) : Create the scripts callers and profile.
--setup_wsl (-ws) : Prepare the WSL have the proper intallation, configuration and mappings
--jenkins_server_start (-js) : Start Jenkins Server
--artifactory_server_start (-as) : Start JFrog Artifactory Server (Conan Package Manager Repository)
--builder_start (-bs): Start Builder (with Conan Client)
--fn_server_start (-fs) : Start Fn Server
--get_docker_run_command (-gr) <container> : Get the run command of a container. You can inform the container name or id.
```



