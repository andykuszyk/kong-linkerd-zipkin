local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function hex_to_char(c)
    return string.char(tonumber(c, 16))
end

function from_hex(str)
    if str ~= nil then -- allow nil to pass through
        str = str:gsub("%x%x", hex_to_char)
    end
    return str
end

function build_header(span_id, parent_id, trace_id, flags)
    return enc(put64be(span_id)..put64be(parent_id)..put64be(trace_id)..put64be(flags))
end

function enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end


function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

function lshift(data, amount)
    return bit.lshift(bit.band(data, 0xff), amount)
end

function put64be(id)
    result = ''
    for i = 7, 0, -1 do
        result = result .. string.char(bit.band(bit.rshift(id, i * 8), 0xff))
    end
    return result
end

function get64be(data, index)
    result = lshift(string.byte(data, index, index), 56)
    for i = 1, 7 do
        result = bit.bor(result, lshift(string.byte(data, index + i, index + i), (7 - i) * 8))
    end
    return result
end

function get_id(data)
    return get64be(dec(data), 1)
end

function get_span_id(data)
    return get64be(dec(data), 1)
end

function get_parent_id(data)
    return get64be(dec(data), 8)
end

function get_trace_id(data)
    return get64be(dec(data), 17)
end

function get_flags(data)
    return get64be(dec(data), 25)
end
