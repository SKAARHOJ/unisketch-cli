source "${SRC_PATH}/config/read.bash"
source "${SRC_PATH}/reporting/colors.bash"
source "${SRC_PATH}/reporting/report.bash"
source "${SRC_PATH}/tools/arm-none-eabi/gdb.bash"

function run() {
  assert_configuration_exists

  gdbscript="${TMP_PATH}/load.gdbscript"
  device_debug_probe_path=$(read_config .device.debug_probe.path)

  build

  report_status "Creating a GDB script..."

  create_gdb_load_script $gdbscript

  report_status "Loading and starting the executable on the device..."
  report_metadata "Blackmagic Debug Probe (BDP) path" $device_debug_probe_path
  run_gdb headless $gdbscript
  remove_gdb_script $gdbscript

  report_finish "Finished running the project."
}