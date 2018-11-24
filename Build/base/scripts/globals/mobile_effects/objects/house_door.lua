MobileEffectLibrary.HouseDoorToggle = 
{

    OnEnterState = function(self,root,target,args)
        local Door = Door
        if ( Door.IsOpen(target) ) then
            Door.Close(target) -- anyone can close house doors...hehe
        else
            if ( not Door.IsLocked(target) or Plot.HasObjectControl(self.ParentObj, target, true) ) then
                Door.Open(target, not target:HasObjVar("NoAutoClose"))
            else
                self.ParentObj:SystemMessage("That door is locked.", "info")
            end
        end
        EndMobileEffect(root)
	end,

}

MobileEffectLibrary.HouseDoorLock = 
{

    OnEnterState = function(self,root,target,args)
        if ( Plot.HasObjectControl(self.ParentObj, target) ) then
            Door.Lock(target)
            self.ParentObj:SystemMessage("Door is now locked.", "info")
        else
            self.ParentObj:SystemMessage("Do not have permission to lock that.", "info")
        end
        EndMobileEffect(root)
	end,

}


MobileEffectLibrary.HouseDoorUnlock = 
{

    OnEnterState = function(self,root,target,args)
        local Door = Door
        if ( Plot.HasObjectControl(self.ParentObj, target) ) then
            Door.Unlock(target)
            self.ParentObj:SystemMessage("Door is now un-locked.", "info")
        else
            self.ParentObj:SystemMessage("Do not have permission to unlock that.", "info")
        end
        EndMobileEffect(root)
	end,

}