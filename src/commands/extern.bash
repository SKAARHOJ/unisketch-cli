source "${SRC_PATH}/extern/vmix-client/main.bash"

function extern() {
  assert_configuration_exists

  if [ "$#" -lt 1 ]
  then
    print_extern_help
    exit
  fi

  # Remove 'extern' from the argument list
  subcommand=${1:2}; shift

  case "$subcommand" in
    vmix-client )
      VMIX_CLIENT_run "$@"
      ;;
    * )
      crash 9 "Invalid extension ${RESET_COLOR}${subcommand}${BOLD}${RED_COLOR}, use ${RESET_COLOR}help${BOLD}${RED_COLOR} command to display usage information."
  esac
}