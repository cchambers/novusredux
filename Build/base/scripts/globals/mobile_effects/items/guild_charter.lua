MobileEffectLibrary.GuildCharter = 
{
    OnEnterState = function(self,root,target,args)
        local isMemorial = target:GetObjVar("Memorial")
		if(not(isMemorial) and Guild.IsInGuild(self.ParentObj)) then 
			self.ParentObj:SystemMessage("You are already in a guild.","info")
			EndMobileEffect(root)
			return
		end
        if not( self.ParentObj:HasModule("guild_charter_window") ) then
            self.ParentObj:AddModule("guild_charter_window",{ScrollTarget=target})
        end

        EndMobileEffect(root)
    end,
}