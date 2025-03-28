# Using Arduino to Develop With Texas Instruments Processors

[![Check Markdown Links](https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/actions/workflows/check-links.yml/badge.svg)](https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/actions/workflows/check-links.yml)

**Use Arduino as a replacement for Energia** to develop on Texas Instruments LaunchPad products.

[Energia][1] was originally created in 2012 as a fork from Arduino specifically to support Texas Instruments LaunchPads. However, it is [no longer maintained][73]. The last version was released in 2019.

Fortunately, **Texas Instruments processor cores can be loaded into Arduino** using the [Arduino Boards Manager][69]. I created this repo to maintain the Energia MSP430, MSP432, and Tiva cores so that they can continue to be used with Arduino.

## Loading a LaunchPad Board into Arduino IDE

1. Open the Arduino Preferences pane
2. Click on the box next to the text field labeled `Additional Boards Manager URLs`
3. Add the following URL to the list (on a line of its own):

    ```text
    https://raw.githubusercontent.com/Andy4495/TI_Platform_Cores_For_Arduino/main/json/package_energia_optimized_index.json
    ```

4. Click OK to close the window and OK to close the Preferences pane
5. Open `Tools->Board->Boards Manager...` menu item
6. Select the board platform you wish to install:
    - Use the search box at the top to make it easier to find the board (e.g., "MSP430")
    - Hover the mouse over the board platform you want, and click "Install"
    - It can take several minutes to download and install a board package
7. Once the board package is installed, you can select the board you want with the `Tools->Board` menu

## Energia Application Libraries and Examples

Energia includes several libraries and example sketches at the application level of the IDE instead of in the platform cores. This means that if you install an MSP or Tiva core into Arduino, you don't end up getting every library and example sketch that you would when using the Energia IDE.

Most of the libraries and examples included with the Energia application are either readily available with Arduino or are obsolete. However, some are particular to the platforms supported by Energia and are not directly available with Arduino. I have published standalone libraries to allow them to be loaded into Arduino.

These libraries are included in the Arduino Library Manager registry, so they can easily be installed from the `Sketch->Include Library->Manage Libraries...` menu. Note that some of the library names needed to be shortened to meet the registry name length recommendation.

| Repository                       | Name in Arduino Library Manager | Notes                                   |
| -------------------------------- | ------------------------------- | --------------------------------------- |
| [LCD_SharpBoosterPack_SPI][25]   | LCD_SharpBP_SPI                 | Energia application library             |
| [OneMsTaskTimer][26]             | OneMsTaskTimer                  | Energia application library             |
| [Energia-EducationalBP_MKII][27] | Energia-EBP_MKII                | Example sketches packaged into library  |
| [Energia-MultiTasking][28]       | Energia-MultiTas                | Example sketches packaged into library  |

## Installing LaunchPad Drivers

Depending on your host machine and the specific board you are programming, you may need to install drivers and/or configuration files in order to communicate with the LaunchPad. If you see a message along the lines of "Error connecting to the target", then a missing driver or configuration file is likely the cause.

### MacOS

No drivers should be needed for MSP432, Tiva, or the newer MSP430 LaunchPads (including the [MSP430G2ET][210]).

The [old MSP430G2][211] (non-ET) LaunchPads work without drivers when using version 0.25 of the `mspdebug` tool, which is included with the msp430 v1.1.0 and msp430gcc9 v3.0.0 cores. Versions of `mspdebug` included with older MSP430 cores required separate drivers to be installed.

> [!NOTE]  
> While you don't need drivers, the `mspdebug` tool used to connect to the old MSP430G2 (non-ET) LaunchPads requires some libraries to be installed.

In particular, if you get a "no such file" error similar to the following:

```text
Reason: tried: '/usr/local/opt/hidapi/lib/libhidapi.0.dylib' (no such file), '/System/Volumes/Preboot/Cryptexes/OS/usr/local/opt/hidapi/lib/libhidapi.0.dylib' (no such file), '/usr/local/opt/hidapi/lib/libhidapi.0.dylib' (no such file)
```

Then you need to install the hidapi and libusb-compat libraries. I use the [Homebrew][208] tool:

```shell
brew install hidapi libusb-compat
```

### Windows

On Windows, the drivers can be installed using either of the methods below:

