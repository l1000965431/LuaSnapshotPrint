Debug = {}

Debug._index = Debug

local PrintedCatch = nil            --记录已经打印过的表命 防止递归遍历

function Debug.dumptree(obj,ObjName, width)
    -- 递归打印函数
    local dump_obj;
    local end_flag = {};

    local function make_indent(layer, is_end)
        local subIndent = string.rep("  ", width)
        local indent = "";
        end_flag[layer] = is_end;
        local subIndent = string.rep("  ", width)
        for index = 1, layer - 1 do
            if end_flag[index] then
                indent = indent.." "..subIndent
            else
                indent = indent.."|"..subIndent
            end
        end

        if is_end then
            return indent.."└"..string.rep("─", width).." "
        else
            return indent.."├"..string.rep("─", width).." "
        end
    end

    local function make_quote(str)
        str = string.gsub(str, "[%c\\\"]", {
            ["\t"] = "\\t",
            ["\r"] = "\\r",
            ["\n"] = "\\n",
            ["\""] = "\\\"",
            ["\\"] = "\\\\",
        })
        return "\""..str.."\""
    end

    local function dump_key(key)
        if type(key) == "number" then
            return key .. ":"
        elseif type(key) == "string" then
            return "\"".. key.. "\": "
        elseif type(key) == "userdata" then
            return "userdata"
        end

        return "["..type(key).."]"..key..":"
    end

    local function dump_val(val,parentObjName,layer)
        if type(val) == "table" then
            return dump_obj(val,parentObjName,layer)
        elseif type(val) == "string" then
            return make_quote(val)
        else
            return tostring(val)
        end
    end

    local function count_elements(obj)
        local count = 0
        for _, _ in pairs(obj) do
            count = count + 1
        end
        return count
    end

    dump_obj = function(obj,parentName,layer)
        if type(obj) ~= "table" then
            return count_elements(obj)
        end

        if PrintedCatch[obj] ~= nil then
            return parentName
        else
            PrintedCatch[obj] = true
        end

        layer = layer + 1
        local tokens = {}
        local max_count = count_elements(obj)
        local cur_count = 1

        for k, v in pairs(obj) do
            local key_name = dump_key(k)
            if type(v) == "table" then
                key_name = key_name.."\n"
            end

            if k == "PrintedCatch" then
                table.insert(tokens, make_indent(layer, true) .. "table is filter")
                --logWarn(k)
            else
                table.insert(tokens, make_indent(layer, cur_count == max_count)
                    .. key_name .. dump_val(v,k, layer))
            end

            cur_count = cur_count + 1
        end

        -- 处理空table
        if max_count == 0 then
            table.insert(tokens, make_indent(layer, true) .. "{ }")
        end

        return table.concat(tokens, "\n")
    end

    if type(obj) ~= "table" then
        return "the params you input is "..type(obj)..
            ", not a table, the value is --> "..tostring(obj)
    end

    width = width or 2
    PrintedCatch = {}
    local str = dump_obj(obj,ObjName,0)
    PrintedCatch = nil
    return "root-->"..tostring(obj).."\n"..str
end
