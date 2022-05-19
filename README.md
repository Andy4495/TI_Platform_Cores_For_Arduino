# Texas Instruments MSP430 and Tiva C Series Cores for Arduino IDE

[![Check Markdown Links](https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/actions/workflows/CheckMarkdownLinks.yml/badge.svg)](https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/actions/workflows/CheckMarkdownLinks.yml)

This repository contains JSON index files and hadware platform cores for the Texas Instruments MSP430 and Tiva C microcontrollers for use with the Arduino IDE or CLI.

[Platform cores][6] are used to add support for new boards to the [Arduino development software][5]. The cores in this repo were originally developed for the [Energia IDE][1], which is a fork of the Arduino IDE specifically for Texas Instruments processors. Software for many TI processors can now be developed directly using the Arduino IDE once the appropriate platform core is installed. A notable exception is MSP432, which does not work with the Arduino builder according to this [thread][8].

In addition to being able to use the Arduino IDE/CLI to develop for TI processors, it is also possible to use the `compile-arduino-sketches` [GitHub action][20] to automatically verify that sketches compile whenever they are checked into GitHub. Since the action uses the Arduino CLI, all you need to do is configure the workflow to install the appropriate platform core to have the action compile for TI processors.

Because compiling a sketch does not need all the data and tools required for a full development environment, I created some slimmed-down [platform index files][7] used by Arduino to load the cores. Just a single board is defined, and only the compiler for that board is downloaded (no debugger or other tools are configured).

These "minimal" platform configurations should slightly speed up build times for the compile-arduino-sketches action and may also help reduce timeout errors when running the compile-sketches action. I periodically receive the following error when running the workflow with an MSP or Tiva build:

```text
ERRO[0130] Error updating indexes: Error downloading index 'http://energia.nu/packages/package_energia_index.json': Get "http://energia.nu/packages/package_energia_index.json": dial tcp 107.180.20.87:80: connect: connection timed out
```

## Repository Contents

### Package Index JSON Files

Located in the `json` folder.

( <<< Add explanation on file name convention, reference Arduino spec. Consider shortening the names while still meeting the spec. >>>)

