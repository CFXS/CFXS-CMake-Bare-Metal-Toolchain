return {
    Sections = {
        -- FLASH
        {
            name = "vector_table",
            location = "FLASH",
            target = "FLASH",
            content = {
                Define("__VECTOR_TABLE_START__"),
                Place({ align = 4, nodiscard = true }, ".vector_table"),
                Define("__VECTOR_TABLE_END__"),
            }
        },
        {
            name = "text",
            location = "FLASH",
            target = "FLASH",
            content = {
                Define("__TEXT_START__"),
                Place({ align = 4 }, ".text", ".text*", ".gnu.linkonce.t.*"),
                Place({ align = 4 }, ".glue_7", ".glue_7t"),
                Place({ align = 4, nodiscard = true }, ".init", ".fini"),
                Define("__TEXT_END__"),
            }
        },
        {
            name = "rodata",
            location = "FLASH",
            target = "FLASH",
            content = {
                Define("__RODATA_START__"),
                Place({ align = 4 }, ".rodata", ".rodata*", ".gnu.linkonce.r.*"),
                Define("__RODATA_END__"),
            }
        },
        {
            name = "ARM.extab",
            location = "FLASH",
            target = "FLASH",
            content = {
                Place({ align = 4 }, ".ARM.extab*", ".gnu.linkonce.armextab.*"),
            }
        },
        {
            name = "ARM",
            location = "FLASH",
            target = "FLASH",
            content = {
                DefineHidden("__exidx_start"),
                Place({ align = 4 }, ".ARM.exidx*", ".gnu.linkonce.armexidx.*"),
                DefineHidden("__exidx_end"),
            }
        },
        {
            name = "preinit_array",
            location = "FLASH",
            target = "FLASH",
            content = {
                Define("__PREINIT_ARRAY_START__"),
                Place({ align = 4, nodiscard = true }, ".preinit_array*"),
                Define("__PREINIT_ARRAY_END__"),
            }
        },
        {
            name = "init_array",
            location = "FLASH",
            target = "FLASH",
            content = {
                Define("__INIT_ARRAY_START__"),
                Place({ align = 4, sort = true, nodiscard = true }, ".init_array.*"),
                Place({ nodiscard = true }, ".init_array"),
                Define("__INIT_ARRAY_END__"),
            }
        },
        {
            name = "fini_array",
            location = "FLASH",
            target = "FLASH",
            content = {
                Define("__FINI_ARRAY_START__"),
                Place({ align = 4, sort = true, nodiscard = true }, ".fini_array.*"),
                Place({ nodiscard = true }, ".fini_array"),
                Define("__FINI_ARRAY_END__"),
            }
        },
        -- RAM
        {
            name = "data",
            location = "FLASH",
            target = "RAM",
            content = {
                Define("__DATA_START__"),
                Place({ align = 4 }, ".data", ".data*"),
                Place(".ram_func", ".ram_func*"),
                Define("__DATA_END__"),
                Define("__NOINIT_START__"),
                Place({ align = 4 }, ".noinit", ".noinit*"),
                Define("__NOINIT_END__"),
            }
        },
        {
            name = "bss",
            location = "RAM",
            target = "RAM",
            type = NO_LOAD,
            content = {
                Define("__BSS_START__"),
                Place({ align = 4 }, ".bss", ".bss*", "COMMON"),
                Define("__BSS_END__"),
            }
        },
        {
            type = ARM_ATTRIBUTES
        }
    },
}
