if(${CFXS_PART} STREQUAL "TM4C129ENCPDT")
    message("[CFXS] Selecting part TM4C129ENCPDT")
    set(CFXS_CORE "Cortex-M4F")
    set(CFXS_PLATFORM "TM4C")
    set(CFXS_STARTUP_PLATFORM "TM4C129X")
    add_compile_definitions("CFXS_PLATFORM_TM4C")
    add_compile_definitions("CFXS_PLATFORM_STRING=\"TM4C\"")
    add_compile_definitions("PART_TM4C129ENCPDT")
    add_compile_definitions("TARGET_IS_TM4C129_RA2")

    # ARM CMSIS
    # add_compile_definitions("__CM4_REV=0x0100U")       
    add_compile_definitions("__MPU_PRESENT=1U")
    add_compile_definitions("__NVIC_PRIO_BITS=3U")
    add_compile_definitions("__Vendor_SysTickConfig=0U")
    add_compile_definitions("__FPU_PRESENT=1U")
    add_compile_definitions("__ICACHE_PRESENT=0U")
    add_compile_definitions("__DCACHE_PRESENT=0U")
endif()