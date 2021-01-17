function send_message() {
  report_status "Sending command..." $1
  report_metadata "Host" $2
  report_metadata "Port" $3

  nc -z "$2" "$3" > $LOG_FILE 2>&1

  if [ $? -ne 0 ]; then
    crash 1 "Could not connect to the server."
  fi
  
  report_status "Receiving response..."
  echo "$1" | nc "$2" "$3" | sed 's/^/    /'

  report_finish "Finished sending command."
}