1. Install [Code Composer Studio IDE][89] from Texas Instruments.

    Code Composer Studio is a free professional-level IDE for Texas Instruments processors. It is fully supported and regularly updated by Texas Instruments. However, it is a large download (> 1 GB), and installs many more packages than are needed if you are just using the Arduino IDE. You are essentially installing a full IDE that you won't be using, just to get the drivers.

    Even with this in mind, **I use this method to install the drivers**, because this way I know they are up-to-date and supported.

    Also note, per TI:

    > Code Composer Studio is going through a major update. As part of this major update Code Composer Studio is transitioning from the Eclipse application framework to the much more modern Theia framework. Code Composer Studio Theia is now available for most devices and additional features are being added with each release. The final planned Eclipse-based release is expected to be CCS 12.8.

    I currently have installed the Eclipse-based version of CCS and have not tested the Theia-based version. However, I expect that the drivers installed by either version are the same.

2. Or, follow the host platform and board-specific instructions from the Energia website for [Windows][90] to install just the drivers (without the full CCS IDE).

    **The driver packages from the Energia website are no longer supported and will not be updated.** They probably still work, but do not expect any support if you run into issues with them.

### Linux

On Linux, no drivers are required for MSP430, MSP432, or Tiva LaunchPads. Just run the following steps from the Energia [Linux Install Guide page][92] to add the udev rules:

1. Download the udev rules: [TI udev rules][201]
2. Open a terminal and execute the following command:

    ```shell
    sudo mv 71-ti-permissions.rules /etc/udev/rules.d/
    ```

3. If your Linux distribution supports the service command you can activate the new rules with `sudo service udev restart`. If your board is plugged in, unplug it and plug it back in.
4. If your Linux distribution does not support the service command, or if you are still unable to upload to the LaunchPad, then restart your computer to activate the rules.

## MSP432G2 (non-ET) LaunchPads

If you are having trouble uploading to one of the [older "non-ET" versions of the MSP-EXP430G2 LaunchPads][211], try the following:

1. Disconnect and re-connect the USB plug from the LaunchPad board two or three times, and make sure to insert the plug fully for a solid connection. Since these LaunchPads are over ten years old, it is possible that some oxidation or corrosion on the either the board or USB connection is causing intermittent contact.

2. On Windows, try selecting "MSP432G2ET" in the `Tools->Board` menu. That is, choose the ET board instead of the non-ET board. The `dslite` tool used to program the newer LauchPads also works with the non-GT G2 LaunchPads on Windows (this does not work for Linux or MacOS).

## MSP430 Compiler Versions

There are two different platform cores available for MSP430 processors. The main difference between them is the compiler version:

- "Energia MSP430 boards" - Installs MSP430 boards with the old GCC 4.6 compiler
- "Energia MSP430 boards (GCCv9)" - Installs MSP430 boards with the newer GCC 9.3 compiler

The GCC 4.6 compiler is the last version officially published by Energia. GCC 4.6 was released in 2012 and does not support C++11 or C++14.

GCC 9.3 fully supports C++11 and C++14 by default. GCC9.3 is the last MSP430 GCC compiler version released by Texas Instruments.

Having two distinct platform cores allows you to have both compilers installed so that you can easily switch between them. Code which was originally compiled with GCC 4.6 may run into some compatibility issues when compiled with GCC 9.3, as outlined in this [migration README][203].

If you install both platforms, be sure to select the correct platform core and board from the `Tools->Board` menu.

Note that the MSP432 and Tiva platforms install GCC 8.3, which fully support C++11 and C++14 by default.

### GitHub Actions and Arduino Command Line

In order to select the GCC 9.3 compiler from a workflow or when using the Arduino command line directly, be sure to use the following parameters:

```text
fqbn: energia:msp430gcc9:<LaunchPad-Board-Name>
platforms.name: energia:msp430gcc9
```

## Board Packages and PlatformIO

Per GitHub user [chemmex][85], it is possible to use these processor cores with [PlatformIO][86]. Some manual setup and configuration is required, which includes editing the `platformio.ini` file. For more details, refer to this issue [comment][87] and this PlatformIO [discussion][88].

## New Board Package Versions to Remove Python 2 Dependency

