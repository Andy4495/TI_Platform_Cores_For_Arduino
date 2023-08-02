# Using Arduino to Develop With Texas Instruments Processors

[![Check Markdown Links](https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/actions/workflows/CheckMarkdownLinks.yml/badge.svg)](https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/actions/workflows/CheckMarkdownLinks.yml)

The [Arduino Boards Manager][69] makes it possible to load other processor families besides the original AVR-based Arduino boards. This repo contains instructions and relevant files for loading processor cores for Texas Instruments LaunchPad products in the MSP430, MSP432, and Tiva families. This allows development for TI LaunchPads using the Arduino IDE or CLI instead of the [Energia IDE][1].

Energia was originally developed in 2012 as a fork from Arduino specifically to support Texas Instruments LaunchPads. Unfortunately, it is [no longer under active development][73], with the last version released in 2019. The good news is that the processor cores used by Energia are compatible with Arduino. This means that **Arduino can be used as a replacement for Energia**, allowing for continued software development using TI’s LaunchPad products.

## Loading a LaunchPad Board into Arduino IDE

1. Open the Arduino Preferences pane.
2. Click on the box next to the text field labeled `Additional Boards Manager URLs`.
3. Add the following URL (on a line of its own) to the list:
  `https://raw.githubusercontent.com/Andy4495/TI_Platform_Cores_For_Arduino/main/json/package_energia_optimized_index.json`
4. Click OK to close the window and OK to close the Preferences pane
5. Open `Tools->Board->Boards Manager...` menu item
6. Select the board platform you wish to install:
    - Use the search box at the top to make it easier to find the board (e.g., "MSP430")
    - Hover the mouse over the board platform you want, and click "Install"
    - It can take several minutes to install a board package
7. Once the board package is installed, you can select the board you want with the `Tools->Board` menu.

## Energia Application Libraries

The Energia IDE includes several libraries at the application level of the IDE instead of in the platform cores. This means that if you use the Arduino IDE/CLI and install an MSP or Tiva core, you don't end up getting every library that you would when using the Energia IDE. Most of the libraries included with the Energia application are either readily available as an Arduino library or are obsolete. However, two libraries in particular are specific to the platforms supported by Energia. I have created stand-alone repositories for these libraries:

- [LCD_SharpBoosterPack_SPI][25]
- [OneMsTaskTimer][26]

## More Detailed Information

The following sections contain more details on the board packages, sample GitHub action files, and the descriptions of the various files included in this repo.

### Texas Instruments Platform Cores for Arduino IDE

With the end of development of the Energia IDE, I created this repository as an archive of the key files and packages needed to develop for various Texas Instruments LaunchPads.

This repository contains tested JSON index files and hadware platform cores for the Texas Instruments MSP430, MSP432 (red), and Tiva C microcontrollers for use with the Arduino IDE or CLI. In addition, platform cores for msp432e (ethernet), cc13xx, cc3220emt, and cc3200 are also included but have not been tested.

[Platform cores][6] are used to add support for boards to the [Arduino development software][5]. The cores in this repo were originally developed for the [Energia IDE][1], which is a fork of the Arduino IDE specifically for Texas Instruments processors. Software for many TI processors can now be developed directly using the Arduino IDE once the appropriate platform core is installed.

In addition to being able to use the Arduino IDE/CLI to develop for TI processors, it is also possible to use the `compile-arduino-sketches` [GitHub action][20] to automatically verify that sketches compile whenever they are checked into GitHub. Since the action uses the Arduino CLI, all you need to do is configure the workflow to install the appropriate platform core to have the action compile for TI processors.

Because compiling a sketch does not need all the data and tools required for a full development environment, I created some slimmed-down [platform index files][7] used by Arduino to load the cores. Only boards from a related family are defined, and only the compiler for that family of boards is downloaded (no debugger or other tools are configured).

