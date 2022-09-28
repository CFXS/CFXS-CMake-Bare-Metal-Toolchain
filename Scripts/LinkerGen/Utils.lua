return {
    EscapeString = function(x)
        return (
            x:gsub('%%', '%%%%'):gsub('^%^', '%%^'):gsub('%$$', '%%$'):gsub('%(', '%%('):gsub('%)', '%%)'):gsub('%.',
                '%%.'):gsub('%[', '%%['):gsub('%]', '%%]'):gsub('%*', '%%*'):gsub('%+', '%%+'):gsub('%-', '%%-'):gsub('%?'
                ,
                '%%?'))
    end,

    ReadFile = function(path)
        local f = io.open(path, "r")
        if not f then
            return nil
        end
        local content = f:read("*a")
        f:close()
        return content
    end,

    WriteFile = function(path, content)
        local folderIndex = path:match('^.*()/')
        local folder = path:sub(1, folderIndex - 1):gsub("/", "\\")
        os.execute('if not exist "' .. folder .. '" mkdir "' .. folder .. '"')
        local f = io.open(path, "w+")
        if not f then
            return false
        end
        f:write(content)
        f:close()
        return true
    end,

    NumberToByteString = function(x, noDecimal)
        if x < kB then
            return tostring(x)
        elseif x < MB then
            return string.format(noDecimal and "%dkB" or "%.3fkB", math.ceil(x / kB)):gsub("%.[%d]+", "")
        else
            return string.format(noDecimal and "%dMB" or "%.3fMB", math.ceil(x / MB)):gsub("%.[%d]+", "")
        end
    end,

    Assert = function(cond, message)
        if cond then
            error(message)
        end
    end
}
