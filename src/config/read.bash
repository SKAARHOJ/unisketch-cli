source "${SRC_PATH}/reporting/colors.bash"
source "${SRC_PATH}/reporting/crash.bash"

RC_FILE="./.unisketch.yml"

function read_config() {
  yq -r $1 $RC_FILE
}

function assert_configuration_exists() {
  stat $RC_FILE > $nulldevice 2>&1

  if [ $? -ne 0 ];
  then
    crash 1 "File ${RESET_COLOR}${RC_FILE}${BOLD}${RED_COLOR} cannot be found."
  fi
}

function assert_configuration_missing() {
  stat $RC_FILE > $nulldevice 2>&1

  if [ $? -eq 0 ];
  then
    crash 1 "File ${RESET_COLOR}${RC_FILE}${BOLD}${RED_COLOR} is found. Remove it and try the command again."
  fi
}