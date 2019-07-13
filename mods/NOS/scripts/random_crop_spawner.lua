mRandomCrops = {
	"plant_ginseng",
	"plant_lemon_grass",
	"plant_mushrooms",
	"plant_moss",
	"plant_cotton",
}

createCount = 0

campController = nil

RegisterEventHandler(EventType.ModuleAttached,"random_crop_spawner",
	function ( ... )
		local randomCrop = mRandomCrops[math.random(1,#mRandomCrops)]
		CallFunctionDelayed(TimeSpan.FromSeconds(3),function ( ... )
			campController = FindObject(SearchModule("prefab_camp_controller",30))
			
			for i,cropObj in pairs(FindObjects(SearchTemplate("random_crop_location",30))) do
				local scale = 0.8+(math.random()*0.4)
				createCount = createCount + 1
				CreateObjExtended(randomCrop,nil,cropObj:GetLoc(),Loc(0,math.random(1,360),0),Loc(scale,scale,scale),"crop")
				cropObj:Destroy()
			end

			if(createCount == 0) then
				this:Destroy()
			end
		end)
	end)

RegisterEventHandler(EventType.CreatedObject,"crop",
	function (success,objRef)
		if(success and campController) then
			AddToListObjVar(campController,"PrefabObjects",objRef)
		end

		createCount = createCount - 1
		if(createCount == 0) then
			this:Destroy()
		end
	end)