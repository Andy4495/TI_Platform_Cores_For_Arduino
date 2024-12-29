# Migrating to the GCC9.3 Compiler for MSP430

A new platform core, "msp430gcc9", is now available for MSP430 LaunchPads. This new core uses GCC version 9.3, which was released in 2020. It is the latest MSP430 GCC compiler published by Texas Instruments.

The existing platform core, "msp430", includes GCC version 4.6, which was released in 2012.

While many sketches and libraries will compile and run the same without any changes, there are some cases where the code needs to be updated for proper compilation and operation.

A new platform name was used so that both can be installed by the Arduino boards manager at the same time. The new compiler can be used where the newer features are needed, but the old compiler can still be readily accessed when needed for compatibility reasons.

## Features in GCC 9.3 Compared to 4.6

For a full list of changes, see the GCC [release history][gcc-releases] and C++ Standards Support [summary][gcc-standards].

Probably the most impacting changes with the new compiler is support for C++11 and C++14 by default. C++17 is supported, but is not enabled by default.

[gcc-standards]: https://gcc.gnu.org/projects/cxx-status.html
[gcc-releases]: https://gcc.gnu.org/releases.html

## Issues With Using the New Compiler

I compiled all of my libraries and sketches with the new compiler. While most compiled without issue, I ran into a few problems as listed below.

### Program Size

In all the cases that I tested, sketches compiled with GCC 9.3 were larger, both in flash and RAM usage. The amount varied from sketch to sketch, and I did not notice any particular pattern in what caused the increases.

The default compiler options for the platform selects optimization level `-Os` which optimizes for space rather than speed. So there probably aren't any compiler configuration changes that would reduce the code size.

For the sketches that went over the available flash or RAM limit, I downgraded back to the GCC 4.6 compiler.

### Integer to Text Conversion Functions

The integer to text conversion functions `itoa()`, `ltoa()`, `utoa()`, and `ultoa()` are non-standard C++ functions, but included in the MSP platform cores. The function prototypes were previously included in the GCC 4.6 `stdlib.h` header, but are not included in the GCC 9.3 headers. If your sketch or library are using these functions, you will see an error similar to the following when compiling:

```text
/Users/user1/Documents/repos/file.cpp: In member function 'bool class1::f1(uint32_t)':
/Users/user1/Documents/repos/file.cpp:119:3: error: 'ultoa' was not declared in this scope; did you mean 'utoa'?
  119 |   ultoa(i, payload, 10);
      |   ^~~~~
      |   utoa
```

To fix this, you will need to explicitly include the header file declaring these functions in any file that uses them:

```cpp
#include "itoa.h"
```

This change is backwards compatible with GCC 4.6.

### Type Conversions

There may be cases where an implicit type conversion was used by GCC 4.6, but is now flagged with an error with GCC 9.3.

One example were I saw this was with the `Serial.println()` method when passing a value of type `size_t`:

```cpp
Serial.println(strlen(cstring1));
```

Which caused the following error with GCC 9.3:

```text
error: call of overloaded 'println(size_t)' is ambiguous
```

In this case, an explicit caste to type `unsigned int` was needed:

```cpp
Serial.println((unsigned int) strlen(cstring1));
```

This change is backwards compatible with GCC 4.6.
