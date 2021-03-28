# CFXS Bare Metal Toolchain
Bare metal CMake GCC toolchain for ARM Cortex processors

# Supported Platforms
- `ARM Cortex-M`

# Usage
> Example root CMakeLists.txt file
```cmake
cmake_minimum_required(VERSION 3.15)

set(TOOLCHAIN_DIR ${PROJECT_SOURCE_DIR}/_Toolchain)

include("${TOOLCHAIN_DIR}/GCC_ARM.cmake")

project(BareMetalProject ASM C CXX)
 
add_subdirectory(BareMetalTest)
```

> Example BareMetalTest/CMakeLists.txt file
```cmake
include("${TOOLCHAIN_DIR}/Target/CortexM4F.cmake")

set(EXE_NAME BareMetalTest)

# Select linker script
set(CFXS_LINKER_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/LinkerScript.ld)

# Select target
CFXS_Target_CortexM4F()

set(sources "src/main.cpp")
set(headers "src/main.hpp")
add_executable(${EXE_NAME} ${sources} ${headers})

add_compile_options(${EXE_NAME} ${CPU_OPTIONS})
target_link_libraries(${EXE_NAME} ${CPU_OPTIONS} -o${EXE_NAME}.elf -specs=nosys.specs)
```
