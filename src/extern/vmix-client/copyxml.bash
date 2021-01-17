function copy_xml() {
  report_status "Getting XML..."
  report_metadata "Host" $1
  report_metadata "Port" $2

  nc -z "$1" "$2" > $LOG_FILE 2>&1

  if [ $? -ne 0 ]; then
    crash 1 "Could not connect to the server."
  fi

  report_status "Receiving response..."

  osname=$(uname -o)

  if [[ $osname == "Cygwin" ]];
  then
    echo "XML" | nc "$1" "$2" | tail -1 | tidy -xml -iq > /dev/clipboard
  elif [[ $osname == "Darwin" ]];
  then
    echo "XML" | nc "$1" "$2" | tail -1 | tidy -xml -iq | pbcopy
  else
    crash 9 "Not supported on Linux, please create a feature request to make it supported."
  fi

  report_finish "Copied XML to the clipboard."
}