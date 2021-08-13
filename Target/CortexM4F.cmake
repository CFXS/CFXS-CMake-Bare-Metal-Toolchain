function(Target_CortexM4F)

set(CPU_OPTIONS ${CPU_OPTIONS} -mthumb -mcpu=cortex-m4 -march=armv7e-m -mfpu=fpv4-sp-d16 -mfloat-abi=hard PARENT_SCOPE)
add_compile_definitions("CORE_CORTEX_M4")
add_compile_definitions("__bkpt=asm volatile(\"bkpt 0\")")

endfunction()