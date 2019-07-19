local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

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

function to_bytes(data)
    bytes_string = ''
    for i = 7, 0, -1 do
        bytes_string = bytes_string..string.char((data >> (i * 8)) & 0xFF)
    end
    return bytes_string
end

function from_bytes(data)
   long = tonumber(string.byte(data, 1, 1) & 0xFF) << 56
    for i = 2, 8 do
        long = long | tonumber(string.byte(data, i, i) & 0xFF) << ((8 - i) * 8)
    end
    return tonumber(long)
end

function get_id(base64_encoded)
    return from_bytes(dec(base64_encoded))
end

function encode(value)
    return enc(to_bytes(value))
end
