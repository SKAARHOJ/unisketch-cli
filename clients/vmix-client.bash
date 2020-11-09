#!/usr/bin/env bash

BOLD=`tput bold`
RED_COLOR=`tput setaf 1`
GREEN_COLOR=`tput setaf 2`
BLUE_COLOR=`tput setaf 3`
PURPLE_COLOR=`tput setaf 4`
RESET_COLOR=`tput sgr0`

nulldevice="/dev/null"

function send_message() {
  nc -z "$2" "$3" > $nulldevice 2>&1

  if [ $? -ne 0 ]; then
    printf "$BOLD $RED_COLOR Could not connect to the server.$RESET_COLOR\n"
    printf "  $BLUE_COLOR Host:$RESET_COLOR $2\n"
    printf "  $BLUE_COLOR Port:$RESET_COLOR $3\n"
    exit
  fi

  printf "$BOLD $BLUE_COLOR Sending command:$RESET_COLOR $1\n"
  printf "$BOLD $PURPLE_COLOR Receiving response:$RESET_COLOR\n"
  echo "$1" | nc "$2" "$3" | sed 's/^/    /'
}

function client_vmix() {
  # Parse options to the `unisketch` command
  while getopts ":h" opt;
  do
    case ${opt} in
      h )
        echo "Usage:"
        echo "    unisketch c:vmix -h                      Display this help message."
        echo "    unisketch c:vmix send-message <message>  Send message <message>."

        exit 0
        ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
    esac
  done

  shift $((OPTIND -1))

  # Remove 'vmix-client' from the argument list
  subcommand=$1; shift

  case "$subcommand" in
    # Parse options to the install sub command
    send-message )
      message=$1; shift  # Remove 'send-message' from the argument list

      # Process message sending options
      while getopts "h:p:" opt;
      do
        case ${opt} in
          h )
            host=$OPTARG
            ;;
          p )
            port=$OPTARG
            ;;
          \? )
            echo "invalid option: -$OPTARG" 1>&2
            exit 1
            ;;
          : )
            echo "invalid option: -$OPTARG requires an argument" 1>&2
            exit 1
            ;;
        esac
      done

      port=${port:="8099"}

      send_message "$message" "$host" "$port"

      shift $((OPTIND -1))
      ;;
  esac
}


