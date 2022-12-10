include(Target/CortexM3.cmake)
include(Target/CortexM4.cmake)
include(Target/CortexM4F.cmake)
include(Target/CortexM7.cmake)

message("CFXS: Set core to ${CFXS_CORE}")
if(${CFXS_CORE} strequal "Cortex-M3")
    CFXS_SetTarget_CortexM3(${CFXS_COMPONENT_NAME})
elseif(${CFXS_CORE} strequal "Cortex-M4")
    CFXS_SetTarget_CortexM4(${CFXS_COMPONENT_NAME})
elseif(${CFXS_CORE} strequal "Cortex-M4F")
    CFXS_SetTarget_CortexM4F(${CFXS_COMPONENT_NAME})
elseif(${CFXS_CORE} strequal "Cortex-M7")
    CFXS_SetTarget_CortexM7(${CFXS_COMPONENT_NAME})
else()
    message(FATAL_ERROR "Unknown CFXS_CORE: [${CFXS_CORE}]")
endif()