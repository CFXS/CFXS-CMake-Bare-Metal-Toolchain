function(CFXS_Target_CortexM4F)

set(CPU_OPTIONS ${CPU_OPTIONS} -mthumb -mcpu=cortex-m4 -march=armv7e-m -mfpu=fpv4-sp-d16 -mfloat-abi=hard PARENT_SCOPE)
if(DEFINED CFXS_LINKER_SCRIPT)
    set(CPU_OPTIONS ${CPU_OPTIONS} -T${CFXS_LINKER_SCRIPT} PARENT_SCOPE)
endif()

endfunction()