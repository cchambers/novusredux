require 'incl_packed_object'


RegisterEventHandler(EventType.Message,"RepackObject",function()
    if (this:IsContainer()) then
        local objectsInContainer = FindItemsInContainerRecursive(this)
        if #objectsInContainer > 0 then
            return false
        end
    end
    CreatePackedObjectAtLoc(this:GetCreationTemplateId(),this:GetLoc())
end)

RegisterSingleEventHandler(EventType.CreatedObject,"packed_object_created",
	function(user,objRef)
		this:Destroy()
        --DFB HACK: Add the decay script since it's on the ground
        Decay(objRef, 15*60)
	end)
