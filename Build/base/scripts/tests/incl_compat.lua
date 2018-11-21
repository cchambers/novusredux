-- Compatability for Lua 5.2 functions in 5.1 (such as Lua for Windows)

if not table.pack then
  function table.pack(...)
    return { n = select('#',...); ... }
  end
end
