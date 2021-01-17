#!/usr/bin/env bash

source "${PKG_PATH}/vmix-client/sendmessage.bash"
source "${PKG_PATH}/vmix-client/getxml.bash"
source "${PKG_PATH}/vmix-client/copyxml.bash"

function VMIX_CLIENT_run() {
  # Parse options to the `unisketch` command
  while getopts ":h" opt;
  do
    case ${opt} in
      h )
        echo "Usage:"
        echo "    unisketch e:vmix-client -h                      Display this help message."
        echo "    unisketch e:vmix-client send-message <message>  Send message <message>."

        exit 0
        ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
    esac
  done

  shift $((OPTIND -1))

  process_command "$@"
}

function process_command() {
  # Remove 'vmix-client' from the argument list
  subcommand=$1; shift

  case "$subcommand" in
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

      host=${host:="localhost"}
      port=${port:="8099"}

      send_message "$message" "$host" "$port"

      shift $((OPTIND -1))
      ;;
    get-xml )
      shift

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

      host=${host:="localhost"}
      port=${port:="8099"}

      get_xml "$host" "$port"

      shift $((OPTIND -1))
      ;;
    copy-xml )
      shift

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

      host=${host:="localhost"}
      port=${port:="8099"}

      copy_xml "$host" "$port"

      shift $((OPTIND -1))
      ;;
  esac
}
