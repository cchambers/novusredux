function WriteAccountVar(user_id, tableName, key, value) 
    user_id = user_id.."_"..tableName;
    GlobalVarWrite(user_id, "WriteResultEvent", function(writeTable) 
        writeTable[key] = value;
        return true;
    end);
end

function CheckJail(user)
        
    local user_id = user:GetAttachedUserId();
    local jail_settings = GlobalVarRead("settings_jail");

    local jail_record = user_id.."_jail";
    local table = GlobalVarRead(jail_record);

    if (table == nil) then
        user:SystemMessage(tostring("Account not jailed"));
        return;
    end

    if (table["isJailed"]) then
        
        if (table["characterJailed"] ~= tostring(user)) then
            --DebugMessage(tostring(user).." "..table["characterJailed"]);
            if (user ~= nil) then user:KickUser("You must log into the character that got jailed to finish your sentence.") end
        end

        --local jailLocation = jail_settings["location"];
        --DoSlay(user);
        --user:SetWorldPosition(jailLocation);
        --user:SendMessage("PlayerResurrect",this,nil,true);             

    end

end

function DoSlay(target)    
    if( target:IsValid() ) then        
        target:SendMessage("ProcessTrueDamage", this, GetCurHealth(target), true)
        target:PlayEffect("LightningCloudEffect")
    end
end