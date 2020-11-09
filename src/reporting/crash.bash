source "${SRC_PATH}/reporting/report.bash"

function crash() {
  return_value=$1; shift

  report_error "$@"
  exit $return_value
}