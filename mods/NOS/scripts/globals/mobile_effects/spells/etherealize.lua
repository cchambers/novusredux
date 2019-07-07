local etherealizable = {
    horse = "item_statue_mount_horse",
    bay_horse = "item_statue_mount_horse",
    void_horse = "item_statue_mount_horse",
    desert_horse = "item_statue_mount_horse",
    black_horse = "item_statue_mount_horse",
    chestnut_horse = "item_statue_mount_horse",
    cultist_horse = "item_statue_mount_horse",
}

MobileEffectLibrary.Etherealize = 
{

    OnEnterState = function(self,root,target,args)
        if not( self.ValidTarget(self.ParentObj,target) ) then
            EndMobileEffect(root)
            return false
        end
        
        Create.InBackpack(etherealizable[target:GetCreationTemplateId()], self.ParentObj, nil, function(statue)
            if ( statue ) then
                PlayEffectAtLoc("CloakEffect", target:GetLoc())
                target:Destroy()
            else
                self.ParentObj:SystemMessage("Failed to create statue.", "info")
            end
            EndMobileEffect(root)
        end)
    end,
    
    -- this is used for validating the spell cast as well (to avoid resource consumption)
    ValidTarget = function(mobile,target)
        if ( not target or not target:IsValid() ) then
            mobile:SystemMessage("Invalid target.", "info")
            return false
        end
        if not( etherealizable[target:GetCreationTemplateId()] ) then
            mobile:SystemMessage("Invalid target.", "info")
            return false
        end
        if ( target:GetObjVar("controller") ~= mobile ) then
            mobile:SystemMessage("Can only be applied to pets you own.", "info")
            return false
        end
        if ( IsDead(target) ) then
            mobile:SystemMessage("Cannot apply to dead pets.", "info")
            return false
        end
        if not( IsMount(target) ) then
            mobile:SystemMessage("Can only be applied to mounts.", "info")
            return false
        end
        if ( target:HasObjVar("HasPetPack") ) then
            mobile:SystemMessage("Cannot Etherealize a mount with items.", "info")
            return false
        end
        return true
    end,
}

SpellData.AllSpells.Etherealize.TargetValidate = MobileEffectLibrary.Etherealize.ValidTarget