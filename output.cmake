add_custom_command(OUTPUT ${PROJECT_NAME}.bin
    DEPENDS ${PROJECT_NAME}
    COMMAND ${CMAKE_OBJCOPY} -Obinary ${PROJECT_NAME} ${PROJECT_NAME}.bin
)
add_custom_command(OUTPUT ${PROJECT_NAME}.sym
    DEPENDS ${PROJECT_NAME}
    COMMAND ${CMAKE_NM} -C -l -n -S ${PROJECT_NAME} > ${PROJECT_NAME}.sym
)

add_custom_target(bin
    DEPENDS ${PROJECT_NAME}.bin
)
add_custom_target(sym
    DEPENDS ${PROJECT_NAME}.sym
)