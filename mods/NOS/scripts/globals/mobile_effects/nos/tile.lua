MobileEffectLibrary.Stonewall = 
{

	OnEnterState = function(self,root,target,args)
		self.SourceSpawnLoc = args.SourceSpawnLoc or self.ParentObj:GetLoc() or self.SourceSpawnLoc
		WallStart = args.SpellLoc
		Caster = self.ParentObj
		RootEffect = root
		self.ParentObj:SystemMessage("Select End Point for Tile")
		self.ParentObj:RequestClientTargetLoc(this, "SelectTileEndPoint")
		RegisterEventHandler(EventType.ClientTargetLocResponse, "SelectTileEndPoint",
		function(success, wallLoc)
			if(wallLoc == nil) then
				EndMobileEffect(root)
				return
			end
			-- if not(self.ValidateWallLocation(wallLoc)) then
			-- 	self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(10), "StoneWallTargetTimeout")
			-- 	self.ParentObj:SystemMessage("Select End Point for Tile")
			-- 	self.ParentObj:RequestClientTargetLoc(this, "SelectTileEndPoint")
			-- 	return
			-- end
			WallEnd = wallLoc
			self.CreateWall(root)
			EndMobileEffect()
			return

		end)
	end,

	OnExitState = function(self,root)
		UnregisterEventHandler("", EventType.Timer, "StoneWallTargetTimeout")
		UnregisterEventHandler("", EventType.ClientTargetLocResponse, "SelectTileEndPoint")

	end,

	CreateWall = function(root)
		local projAngle = WallStart:YAngleTo(WallEnd)
		Facing = math.fmod(projAngle + 85, 360)
		local dist = WallStart:Distance(WallEnd)
		local curProj = 0

		while(curProj <= dist) do
	
			local nextLoc = WallStart:Project(projAngle,curProj)
			if (Caster:HasLineOfSightToLoc(Loc(nextLoc))) then
				CreateTempObj("pit_wall",nextLoc,"pit_wallloc_created")
			end			
			curProj = curProj + 1
	
		end
		WallInstances = curProj
		RegisterEventHandler(EventType.CreatedObject,"pit_wallloc_created",function (success,objRef)
			if (success) then
				objRef:SetRotation(objRef:GetRotation() + Loc(0,Facing,0))
				objRef:SendMessage("InitStoneWall", {Caster = Caster, Skill = CastSkill, Controller = Controller})

			end
			WallInstances = WallInstances - 1
			if(WallInstances < 1) then
				UnregisterEventHandler("",EventType.CreatedObject,"pit_wallloc_created")
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