source "${SRC_PATH}/reporting/report.bash"

function crash() {
  return_value=$1; shift

  report_error "$@"

  sed 's/^/     /' $LOG_FILE

  exit $return_value
}