_G.kB = 1024
_G.MB = 1048576
_G.Place = function(...)
    local list = { ... }
    if #list == 0 then
        error("Place with no arguments")
    end
    local sort = false
    local nodiscard = false
    local output = {}
    local sections = {}
    for i, v in pairs(list) do
        if type(v) == "table" then
            if i ~= 1 then
                error("Place flags not at index 1")
            end
            sort = v.sort
            nodiscard = v.nodiscard
            if v.align then
                table.insert(output, ". = ALIGN(" .. v.align .. ");")
            end
        else
            table.insert(sections, v)
        end
    end
    local temp = (
        nodiscard and (sort and "KEEP(*(SORT(SECTIONS)));" or "KEEP(*(SECTIONS));") or
            (sort and "*(SORT(SECTIONS));" or "*(SECTIONS);")):gsub("SECTIONS", table.concat(sections, " "))
    table.insert(output, temp)
    return output
end
_G.Align = function(n)
    return { ". = ALIGN(" .. n .. ");" }
end
_G.Extend = function(size)
    return { ". = . + " .. size .. ";" }
end
_G.Define = function(name, value)
    if value then
        return { string.format('PROVIDE(%s = %s);', name, value) }
    else
        return { string.format('PROVIDE(%s = .);', name) }
    end
end
_G.DefineHidden = function(name, value)
    if value then
        return { string.format('PROVIDE_HIDDEN(%s = %s);', name, value) }
    else
        return { string.format('PROVIDE_HIDDEN(%s = .);', name) }
    end
end
_G.table_InsertBefore = {}
_G.InsertBefore = function(target, t)
    _G.table_InsertBefore[target] = t
end
_G.NO_LOAD = "(NOLOAD)"
_G.ARM_ATTRIBUTES = ".ARM.attributes 0 : { *(.ARM.attributes) }"

local ALIGN_DEFINES = false

local args = { ... }
local ROOT = args[1]:gsub("\\", "/")
local CONFIG_FILE_PATH = args[2]:gsub("\\", "/")
local EXPORT_FILE_PATH = args[3]:gsub("\\", "/")

print("[CFXS LinkerGen]")
print(" - Root:   " .. ROOT)
print(" - Config: " .. CONFIG_FILE_PATH)
print(" - Export: " .. EXPORT_FILE_PATH)

local Utils = dofile(ROOT .. "/Utils.lua")
local Defaults = dofile(ROOT .. "/Defaults.lua")

print("Loading config file...")
local Config = dofile(CONFIG_FILE_PATH)

Utils.Assert(Config.EntryPoint == nil, "Config missing [EntryPoint]")
Utils.Assert(Config.Memory == nil, "Config missing [Memory]")
Utils.Assert(Config.Stack == nil, "Config missing [Stack]")
Utils.Assert(Config.Stack.location == nil, "Config.Stack.location not defined")
Utils.Assert(Config.Stack.size == nil, "Config.Stack.size not defined")
Utils.Assert((Config.Stack.size % 8) ~= 0, "Config.Stack.size not aligned to 8")
Utils.Assert(Config.Sections == nil, "Config missing [Sections]")

----------------------------------------------------------------
local output = string.format("/* Entry Point */\nENTRY(%s)\n\n", Config.EntryPoint)

-- Insert default sections into config sections
if Config.NoDefaultSections ~= true then
    print("Merging default sections...")
    for i, v in pairs(Defaults.Sections) do
        if v.type == NO_LOAD or v.type == ARM_ATTRIBUTES then
            table.insert(Config.Sections, v) -- at end
        else
            table.insert(Config.Sections, i, v) -- at start in order
        end
    end
end

local memoryList = {}
local namePaddingLength = 0
for i, v in pairs(Config.Memory) do
    if i ~= "Alias" then
        v.name = i
        if #i > namePaddingLength then
            namePaddingLength = #i
        end
        table.insert(memoryList, v)
        Config.Memory.Alias[v.name] = v.name
    end
end
table.sort(memoryList, function(a, b) return a.start < b.start end)

local regionDefines = "/* Memory Region Range Defines */\n"
output = output .. "/* Memory Regions */\nMEMORY {\n"
print("Memory Regions:")
for i, v in pairs(memoryList) do
    print(string.format(" - %-8s %s [0x%08X - 0x%08X] %s",
        v.name,
        v.permissions,
        v.start,
        v.start + v.size - 1,
        Utils.NumberToByteString(v.size)))

    output = output .. string.format(
        "    %-" .. namePaddingLength .. "s (%3s) : ORIGIN = 0x%08X, LENGTH = %s\n",
        v.name,
        v.permissions:gsub("%-", ""),
        v.start,
        Utils.NumberToByteString(v.size, false):upper():gsub("B", "")
    )
end

output = output .. "}\n\n"

local aliasRegionCheck = {}
local aliasPaddingLength = 0
for i, v in pairs(Config.Memory.Alias) do
    if #i > aliasPaddingLength then
        aliasPaddingLength = #i
    end
