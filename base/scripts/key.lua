require 'incl_keyhelpers'

RegisterSingleEventHandler(EventType.ModuleAttached, "key", 
    function ()
        AddUseCase(this,"Use",true,"HasObject")
        AddUseCase(this,"Copy",false,"HasObject")
        AddUseCase(this,"Add to Key Ring",false,"HasObject")
        SetTooltipEntry(this,"key_use", "[$1906]")
    end)

RegisterEventHandler(EventType.Message, "UseObject", 
    function(user,usedType)
        if(usedType == "Use") then         
            if( this:HasObjVar("lockUniqueId") ) then
                user:RequestClientTargetGameObj(this, "keyTarget")
            else
                user:SystemMessage("This key does not seem to belong to anything.")
            end
        elseif(usedType == "Add to Key Ring") then
            if IsBlankKey(this) then
                user:SystemMessage("You cannot add a blank key to your keyring.")
                return
            end
            if(this:HasObjVar("OneTimeKey")) then
                user:SystemMessage("The key is too fragile to add to your keyring.")
                return
            end            
            
            if(AddKeyToKeyRing(user,this)) then
                user:SystemMessage("You add the key to your key ring.")
            end
        elseif(usedType == "Copy") then    
            if(this:HasObjVar("OneTimeKey")) then
                user:SystemMessage("The key is too fragile to copy.")
                return
            end
            MakeCopy(user,this)
        end
    end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "keyTarget", 
    function(target,user)
        if( target == nil ) then return end
        
        local lockUniqueId = this:GetObjVar("lockUniqueId")
        
        if ( lockUniqueId ~= nil and target:GetObjVar("lockUniqueId") == lockUniqueId ) then
            -- toggle lock status
            if ( target:HasObjVar("locked") ) then                
                target:SendMessage("Unlock", user, this)
            else
                target:SendMessage("Lock", user, this)              
            end
        else
            user:SystemMessage("You try, but that key does not fit the lock.")
        end
    end)