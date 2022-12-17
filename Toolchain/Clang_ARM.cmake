set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(CMAKE_ASM_COMPILER clang CACHE STRING "" FORCE)
set(CMAKE_C_COMPILER clang CACHE STRING "" FORCE)
set(CMAKE_CXX_COMPILER clang++ CACHE STRING "" FORCE)
set(CMAKE_ASM_COMPILER_ID Clang)
set(CMAKE_C_COMPILER_ID Clang)
set(CMAKE_CXX_COMPILER_ID Clang)
set(CMAKE_ASM_COMPILER_FORCED TRUE)
set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)

if(CMAKE_VERSION VERSION_LESS "3.6.0")
    include(CMakeForceCompiler)
    cmake_force_c_compiler(${CMAKE_C_COMPILER} Clang)
    cmake_force_cxx_compiler(${CMAKE_CXX_COMPILER} Clang)
else()
    set(CMAKE_TRY_COMPILE_TARGET_TYPE "STATIC_LIBRARY")
endif()

set(CMAKE_LINKER arm-none-eabi-ld CACHE STRING "GNU ARM linker")
set(CMAKE_AR arm-none-eabi-ar CACHE STRING "GNU ARM archiver")

execute_process(
    COMMAND arm-none-eabi-gcc -print-sysroot
    OUTPUT_VARIABLE GCC_ARM_NONE_EABI_ROOT
    OUTPUT_STRIP_TRAILING_WHITESPACE
)

get_filename_component(GCC_ARM_NONE_EABI_ROOT
    "${GCC_ARM_NONE_EABI_ROOT}"
    REALPATH
)

file(GLOB_RECURSE GCC_ARM_NONE_EABI_INCLUDE
    "${GCC_ARM_NONE_EABI_ROOT}/include/c++/*/cstddef")
    
string(REPLACE "/cstddef" "" GCC_ARM_NONE_EABI_INCLUDE
"${GCC_ARM_NONE_EABI_INCLUDE}")

set(CMAKE_FIND_ROOT_PATH ${GCC_ARM_NONE_EABI_ROOT})
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CLANG_ARM_NONE_EABI_FLAGS
    --target=armv7m-none-eabi
    --stdlib=libstdc++
    --rtlib=compiler-rt
    --gcc-toolchain=\"${GCC_ARM_NONE_EABI_ROOT}/../\"
    --sysroot=\"${GCC_ARM_NONE_EABI_ROOT}\"
    -isystem\"${GCC_ARM_NONE_EABI_INCLUDE}\"
    -isystem\"${GCC_ARM_NONE_EABI_INCLUDE}/arm-none-eabi/include\"
    -isystem\"${GCC_ARM_NONE_EABI_INCLUDE}/arm-none-eabi\"
    -isystem\"${GCC_ARM_NONE_EABI_ROOT}/include\"
    #-fshort-enums
)

string(REPLACE ";" " " CLANG_ARM_NONE_EABI_FLAGS
    "${CLANG_ARM_NONE_EABI_FLAGS}")

# optimizations (-O0 -O1 -O2 -O3 -Os -Ofast -Og -flto)
set(C_COMMON_FLAGS
    ${CLANG_ARM_NONE_EABI_FLAGS}
    -Werror=return-type
    -Wno-comment
    -fno-common                 # place uninitialized variables in .bss
    -ffunction-sections         # functions in seperate sections
    -fdata-sections             # data in seperate sections
    -ffreestanding              # stdlib bight
    -fno-builtin                # assert that compilation targets a freestanding environment-fno-threadsafe-statics     # Do not emit the extra code to use the routines specified in the C++ ABI for thread-safe initialization of local statics
    #-fstrict-volatile-bitfields # This option should be used if accesses to volatile bit-fields (or other structure fields, although the compiler usually honors those types anyway) should use a single access of the width of the field’s type, aligned to a natural alignment if possible
)
string (REPLACE ";" " " C_COMMON_FLAGS "${C_COMMON_FLAGS}")

set(CMAKE_C_FLAGS_DEBUG          "-DDEBUG            -gdwarf -Og       ${C_COMMON_FLAGS}")
set(CMAKE_C_FLAGS_RELEASE        "-DNDEBUG -DRELEASE -gdwarf -O3       ${C_COMMON_FLAGS}")
set(CMAKE_C_FLAGS_MINSIZEREL     "-DNDEBUG -DRELEASE -gdwarf -Os       ${C_COMMON_FLAGS}") 
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-DNDEBUG -DRELEASE -gdwarf -O2 -Og   ${C_COMMON_FLAGS}")

