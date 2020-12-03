source "${SRC_PATH}/reporting/colors.bash"
source "${SRC_PATH}/reporting/crash.bash"

function assert_prerequisites() {
  programs=(jq yq arm-none-eabi-gdb jinja2 cmake ninja)

  for each_program in $programs
  do
    type $1 $each_program >> /dev/null 2>&1

    if [[ $? -ne 0 ]];
    then
      crash 1 "Program ${RESET_COLOR}\"${GREEN_COLOR}${each_program}${RESET_COLOR}\"${RED_COLOR}${BOLD} not found in path."
    fi
  done
}