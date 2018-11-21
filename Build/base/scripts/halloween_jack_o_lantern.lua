require 'incl_packed_object'

MAX_SPIDERS = 3
MIN_SPIDERS = 1

items = {
	"item_apple",
	"ingredient_broccoli",
	"ingredient_tomato",
	"ingredient_lemongrass",
	"item_lettuce_leaf"
}

function SpawnSpiders()        
    local i = 1
    local spawnAmount = math.random(MIN_SPIDERS,MAX_SPIDERS)
    while i <= spawnAmount do 
        CreateObj("graveyard_spider",this:GetLoc():Project(math.random(0,360), math.random()),"MobCustomAge",math.random(5,6))
        i = i + 1
    end
end

RegisterEventHandler(EventType.CreatedObject,"MobCustomAge",
    function(success,objRef,newAge)
        objRef:SendMessage("ChangeAge",newAge)
        objRef:SendMessage("AttackEnemy",target)
        --DebugMessage("Changing age to "..newAge.." in "..objRef:GetName())
    end)

RegisterEventHandler(EventType.Message,"RequestResource",
	function(requester, user)		
		if(math.random(1,100)==1) then
			PlayEffectAtLoc("DigDirtParticle",this:GetLoc())
			user:PlayObjectSound("WormPain",false)
			CreatePackedObjectAtLoc(this:GetObjVar("DecorationTemplate"),this:GetLoc())
		elseif(math.random(1,5)==1) then
			--DebugMessage("AnimalParts RequestResource "..tostring(this:GetName()))
			PlayEffectAtLoc("VoidExplosionEffect",this:GetLoc())
			user:PlayObjectSound("FireballImpact",false)
			SpawnSpiders()
		else
			PlayEffectAtLoc("DigDirtParticle",this:GetLoc())
			user:PlayObjectSound("WormPain",false)
			CreateObj(items[math.random(#items)],this:GetLoc(),"item_spawned")
		end

		CallFunctionDelayed(TimeSpan.FromSeconds(0.5),function() this:Destroy() end)		
	end)

RegisterEventHandler(EventType.CreatedObject,"item_spawned",
	function (success,objRef )
		Decay(objRef)
	end)

this:SetObjVar("HandlesHarvest",true)