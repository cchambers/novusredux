

MobileEffectLibrary.LotteryBox = 
{
    OnEnterState = function(self,root,target,args)        
    	--DebugMessage("A "..tostring(target:GetName()))
        -- Are you sure?
        ClientDialog.Show{
            TargetUser = self.ParentObj,
            DialogId = "RedeemBox",
            TitleStr = "Open Crate",
            DescStr = "Are you sure you wish to open this crate? This cannot be undone.",
            Button1Str = "Confirm",
            Button2Str = "Cancel",
	        ResponseObj = self.ParentObj,
            ResponseFunc = function( user, buttonId )
                buttonId = tonumber(buttonId)
                if ( buttonId == 0 ) then
                	local backpackObj = self.ParentObj:GetEquippedObject("Backpack")
                	if(backpackObj) then
	                	LootTables.SpawnLoot({target:GetObjVar("LootTable")},backpackObj)
	                	target:Destroy()
	                	self.ParentObj:SystemMessage("The contents of the crate have been placed in your pack.","info")
	                end
                end
                EndMobileEffect(root)
            end,
        }
	end,
}