Python 2 has long since reached its end of life, and recent Linux distros no longer include it (Debian 12, Ubuntu 24.04, Mint 22, etc.). Unfortunately, the version of the DSLite tool used by the Energia-created board packages has a dependency on Python 2. Attempting to upload and Arduino sketch on these newer distros will create an error similar to the following (see [issue #6][94]):

```text
/home/user/.arduino15/packages/energia/tools/dslite/9.3.0.1863/DebugServer/bin/DSLite: error while loading shared libraries: libpython2.7.so.1.0: cannot open shared object file: No such file or directory
```

I have created a new DSLite tool package using the latest version of TI's [UniFlash][99]. I have also created MSP430, MSP432, and Tiva board packages and associated board manager JSON files to reference the updated board packages and DSLite tool. The new DSLite tool and board packages continue to be compatible with Windows, MacOS, and older Linux distros, in addition to now supporting the most recent distros that no longer include Python 2.

## More Detailed Information

The following sections contain more details on the board packages, sample GitHub action files, and the descriptions of the various files included in this repo.

### Texas Instruments Platform Cores for Arduino IDE

With the end of development of the Energia IDE, I created this repository as an archive of the key files and packages needed to develop for various Texas Instruments LaunchPads.

This repository contains tested JSON index files and hadware platform cores for the Texas Instruments MSP430, MSP432, and Tiva C microcontrollers for use with the Arduino IDE or CLI. In addition, platform cores for msp432e (ethernet), cc13xx, cc3220emt, and cc3200 are also included but have not been tested.

[Platform cores][6] are used to add support for boards to the [Arduino development software][5]. The cores in this repo were originally developed for the [Energia IDE][1], which is a fork of the Arduino IDE specifically for Texas Instruments processors. Software for many TI processors can now be developed directly using the Arduino IDE once the appropriate platform core is installed.

### Using the TI Cores with GitHub Actions

In addition to being able to use the Arduino IDE/CLI to develop for TI processors, it is also possible to use the `compile-arduino-sketches` [GitHub action][20] to automatically verify that sketches compile whenever they are checked into GitHub. Since the action uses the Arduino CLI, all you need to do is configure the workflow to install the appropriate platform core to have the action compile for TI processors.

Because compiling a sketch does not need all the data and tools required for a full development environment, I created some [slimmed-down platform index files][13] used by Arduino to load the cores. Only boards from a related family are defined, and only the compiler for that family of boards is downloaded (no debugger or other tools are configured).

If your GitHub action exits with a timeout error similar to this:

```text
ERRO[0130] Error updating indexes: Error downloading index 'http://energia.nu/packages/package_energia_index.json': 
Get "http://energia.nu/packages/package_energia_index.json": 
dial tcp 107.180.20.87:80: connect: connection timed out
```

Then try replacing the index file with the corresponding ["minimal" file][13] from this repo. The "minimal" platform configurations should speed up the run times and reduce timeout errors when running the `compile-arduino-sketches` action.

### MSP432 Support

GitHub user [ndroid][75] has created updated [MSP432 board packages][74] based on the Energia version 5.29.1 board package. These updated packages add support for the MSP432P4111 LaunchPad and fix several issues with the board package as described in the [change log][79].

Later versions of Energia include support for multi-tasking for MSP432 boards based on [TI-RTOS][82]. The MSP432 board package for Arduino continues to support multi-tasking, which can be accessed by using the methods demonstrated in the [Energia-MultiTasking][28] examples or through the [Galaxia library][83] created by [Rei Vilo][84].

#### Details on MSP432 Board Packages 5.29.1 and 5.29.2 Created by Andy4495

*This section is provided to document the creation of updated MSP432 board packages that turned out to be unnecessary.*

At the time I created this repo, the latest Energia-supplied board package for MSP432 that I could find was version 5.29.0. That version (and all earlier versions) has an issue that made it incompatible with the Arduino build tools, as documented in this [thread][908] ([archived version][8]) and this unmerged [pull request][61]. The issue has to do with accessing a temporary path from within the build scripts. The Energia builder makes use of a variable called "build.project_path" which is not available with the arduino-builder. However, a global predefined property named "build.source.path" is available for use in [`platform.txt`][6] and defines the path needed for building MSP432 with Arduino.

In addition, the `ino2cpp` tool version 1.0.6 used during the MSP432 build process makes some assumptions on the availability and location of Java during the build process. This can cause issues when building locally with Arduino and when running the [compile-arduino-sketches][20] GitHub action both locally using [nektos/act][63] and on GitHub's servers.

So I created new MSP432 board package versions 5.29.1 and 5.29.2 based off of version 5.29.0. The only differences are changes to the `platform.txt` file as listed below. Version 5.29.1 fixes the Java issue for MacOS and Linux, and version 5.29.2 also adds a fix for Windows.

- Update `recipe.hooks.sketch.prebuild.1.pattern` definition to change `{build.project_path}` to `{build.source.path}`
- Change `java.path.macosx` value to `/usr/bin/java`
- Change `build.ino2cpp.cmd.linux` value to `"/usr/bin/java"`
- Change `build.ino2cpp.cmd.windows` value to `"java"` (5.29.2 only)
- Update `version` to `5.29.2`
- Update `version.string` to `5292`

As it turns out, an Energia-supplied board package version 5.29.1 is available that fixes the Arduino build issue and removes the Java dependency (by using `ino2cpp` version 1.0.7).

Because I was unaware of the Energia MSP432 version 5.29.1, there are two MSP432 board packages archived in this repo with a version 5.29.1: I added suffixes to the filenames to differentiate them.

##### Extra Step Needed for Windows - No Longer Necessary

If using the latest board package for MPS432 (version 5.29.4 or later), it is not necessary to install Java.

When using an older MSP432 board package, then Java needs to be installed on the build machine. I have successfully tested the 5.29.2 board package with both the [Microsoft][970] and [Temurin][71] Java distributions.

##### Details on Generating a Board Package

I ran the following steps to create the new board package using MacOS:

1. Download version 5.29.0 (<https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/raw/main/boards/msp432r-5.29.0.tar.bz2>)
2. Decompress and extract files (in MacOS, this can be done by double-clicking the downloaded file)
3. Change directory into the extracted folder
4. Duplicate `platform.txt` and rename the copy to `platform_orig.txt`
5. Update `platform.txt` as noted above
6. Rename the parent folder to `msp432r-core-5.29.2`
7. Recompress the updated folder: `tar cvjf msp432r-5.29.2.tar.bz2 msp432r-core-5.29.2`
8. Calculate SHA-256 checksum: `shasum -a 256 msp432r-5.29.2.tar.bz2`
9. Note the new file's size: `ls -l msp432r-5.29.2.tar.bz2`
10. Udpate appropriate key values `url`, `archiveFileName`, `checksum`, and `size` in the package index file

### mspdebug Tool

The [`mspdebug`][207] tool is used to upload code to MSP430G2 (non-ET) and FR5739 LaunchPads. The latest version supplied by Energia is 0.24, but this version has issues with later versions of MacOS.

I compiled version 0.25 for MacOS, and tested it on MacOS 15 Sequoia. The board packages for msp430 v1.1.0 and msp430gcc9 v3.0.0 now install `mspdebug` version 0.25 on MacOS systems. Note that if you previously installed msp430 v1.1.0, you will need to un-install and re-install it to get the new version of `mspdebug`.

#### Steps to Compile `mspdebug` on MacOS

- Download and extract the mspdebug code from GitHub using the [v0.25 tag][209]
- Install the [homebrew][208] package manager if you don't already have it
- Install the following packages:

  ```shell
  brew install hidapi libusb-compat pkgconf
  ```

- Build the executable

  ```shell
  make
  ```

- Confirm the version number (should be 0.25):

  ```shell
  ./mspdebug --version
  ```

#### Running `mspdebug` on MacOS

Version 0.25 of `mspdebug` requires libraries to be installed in order to run the tool:

```shell
brew install hidapi libusb-compat
```

### Repository Contents

#### Package Index JSON Files (`json` Folder)

##### Package index file to use as Arduino Board Manager URL

Use this URL in the *Additional Boards Manager URLs* field: `https://raw.githubusercontent.com/Andy4495/TI_Platform_Cores_For_Arduino/main/json/package_energia_optimized_index.json`

| File Name                              | MSP430 (GCC 4.6) | MSP430 (GCC 9.3) | MSP432 | Tiva  | Notes |
| ------------------                     | ------           | -----            | -----  | ----- | ----- |
| `package_energia_optimized_index.json` | 1.1.0            | 3.0.0            | 5.30.0 | 1.1.0 | Recommended for Arduino IDE. |

##### Package index files to use with GitHub Actions

These files include a single platform version and only the tools needed for compilation. This shortens the time needed to run an action, since only the files needed for compilation are installed in the action runner. Use the URL `https://raw.githubusercontent.com/Andy4495/TI_Platform_Cores_For_Aduino/main/json/File-Name` in the `source-url` field.

| File Name                                   | MSP430 Version  | MSP432 Version | Tiva Version | Notes |
| ------------------                          | ------          | -----          | -----        | ----- |
| `package_energia_minimal_msp430_index.json` | 1.1.0 and 3.0.0 | N/A            | N/A          | MSP430 boards only. |
| `package_energia_minimal_msp432_index.json` | N/A             | 5.30.0         | N/A          | MSP432 boards only. |
| `package_energia_minimal_tiva_index.json`   | N/A             | N/A            | 1.1.0        | Tiva boards only.   |

##### Package index files kept for historical reference or specialized applications

| File Name                                   | MSP430 Version  | MSP432 Version | Tiva Version | Notes |
| ------------------                          | ------          | -----          | -----        | ----- |
| `package_energia_index.json`                | 1.0.5           | 5.23.1         | 1.0.3        | Last official board manager URL published by Energia. |
| `package_Energia23_index.json`              | 1.0.6           | 5.25.2         | 1.0.3        | Version installed by Energia23. |
| `package_energia_latest_index.json`         | 1.0.7           | 5.29.0         | 1.0.4        | See [Note 1](#note) below. |
| `package_msp430_elf_GCC_index.json`         | 2.0.10          | N/A            | N/A          | See [Note 2](#note) below. |
| `package_msp432_index.json`                 | N/A             | 5.29.5         | N/A          | [MPS432 package index][74] created by [ndroid][75]. |

##### Note

1. This version of the package index is [loaded][12] by Energia23 when using the Board Manager menu item in Energia. Note that the filename from the Energia repo (`platform_index.json`) does not conform to the [Package Index Specification][7] naming convention. Specifically, the file name needs be of the form `package_YOURNAME_PACKAGENAME_index.json`. The prefix `package_` and suffix `_index.json` are mandatory, while the choice of `YOURNAME_PACKAGENAME` is left to the packager. The file has been renamed [in this repo][17] with a valid name.
2. `package_msp430_elf_GCC_index.json` is an alternate package index file which defines 2.0.x versions of the msp430 platform. The 2.0.x vesions are not part of the official Energia application and use a much newer GCC compiler (v8.3). This package index file only includes definitions for msp430 and not any other platforms. This [thread][911] ([archived version][11]) explains the differences and the file can be [downloaded][100] from this repo or [directly from the Energia][10]. **Now that GCC 9.3 is included in the standard platform index file, there would normally not be a reason to use this file any more.**

#### Board Package Files

Located in the [`boards`][14] directory. These files are referenced by the package index json files.

These are copies of the board package files avaialble from Energia (except as noted).

- `msp430-1.0.5.tar.bz2`
- `msp430-1.0.6.tar.bz2`
- `msp430-1.0.7.tar.bz2`
- `msp430-1.1.0.tar.bz2`  (Updated from 1.0.7 by me to use dslite 12.8.0.3522)
- `msp430-3.0.0.tar.bz2`  (Updated from msps430elf 2.0.10 by me to add GCC 9.3 compiler support)
- `msp430elf-2.0.7.tar.bz2`
- `msp430elf-2.0.10.tar.bz2`
- `msp432r-5.29.2.tar.bz2`
- `msp432-5.29.5.tar.bz2` (Created by GitHub user [ndroid][75])
- `msp432-5.30.0.tar.bz2` (Updated from 5.29.5 by me to use dslite 12.8.0.3522)
- `tivac-1.0.3.tar.bz2`
- `tivac-1.0.4.tar.bz2`
- `tivac-1.1.0.tar.bz2`  (Updated from 1.0.4 by me to use dslite 12.8.0.3522)

##### Board Platform Compiler and Tool Versions

The tools are specific to the board package platform and version.

| Board Version  | Compiler                         | dslite      | mspdebug | ino2cpp |
| -------------- | --------                         | ------      | -------- | ------- |
| MSP430 3.0.0   | msp430-elf-gcc 9.3.1.11          | 12.8.0.3352 | 0.25     | N/A     |
| MSP430 1.1.0   | msp430-gcc 4.6.6                 | 12.8.0.3522 | 0.25     | N/A     |
| MSP430 1.0.7   | msp430-gcc 4.6.6                 |  9.3.0.1863 | 0.24     | N/A     |
| MSP430 1.0.6   | msp430-gcc 4.6.6                 |  9.2.0.1793 | 0.24     | N/A     |
| MSP430 1.0.5   | msp430-gcc 4.6.6                 |  8.2.0.1400 | 0.24     | N/A     |
| MSP430 2.0.10  | msp430-elf-gcc 9.2.0.50          |  9.3.0.1863 | 0.24     | 1.0.4   |
| MSP430 2.0.7   | msp430-elf-gcc 8.3.0.16          |  9.3.0.1863 | 0.24     | 1.0.4   |
| MSP432 5.30.0  | arm-none-eabi-gcc 8.3.1-20190703 | 12.8.0.3522 | N/A      | 1.0.7   |
| MSP432 5.29.5  | arm-none-eabi-gcc 8.3.1-20190703 |  9.3.0.1863 | N/A      | 1.0.7   |
| MSP432 5.29.2  | arm-none-eabi-gcc 6.3.1-20170620 |  9.2.0.1793 | N/A      | 1.0.6   |
| Tiva 1.1.0     | arm-none-eabi-gcc 8.3.1-20190703 | 12.8.0.3522 | N/A      | N/A     |
| Tiva 1.0.4     | arm-none-eabi-gcc 8.3.1-20190703 |  9.3.0.1863 | N/A      | N/A     |
| Tiva 1.0.3     | arm-none-eabi-gcc 6.3.1-20170620 |  7.2.0.2096 | N/A      | N/A     |

| Tool Download Links              |              |              |             |
| :------------------------------- | ------------ | ------------ | ----------- |
| msp430-gcc 4.6.6                 | [Wndows][30] | [MacOS][31]  | [Linux][32] |
| msp430-elf-gcc 8.3.0.16          | [Wndows][58] | [MacOS][59]  | [Linux][60] |
| msp430-elf-gcc 9.2.0.50          | [Wndows][55] | [MacOS][56]  | [Linux][57] |
| msp430-elf-gcc 9.3.1.1           | [Wndows][204]| [MacOS][205] | [Linux][206]|
| arm-none-eabi-gcc 8.3.1-20190703 | [Wndows][33] | [MacOS][34]  | [Linux][35] |
| arm-none-eabi-gcc 6.3.1-20170620 | [Wndows][36] | [MacOS][37]  | [Linux][38] |
| dslite 12.8.0.3522               | [Wndows][96] | [MacOS][97]  | [Linux][98] |
| dslite 9.3.0.1863                | [Wndows][39] | [MacOS][40]  | [Linux][41] |
| dslite 9.2.0.1793                | [Wndows][42] | [MacOS][43]  | [Linux][44] |
| dslite 8.2.0.1400                | [Wndows][45] | [MacOS][46]  | [Linux][47] |
| dslite 7.2.0.2096                | [Wndows][48] | [MacOS][49]  | [Linux][50] |
| mspdebug 0.24                    | [Wndows][51] | [MacOS][52]  | [Linux][53] |
| mspdebug 0.25 (see Note below)   | [Wndows][51] | [MacOS][213] | [Linux][53] |
| ino2cpp 1.0.4                    | [Wndows][54] | [MacOS][54]  | [Linux][54] |
| ino2cpp 1.0.6                    | [Wndows][64] | [MacOS][64]  | [Linux][64] |
| ino2cpp 1.0.7                    | [Wndows][76] | [MacOS][77]  | [Linux][78] |

Note that mspdebug 0.25 was only created for MacOS; the Linux and Windows download links point to version 0.24.

##### Additional Board Package Files

In addition to the board package files listed above, the following untested board packages are included in this repo:

- `cc13xx-4.9.1.tar.bz2`
- `cc3200-1.0.3.tar.bz2`
- `cc3220emt-5.6.2.tar.bz2`
- `msp432e-5.19.0.tar.bz2`

And these are included for historical purposes:

- `msp432r-5.29.0.tar.bz2`
  - Used as a baseline to create verstions 5.29.1 and 5.29.2. It will not work correctly with Arduino as mentioned [above](#msp432-support).
- `msp432r-5.29.1-Andy4495_version.tar.bz2`
  - Package inadvertently created to fix a build issue - see [MSP432 Support](#msp432-support) above. Note that this has the same version number as a board package provided by Energia, and has "`Andy4495_version`" added to the file name.
- `msp432r-5.29.1-Energia_version.tar.bz2`
  - Version provided by Energia, and is differentiated from the other 5.29.1 package with `Energia_version` added to the file name.

#### Compile Sketches Using GitHub Workflows

The files in the [`actions`][15] directory contain examples for [arduino-compile-sketches][23] GitHub [actions][24] for MSP and Tiva platforms.

- `compile_arduino_sketch-MSP430F5529-GCC9.yml`
- `compile_arduino_sketch-MSP430G2.yml`
- `compile_arduino_sketch-MSP430F5529.yml`
- `compile_arduino_sketch-MSP432P401R.yml`
- `compile_arduino_sketch-TM4C123.yml`

## References

- Energia IDE [application][1] and source code [repo][2]
- Website [source pages repo][93] for energia.nu
- Energia MSP430 platform core [repo][3]
  - Information on [migrating from GCC 4.6 to GCC 9.3][203]
  - GCC [release history][gcc-releases]
  - GCC [standards support][gcc-standards]
  - Texas Instruments [MSP430 GCC compiler][212]
- Energia MSP432 platform core [repo][67]
- Energia Tiva C platform core [repo][4]
- Arduino instructions for [installing cores][5]
- GitHub documentation for managing GitHub Actions [workflows][22]
- Compile Arduino Sketches GitHub [action][20]
- Updated MSP432 [board package repo][74] created by [ndroid][75]
- [Galaxia multi-tasking library][83] created by [Rei Vilo][84]
- Info on using Arduino cores with [PlatformIO][86]: [here][87] and [here][88]
- Arduino JSON package index [file][16]
- Arduino [Platform Specification][6]
- Arduino [Package Index JSON Specification][7]
- Board Manager URLs:
  - Optimized Texas Instruments LaunchPad URL. Streamlined file including all the LaunchPad board platforms and tools, including updates after Energia ended support. **Use this URL with the Arduino IDE**:

    ```text
    https://raw.githubusercontent.com/Andy4495/TI_Platform_Cores_For_Arduino/main/json/package_energia_optimized_index.json
    ```

  - ESP8266 board manager URL:
    - <http://arduino.esp8266.com/stable/package_esp8266com_index.json>
  - Arduino board manager URL (can be useful when configuring build matrix in an action):
    - <https://downloads.arduino.cc/packages/package_index.json>
  - STM32 board manager URL:
    - <https://github.com/stm32duino/BoardManagerFiles/raw/main/package_stmicroelectronics_index.json>
    - Note that many of the devices in this package require [additional options][72] as part of the FQBN, for example: `STMicroelectronics:stm32:GenF1:pnum=BLUEPILL_F103C8`
  - Unofficial list of Arduino 3rd Party [Board Manager URLs][68]

## License

The DSLite tool is licensed per the Texas Instruments [Uniflash License][95]. DSLite is available for download in the Assets area on the [Releases page][202].

GCC is distributed per the [GNU General Public License v3][103].

[`mspdebug`][207] is Copyright (C) Daniel Beer and distributed per [GNU General Public License v2][104].

The majority of the remaining files in this repo are either a copy or a derivation of Energia platform cores, which are licensed under the GNU [Lesser General Public License v2.1][102] per [Energia][19].

The other non-Energia derived software and files in this repository are also released released under LGPL v2.1.

See the file [`LICENSE.txt`][101] in this repository.

[1]: https://energia.nu/
[2]: https://github.com/energia/Energia
[3]: https://github.com/energia/msp430-lg-core
[4]: https://github.com/energia/tivac-core
[5]: https://docs.arduino.cc/learn/starting-guide/cores
[6]: https://arduino.github.io/arduino-cli/0.21/platform-specification/
[7]: https://arduino.github.io/arduino-cli/0.21/package_index_json-specification/
[8]: ./extras/43oh-MSP432_support.pdf
[10]: http://s3.amazonaws.com/energiaUS/packages/package_msp430_elf_GCC_index.json
[11]: ./extras/43oh-GCC_C99.pdf
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
[27]: https://github.com/Andy4495/Energia-EducationalBP_MKII
[28]: https://github.com/Andy4495/Energia-MultiTasking
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
[63]: https://github.com/nektos/act
[64]: https://s3.amazonaws.com/energiaUS/tools/ino2cpp-1.0.6.tar.bz2
[67]: https://github.com/energia/msp432r-core
[68]: https://github.com/arduino/Arduino/wiki/Unofficial-list-of-3rd-party-boards-support-urls
[69]: https://support.arduino.cc/hc/en-us/articles/360016119519-Add-boards-to-Arduino-IDE
[71]: https://adoptium.net
[72]: https://arduino.github.io/arduino-cli/0.26/platform-specification/#custom-board-options
[73]: https://github.com/energia/Energia#readme
[74]: https://github.com/ndroid/msp432-core/
[75]: https://github.com/ndroid
[76]: https://s3.amazonaws.com/energiaUS/tools/windows/ino2cpp-1.0.7-i686-mingw32.tar.bz2
[77]: https://s3.amazonaws.com/energiaUS/tools/macosx/ino2cpp-1.0.7-x86_64-apple-darwin.tar.bz2
[78]: https://s3.amazonaws.com/energiaUS/tools/linux64/ino2cpp-1.0.7-x86_64-pc-linux-gnu.tar.bz2
[79]: https://github.com/ndroid/msp432-core/tree/main#change-log
[82]: https://www.ti.com/tool/TI-RTOS-MCU
[83]: https://github.com/rei-vilo/Galaxia_Library
[84]: https://github.com/rei-vilo/
[85]: https://github.com/chemmex
[86]: https://platformio.org
[87]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/issues/3#issuecomment-1687530096
[88]: https://community.platformio.org/t/using-different-toolchain-versions/22787
[89]: https://www.ti.com/tool/CCSTUDIO#downloads
[90]: https://energia.nu/guide/install/windows/
[//]: # ( [91]: https://energia.nu/guide/install/macos/ )
[92]: https://energia.nu/guide/install/linux/
[93]: https://github.com/energia/energia.nu
[94]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/issues/6
[95]: ./Uniflash_manifest_and_license.html
[96]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/releases/download/v1.2.0/dslite-12.8.0.3522-i686-mingw32.tar.bz2
[97]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/releases/download/v1.2.0/dslite-12.8.0.3522-x86_64-apple-darwin.zip
[98]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/releases/download/v1.2.0/dslite-12.8.0.3522-i386-x86_64-pc-linux-gnu.tar.bz2
[99]: https://www.ti.com/tool/UNIFLASH
[100]: https://raw.githubusercontent.com/Andy4495/TI_Platform_Cores_For_Arduino/refs/heads/main/json/package_msp430_elf_GCC_index.json
[101]: ./LICENSE.txt
[102]: https://www.gnu.org/licenses/old-licenses/lgpl-2.1.html
[103]: https://www.gnu.org/licenses/gpl-3.0.html#license-text
[104]: https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt
[201]: ./extras/71-ti-permissions.rules
[202]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/releases/tag/v1.2.0
[203]: ./README-Migrating_from_GCC_4_to_9.md
[204]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/releases/download/v1.3.0/msp430-gcc-9.3.1.11_win64.zip
[205]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/releases/download/v1.3.0/msp430-elf-gcc-9.3.1.11_macos.tar.bz2
[206]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/releases/download/v1.3.0/msp430-elf-gcc-9.3.1.11_linux64.tar.bz2
[207]: https://github.com/dlbeer/mspdebug
[208]: https://brew.sh
[209]: https://github.com/dlbeer/mspdebug/releases/tag/v0.25
[210]: https://www.ti.com/tool/MSP-EXP430G2ET
[211]: https://embeddedcomputing.weebly.com/launchpad-msp430g2.html
[212]: https://www.ti.com/tool/MSP430-GCC-OPENSOURCE
[213]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino/releases/download/v1.3.0/mspdebug-0.25-x86_64-apple-darwin.tar.bz2
[908]: https://forum.43oh.com/topic/13361-add-msp432-support-to-arduino/
[911]: https://forum.43oh.com/topic/31134-error-compiling-for-board-msp-exp430f5529lp/
[970]: https://www.microsoft.com/openjdk
[gcc-standards]: https://gcc.gnu.org/projects/cxx-status.html
[gcc-releases]: https://gcc.gnu.org/releases.html
[//]: # ([200]: https://github.com/Andy4495/TI_Platform_Cores_For_Arduino)
[//]: # ([62]: https://github.com/arduino/arduino-builder/blob/master/README.md)
[//]: # ([9]: https://energia.nu/packages/package_energia_index.json)
[//]: # ([80]: https://www.arduino.cc/en/software)
[//]: # ([81]: https://arduino.github.io/arduino-cli/)

[//]: # (This is a way to hack a comment in Markdown. This will not be displayed when rendered.)
[//]: # (The board download links from energia.nu are not consistently working. Previous link for board msp432r 5.29.0 was: http://energia.nu/downloads/download_core.php?file=msp432r-5.29.0.tar.bz2 )
