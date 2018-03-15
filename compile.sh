#!/bin/bash

## Continous compiling
## Author: Francisco Chaves
## pachopepe@gmail.com

usage() { echo "Usage: $0 [-p <port>]" 1>&2; exit 1; }


port=8080

while getopts ":p:" opt; do
        case ${opt} in
                -p)
                    port="$OPTARG"
                    echo "setting port to ${port}"
                    ;;
                \?)
                    usage
                    ;;
                :)
                    usage
                    ;;
        esac
done
shift $((OPTIND-1))

if [ "${port}" == "undefined" ]
then
   echo "The port parameter is mandatory"
   usage
fi

# Checks if the port is available

pid_port=`lsof -Pi :${port} -sTCP:LISTEN -t`
if [ "${pid_port}" != "" ]
then
   echo "The process ${pid_port} is running on ${port}"
   exit 1
fi

# Clean background process on exit
trap 'kill $(jobs -p)' EXIT

# takes the process id of http server
server_pid=0

# running server on ${port}
# Use <contextReloadable>true</contextReloadable> on the maven tomcat plugin
mvn -Dmaven.tomcat.port="${port}" tomcat7:run &

# takes the process id of http server
server_pid=$!


# Output files
autoDir="autodir"

# Colors
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"
gray="$(tput setaf 8)"
red="$(tput setaf 1)"
magenta="$(tput setaf 5)"
purple="$(tput setaf 4)"

if [ ! -d "${autoDir}" ]
then
   echo "create directory ${autoDir}"
   mkdir -p "${autoDir}"
fi

first_time=1

while true
do
  # Files check
  changes=`find src -name "*" -a -newer "${autoDir}" | wc -l | sed -e 's/^[ \t]*//'`
  pom_updated=`find . -wholename ./pom.xml -a -newer ${autoDir}`
  if [[ $? != 0 || ${changes} > 0 || ${pom_updated} != "" || ${first_time} > 0 ]] 
  then
    first_time=0
    # if [[ ${server_pid} > 0 ]]
    # then
    #   echo -e "${yellow}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    #   echo -e "${yellow}~~~~~~~~~~~~~~~ KILL ${server_pid}  ~~~~~~~~~~~~~~~~~~~"
    #   echo -e "${yellow}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    #   kill ${server_pid}
    #   server_pid=0
    #   echo -e "${yellow}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    # fi
    echo -e "${yellow}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo -e "${yellow}~~~~~~~~~~~~~~~~~ COMPILING ~~~~~~~~~~~~~~~~~~"
    echo -e "${yellow}~~~~~~~ " `date` " ~~~~~~~"
    echo -e "$(tput sgr0)"
    mvn package
    result=$?
    echo
    if [[ ${result} > 0 ]]
      then
      echo -e "${red}^^^^^^^^^^^^^^^^^^^^ ERRORS! ^^^^^^^^^^^^^^^^^^^"
      echo -e "${red}^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
    else
      echo -e "${green}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ OK :)"
      echo -e "${green}~~~~~~~~~~~~ Running on port ${port} ~~~~~~~ OK :)"

    fi
    echo -e "$(tput sgr0)"
    touch ${autoDir}
    
  fi
done
