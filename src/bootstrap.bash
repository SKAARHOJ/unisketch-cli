source "${SRC_PATH}/reporting/colors.bash"
source "${SRC_PATH}/reporting/crash.bash"
source "${SRC_PATH}/commands/build.bash"
source "${SRC_PATH}/commands/run.bash"
source "${SRC_PATH}/commands/debug.bash"
source "${SRC_PATH}/commands/help.bash"
source "${SRC_PATH}/commands/attach.bash"
source "${SRC_PATH}/commands/init.bash"
source "${SRC_PATH}/commands/clean.bash"

function bootstrap() {
  if [ "$#" -lt 1 ]
  then
    print_help
    exit
  fi

  # Remove 'unisketch' from the argument list
  subcommand=$1; shift

  case "$subcommand" in
    # Parse options to the install sub command
    build )
      build "$@"
      ;;
    run )
      run "$@"
      ;;
    debug )
      debug "$@"
      ;;
    attach )
      attach "$@"
      ;;
    init )
      init "$@"
      ;;
    clean )
      clean "$@"
      ;;
    help )
      print_help extended
      ;;
    * )
      crash 9 "Invalid option ${RESET_COLOR}${subcommand}${BOLD}${RED_COLOR}, use ${RESET_COLOR}help${BOLD}${RED_COLOR} command to display usage information."
  esac
}