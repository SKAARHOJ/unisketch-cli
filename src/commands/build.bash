function run_fetch_script() {
  python_interpreter=$(read_config .fetch.python_interpreter)

  bash -c "${python_interpreter} ${CLI_INSTALLATION_PATH}/scripts/fetch.py $1"
}

function build() {
  assert_configuration_exists

  build_path=$(read_config .build.path)
  cmake_args=$(read_config .build.cmake.args)
  ninja_args=$(read_config .build.ninja.args)
  cid=$(read_config .devices[0].cid)
  device_type=$(read_config .devices[0].type)

  report_status "Fetching the templated files from platform..."
  report_metadata "CID" $cid
  report_metadata "Device type" $device_type

  # Running the fetch script
  run_fetch_script $cid &> $LOG_FILE

  if (( $? ))
  then
    crash 1 "Cannot fetch the device configuration."
  fi

  report_status "Preparing a build..."

  if [ -n "$cmake_args" ]
  then
    report_metadata "Using extra arguments for CMake" $cmake_args
  fi

  # Running CMake to configure the project
  cmake \
    $cmake_args \
    -S. \
    -B${build_path} \
    -DCMAKE_BUILD_TYPE=DEBUG \
    -DCMAKE_TOOLCHAIN_FILE=cmake/toolchain.cmake \
    -GNinja > $LOG_FILE

  if (( $? ))
  then
    crash 1 "Configuration failed."
  fi

  report_status "Building the project..."

  if [ -n "$ninja_args" ]
  then
    report_metadata "Using extra arguments for Ninja" $ninja_args
  fi

  # Running Ninja to build the project
  ninja \
    -C $build_path > $LOG_FILE

  if (( $? ))
  then
    crash 1 "Compilation failed."
  fi

  report_finish "Finished building the project."
}