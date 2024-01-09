if(${CFXS_PART} STREQUAL "STM32G473CE")
    message("[CFXS] Selecting part STM32G473CE")
    set(CFXS_CORE "Cortex-M4F")
    set(CFXS_PLATFORM "STM32")
    set(CFXS_STARTUP_PLATFORM "STM32G4x3")
    add_compile_definitions("CFXS_PLATFORM_STM32")
    add_compile_definitions("CFXS_PLATFORM_STRING=\"STM32\"")
    add_compile_definitions("STM32G4")
    add_compile_definitions("STM32G473xx")

    # add_compile_definitions("DATA_IN_D2_SRAM")

    # ARM CMSIS
    add_compile_definitions("__CM4_REV=0x0001U") # Cortex-M4 revision r1p0
    add_compile_definitions("__MPU_PRESENT=1U") # CM4 provides an MPU
    add_compile_definitions("__NVIC_PRIO_BITS=4U") # CM4 uses 4 Bits for the Priority Levels
    add_compile_definitions("__Vendor_SysTickConfig=0U") # Set to 1 if different SysTick Config is used
    add_compile_definitions("__FPU_PRESENT=1U") # FPU present
endif()