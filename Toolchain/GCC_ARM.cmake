set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(TOOLCHAIN_PREFIX arm-none-eabi-)

set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}as CACHE STRING "" FORCE)
set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}gcc CACHE STRING "" FORCE)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++ CACHE STRING "" FORCE)
set(CMAKE_ASM_COMPILER_ID GNU)
set(CMAKE_C_COMPILER_ID GNU)
set(CMAKE_CXX_COMPILER_ID GNU)
set(CMAKE_ASM_COMPILER_FORCED TRUE)
set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)

# optimizations (-O0 -O1 -O2 -O3 -Os -Ofast -Og -flto)
set(C_COMMON_FLAGS
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

set(CMAKE_C_LINK_FLAGS   "-specs=nosys.specs -Wl,--gc-sections -ffreestanding -nostartfiles")
set(CMAKE_CXX_LINK_FLAGS "-specs=nosys.specs -Wl,--gc-sections -ffreestanding -nostartfiles")

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