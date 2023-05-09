set(CMAKE_CROSSCOMPILING TRUE)
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

SET(TARGET armv7-none-eabi)

SET(CMAKE_C_COMPILER_TARGET ${TARGET})
SET(CMAKE_C_COMPILER clang)
SET(CMAKE_CXX_COMPILER_TARGET ${TARGET})
SET(CMAKE_CXX_COMPILER clang++)
SET(CMAKE_ASM_COMPILER_TARGET ${TARGET})
SET(CMAKE_ASM_COMPILER clang)

# SET(TOOLCHAIN "C:/Program Files (x86)/Arm GNU Toolchain arm-none-eabi/12.2 mpacbti-rel1")
SET(CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN ${TOOLCHAIN})
SET(CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN ${TOOLCHAIN})

SET(SYSROOT "C:/Program Files/LLVM/lib/clang-runtimes/arm-none-eabi/armv7em_hard_fpv4_sp_d16")

# optimizations (-O0 -O1 -O2 -O3 -Os -Ofast -Og -flto)
set(C_COMMON_FLAGS
    -Werror=return-type
    -Wno-comment
    -fno-common # place uninitialized variables in .bss
    -ffunction-sections # functions in seperate sections
    -fdata-sections # data in seperate sections
    -ffreestanding # stdlib bight
    -fno-builtin # assert that compilation targets a freestanding environment-fno-threadsafe-statics     # Do not emit the extra code to use the routines specified in the C++ ABI for thread-safe initialization of local statics

    -fno-short-enums

    --sysroot="${SYSROOT}"
    -isystem="${SYSROOT}/include"

    # -fstrict-volatile-bitfields # This option should be used if accesses to volatile bit-fields (or other structure fields, although the compiler usually honors those types anyway) should use a single access of the width of the field’s type, aligned to a natural alignment if possible
)
string(REPLACE ";" " " C_COMMON_FLAGS "${C_COMMON_FLAGS}")

set(CMAKE_C_FLAGS_DEBUG "-DDEBUG            -gdwarf${CFXS_COMPILE_DWARF_VERSION} -O0       ${C_COMMON_FLAGS}")
set(CMAKE_C_FLAGS_RELEASE "-DNDEBUG -DRELEASE -gdwarf${CFXS_COMPILE_DWARF_VERSION} -Ofast       ${C_COMMON_FLAGS}")
set(CMAKE_C_FLAGS_MINSIZEREL "-DNDEBUG -DRELEASE -gdwarf${CFXS_COMPILE_DWARF_VERSION} -Os       ${C_COMMON_FLAGS}")
set(CMAKE_C_FLAGS_RELWITHDEBINFO "-DNDEBUG -DRELEASE -gdwarf${CFXS_COMPILE_DWARF_VERSION} -O2 -Og   ${C_COMMON_FLAGS}")

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(CXX_COMMON_FLAGS
    -Werror=return-type
    -Wno-comment
    -fno-common # place uninitialized variables in .bss
    -ffunction-sections # functions in seperate sections
    -fdata-sections # data in seperate sections
    -ffreestanding # stdlib bight
    -fno-builtin # assert that compilation targets a freestanding environment
    -felide-constructors # The C++ standard allows an implementation to omit creating a temporary that is only used to initialize another object of the same type. Specifying this option disables that optimization, and forces G++ to call the copy constructor in all cases
    -fno-threadsafe-statics # Do not emit the extra code to use the routines specified in the C++ ABI for thread-safe initialization of local statics

    --sysroot="${SYSROOT}"
    -isystem="${SYSROOT}/include"

    -Wno-deprecated-builtins
    -Wno-deprecated-volatile

    -fno-short-enums

    # -fstrict-volatile-bitfields # This option should be used if accesses to volatile bit-fields (or other structure fields, although the compiler usually honors those types anyway) should use a single access of the width of the field’s type, aligned to a natural alignment if possible
    -fms-extensions # Accept some non-standard constructs used in Microsoft header files. In C++ code, this allows member names in structures to be similar to previous types declarations
    -fno-use-cxa-atexit # Register destructors for objects with static storage duration with the __cxa_atexit function rather than the atexit function. This option is required for fully standards-compliant handling of static destructors
)
string(REPLACE ";" " " CXX_COMMON_FLAGS "${CXX_COMMON_FLAGS}")

set(CMAKE_CXX_FLAGS_DEBUG "-std=c++2a -DDEBUG            -gdwarf${CFXS_COMPILE_DWARF_VERSION} -O0       ${CXX_COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS_RELEASE "-std=c++2a -DNDEBUG -DRELEASE -gdwarf${CFXS_COMPILE_DWARF_VERSION} -Ofast       ${CXX_COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS_MINSIZEREL "-std=c++2a -DNDEBUG -DRELEASE -gdwarf${CFXS_COMPILE_DWARF_VERSION} -Os       ${CXX_COMMON_FLAGS}")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-std=c++2a -DNDEBUG -DRELEASE -gdwarf${CFXS_COMPILE_DWARF_VERSION} -O2 -Og   ${CXX_COMMON_FLAGS}")

set(CMAKE_C_LINK_FLAGS "-ffreestanding -nostdlib")
set(CMAKE_CXX_LINK_FLAGS "-ffreestanding -nostdlib")

add_compile_definitions("clang")

set(OBJCOPY llvm-objcopy)
set(OBJDUMP llvm-objdump)
set(SIZE llvm-size)
set(NM llvm-nm)
set(AR llvm-ar)

set(CFXS_COMPILER "CLANG")