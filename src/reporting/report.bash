source "${SRC_PATH}/reporting/colors.bash"

function report_status() {
  format_string=$1; shift

  printf "  ${RESET_COLOR}${BOLD}${BLUE_COLOR}${format_string}${RESET_COLOR}\n" $@
}

function report_metadata() {
  printf "    ${RESET_COLOR}${BOLD}$1${RESET_COLOR}: $2\n" $@
}

function report_finish() {
  format_string=$1; shift

  printf "  ${RESET_COLOR}${BOLD}${GREEN_COLOR}${format_string}${RESET_COLOR}\n" $@
}

function report_error() {
  format_string=$1; shift

  printf "    ${RESET_COLOR}${BOLD}${RED_COLOR}${format_string}${RESET_COLOR}\n" $@ >&2
}

function prompt() {
  printf "${RESET_COLOR}${BOLD}${PURPLE_COLOR}${1}${RESET_COLOR} [${2}] "
}