function run_usbreset() {
  osname=$(uname)

  if [ "$osname" = "Darwin" ];
  then
    blackmagic-debug-probe-usbreset > $LOG_FILE 2>&1
  fi
}