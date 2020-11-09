function run_fetch_script() {
  python_interpreter=$(read_config .fetch.python_interpreter)

  bash -c "${python_interpreter} ${CLI_INSTALLATION_PATH}/scripts/fetch.py $1"
}

function build() {
  build_path=$(read_config .build.path)
  cmake_args=$(read_config .build.cmake.args)
  ninja_args=$(read_config .build.ninja.args)
  cid=$(read_config .fetch.defaults.cid)
  device_type=$(read_config .device.type)
  log_file=$(read_config .logging.path)

  report_status "Fetching the templated files from platform..."
  report_metadata "CID" $cid
  report_metadata "Device type" $device_type
  run_fetch_script $cid >> $log_file

  report_status "Preparing a build..."

  if [ -n "$cmake_args" ]
  then
    report_metadata "Using extra arguments for CMake" $cmake_args
  fi
  
  cmake \
    $cmake_args \
    -S. \
    -B${build_path} \
    -DCMAKE_BUILD_TYPE=DEBUG \
    -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain.cmake \
    -GNinja >> $log_file

  report_status "Building the project..."

  if [ -n "$ninja_args" ]
  then
    report_metadata "Using extra arguments for Ninja" $ninja_args
  fi

  ninja \
    -C $build_path >> $log_file

  report_finish "Finished building the project."
}