These "minimal" platform configurations should slightly speed up the run times for the compile-arduino-sketches action and may also help reduce timeout errors when running the compile-sketches action. If your GitHub action exits with the following error when running a build using the official Energial board package file, try replacing it with the corresponding "minimal" file from this repo:

```text
ERRO[0130] Error updating indexes: Error downloading index 'http://energia.nu/packages/package_energia_index.json': Get "http://energia.nu/packages/package_energia_index.json": dial tcp 107.180.20.87:80: connect: connection timed out
```

### MSP432 Support

The official Energia board package for MSP432 does not work with the Arduino IDE/CLI due to an issue with the arduino-builder. It also requires Java as part of the build process.

GitHub user [ndroid][75] created MSP432 board package version [5.29.4][74] based on 5.29.1 which no longer requires Java for building. It also updates the ARM compiler to 8.3.1 and ino2cpp to 1.0.7 and adds support for the MSP432P4111 LaunchPad.

#### Details on MSP432 Board Packages 5.29.1 and 5.29.2

The issue with the offical MSP432 board package version 5.29.0 is documented in a [thread][8] and this unmerged [pull request][61]. Since arduino-builder is now [deprecated][62], it is unlikely that this pull request will ever be merged. The main issue has to do with accessing a temporary path from within the build scripts. The Energia builder makes use of a variable called "build.project_path" which is not available with the arduino-builder. However, a global predefined property named "build.source.path" is available for use in [`platform.txt`][6] and defines the path needed for building MSP432 with Arduino.

In addition, the `ino2cpp` tool version 1.0.6 used during the MSP432 build process makes some assumptions on the availability and location of Java during the build process. This can cause issues when building locally with Arduino and when running the [compile-arduino-sketches][20] GitHub action both locally using [nektos/act][63] and on GitHub's servers. This Java dependency has been removed in version 1.0.7.

Therefore, the following changes are needed to `platform.txt` in the MSP432 board package:

- Update `recipe.hooks.sketch.prebuild.1.pattern` definition to change `{build.project_path}` to `{build.source.path}`
- Change `java.path.macosx` value to `/usr/bin/java`
- Change `build.ino2cpp.cmd.linux` value to `"/usr/bin/java"`
- Change `build.ino2cpp.cmd.windows` value to `"java"`
- Update `version` to `5.29.2`
- Update `version.string` to `5292`

