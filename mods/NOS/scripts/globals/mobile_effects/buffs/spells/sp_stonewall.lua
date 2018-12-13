MobileEffectLibrary.Stonewall = 
{

	OnEnterState = function(self,root,target,args)
		self.SourceSpawnLoc = args.SourceSpawnLoc or self.ParentObj:GetLoc() or self.SourceSpawnLoc
		self.CallbackMessage = args.CallbackMessage or "DestroyRune"
		WallStart = args.SpellLoc
		Caster = self.ParentObj
		RootEffect = root
		CastSkill = GetSkillLevel(self.ParentObj,"MagerySkill")
		self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(30), "StoneWallTargetTimeout")
		RegisterEventHandler(EventType.Timer, "StoneWallTargetTimeout", 
		function( )
			EndMobileEffect(root)	
		end)
		self.ParentObj:SystemMessage("Select End Point for Stone Wall")
		self.ParentObj:RequestClientTargetLoc(this, "SelectStoneWallEndPoint")
		RegisterEventHandler(EventType.ClientTargetLocResponse, "SelectStoneWallEndPoint",
		function(success, wallLoc)
			if(wallLoc == nil) then
				EndMobileEffect(root)
				return
			end
			if not(self.ValidateWallLocation(wallLoc)) then
				self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "StoneWallTargetTimeout")
				self.ParentObj:SystemMessage("Select End Point for Stone Wall")
				self.ParentObj:RequestClientTargetLoc(this, "SelectStoneWallEndPoint")
				return
			end
			WallEnd = wallLoc
			self.CreateWall(root)
			self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(2), "StoneWallTargetTimeout")
			return

		end)
	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.Timer, "StoneWallTargetTimeout")
		UnregisterEventHandler("", EventType.ClientTargetLocResponse, "SelectStoneWallEndPoint")

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
				CreateTempObj("wall_half_graveyard",nextLoc,"stonewallloc_created")
			end			
			curProj = curProj + 1
	
		end
		WallInstances = curProj
		RegisterEventHandler(EventType.CreatedObject,"stonewallloc_created",function (success,objRef)
			if (success) then
				objRef:SetRotation(objRef:GetRotation() + Loc(0,Facing,0))
				objRef:SendMessage("InitStoneWall", {Caster = Caster, Skill = CastSkill, Controller = Controller})

			end
			WallInstances = WallInstances - 1
			if(WallInstances < 1) then
				UnregisterEventHandler("",EventType.CreatedObject,"stonewallloc_created")
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