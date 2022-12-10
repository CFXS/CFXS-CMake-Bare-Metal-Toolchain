function(CFXS_SetTarget_CortexM4F)

set(CPU_OPTIONS ${CPU_OPTIONS} -mthumb -mcpu=cortex-m3 -march=armv7e-m -mtune=cortexm3 PARENT_SCOPE)
add_compile_definitions("CFXS_CORE_CORTEX_M")
add_compile_definitions("CFXS_CORE_CORTEX_M3")
add_compile_definitions("__bkpt=asm volatile(\"bkpt 0\")")

endfunction()