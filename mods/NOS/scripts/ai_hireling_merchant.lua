require 'default:ai_hireling_merchant'

-- UnregisterEventHandler("",EventType.Timer,"ClearSpawnerTimer")
-- RegisterSingleEventHandler(EventType.Timer,"ClearSpawnerTimer",function ( ... )
--     RemoveFromSpawner()
-- end)

-- function HandleHireSelectLocation(success,targetLoc,targetObj,user)
--     if(not(success) or GetFollowTarget() ~= user) then
--         return
--     end

--     if not(Plot.IsOwnerForLoc(user,targetLoc)) then
--         this:NpcSpeech("[$87]")
--         return
--     else
--         local plot = Plot.GetAtLoc(targetLoc)
--         this:SetObjVar("PlotController", plot)
--     end

--     if (CountCoins(user) < MERCHANT_HIRE_FEE) then
--         this:NpcSpeech("[$89]"..ValueToAmountStr(MERCHANT_HIRE_FEE,false,true).." gold to set up shop for you.")
--         return
--     end

--     completeHireLoc = targetLoc
--     RequestConsumeResource(user,"coins",MERCHANT_HIRE_FEE,"CompleteHire",this)    
-- end