project(CFXS_Toolchain)
add_library(CFXS_Toolchain INTERFACE)
target_include_directories(CFXS_Toolchain INTERFACE "${CMAKE_CURRENT_SOURCE_DIR}/include")

target_precompile_headers(
    CFXS_Toolchain
    INTERFACE
    <Compiler.hpp>
)