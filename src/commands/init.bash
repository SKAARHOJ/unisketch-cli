source "${SRC_PATH}/config/read.bash"
source "${SRC_PATH}/reporting/colors.bash"
source "${SRC_PATH}/reporting/report.bash"

function init() {
  assert_configuration_missing

  report_status "Creating a ${RESET_COLOR}${PURPLE_COLOR}${BOLD}\`.unisketch.yml\`${RESET_COLOR}${BLUE_COLOR}${BOLD} file..."

  cp "${CLI_INSTALLATION_PATH}/configurations/${OSTYPE}.yml" ./.unisketch.yml

  report_finish "Successfully initialized the CLI configuration."
}