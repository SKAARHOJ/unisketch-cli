source "${SRC_PATH}/config/read.bash"
source "${SRC_PATH}/reporting/report.bash"
source "${SRC_PATH}/tools/arm-none-eabi/gdb.bash"

function attach() {
  assert_configuration_exists

  gdbscript="${TMP_PATH}/debug.gdbscript"
  device_debug_probe_path=$(read_config .device.debug_probe.path)

  report_status "Creating a GDB script..."

  create_gdb_debug_script $gdbscript

  report_status "Loading and starting the executable on the device..."
  report_metadata "Blackmagic Debug Probe (BDP) path" $device_debug_probe_path
  run_gdb interactive $gdbscript
  remove_gdb_script $gdbscript
}