set(CXX_COMMON_FLAGS
    ${CLANG_ARM_NONE_EABI_FLAGS}
    -Werror=return-type
    -Wno-comment
    -fno-common                 # place uninitialized variables in .bss
    -ffunction-sections         # functions in seperate sections
    -fdata-sections             # data in seperate sections
    -ffreestanding              # stdlib bight
    -fno-builtin                # assert that compilation targets a freestanding environment
    -felide-constructors        # The C++ standard allows an implementation to omit creating a temporary that is only used to initialize another object of the same type. Specifying this option disables that optimization, and forces G++ to call the copy constructor in all cases
    -fno-threadsafe-statics     # Do not emit the extra code to use the routines specified in the C++ ABI for thread-safe initialization of local statics
    #-fstrict-volatile-bitfields # This option should be used if accesses to volatile bit-fields (or other structure fields, although the compiler usually honors those types anyway) should use a single access of the width of the field’s type, aligned to a natural alignment if possible
    -fms-extensions             # Accept some non-standard constructs used in Microsoft header files. In C++ code, this allows member names in structures to be similar to previous types declarations
    -fno-use-cxa-atexit         # Register destructors for objects with static storage duration with the __cxa_atexit function rather than the atexit function. This option is required for fully standards-compliant handling of static destructors
)
string (REPLACE ";" " " CXX_COMMON_FLAGS "${CXX_COMMON_FLAGS}")

set(CMAKE_CXX_FLAGS_DEBUG          "-DDEBUG            -gdwarf -Og       ${CXX_COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS_RELEASE        "-DNDEBUG -DRELEASE -gdwarf -O3       ${CXX_COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS_MINSIZEREL     "-DNDEBUG -DRELEASE -gdwarf -Os       ${CXX_COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-DNDEBUG -DRELEASE -gdwarf -O2 -Og   ${CXX_COMMON_FLAGS}")

set(CMAKE_C_LINK_FLAGS   "-v ")
set(CMAKE_CXX_LINK_FLAGS "-v ")

set(CMAKE_C_LINK_EXECUTABLE
    <CMAKE_C_COMPILER>
    <FLAGS>
    "-specs=nosys.specs -dead_strip -ffreestanding -nostartfiles"
    <CMAKE_C_LINK_FLAGS>
    <LINK_FLAGS>
    <OBJECTS>
    -o <TARGET>
    <LINK_LIBRARIES>
)

set(CMAKE_CXX_LINK_EXECUTABLE
    <CMAKE_CXX_COMPILER>
    <FLAGS>
    "-specs=nosys.specs -dead_strip -ffreestanding -nostartfiles"
    <CMAKE_CXX_LINK_FLAGS>
    <LINK_FLAGS>
    <OBJECTS>
    -o <TARGET>
    <LINK_LIBRARIES>
)

set(CMAKE_C_CREATE_STATIC_LIBRARY
    <CMAKE_AR>
    qc
    <TARGET>
    <LINK_FLAGS>
    <OBJECTS>
)

set(CMAKE_CXX_CREATE_STATIC_LIBRARY
    <CMAKE_AR>
    qc
    <TARGET>
    <LINK_FLAGS>
    <OBJECTS>
)

string(REPLACE ";" " " CMAKE_C_LINK_EXECUTABLE "${CMAKE_C_LINK_EXECUTABLE}")
string(REPLACE ";" " " CMAKE_CXX_LINK_EXECUTABLE "${CMAKE_CXX_LINK_EXECUTABLE}")
string(REPLACE ";" " " CMAKE_C_CREATE_STATIC_LIBRARY "${CMAKE_C_CREATE_STATIC_LIBRARY}")
string(REPLACE ";" " " CMAKE_CXX_CREATE_STATIC_LIBRARY "${CMAKE_CXX_CREATE_STATIC_LIBRARY}")

add_compile_definitions("gcc")
add_compile_definitions("__interrupt=__attribute__((interrupt(\"irq\")))")
add_compile_definitions("__weak=__attribute__((weak))")
add_compile_definitions("__used=__attribute__((used))")
add_compile_definitions("__noinit=__attribute__((section(\".noinit\")))")
add_compile_definitions("__vector_table=__attribute__((section(\".vector_table\"), used))")
add_compile_definitions("__naked=__attribute__((naked))")
add_compile_definitions("__noreturn=__attribute__((noreturn))")
add_compile_definitions("__noinit=__attribute__((section(\".noinit\")))")
add_compile_definitions("__memory_barrier=asm volatile(\"\" ::: \"memory\")")

set(OBJCOPY ${TOOLCHAIN_PREFIX}objcopy)
set(OBJDUMP ${TOOLCHAIN_PREFIX}objdump)
set(SIZE ${TOOLCHAIN_PREFIX}size)
set(NM ${TOOLCHAIN_PREFIX}nm)
set(AR ${TOOLCHAIN_PREFIX}ar)