I created a new MSP432 board package version 5.29.2 based off of version 5.29.0. The only differences are the above changes to the `platform.txt` file. The board manager URL reference [above](#loading-a-launchpad-board-into-arduino-ide) includes the updated MSP432 board package.

#### Extra Step Needed for Windows - No Longer Necessary

If using the latest board package for MPS432 (version 5.29.4 or later), it is no longer necessary to install Java.

When using an older MSP432 board package, then Java needs to be installed on the build machine. I have successfully tested the 5.29.2 board package with both the [Microsoft][70] and [Temurin][71] Java distributions.

#### Details on Generating a Board Package

I ran the following steps to create the new board package using MacOS:

1. Download version 5.29.0 (<https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/raw/main/boards/msp432r-5.29.0.tar.bz2>)
2. Decompress and extract files (in MacOS, this can be done by double-clicking the downloaded file)
3. Change directory into the extracted folder
4. Duplicate `platform.txt` and rename the copy to `platform_orig.txt`
5. Update `platform.txt` as noted above
6. Rename the parent folder to `msp432r-core-5.29.2`
7. Recompress the updated folder: `tar cvyf msp432r-5.29.2.tar.bz2 msp432r-core-5.29.2`
8. Calculate SHA-256 checksum: `shasum -a 256 msp432r-5.29.2.tar.bz2`
9. Note the new file's size: `ls -l msp432r-5.29.2.tar.bz2`
10. Udpate appropriate key values `url`, `archiveFileName`, `checksum`, and `size` in the package index file

### Repository Contents

#### Package Index JSON Files

Located in the [`json`][13] folder.

The Package Index file names need to follow the convention specified in the Arduino [Package Index Specification][7]. Specifically, the file name needs be of the form `package_YOURNAME_PACKAGENAME_index.json`. The prefix `package_` and suffix `_index.json` are mandatory, while the choice of `YOURNAME_PACKAGENAME` is left to the packager.

| Package Index File                          | MSP Board Version  | Tiva Board Version | Notes |
| ------------------                                      | ------ | -----              | ----- |
| `package_energia_index.json`                            | 1.0.5  | 1.0.3              | Official [board manager URL][9] version from Energia. |
| `package_Energia23_index.json`                          | 1.0.6  | 1.0.3              | Version installed by Energia23. |
| `package_energia_latest_index.json`                     | 1.0.7  | 1.0.4              | See [Note 1](#note) below. |
| `package_energia_optimized_index.json`                  | 1.0.7  | 1.0.4              | Latest version of each board only. Use as Board Manger URL. |
| `package_msp430_elf_GCC_index.json`                     |        |                    | See [Note 2](#note) below. |
| `package_energia_minimal_MSP_105_index.json`            | 1.0.5  | N/A                | MSP430 boards only and installs from this repo. |
| `package_energia_minimal_MSP_107_index.json`            | 1.0.7  | N/A                | MSP430 boards only and installs from this repo. |
| `package_energia_minimal_MSP_107_alternate_index.json`  | 1.0.7  | N/A                | MSP430 boards only, installs from this repo, compiler from Release. |
| `package_energia_minimal_TM4C_103_index.json`           | N/A    | 1.0.3              | TM4C boards only and installs from this repo. |
| `package_energia_minimal_TM4C_104_index.json`           | N/A    | 1.0.4              | TM4C boards only and installs from this repo. |
| `package_energia_minimal_TM4C_104_alternate_index.json` | N/A    | 1.0.4              | TM4C boards only, installs from this repo, compiler from Release. |
| `package_energia_development_MSP432r_index.json`        | 5.29.4 | N/A                | MSP432P401R board only, use with local Arduino IDE/CLI. |
| `package_energia_minimal_MSP432r_index.json`            | 5.29.4 | N/A                | MSP432P401R board only, installs minimal tools.  |
| `package_msp432_index.json`                             | 5.29.4 | N/A                | [MPS432 package index][74] created by [ndroid][75] |

##### Note

1. This version of the package index is [loaded][12] by Energia23 when using the Board Manager menu item in Energia. Note that the filename loaded as-is (`platform_index.json`) does not conform to the [Package Index Specification][7] naming convention. It is renamed [in this repo][17] with a valid name.
2. `package_msp430_elf_GCC_index.json` is an alternate package index file which defines 2.0.x versions of the msp430 platform. The 2.0.x vesions are not part of the official Energia application and use a much newer GCC compiler (V2.x) which supports C99. This package index file only includes definitions for msp430 and not any other platforms. This [thread][11] explains the differences and the file can be [downloaded][10] from the Energia.

#### Board Package Files

Located in the [`boards`][14] directory. These files are referenced by the package index json files.

These are copies of the board package files avaialble from Energia (with the exception of the mps432 packages as explained above).

- `msp430-1.0.5.tar.bz2`
- `msp430-1.0.6.tar.bz2`
- `msp430-1.0.7.tar.bz2`
- `msp430elf-2.0.7.tar.bz2`
- `msp430elf-2.0.10.tar.bz2`
- `msp432r-5.29.2.tar.bz2`
- `msp432-5.29.4.tar.bz2`
- `tivac-1.0.3.tar.bz2`
- `tivac-1.0.4.tar.bz2`

##### Board Platform Compiler and Tool Versions

The tools are specific to the board package platform and version.

| Board Version  | Compiler                         | dslite     | mspdebug | ino2cpp |
| -------------- | --------                         | ------     | -------- | ------- |
| MSP430 1.0.7   | msp430-gcc 4.6.6                 | 9.3.0.1863 | 0.24     | N/A     |
| MSP430 1.0.6   | msp430-gcc 4.6.6                 | 9.2.0.1793 | 0.24     | N/A     |
| MSP430 1.0.5   | msp430-gcc 4.6.6                 | 8.2.0.1400 | 0.24     | N/A     |
| MSP430 2.0.10  | msp430-elf-gcc 9.2.0.50          | 9.3.0.1863 | 0.24     | 1.0.4   |
| MSP430 2.0.7   | msp430-elf-gcc 8.3.0.16          | 9.3.0.1863 | 0.24     | 1.0.4   |
| MSP432 5.29.4  | arm-none-eabi-gcc 8.3.1-20190703 | 9.3.0.1863 | N/A      | 1.0.7   |
| MSP432 5.29.2  | arm-none-eabi-gcc 6.3.1-20170620 | 9.2.0.1793 | N/A      | 1.0.6   |
| Tiva 1.0.4     | arm-none-eabi-gcc 8.3.1-20190703 | 9.3.0.1863 | N/A      | N/A     |
| Tiva 1.0.3     | arm-none-eabi-gcc 6.3.1-20170620 | 7.2.0.2096 | N/A      | N/A     |

| Tool Download Links              |              |             |             |
| :------------------------------- | ------------ | ----------- | ----------- |
| msp430-gcc 4.6.6                 | [Wndows][30] | [MacOS][31] | [Linux][32] |
| msp430-elf-gcc 9.2.0.50          | [Wndows][55] | [MacOS][56] | [Linux][57] |
| msp430-elf-gcc 8.3.0.16          | [Wndows][58] | [MacOS][59] | [Linux][60] |
| arm-none-eabi-gcc 8.3.1-20190703 | [Wndows][33] | [MacOS][34] | [Linux][35] |
| arm-none-eabi-gcc 6.3.1-20170620 | [Wndows][36] | [MacOS][37] | [Linux][38] |
| dslite 9.3.0.1863                | [Wndows][39] | [MacOS][40] | [Linux][41] |
| dslite 9.2.0.1793                | [Wndows][42] | [MacOS][43] | [Linux][44] |
| dslite 8.2.0.1400                | [Wndows][45] | [MacOS][46] | [Linux][47] |
| dslite 7.2.0.2096                | [Wndows][48] | [MacOS][49] | [Linux][50] |
| mspdebug 0.24                    | [Wndows][51] | [MacOS][52] | [Linux][53] |
| ino2cpp 1.0.4                    | [Wndows][54] | [MacOS][54] | [Linux][54] |
| ino2cpp 1.0.6                    | [Wndows][64] | [MacOS][64] | [Linux][64] |
| ino2cpp 1.0.7                    | [Wndows][76] | [MacOS][77] | [Linux][78] |

##### Additional Board Package Files

In addition to the board package files listed above, the following board packages are included in this repo

These have not been tested:

- `cc13xx-4.9.1.tar.bz2`
- `cc3200-1.0.3.tar.bz2`
- `cc3220emt-5.6.2.tar.bz2`
- `msp432e-5.19.0.tar.bz2`

These are included for historical purposes:

- `msp432r-5.29.0.tar.bz2`
  - Used as a baseline to create verstions 5.29.1 and 5.29.2. It will not work correctly with Arduino as mentioned [above](#msp432-support).
- `msp432r-5.29.1.tar.bz2`
  - This file is has fixes for Linux and MacOS, but does not include the fix for Windows.

#### GitHub Workflow Action Definition Files

Located in the [`actions`][15] directory.

These files contain example yaml configuration files for [arduino-compile-sketches][23] actions for MSP and Tiva platforms.

You can generally use the latest version of the board package for the platform you are compiling. Configuration files for older platform versions are included in case there is a specific compatibility issue with a particular sketch or library.

[Workflow action][24] files should be placed in the `.github/workflows` directory in your repo.

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
- `compile_arduino_sketch_minimal-MSP432R.yml`
  - Compile for MSP432P401 with minimal package index file and board package 5.29.4 downloaded from this repo.
- `compile_arduino_sketch_minimal-TM4C123-103.yml`
  - Compile for TM4C123 with minimal package index file and tivac board package 1.0.3 downloaded from this repo.
- `compile_arduino_sketch_minimal-TM4C123-104.yml`
  - Compile for TM4C123 with minimal package index file and tivac board package 1.0.4 downloaded from this repo.

## References

- Energia IDE [application][1] and source code [repo][2]
- Energia MSP430 core [repo][3]
- Energia MSP432 core [repo][67]
- Energia Tiva C core [repo][4]
- Arduino [Platform Specification][6]
- Arduino instructions for [installing cores][5]
- Arduino [Package Index JSON Specification][7]
- GitHub documentation for managing GitHub Actions [workflows][22]
- Compile Arduino Sketches GitHub [action][20]
- Arduino JSON package index [file][16]
- Unofficial list of Arduino 3rd Party [Board Manager URLs][68]
- Updated MSP432 [board package repo][74] created by [ndroid][75]
- Board Manager URLs:
  - Optimized LaunchPad URL:
    - <https://raw.githubusercontent.com/Andy4495/TI_Platform_Cores_For_Arduino/main/json/package_energia_optimized_index.json>
    - Streamlined version which defines only the latest version of each platform.
    - **This the URL you would most likely use with the Arduino IDE.**
  - Standard Energia URL:
    - <https://energia.nu/packages/package_energia_index.json>
    - This is the **official** URL published by Energia, but specifies older board package versions.
    - This would only be used in specialized cases, and is mainly here for archival purposes.
  - Standard Energia URL with latest board versions:
    - <https://raw.githubusercontent.com/Andy4495/TI_Platform_Cores_For_Arduino/main/json/package_energia_latest_index.json>
    - This specifies the latest **official** board versions (along with all the older board version). The original file is available [here][12]. The above URL has the same file contents, but the name is changed to conform to the [spec][7].
  - MSP430 boards using later compiler version:
    - <http://s3.amazonaws.com/energiaUS/packages/package_msp430_elf_GCC_index.json>
    - [Thread][11] explaining why MSP430 elf compiler option is availble.
  - MSP432 board manager URL when using local Arduino IDE/CLI:
    - <https://raw.githubusercontent.com/Andy4495/TI_Platform_Cores_For_Arduino/main/json/package_energia_development_MSP432r_index.json>
    - Includes the MSP432432P401R (red) and MSPP4111 platform definitions.
  - MSP432 board manager URL when using with `compile-arduino-sketches` GitHub action:
    - <https://raw.githubusercontent.com/Andy4495/TI_Platform_Cores_For_Arduino/main/json/package_energia_minimal_MSP432r_index.json>
  - ESP8266 board manager URL:
    - <http://arduino.esp8266.com/stable/package_esp8266com_index.json>
  - Arduino board manager URL (can be useful when configuring build matrix):
    - <https://downloads.arduino.cc/packages/package_index.json>
  - STM32 board manager URL:
    - <https://github.com/stm32duino/BoardManagerFiles/raw/main/package_stmicroelectronics_index.json>
    - Note that many of the devices in this package require [additional options][72] as part of the FQBN, for example: `STMicroelectronics:stm32:GenF1:pnum=BLUEPILL_F103C8`

## License

The majority of the files in this repo are either a copy or a derivation of Energia platform cores, which are licensed under the GNU [Lesser General Public License v2.1][102] per [Energia][19]. For consistency, the non-Energia derived software and files in this repository are also released released under LGPL v2.1. See the file [`LICENSE.txt`][101] in this repository.

[1]: https://energia.nu/
[2]: https://github.com/energia/Energia
[3]: https://github.com/energia/msp430-lg-core
[4]: https://github.com/energia/tivac-core
[5]: https://docs.arduino.cc/learn/starting-guide/cores
[6]: https://arduino.github.io/arduino-cli/0.21/platform-specification/
[7]: https://arduino.github.io/arduino-cli/0.21/package_index_json-specification/
[8]: https://forum.43oh.com/topic/13361-add-msp432-support-to-arduino/
[9]: https://energia.nu/packages/package_energia_index.json
[10]: http://s3.amazonaws.com/energiaUS/packages/package_msp430_elf_GCC_index.json
[11]: https://forum.43oh.com/topic/31134-error-compiling-for-board-msp-exp430f5529lp/
[12]: https://energia.nu/packages/package_index.json
[13]: ./json
[14]: ./boards
[15]: ./actions
[16]: http://downloads.arduino.cc/packages/package_index.json
[17]: ./json/package_energia_latest_index.json
[19]: https://github.com/energia/Energia/blob/master/license.txt
[20]: https://github.com/marketplace/actions/compile-arduino-sketches
[22]: https://docs.github.com/en/actions/using-workflows
[23]: https://github.com/marketplace/actions/compile-arduino-sketches
[24]: https://docs.github.com/en/actions
[25]: https://github.com/Andy4495/LCD_SharpBoosterPack_SPI
[26]: https://github.com/Andy4495/OneMsTaskTimer
[30]: https://s3.amazonaws.com/energiaUS/tools/windows/msp430-gcc-4.6.6-i686-mingw32.tar.bz2
[31]: https://s3.amazonaws.com/energiaUS/tools/macosx/msp430-gcc-4.6.6-i386-apple-darwin11.tar.bz2
[32]: https://s3.amazonaws.com/energiaUS/tools/linux64/msp430-gcc-4.6.6-i386-x86_64-pc-linux-gnu.tar.bz2
[33]: https://s3.amazonaws.com/energiaUS/tools/windows/gcc-arm-none-eabi-8.3.1-20190703-windows.tar.bz2
[34]: https://s3.amazonaws.com/energiaUS/tools/macosx/gcc-arm-none-eabi-8.3.1-20190703-mac.tar.bz2
[35]: https://s3.amazonaws.com/energiaUS/tools/linux64/gcc-arm-none-eabi-8.3.1-20190703-x86_64-pc-linux-gnu.tar.bz2
[36]: https://s3.amazonaws.com/energiaUS/tools/windows/gcc-arm-none-eabi-6.3.1-20170620-windows.tar.bz2
[37]: https://s3.amazonaws.com/energiaUS/tools/macosx/gcc-arm-none-eabi-6.3.1-20170620-mac.tar.bz2
[38]: https://s3.amazonaws.com/energiaUS/tools/linux64/gcc-arm-none-eabi-6.3.1-20170620-x86_64-pc-linux-gnu.tar.bz2
[39]: https://s3.amazonaws.com/energiaUS/tools/windows/dslite-9.3.0.1863-i686-mingw32.tar.bz2
[40]: https://s3.amazonaws.com/energiaUS/tools/macosx/dslite-9.3.0.1863-x86_64-apple-darwin.tar.bz2
[41]: https://s3.amazonaws.com/energiaUS/tools/linux64/dslite-9.3.0.1863-i386-x86_64-pc-linux-gnu.tar.bz2
[42]: https://s3.amazonaws.com/energiaUS/tools/windows/dslite-9.2.0.1793-i686-mingw32.tar.bz2
[43]: https://s3.amazonaws.com/energiaUS/tools/macosx/dslite-9.2.0.1793-x86_64-apple-darwin.tar.bz2
[44]: https://s3.amazonaws.com/energiaUS/tools/linux64/dslite-9.2.0.1793-i386-x86_64-pc-linux-gnu.tar.bz2
[45]: https://s3.amazonaws.com/energiaUS/tools/windows/dslite-8.2.0.1400-i686-mingw32.tar.bz2
[46]: https://s3.amazonaws.com/energiaUS/tools/macosx/dslite-8.2.0.1400-x86_64-apple-darwin.tar.bz2
[47]: https://s3.amazonaws.com/energiaUS/tools/linux64/dslite-8.2.0.1400-i386-x86_64-pc-linux-gnu.tar.bz2
[48]: https://s3.amazonaws.com/energiaUS/tools/windows/dslite-7.2.0.2096-i686-mingw32.tar.bz2
[49]: https://s3.amazonaws.com/energiaUS/tools/macosx/dslite-7.2.0.2096-x86_64-apple-darwin.tar.bz2
[50]: https://s3.amazonaws.com/energiaUS/tools/linux64/dslite-7.2.0.2096-i386-x86_64-pc-linux-gnu.tar.bz2
[51]: https://s3.amazonaws.com/energiaUS/tools/windows/mspdebug-0.24-i686-mingw32.tar.bz2
[52]: https://s3.amazonaws.com/energiaUS/tools/macosx/mspdebug-0.24-x86_64-apple-darwin.tar.bz2
[53]: https://s3.amazonaws.com/energiaUS/tools/linux64/mspdebug-0.24-i386-x86_64-pc-linux-gnu.tar.bz2
[54]: https://s3.amazonaws.com/energiaUS/tools/ino2cpp-1.0.4.tar.bz2
[55]: https://s3.amazonaws.com/energiaUS/tools/windows/msp430-elf-gcc-9.2.0.50_win32.tar.bz2
[56]: https://s3.amazonaws.com/energiaUS/tools/macosx/msp430-elf-gcc-9.2.0.50_macos.tar.bz2
[57]: https://s3.amazonaws.com/energiaUS/tools/linux64/msp430-elf-gcc-9.2.0.50_linux64.tar.bz2
[58]: https://s3.amazonaws.com/energiaUS/tools/windows/msp430-elf-gcc-8.3.0.16_win32.tar.bz2
[59]: https://s3.amazonaws.com/energiaUS/tools/macosx/msp430-elf-gcc-8.3.0.16_macos.tar.bz2
[60]: https://s3.amazonaws.com/energiaUS/tools/linux64/msp430-elf-gcc-8.3.0.16_linux64.tar.bz2
[61]: https://github.com/arduino/arduino-builder/pull/119
[62]: https://github.com/arduino/arduino-builder/blob/master/README.md
[63]: https://github.com/nektos/act
[64]: https://s3.amazonaws.com/energiaUS/tools/ino2cpp-1.0.6.tar.bz2
[67]: https://github.com/energia/msp432r-core
[68]: https://github.com/arduino/Arduino/wiki/Unofficial-list-of-3rd-party-boards-support-urls
[69]: https://support.arduino.cc/hc/en-us/articles/360016119519-Add-boards-to-Arduino-IDE
[70]: https://www.microsoft.com/openjdk
[71]: https://adoptium.net
[72]: https://arduino.github.io/arduino-cli/0.26/platform-specification/#custom-board-options
[73]: https://github.com/energia/Energia#readme
[74]: https://github.com/ndroid/msp432-core/
[75]: https://github.com/ndroid
[76]: https://s3.amazonaws.com/energiaUS/tools/windows/ino2cpp-1.0.7-i686-mingw32.tar.bz2
[77]: https://s3.amazonaws.com/energiaUS/tools/macosx/ino2cpp-1.0.7-x86_64-apple-darwin.tar.bz2
[78]: https://s3.amazonaws.com/energiaUS/tools/linux64/ino2cpp-1.0.7-x86_64-pc-linux-gnu.tar.bz2
[101]: ./LICENSE.txt
[102]: https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html
[//]: # ([200]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino)

[//]: # (This is a way to hack a comment in Markdown. This will not be displayed when rendered.)
[//]: # (The board download links from energia.nu are not consistently working. Previous link for board msp432r 5.29.0 was: http://energia.nu/downloads/download_core.php?file=msp432r-5.29.0.tar.bz2 )
