if(${CFXS_PART} STREQUAL "STM32H7A3ZIQ")
    message("[CFXS] Selecting part STM32H7A3ZIQ")
    set(CFXS_CORE "Cortex-M7")
    set(CFXS_PLATFORM "STM32")
    set(CFXS_STARTUP_PLATFORM "STM32H7x3")
    add_compile_definitions("CFXS_PLATFORM_STM32")
    add_compile_definitions("CFXS_PLATFORM_STRING=\"STM32\"")
    add_compile_definitions("STM32H7")
    add_compile_definitions("STM32H7A3xxQ")
    add_compile_definitions("DATA_IN_D2_SRAM")

    # ARM CMSIS
    add_compile_definitions("__CM7_REV=0x0100U") # Cortex-M7 revision r1p0
    add_compile_definitions("__MPU_PRESENT=1U") # CM7 provides an MPU
    add_compile_definitions("__NVIC_PRIO_BITS=4U") # CM7 uses 4 Bits for the Priority Levels
    add_compile_definitions("__Vendor_SysTickConfig=0U") # Set to 1 if different SysTick Config is used
    add_compile_definitions("__FPU_PRESENT=1U") # FPU present
    add_compile_definitions("__ICACHE_PRESENT=1U") # CM7 instruction cache present
    add_compile_definitions("__DCACHE_PRESENT=1U") # CM7 data cache present
endif()