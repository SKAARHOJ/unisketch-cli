# unisketch-cli

Unisketch development ninja.

## Usage

#### Dependencies

- [`jinja2-cli`](https://github.com/mattrobenolt/jinja2-cli)
- [`jq`](https://stedolan.github.io/jq/)
- [`yq`](https://github.com/mikefarah/yq)
- ARM Toolchain 9, 2019, Q4 Major, must be available in `$PATH`, e.g. `arm-none-eabi-gdb`
- CMake v3.17.3, or higher, must be available in `$PATH` as `cmake`
- Ninja v1.10.1, or higher, must be available in `$PATH` as `ninja`

#### Installation

```sh
$ git clone https://github.com/SKAARHOJ/unisketch-cli.git ~/unisketch-cli && sh ~/unisketch-cli/tools/install.sh
```

## Introduction

Unisketch CLI is a set of bash-scripts that make your development experience better.
Under the hood, it utilises the power of CMake, Ninja, and some other fancy stuff,
but combines them with the power of the shell scripting.

To start working with it, simply issue `unisketch init` in your `unisketch` repository
clone. The command will create a `.unisketch.yml` file which contains your development-
specific configurations.

Here is an example of a `.unisketch.yml` file:

```yml
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
```

## Configuration

- `build.path`: Directory to put the build artifacts.
- `build.cmake.args`: Extra arguments to be provided to *CMake*.
- `build.ninja.args`: Extra arguments to be provided to *Ninja*.
- `fetch.python_interpreter`: Path to Python interpreter to run the `fetch.py` script.
- `fetch.defaults.cid`: CID to be used in the `fetch.py` script.
- `device.type`: Type of the device connected.
- `device.path`: In *\*nix* systems, path to the character device connected via USB. In *Windows*, the root COM port path.
- `device.debug_probe.path`: In *\*nix* systems, path to the character device connected via *Blackmagic Debug Probe (BDP)*. In Windows, the root COM port path.
- `logging.path`: Log file to sink the logs of underlying executables. **Optional.**