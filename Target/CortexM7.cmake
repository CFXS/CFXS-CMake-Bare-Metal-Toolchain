function(CFXS_SetTarget_CortexM7F)

set(CPU_OPTIONS ${CPU_OPTIONS} -mthumb -mcpu=cortex-m7 -march=armv7e-m -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mtune=cortexm7 PARENT_SCOPE)
add_compile_definitions("CFXS_CORE_CORTEX_M")
add_compile_definitions("CFXS_CORE_CORTEX_M7")
add_compile_definitions("CFXS_CORE_HAS_FPU")
add_compile_definitions("__bkpt=asm volatile(\"bkpt 0\")")

endfunction()