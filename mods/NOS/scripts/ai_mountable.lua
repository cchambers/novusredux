
local hueTable = { 
    ice = {819, 820, 821, 822, 823, 824, 839, 900, 913},
    fire = {826, 827, 831, 832, 833, 862, 956, 957},
    poison = {805, 901, 903, 911, 923, 931, 949, 959},
    lunar = {848, 868, 869, 870, 872, 897, 961, 973},
}

-- fire, ice, poison, lunar, 
if (initializer ~= nil) then
    if( initializer.Type ~= nil ) then  
        local type = initializer.Type  
        local typeTable = hueTable[type]
        local hue = typeTable[math.random(1,#typeTable)]
        this:SetHue(hue)
        return
    end
    
    if( initializer.Body ~= nil ) then  
        local bodyTemplateId = initializer.Body  
        this:SetAppearanceFromTemplate(bodyTemplateId)
        this:SetObjVar("FormTemplate",bodyTemplateId)
    end
end