| Package Index File                    | MSP430 Board Vers | Tiva Board Vers | Notes |
| ------------------                                | ----- | -----           | ----- |
| `package_energia_index.json`                      | 1.0.5 | 1.0.3           | Available for [download][9] from [energia.nu][1] |
| `package_msp430_elf_GCC_index.json`               |       |                 | See [Note 1](#Notes) below |
| `package_Energia23_index.json`                    | 1.0.6 | 1.0.3           | Full package index JSON, as-installed by Energia23 |
| `package_E23-updated_index.json`                  | 1.0.7 | 1.0.4           | Package index file from Energia23 after updating application with latest MSP430 and Tiva board versions ??? |
| `package_energia_minimal_F5529_105_index.json`    | 1.0.5 | N/A             | Minimal index. Only defines MSP430F5529 and installs from this repo. |
| `package_energia_minimal_F5529_107_index.json`    | 1.0.7 | N/A             | Minimal index. Only defines MSP430F5529 and installs from this repo. |
| `package_energia_minimal_G2_105_index.json`       | 1.0.5 | N/A             | Minimal index. Only defines MSP430G2 and installs from this repo. |
| `package_energia_minimal_G2_107_index.json`       | 1.0.7 | N/A             | Minimal index. Only defines MSP430G2 and installs from this repo. |
| `package_energia_minimal_TM4C123_103_index.json`  | N/A   | 1.0.3           | Minimal index. Only defines TM4C123 and installs from this repo. |
| `package_energia_minimal_TM4C123_104_index.json`  | N/A   | 1.0.4           | Minimal index. Only defines TM4C123 and installs from this repo. |

#### Note

1. `package_msp430_elf_GCC_index.json` is an alternate package index file which defines 2.0.x versions of the msp430 platform. The 2.0.x vesions are not part of the official Energia application and use a much newer GCC compiler (V2.x) which supports C99. This package index file only includes definitions for msp430 and not any other platforms. This [thread][11] explains the differences and the file can be [downloaded][10] from the Energia team.

### Board Platform Versions

| Board Version | Compiler                         | dslite     | mspdebug | ino2cpp |
| ------------- | --------                         | ------     | -------- | ------- |
| MSP430 1.0.7  | msp430-gcc 4.6.6                 | 9.3.0.1863 | 0.24     | N/A     |
| MSP430 1.0.6  | msp430-gcc 4.6.6                 | 9.2.0.1793 | 0.24     | N/A     |
| MSP430 1.0.5  | msp430-gcc 4.6.6                 | 8.2.0.1400 | 0.24     | N/A     |
| MSP430 2.0.7  | msp430-elf-gcc 8.3.0.16          | 9.3.0.1863 | 0.24     | 1.0.4   |
| MSP430 2.0.10 | msp430-elf-gcc 9.2.0.50          | 9.3.0.1863 | 0.24     | 1.0.4   |
| Tiva 1.0.4    | arm-none-eabi-gcc 8.3.1-20190703 | 9.3.0.1863 | N/A      | N/A     |
| Tiva 1.0.3    | arm-none-eabi-gcc 6.3.1-20170620 | 7.2.0.2096 | N/A      | N/A     |

### Board Package Files

Located in the `boards` directory.

- `msp430-1.0.5.tar.bz2`
- `msp430-1.0.6.tar.bz2`
- `msp430-1.0.7.tar.bz2`
- `msp430elf-2.0.7.tar.bz2`
  - Uses updated GCC compiler supporting C99
- `msp430elf-2.0.10.tar.bz2`
  - Uses updated GCC compiler supporting C99
- `tivac-1.0.3.tar.bz2`
- `tivac-1.0.4.tar.bz2`

### GitHub Workflow Definition YAML Files

Located in the `actions` directory. Workflow YAML files should be placed in the `.github/workflows` directory in your repo.

- `compile_arduino_sketch_standard-MSP430-105.yml`
  - Compile for MSP430G2 using the standard Energia platform index and board packages version 1.0.5 downloaded from energia.nu
- `compile_arduino_sketch_standard-MSP430-107.yml`
  - Compile for MSP430G2 using the standard Energia platform index and board packages version 1.0.7 downloaded from energia.nu
- `compile_arduino_sketch_standard-TivaC-103.yml`
  - Compile for Tiva TM4C123 using the standard Energia platform index and board packages version 1.0.3 downloaded from energia.nu
- `compile_arduino_sketch_standard-TivaC-104.yml`
  - Compile for Tiva TM4C123 using the standard Energia platform index and board packages version 1.0.4 downloaded from energia.nu
- `compile_arduino_sketch_minimal-MSP430G2-105.yml`
  - Compile for MSP430G2 with minimal package index file and board package 1.0.5 downloaded from this repo.
- `compile_arduino_sketch_minimal-MSP430G2-107.yml`
  - Compile for MSP430G2 with minimal package index file and board package 1.0.7 downloaded from this repo.
- `compile_arduino_sketch_minimal-MSP430F5529-105.yml`
  - Compile for MSP430F5529 with minimal package index file and board package 1.0.5 downloaded from this repo.
- `compile_arduino_sketch_minimal-MSP430F5529-107.yml`
  - Compile for MSP430F5529 with minimal package index file and board package 1.0.7 downloaded from this repo.
- `compile_arduino_sketch_minimal-TM4C123-103.yml`
  - Compile for TM4C123 with minimal package index file and tivac board package 1.0.3 downloaded from this repo.
- `compile_arduino_sketch_minimal-TM4C123-104.yml`
  - Compile for TM4C123 with minimal package index file and tivac board package 1.0.4 downloaded from this repo.

## Configuring GitHub Workflows With This Repository

This repo contains more configurations that you will probably ever need. You can generally use the latest version of the board package for the platform you are compiling. The older versions are included in case there is a specific compatibility issue with a particular sketch or library.

Use one of the following YAML workflow files depending on how you want to compile your sketches:

- yaml1
- yaml2
- yaml3

## References

- Energia [IDE][1] and [repo][2]
- Energia MSP430 core [repo][3]
- Energia Tiva C core [repo][4]
- Arduino [Platform Specification][6]
- Arduino instructions for [installing cores][5]
- Arduino [Package Index JSON Specification][7]
- GitHub documentation for managing GitHub Actions [workflows][22]
- Compile Arduino Sketches GitHub [action][20]
- Additional Board Manager URLs:
  - MSP430/Tiva standard [JSON][9]
  - MSP430 elf compiler [JSON][10]
    - [Thread][11] explaining why MSP430 elf compiler option is availble.

## License

Per the Energia GitHub repo, the software in this repository are released under the GNU [Lesser General Public License v2.1][102]. See the file [`LICENSE.txt`][101] in this repository.

[1]: https://energia.nu/
[2]: https://github.com/energia/Energia
[3]: https://github.com/energia/msp430-lg-core
[4]: https://github.com/energia/tivac-core
[5]: https://docs.arduino.cc/learn/starting-guide/cores
[6]: https://arduino.github.io/arduino-cli/0.21/platform-specification/
[7]: https://arduino.github.io/arduino-cli/0.21/package_index_json-specification/
[8]: https://forum.43oh.com/topic/13361-add-msp432-support-to-arduino/
[9]: http://energia.nu/packages/package_energia_index.json
[10]: http://s3.amazonaws.com/energiaUS/packages/package_msp430_elf_GCC_index.json
[11]: https://forum.43oh.com/topic/31134-error-compiling-for-board-msp-exp430f5529lp/
[20]: https://github.com/marketplace/actions/compile-arduino-sketches
[21]: https://github.com/marketplace/actions/markdown-link-check
[22]: https://docs.github.com/en/actions/using-workflows
[100]: https://choosealicense.com/licenses/lgpl-2.1/
[101]: ./LICENSE.txt
[102]: https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html
[200]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino

[//]: # (This is a way to hack a comment in Markdown. This will not be displayed when rendered.)
