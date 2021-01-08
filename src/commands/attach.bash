source "${SRC_PATH}/config/read.bash"
source "${SRC_PATH}/reporting/report.bash"
source "${SRC_PATH}/tools/arm-none-eabi/gdb.bash"
source "${SRC_PATH}/tools/blackmagic-debug-probe/usbreset.bash"

function attach() {
  assert_configuration_exists

  gdbscript="${TMP_PATH}/debug.gdbscript"
  device_debug_probe_path=$(read_config .devices[0].debug_probe.path)

  if [ "$(uname)" = "Darwin" ];
  then
    report_status "Resetting USB devices..."
    report_metadata "Target operating system" "$(uname)"
    run_usbreset
  fi

  report_status "Creating a GDB script..."

  create_gdb_debug_script $gdbscript

  report_status "Attaching GDB to the external executable..."
  report_metadata "Blackmagic Debug Probe (BDP) path" $device_debug_probe_path
  run_gdb interactive $gdbscript
  remove_gdb_script $gdbscript
}