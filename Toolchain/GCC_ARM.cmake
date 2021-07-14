set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

set(TOOLCHAIN_PREFIX arm-none-eabi-)

set(CMAKE_ASM_COMPILER ${TOOLCHAIN_PREFIX}as CACHE STRING "" FORCE)
set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}g++ CACHE STRING "" FORCE)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}g++ CACHE STRING "" FORCE)
set(CMAKE_ASM_COMPILER_ID GNU)
set(CMAKE_C_COMPILER_ID GNU)
set(CMAKE_CXX_COMPILER_ID GNU)
set(CMAKE_ASM_COMPILER_FORCED TRUE)
set(CMAKE_C_COMPILER_FORCED TRUE)
set(CMAKE_CXX_COMPILER_FORCED TRUE)

# optimizations (-O0 -O1 -O2 -O3 -Os -Ofast -Og -flto)
set(C_COMMON_FLAGS 
    -fno-common                 # place uninitialized variables in .bss
    -ffunction-sections         # functions in seperate sections
    -fdata-sections             # data in seperate sections
    -ffreestanding              # stdlib bight
    -fno-builtin                # assert that compilation targets a freestanding environment-fno-threadsafe-statics     # Do not emit the extra code to use the routines specified in the C++ ABI for thread-safe initialization of local statics
    -fstrict-volatile-bitfields # This option should be used if accesses to volatile bit-fields (or other structure fields, although the compiler usually honors those types anyway) should use a single access of the width of the field’s type, aligned to a natural alignment if possible
)
string (REPLACE ";" " " C_COMMON_FLAGS "${C_COMMON_FLAGS}")

set(CMAKE_C_FLAGS_DEBUG          "-DDEBUG            -g3   -Og     ${C_COMMON_FLAGS}")
set(CMAKE_C_FLAGS_RELEASE        "-DNDEBUG -DRELEASE -flto -O3     ${C_COMMON_FLAGS}")
set(CMAKE_C_FLAGS_MINSIZEREL     "-DNDEBUG -DRELEASE -flto -Os     ${C_COMMON_FLAGS}")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-DNDEBUG -DRELEASE -flto -O2 -Og ${C_COMMON_FLAGS}")

set(CXX_COMMON_FLAGS 
    -fno-common                 # place uninitialized variables in .bss
    -ffunction-sections         # functions in seperate sections
    -fdata-sections             # data in seperate sections
    -ffreestanding              # stdlib bight
    -fno-builtin                # assert that compilation targets a freestanding environment
    -felide-constructors        # The C++ standard allows an implementation to omit creating a temporary that is only used to initialize another object of the same type. Specifying this option disables that optimization, and forces G++ to call the copy constructor in all cases
    -fno-threadsafe-statics     # Do not emit the extra code to use the routines specified in the C++ ABI for thread-safe initialization of local statics
    -fstrict-volatile-bitfields # This option should be used if accesses to volatile bit-fields (or other structure fields, although the compiler usually honors those types anyway) should use a single access of the width of the field’s type, aligned to a natural alignment if possible
    -fms-extensions             # Accept some non-standard constructs used in Microsoft header files. In C++ code, this allows member names in structures to be similar to previous types declarations
    -fno-use-cxa-atexit         # Register destructors for objects with static storage duration with the __cxa_atexit function rather than the atexit function. This option is required for fully standards-compliant handling of static destructors
)
string (REPLACE ";" " " CXX_COMMON_FLAGS "${CXX_COMMON_FLAGS}")

set(CMAKE_CXX_FLAGS_DEBUG          "-DDEBUG            -g3   -Og     ${CXX_COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS_RELEASE        "-DNDEBUG -DRELEASE -flto -O3     ${CXX_COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS_MINSIZEREL     "-DNDEBUG -DRELEASE -flto -Os     ${CXX_COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-DNDEBUG -DRELEASE -g3   -O3     ${CXX_COMMON_FLAGS}")

#-specs=nano.specs 
set(CMAKE_C_LINK_FLAGS   "-specs=nosys.specs -Wl,--gc-sections -nostartfiles")
set(CMAKE_CXX_LINK_FLAGS "-specs=nosys.specs -Wl,--gc-sections -nostartfiles")

set(OBJCOPY ${TOOLCHAIN_PREFIX}objcopy)
set(OBJDUMP ${TOOLCHAIN_PREFIX}objdump)
set(SIZE ${TOOLCHAIN_PREFIX}size)
set(NM ${TOOLCHAIN_PREFIX}nm)
set(AR ${TOOLCHAIN_PREFIX}ar)