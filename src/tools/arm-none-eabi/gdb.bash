function run_gdb() {
  log_file=$(read_config .logging.path)

  if [ "$OSTYPE" = "cygwin" ];
  then
    given_path=$(cygpath -d $2)
  else
    given_path=$2
  fi

  case "$1" in
    headless )
      arm-none-eabi-gdb -x $given_path >> $log_file 2>&1
      ;;
    interactive )
      arm-none-eabi-gdb -x $given_path
      ;;
  esac
}

function render_template() {
  if [ "$OSTYPE" = "cygwin" ];
  then
    given_path=$(cygpath -d $1)
  else
    given_path=$1
  fi

  shift

  jinja2 "$@" $given_path 
}

function create_gdb_load_script() {
  device_debug_probe_path=$(read_config .devices[0].debug_probe.path)
  build_path=$(read_config .build.path)
  output_file=$1

  rm $output_file > $nulldevice 2>&1

  render_template \
    "${CLI_INSTALLATION_PATH}/gdb/load.gdbscript" \
    -D device_debug_probe_path=$device_debug_probe_path \
    -D build_path=$build_path > $output_file
}

function create_gdb_debug_script() {
  device_debug_probe_path=$(read_config .devices[0].debug_probe.path)
  build_path=$(read_config .build.path)
  output_file=$1

  rm $output_file > $nulldevice 2>&1

  render_template \
    "${CLI_INSTALLATION_PATH}/gdb/debug.gdbscript" \
    -D device_debug_probe_path=$device_debug_probe_path \
    -D build_path=$build_path > $output_file
}

function remove_gdb_script() {
  output_file=$1

  rm $output_file > $nulldevice 2>&1
}