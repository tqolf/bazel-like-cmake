# bazel-like-cmake

`CC.cmake` provides bazel like `cc_library` `cc_binary` `cc_test` commands.

## Quickstart

``` bash
sudo apt-get install cmake libgtest-dev libboost-all-dev

git clone git@github.com:tqolf/bazel-like-cmake.git

cd bazel-like-cmake && mkdir build && cd build

cmake .. && make -j`nproc` && make test
```

## How to use

- Example:
  ```cmake
  cc_libray(
      mylib
      SOURCES **.cc
      HEADERS **.h *.hpp
      INCLUDES include/
      OPTIONS -Wall -O3
      LINK_OPTIONS -pthread
      DEPENDENCIES folly /path/to/lib.a
  )

  cc_test(
    mytest
    SOURCES **.cc
    DEPENDENCIES mylib Boost:system,unit_test_framework
  )
  ```

- General arguments
  ```markdown
  target name, it will be installed to `<CMAKE_INSTALL_PREFIX>/lib/`
    For library, both shared and static libraries will be built and installed defautly. shared only if set SHARED to ON, OFF for static only library.

  INCLUDES: Include Directories, all will be installed to `<CMAKE_INSTALL_PREFIX>/include/`

  HEADERS/SOURCES:
    - Recursive: /path/to/(**.h, **.cc)
    - Non-recursive: /path/to/(*.h, *.cc)
    - Relative/Absolute: /path/to/(xx.h, xx.cc)

  OPTIONS: Compile Options

  LINK_OPTIONS: Link Options

  DEPENDENCIES: Dependencies of this target, formats supported:
    - single package or target: pthread, your_cmake_target
    - path to precompiled library: /path/to/compied_library
    - single package can be found vai find_package: Boost::system
    - multiple package can be found vai find_package: Boost::system,filesystem

  SANITIZE_OPTIONS: Sanitize Options
    - DEB: Enables debugging information for source-level troubleshooting with debuggers
    - CFI: Ensures control flow integrity to prevent function pointer or vtable hijacking
    - GCOV: Provides test coverage analysis by generating statistics on tested code
    - FUZZ: Uses random input generation to detect vulnerabilities or crashes
    - MSAN: Detects uninitialized memory reads
    - ASAN: Identifies memory errors like buffer overflows and use-after-free
    - TSAN: Detects data races in multithreaded programs
    - UBSAN: Identifies undefined behavior such as integer overflow or invalid type casts

  For more arguments, you can refer comments in CC.cmake.
  ```

- Package manager
  cc_import, it's googd choice than [CPM.cmake](https://github.com/cpm-cmake/CPM.cmake.git) which cann't support neither local package nor non-cmake package
