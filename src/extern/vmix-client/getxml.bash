function get_xml() {
  report_status "Getting XML..."
  report_metadata "Host" $1
  report_metadata "Port" $2

  nc -z "$1" "$2" > $LOG_FILE 2>&1

  if [ $? -ne 0 ]; then
    crash 1 "Could not connect to the server."
  fi

  report_status "Receiving response..."
  echo "XML" | nc "$1" "$2" | tail -1 | tidy -xml -iq | sed 's/^/    /'

  report_finish "Finished retrieving XML."
}