end
print("Generating region defines...")
for i, v in pairs(Config.Memory.Alias) do
    if aliasRegionCheck[i] == nil then
        aliasRegionCheck[i] = true
        regionDefines = regionDefines .. string.format(
            "PROVIDE(%-" .. (aliasPaddingLength + 17) .. "s = ORIGIN(%s));\n" ..
            "PROVIDE(%-" .. (aliasPaddingLength + 17) .. "s = ORIGIN(%s) + LENGTH(%s));\n" ..
            "PROVIDE(%-" .. (aliasPaddingLength + 17) .. "s = LENGTH(%s));\n",
            "__REGION_" .. i:upper() .. "_START__", i:upper(),
            "__REGION_" .. i:upper() .. "_END__  ", i:upper(), i:upper(),
            "__REGION_" .. i:upper() .. "_SIZE__ ", i:upper()
        )
    end
end

local constBeingTable = {}
local outputSections = ""
local sectionPaddingLength = 0
for i, v in pairs(Config.Sections) do
    if v.name and #v.name > sectionPaddingLength then
        sectionPaddingLength = #v.name
    end
end
print("Generating sections and range defines...")

--[[
    InsertBefore
]]

for i, v in pairs(Config.Sections) do
    if v.type == ARM_ATTRIBUTES then
        outputSections = outputSections .. "    " .. ARM_ATTRIBUTES .. "\n\n"
    else
        local location = Config.Memory.Alias[v.location]
        local target = Config.Memory.Alias[v.target]
        Utils.Assert(location == nil, string.format('Invalid [location] for section "%s" ("%s")', v.name, v.location))
        Utils.Assert(target == nil, string.format('Invalid [target] for section "%s" ("%s")', v.name, v.target))

        local insTarget = _G.table_InsertBefore[v.target] and _G.table_InsertBefore[v.target] or
            _G.table_InsertBefore[target]
        if insTarget then
            local lcopy = {}
            for a, b in pairs(insTarget) do
                table.insert(lcopy, b)
            end
            for a, b in pairs(v.content) do
                table.insert(lcopy, b)
            end
            v.content = lcopy
        end

        if location == target then
            target = "> " .. target
        else
            target = "> " .. target .. " AT > " .. location
        end

        local content = ""
        for _, e in pairs(v.content) do
            content = content .. "        " .. table.concat(e, "\n        "):gsub("        $", "") .. "\n"
        end

        local sect = string.format(
            (v.type == NO_LOAD and "    .%s (NOLOAD) : {\n" or "    .%s : {\n") ..
            "%s" ..
            "    } %s\n\n",
            v.name,
            content,
            target
        )

        outputSections = outputSections .. sect
        if not v.name:find("%.") and v.type ~= NO_LOAD and v.type ~= ARM_ATTRIBUTES then
            table.insert(constBeingTable,
                string.format('PROVIDE(%-' .. (sectionPaddingLength + 16) .. 's = LOADADDR(.%s));',
                    "__CONST_" .. v.name:upper() .. "_START__", v.name))
            table.insert(constBeingTable,
                string.format('PROVIDE(%-' .. (sectionPaddingLength + 16) .. 's = LOADADDR(.%s) + SIZEOF(.%s));',
                    "__CONST_" .. v.name:upper() .. "_END__", v.name, v.name))
            table.insert(constBeingTable,
                string.format('PROVIDE(%-' .. (sectionPaddingLength + 16) .. 's = SIZEOF(.%s));',
                    "__CONST_" .. v.name:upper() .. "_SIZE__", v.name))
        end
    end
end

outputSections = outputSections:sub(1, #outputSections - 1)

if Config.Discard then
    print("Generating discard list...")
    local discardOutput = "\n    /DISCARD/ : {\n"
    for i, v in pairs(Config.Discard) do
        if #v > 0 then
            discardOutput = discardOutput .. "        " .. i .. " ( " .. table.concat(v, " ") .. " )\n"
        else
            discardOutput = discardOutput .. "        " .. i .. " ( * )\n"
        end
    end
    discardOutput = discardOutput .. "    }\n"
    outputSections = outputSections .. discardOutput
end

output = output ..
    "/* Sections */\n" ..
    "SECTIONS {\n" ..
    outputSections ..
    "}\n\n"

if not ALIGN_DEFINES then
    for i, v in pairs(constBeingTable) do
        constBeingTable[i] = v:gsub("%s+=", " =")
    end

    regionDefines = regionDefines:gsub("%s+=", " =")
end

output = output ..
    "/* Section Range Defines */\n" ..
    table.concat(constBeingTable, "\n") ..
    "\n\n"

-- region defines at end of linkerscript
output = output .. regionDefines .. "\n\n"
output = output:gsub("[\n]+$", "\n")

-- User defines
if Config.Definitions then
    local userDefs = {}
    for i, v in pairs(Config.Definitions) do
        table.insert(userDefs, string.format("PROVIDE(%s = %s);", v[1], v[2]))
    end
    output = output ..
        "\n/* User Defines */\n" ..
        table.concat(userDefs, "\n") ..
        "\n"
end

print("Writing output: " .. EXPORT_FILE_PATH)
Utils.WriteFile(EXPORT_FILE_PATH, output)
print("> CFXS LinkerGen done")
