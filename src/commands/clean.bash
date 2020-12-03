source "${SRC_PATH}/config/read.bash"
source "${SRC_PATH}/reporting/colors.bash"
source "${SRC_PATH}/reporting/report.bash"

function clean() {
  assert_configuration_exists

  build_path=$(read_config .build.path)
  device_type=$(read_config .devices[0].type)

  report_status "Cleaning up fetch configuration overrides..."
  report_metadata "Device type" $device_type

  /usr/bin/git checkout -- \
    "./ArduinoLibs/SkaarhojUniSketch/SK_CTRL_${device_type^^}.h" \
    "./ArduinoLibs/SkaarhojUniSketch/SK_CFGDEF_${device_type^^}.h" \
    "./Software/UniSketch/UniSketch.ino"

  report_status "Cleaning up build artifacts..."
  report_metadata "Build path" $build_path

  rm -rf $build_path > $nulldevice 2>&1

  report_finish "Finished cleaning the project."
}