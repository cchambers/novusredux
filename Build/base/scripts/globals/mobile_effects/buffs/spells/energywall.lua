MobileEffectLibrary.Energywall = 
{

	OnEnterState = function(self,root,target,args)
		self.SourceSpawnLoc = args.SourceSpawnLoc or self.ParentObj:GetLoc() or self.SourceSpawnLoc
		self.CallbackMessage = args.CallbackMessage or "DestroyRune"
		WallStart = args.SpellLoc
		Caster = self.ParentObj
		RootEffect = root
		CastSkill = GetSkillLevel(self.ParentObj,"ManifestationSkill")
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(30), "EnergyWallTargetTimeout")
		RegisterEventHandler(EventType.Timer, "EnergyWallTargetTimeout", 
		function( )
			EndMobileEffect(root)	
		end)
		self.ParentObj:SystemMessage("Select End Point for Energy Wall")
		self.ParentObj:RequestClientTargetLoc(this, "SelectEnergyWallEndPoint")
		RegisterEventHandler(EventType.ClientTargetLocResponse, "SelectEnergyWallEndPoint",
		function(success, wallLoc)
			if(wallLoc == nil) then
				EndMobileEffect(root)
				return
			end
			if not(self.ValidateWallLocation(wallLoc)) then
				self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "EnergyWallTargetTimeout")
				self.ParentObj:SystemMessage("Select End Point for Energy Wall")
				self.ParentObj:RequestClientTargetLoc(this, "SelectEnergyWallEndPoint")
				return
			end
			WallEnd = wallLoc
			self.CreateWall(root)
			self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "EnergyWallTargetTimeout")
			return

		end)
	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.Timer, "EnergyWallTargetTimeout")
		UnregisterEventHandler("", EventType.ClientTargetLocResponse, "SelectEnergyWallEndPoint")

	end,

	ValidateWallLocation = function(wallPointLoc)
		if( not(IsPassable(wallPointLoc)) ) then
			Caster:SystemMessage("[$2603]")
			return false
		end

		if not(Caster:HasLineOfSightToLoc(wallPointLoc,ServerSettings.Combat.LOSEyeLevel)) then
			Caster:SystemMessage("[$2604]")
			return false
		end

		return true

	end,
	CreateWall = function(root)
		local projAngle = WallStart:YAngleTo(WallEnd)
		Facing = math.fmod(projAngle + 85, 360)
		local dist = math.min(WallStart:Distance(WallEnd), math.floor(CastSkill / 16))
		local curProj = 0

		while(curProj <= dist) do
	
			local nextLoc = WallStart:Project(projAngle,curProj)
			if (Caster:HasLineOfSightToLoc(Loc(nextLoc))) then
			--DebugMessage("Fire At :" .. "pt: " .. curProj.. tostring(nextLoc))
			--need to make this to tell mobs to avoid it
				CreateTempObj("energywall",nextLoc,"energywallloc_created")
			end			
			curProj = curProj + 1
	
		end
		WallInstances = curProj
		RegisterEventHandler(EventType.CreatedObject,"energywallloc_created",function (success,objRef)
			if (success) then
				objRef:SetRotation(objRef:GetRotation() + Loc(0,Facing,0))
				objRef:SendMessage("InitEnergyWall", {Caster = Caster, Skill = CastSkill, Controller = Controller})

			end
			WallInstances = WallInstances - 1
			if(WallInstances < 1) then
				UnregisterEventHandler("",EventType.CreatedObject,"energywallloc_created")
				EndMobileEffect(RootEffect)
			end
		end)
	end,
	WallStart = nil,
	WallEnd = nil,
	WallInstances = 0,
	Facing = 0,
	CastSkill = 0,
	Caster = nil,
	RootEffect = nil,
}