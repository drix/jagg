
require "socket"

function copy(orig)
    local orig_type = type(orig)
    local obj
    if orig_type == 'table' then
        obj = {}
        for orig_key, orig_value in next, orig, nil do
            obj[copy(orig_key)] = copy(orig_value)
        end
        setmetatable(obj, copy(getmetatable(orig)))
    else -- number, string, boolean, etc
        obj = orig
    end
    return obj
end

function fill(obj,with)
    for i,v in ipairs(with) do
        obj[i] = v
    end
    for k,v in pairs(with) do
        obj[k] = v
    end
    return obj
end

function sleep(sec)
    socket.select(nil, nil, sec)
end

function len( t )
    local c = #t
    for _ in pairs(t) do c = c + 1 end
    return c
end
