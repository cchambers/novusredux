
if (initializer ~= nil) then
    if( initializer.Names ~= nil ) then  
        local nameTable = initializer.Names
        local name = nameTable[math.random(1,#nameTable)]
        this:SetName(name)
    end
end