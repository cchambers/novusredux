local log = {}

local c27 = string.char(27)
local reset = c27 .. '[' .. tostring(0) .. 'm'
local red = c27 .. '[' .. tostring(31) .. 'm'
local green = c27 .. '[' .. tostring(32) .. 'm'
local yellow = c27 .. '[' .. tostring(33) .. 'm'

function log.info(msg)
    print(green .. "[info ]  " .. msg .. reset)
end

function log.error(msg)
    print(red .. "[error]  " .. msg .. reset)
end

function log.debug(msg)
    print(yellow .. "[debug]  " .. msg .. reset)
end

return log