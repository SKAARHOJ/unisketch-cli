source "${SRC_PATH}/reporting/colors.bash"

function print_help() {
  cat <<-EOD
  ${BOLD}Unisketch Command-Line Interface${RESET_COLOR}
  v${VERSION} (commit SHA: ${COMMIT_SHA})
  ${GIT_REPOSITORY_URL}

    unisketch help                    Display this help message.
    unisketch init                    Creates a new \`.unisketch.yml\` file on the repository
                                      folder.
    unisketch build                   Build Unisketch.
    unisketch clean                   Clean build and configuration artifacts.
    unisketch run                     Build Unisketch and run the executable on the device.
    unisketch debug                   Build Unisketch and run the executable on the device,
                                      and attach the debugger to the running process.
    unisketch attach                  Attach the debugger to the existing running process.
EOD

  if [ "$1" = "extended" ]
  then
    cat <<-EOD


    Unisketch CLI is a set of bash-scripts that make your development experience better.
    Under the hood, it utilises the power of CMake, Ninja, and some other fancy stuff,
    but combines them with the power of the shell scripting.

    To start working with it, simply issue \`unisketch init\` in your \`unisketch\` repository
    clone. The command will create a \`.unisketch.yml\` file which contains your development-
    specific configurations.

    Here is an example of a \`.unisketch.yml\` file:

        build:
          path: ./build
          cmake:
            args: ''
          ninja:
            args: ''
        fetch:
          python_interpreter: python3.7
          defaults: 
            cid: 6b8fe01b766cef024909cad0699b27d2
        device:
          type: rcpv2
          path: \\.\COM4
          debug_probe:
            path: \\.\COM3
        logging:
          path: ./.logs/output.log

EOD
  fi
}