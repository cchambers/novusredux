require 'scriptcommands_UI_edit'
require 'scriptcommands_UI_info'
require 'scriptcommands_UI_create'
require 'scriptcommands_UI_createcustom'
require 'scriptcommands_UI_search'
require 'scriptcommands_UI_globalvar'

newScale = nil
newColor = nil
newHue = nil
scriptName = nil
bodyTemplateId = nil
mMobToCopy = nil
nameToSet = nil
prefabCreate = nil
mTileTemplate = nil

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "possess",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end
		--DebugMessage("possess",tostring(target))
		DoPossession(this,target)
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "tamecmd",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end
		SetCreatureAsPet(target, this)
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "editchar",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end
		OpenCharEditWindow(target)
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "scale",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SetScale(Loc(newScale,newScale,newScale))
	end
)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "color",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SetColor(newColor)
	end
)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "hue",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SetHue(newHue)
	end
)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "body",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		if not( target:IsMobile() ) then
			this:SystemMessage("Error: /setbody only works on mobiles")
		end

		target:SetAppearanceFromTemplate(bodyTemplateId)
		target:SetObjVar("FormTemplate",bodyTemplateId)
	end
)

RegisterEventHandler(EventType.ClientTargetGameObjResponse,"copyformselect",
	function(target,user)
		if (not IsDemiGod(this)) then return end

		if (target == nil) then return end

		mMobToCopy = target
		user:SystemMessage("Which mob do you wish to change?")

		this:RequestClientTargetGameObj(this, "copyform")
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "copyform",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		if not( target:IsMobile() ) then
			this:SystemMessage("Error: /changeform only works on mobiles")
		end

		target:SendMessage("CopyOtherMobile",mMobToCopy)
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "form",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		if not( target:IsMobile() ) then
			this:SystemMessage("Error: /changeform only works on mobiles")
		end

		target:SendMessage("ChangeMobileToTemplate",bodyTemplateId,{LoadLoot=false})
	end)


RegisterEventHandler(EventType.ClientTargetGameObjResponse, "resTarget",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SendMessage("Resurrect",1.0)
	end
)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "resTargetForce",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SendMessage("Resurrect",1.0,nil,true)
	end
)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "healTarget",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		local curHealth = math.floor(GetCurHealth(target))
		local healAmount = GetMaxHealth(target) - curHealth

		SetCurHealth(target,curHealth + healAmount)

		this:SystemMessage("Healed "..target:GetName().." for " .. healAmount,"event")
		this:SystemMessage("Health is now "..tostring(GetCurHealth(target)))
	end
)

function DoSlay(target)	
    if( target:IsValid() ) then		
		target:SendMessage("ProcessTrueDamage", this, GetCurHealth(target), true)
		target:PlayEffect("LightningCloudEffect")
	end
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "slayTarget", 
	function(target,user)
		if( target == nil ) then
			return
		end

		DoSlay(target)
	end
)

function DoFreeze(target)	
	if( target:IsValid() ) then
		if ( HasMobileEffect(target, "GodFreeze") ) then
			target:SendMessage("EndGodFreezeEffect")
		else
			target:SendMessage("StartMobileEffect", "GodFreeze")
		end
	end
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "freezeTarget", 
	function(target,user)
		if( target == nil ) then
			return
		end

		DoFreeze(target)
	end
)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "container",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		target:SendOpenContainer(user)
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "setname",
	function(target,user)
		if not(IsDemiGod(this)) then return end
		if( target == nil ) then
			return
		end
		target:SetName(nameToSet)
		target:SendMessage("UpdateName")
	end
)

local destroyTargetObj = nil
function DoDestroy(target)
	if(target:IsPlayer()) then
		this:SystemMessage("You cannot destroy players")
	elseif(target:HasObjVar("NoReset")) then
		destroyTargetObj = target
		ClientDialog.Show{
			TargetUser = this,
		    DialogId = "DestroyConfirm",
		    TitleStr = "Warning",
		    DescStr = "[$2456]",
		    Button1Str = "Yes",
		    Button2Str = "No",
		    ResponseFunc = function ( user, buttonId )
				buttonId = tonumber(buttonId)
				if( buttonId == 0 and destroyTargetObj ~= nil) then
					if(destroyTargetObj:HasEventHandler(EventType.Message,"Destroy")) then
						destroyTargetObj:SendMessage("Destroy")
					else
						destroyTargetObj:Destroy()
					end					
				end
			end
		}
	else
		this:SystemMessage("Destroying object "..tostring(target))
		if(target:HasEventHandler(EventType.Message,"Destroy")) then
			target:SendMessage("Destroy")
		else
			target:Destroy()
		end		
	end
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "destroyTarget",
	function(target,user)
		if not(IsDemiGod(this)) then return end

		if( target == nil ) then
			return
		end

		DoDestroy(target)
	end
)

function DoKick(arg)
	if( #arg >= 1) then
		local reason = ""
		if( #arg >= 2 ) then	
			-- DAB TODO: Only supports one word		
			reason = arg[2]
		end

		local playerObj = GetPlayerByNameOrId(arg[1])
		if( playerObj ~= nil ) then
			playerObj:KickUser(reason)
			
			this:SystemMessage(playerObj:GetName().." kicked from server.")
			
		end
	end	
end

function DoUserBan(arg)
	if( #arg >= 1) then
		local hours = "0"
		if( #arg >= 2 ) then	
			hours = arg[2]
		end

		local userid = arg[1]

		if( userid ~= nil and userid ~= "") then
			BanUser(userid, hours)
		end
	end	
end

function UnBanUser(userid)
	UnbanUser(userid)
end

function DoIPBan(arg)
	local ip = arg[1]

	if( ip ~= nil and ip ~= "") then
		BanIP(ip)
	end
end

function UnBanIP(ip)
	UnbanIP(ip)
end

RegisterEventHandler(EventType.GetBanListResult,"BanListResults",function(data)
		this:SystemMessage(DumpTable(data))
	end)

RegisterEventHandler(EventType.ClientTargetLocResponse, "prefab", 
	function(success,targetLoc)
		local commandInfo = GetCommandInfo("createprefab")

		if not(LuaCheckAccessLevel(this,commandInfo.AccessLevel)) then return end	

		if( success and prefabCreate) then
			CreatePrefab(prefabCreate,targetLoc,Loc(0,0,0))
			for i,point in pairs(GetRelativePrefabExtents(prefabCreate,targetLoc).Points) do
				CreateObj("house_plot_marker",Loc(point))
			end
			
		end	
	end)

campCreate = nil
RegisterEventHandler(EventType.ClientTargetLocResponse, "camp", 
	function(success,targetLoc)
		local commandInfo = GetCommandInfo("createcamp")

		if not(LuaCheckAccessLevel(this,commandInfo.AccessLevel)) then return end	

		if( success and campCreate) then
        	CreateObj("prefab_camp_controller",targetLoc,"controller_spawned", campCreate)
		end	
	end)

RegisterEventHandler(EventType.CreatedObject,"controller_spawned",
    function(success,objRef,callbackData)        
        --spawn the object and save it
        if success then
            objRef:SetObjVar("PrefabName",callbackData)
            objRef:SendMessage("Reset")
        end
    end)

function DoToggleInvuln(targetObj)
	if(targetObj == nil or not(targetObj:IsValid())) then return end

	if(targetObj:IsPlayer() and not IsImmortal(targetObj)) then
		this:SystemMessage("You cannot set a mortal player to invulnerable.")
	elseif(targetObj:HasObjVar("Invulnerable")) then
		targetObj:DelObjVar("Invulnerable")
		this:SystemMessage(targetObj:GetName().."("..tostring(targetObj.Id)..") Invulnerable Off")
	else
		targetObj:SetObjVar("Invulnerable",true)
		this:SystemMessage(targetObj:GetName().."("..tostring(targetObj.Id)..") Invulnerable On")
	end
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse,"invuln",
	function(target,user)
		DoToggleInvuln(target)
	end)

function StartPush(pushObj)
	if not(IsDemiGod(this)) then return end

	this:SendClientMessage("EditObjectTransform",{pushObj,this,"push_edit"})
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse,"setpushtarget",
	function(targetObj,user)
		if(targetObj ~= nil) then			
			StartPush(targetObj)
		end
	end)

RegisterEventHandler(EventType.Message,"PushObject",
	function (target)
		StartPush(target)
	end)

RegisterEventHandler(EventType.ClientObjectCommand, "transform",
	function (user,targetId,identifier,command,...)
		if(IsDemiGod(user) and identifier == "push_edit") then
			if(command == "confirm") then
				local targetObj = GameObj(tonumber(targetId))
				if(targetObj:IsValid()) then
					local commandArgs = table.pack(...)

					local newPos = Loc(tonumber(commandArgs[1]),tonumber(commandArgs[2]),tonumber(commandArgs[3]))
					local newRot = Loc(tonumber(commandArgs[4]),tonumber(commandArgs[5]),tonumber(commandArgs[6]))
					local newScale = Loc(tonumber(commandArgs[7]),tonumber(commandArgs[8]),tonumber(commandArgs[9]))

					targetObj:SetWorldPosition(newPos)
					targetObj:SetRotation(newRot)
					targetObj:SetScale(newScale)
				end
			end
		end		
	end)

function ShowCreateCoins()		
	local width = (#Denominations * 80) + 160
	local curX = 20

	local newWindow = DynamicWindow("CreateCoins","Create Coins",width,100,-50,-50,"","Center")

	local i = #Denominations
	while(i > 0) do
		local denomInfo = Denominations[i]
		newWindow:AddTextField(curX,20,50,20,denomInfo.Name,"0")
		newWindow:AddLabel(curX+52,25,denomInfo.Abbrev,60,0,18)
		curX = curX + 80
		i = i - 1
	end

	newWindow:AddButton(curX+10,15,"Create","Create",0,0,"","",true)

	this:OpenDynamicWindow(newWindow)
end

RegisterEventHandler(EventType.DynamicWindowResponse,"CreateCoins",
	function (user,buttonId,fieldData)
		if(buttonId == "Create") then
			amounts = {}
			for denomName,denomValStr in pairs(fieldData) do
				local denomVal = tonumber(denomValStr)
				if(denomVal ~= nil and denomVal > 0) then
					amounts[denomName] = denomVal
				end
			end
			if(CountTable(amounts) > 0) then
				CreateObjInBackpack(user,"coin_purse","coins_created",amounts)
			end
		end
	end)

RegisterEventHandler(EventType.CreatedObject,"coins_created",
	function(success,objref,amounts)
		if(success) then
			objref:SendMessage("SetCoins",amounts)
		end
	end)

function DoCreateFromFile(filename)
	io.open(filename,"r")
	local count = 1
	local depth = 1
	local parent, curItem	
	local lines = {}
	for line in io.lines(filename) do table.insert(lines,line) end
	local args = StringSplit(lines[1]," ")
	table.remove(lines,1,1)
    CreateObj(args[1],this:GetLoc(),"fromfile",lines,args[2])
end

RegisterEventHandler(EventType.CreatedObject,"fromfile",
	function (success,objRef,entries,count)
		if(count ~= nil and tonumber(count) > 1) then
			RequestSetStackCount(objRef,tonumber(count))
		end

		if(#entries > 0) then
			local line = entries[1]
			local depth = entries.depth or 1
			local _, newDepth = string.gsub(line, "%\t", "")
			
			local args = StringSplit(StringTrim(line)," ")
			table.remove(entries,1,1)

			if(newDepth <= depth) then
				if(newDepth < depth) then
					entries.depth = newDepth
					entries.parent = entries.superParent
				end

				if(entries.parent) then
					DebugMessage("Creating ",args[1]," inside ",entries.parent:GetCreationTemplateId())
					local randomLoc = GetRandomDropPosition(entries.parent)
					CreateObjInContainer(args[1], entries.parent, randomLoc, "fromfile", entries, args[2])
				else
					DebugMessage("Creating ",args[1]," inside ","Ground")
					CreateObj(args[1],this:GetLoc(),"fromfile",entries,args[2])
				end
			elseif(newDepth > depth) then
				local randomLoc = GetRandomDropPosition(objRef)
				if(entries.parent ~= nil) then
					entries.superParent = entries.parent
				end
				entries.parent = objRef
				entries.depth = newDepth
				DebugMessage("Creating ",args[1]," inside ",objRef:GetCreationTemplateId())
				CreateObjInContainer(args[1], objRef, randomLoc, "fromfile", entries, args[2])		
			end
		end
	end)


DemigodCommandFuncs = {

	Tile = function(arg)
		mTileTemplate = arg or nil
		this:AddModule("gm_tile")
	end,
	SearchDialog =	function(arg)
		ShowNewSearch(arg)
	end, 

	AddTitle = function(userNameOrId,...)
		local lineData = table.pack(...)
		if (userNameOrId ~= nil and #lineData > 0) then
			local playerObj = GetPlayerByNameOrId(userNameOrId)
			if (playerObj ~= nil) then
				local line = ""
				for i = 1,#lineData do line = line .. tostring(lineData[i]) .. " " end
				if (line ~= "") then
					CheckAchievementStatus(playerObj, "Other", line, nil, {Description = "User Title", CustomAchievement = line, Reward = {Title = line}})
				end
			end
		end
	end,

	Create = function(templateName,amount)		
		if( templateName ~= nil ) then
			templateId = GetTemplateMatch(templateName)
			if( templateId ~= nil ) then
				amount = tonumber(amount) or 0
				if( amount > 1 ) then
					if( GetTemplateObjVar(templateId,"ResourceType") ~= nil ) then
						createAmount = amount
						CreateObj(templateId, this:GetLoc(), "createamount")
						PlayEffectAtLoc("TeleportFromEffect",this:GetLoc())
						return
					end
				end

				CreateObj(templateId, this:GetLoc(), "CreateCommand")
				PlayEffectAtLoc("TeleportFromEffect",this:GetLoc())
			else
				templateListCategory = "All"
				templateListCategoryIndex = 1
				templateListFilter = templateName
				ShowPlacableTemplates()
			end
		else
			templateListFilter = ""
			ShowPlacableTemplates()
		end
	end,

	CreateEquippedObject = function(templateName, targetId)
		local target = this
		if ( targetId ~= nil ) then
			target = GameObj(tonumber(targetId))
			if ( target == nil or not target:IsValid() ) then
				target = this
			end
		end
		if ( target ~= nil and templateName ~= nil and target:IsValid() ) then
			templateId = GetTemplateMatch(templateName)
			if ( templateId ~= nil ) then
				CreateEquippedObj(templateId, target, "CreateCommand")
			end
		end
	end,

	CreatePrefab = function (prefabname)		
		if( prefabname ~= nil ) then
			prefabCreate = prefabname
			this:RequestClientTargetLoc(this, "prefab")
		end
	end,

	CreateCamp = function (campname)		
		if( campname ~= nil ) then
			campCreate = campname
			this:RequestClientTargetLoc(this, "camp")
		end
	end,

	Body = function(templateName)
		if( templateName == nil ) then
			Usage("setbody")
			return
		end

		bodyTemplateId = GetTemplateMatch(templateName)

		if( bodyTemplateId ~= nil ) then
			this:RequestClientTargetGameObj(this, "body")
		end
	end,

	ChangeForm = function(templateName)
		if(templateName ~= nil) then
			bodyTemplateId = GetTemplateMatch(templateName)

			if( bodyTemplateId ~= nil ) then
				this:RequestClientTargetGameObj(this, "form")
			end
		else
			this:AddModule("change_form_window")
		end
	end,

	CopyForm = function()
		this:SystemMessage("Which mob do you wish to copy?")
		this:RequestClientTargetGameObj(this, "copyformselect")
	end,

	Possess = function (targetObj)
		if(targetObj == nil) then			
			this:RequestClientTargetGameObj(this, "possess")
		else
			DoPossession(this,GameObj(tonumber(targetObj)))
		end
	end,

	EndPossess = function ()
		-- passing no argument returns you back to the player
		DoPossession(this)
	end,

	Tame = function(targetObj)
		if(targetObj == nil) then			
			this:RequestClientTargetGameObj(this, "tamecmd")
		else
			SetCreatureAsPet(GameObj(tonumber(targetObj)), this)
		end
	end,

	EditChar = function(targetObj)
		if(targetObj == nil) then			
			this:RequestClientTargetGameObj(this, "editchar")
		else
			OpenCharEditWindow(targetObj)
		end
	end,

	Scale = function(scaleValue)
		if( scaleValue == nil ) then
			Usage("setscale")
			return
		end

		newScale = tonumber(scaleValue)

		if( newScale ~= nil ) then
			this:RequestClientTargetGameObj(this, "scale")
		end
	end,

	Color = function(colorcode)
		if( colorcode == nil ) then
			Usage("SetColor")
			return
		end

		newColor = colorcode

		this:RequestClientTargetGameObj(this, "color")
	end,

	Hue = function(hueindex)
		if( hueindex == nil ) then
			Usage("SetHue")
			return
		end

		newHue = tonumber(hueindex)

		this:RequestClientTargetGameObj(this, "hue")
	end,

	Info = function(targetObjId)
		if(targetObjId ~= nil) then
			gameObj = GameObj(tonumber(targetObjId))
			if(gameObj:IsValid()) then
				DoInfo(gameObj)
				return
			else
				this:SystemMessage(tostring(targetObjId).." is not a valid id. Object does not exist.")
			end
		end
		this:RequestClientTargetGameObj(this, "info")		
	end,

	GlobalVar = function(recordPath)
		local results = GlobalVarListRecords(recordPath)
		if(#results == 1) then
			ShowGlobalVar(results[1])
		else
			ListGlobalVars(results)
		end
	end,

	DeleteGlobalVar = function (recordPath)
		recordPath = recordPath or ""
		local results = GlobalVarListRecords(recordPath)
		if(#results > 0) then
			local varStr = ""
			for i, varName in pairs(results) do 
				varStr = varStr .. varName .. "\n"
			end

			ClientDialog.Show{
				    TargetUser = this,
				    DialogId = "DeleteVarsDialog",
				    TitleStr = "Are you sure?",
				    DescStr = "[$2460]"..varStr,
				    Button1Str = "Yes",
				    Button2Str = "No",
				    ResponseFunc = function ( user, buttonId )
						buttonId = tonumber(buttonId)
						if( buttonId == 0) then				
							for i, varName in pairs(results) do 
								GlobalVarDelete(varName,nil)
							end
							this:SystemMessage("Deleted "..#results.." records.")
						else
							this:SystemMessage("Cancelled")
						end
					end
				}
		else
			this:SystemMessage("No matching records")
		end
	end,

	Debug = function(targetObjId)
		if(args ~= nil) then
			gameObj = GameObj(tonumber(targetObjId))
			if(gameObj:IsValid()) then
				gameObj:SetObjVar("Debug",true)
				DebugMessage(gameObj:GetName().."-----------------------------------")
				return
			end
		end
		this:RequestClientTargetGameObj(this, "debug")		
	end,
	AIState = function(targetObjId)
		if(args ~= nil) then
			gameObj = GameObj(tonumber(targetObjId))
			if(gameObj:IsValid()) then
				DebugMessage("State is "..gameObj:GetObjVar("CurrentState"))
				this:SystemMessage("State is "..gameObj:GetObjVar("CurrentState"))
				return
			end
		end
		this:RequestClientTargetGameObj(this, "aistate")		
	end,

	Resurrect = function(forceOrTargetId, targetObjId)
		local force = false
		local targetId = forceOrTargetId
		if ( forceOrTargetId == "force" ) then
			force = true
			targetId = targetObjId
		end

		if ( targetId == nil ) then
			if ( force ) then
				this:RequestClientTargetGameObj(this, "resTargetForce")
			else
				this:RequestClientTargetGameObj(this, "resTarget")
			end
			return
		end

		local gameObj = this
		if( targetId ~= "self" ) then
			gameObj = GameObj(tonumber(targetId))
		end

		if( gameObj == nil or not(gameObj:IsValid()) ) then
			return
		end

		gameObj:SendMessage("Resurrect",1.0,this,force)
	end,

	ResurrectAll = function (force)
		for i,playerObj in pairs(FindObjects(SearchPlayerInRange(25))) do
			playerObj:SendMessage("Resurrect",1.0,this,force=="force")
		end
	end,

	Heal = function()				
		this:RequestClientTargetGameObj(this, "healTarget")
	end,

	Slay = function(targetObjId)
		if(targetObjId == nil) then
			this:RequestClientTargetGameObj(this, "slayTarget")
			return
		end

		local gameObj = this
		if( targetObjId ~= "self" ) then
			gameObj = GameObj(tonumber(targetObjId))
		end

		DoSlay(gameObj)
	end,

	Nuke = function(targets,userRadius)		
		local includePlayers = false
		local radius = 10
		
		if( targets == "all" ) then
			includePlayers = true
		end
					
		if( userRadius ~= nil ) then
			radius = tonumber(userRadius)
		end				

		local killObjects = FindObjects(SearchMobileInRange(radius))
		if( killObjects ~= nil ) then			
			for index, obj in pairs(killObjects) do
				if( not(obj:IsPlayer() or obj:GetCreationTemplateId() == "wave_target" or (obj:GetObjVar("controller") ~= nil and obj:GetObjVar("controller"):IsPlayer())) or includePlayers) then										
					obj:SendMessage("ProcessTrueDamage", this, 5000, true)
					obj:PlayEffect("LightningCloudEffect")
				end
			end
		end
	end,

	Freeze = function()
		if(targetObjId == nil) then
			this:RequestClientTargetGameObj(this, "freezeTarget")
			return
		end

		local gameObj = this
		if( targetObjId ~= "self" ) then
			gameObj = GameObj(tonumber(targetObjId))
		end

		DoFreeze(gameObj)
	end,	

	SetStat = function(...)
		local arg = table.pack(...)
		if(#arg < 2) then 
			Usage("setstat")
			return
		end
		local myStat = arg[1]
		local myVal = tonumber(arg[2])
		local myTarg = this
		if not (arg[3] == nil) then
			local objId = arg[3]
			local targObj = GameObj(tonumber(objId))
			if(targObj == nil) or not(targObj:IsValid()) then
				this:SystemMessage("[F7CC0A] Invalid Set Target")
				return
			end
			myTarg = targObj
		end
		
		if( string.lower(myStat) == "hp" ) then
			--DebugMessage("SETTING TO "..myVal)
			SetCurHealth(myTarg,myVal)
		elseif(string.lower(myStat) == "mana" ) then
			SetCurMana(myTarg,myVal)
		elseif( string.lower(myStat) == "sta") then
			SetCurStamina(myTarg,myVal)
		elseif( string.lower(myStat) == "vit" ) then
			SetCurVitality(myTarg,myVal)
		-- else its a base stat
		else
			local mySname =string.sub(myStat,2)
			local mySstart = string.sub(myStat,1,1)
			myStat = string.upper(mySstart) .. string.lower(mySname)

			if(myVal <= ServerSettings.Stats.IndividualPlayerStatCap) and (myVal >= ServerSettings.Stats.IndividualStatMin) then
				local myMaxVal = GetStatCap(myTarg) - (GetTotalStats(myTarg) - myTarg:GetStatValue(myStat))
				DebugMessage(myStat,myVal,myMaxVal)
				SetStatByName(myTarg,myStat, math.min(myVal,myMaxVal))
				if (myVal > myMaxVal) then
					this:SystemMessage("[FA0C0C]Entered value exceeds maximum stat cap.[-]")
				end
				this:SystemMessage("[F7CC0A] Set " ..myTarg:GetName() .. " "..myStat.. " to " ..math.min(myVal,myMaxVal))
			else
				this:SystemMessage("Stat Range Must be between "..ServerSettings.Stats.IndividualStatMin.." and "..ServerSettings.Stats.IndividualPlayerStatCap)
			end
		end
	end,

	SetSkill = function(...)		
		local arg = table.pack(...)
		if(#arg < 2) then 
			Usage("setskill")
			return
		end
		local mySkill = arg[1]
		local myVal = tonumber(arg[2])
		local myTarg = this

		if not (arg[3] == nil) then
			local objId = tonumber(arg[3])
			if (type(objId) ~= "number") then return end
			local targObj = GameObj(objId)
			if(targObj == nil) or not(targObj:IsValid()) then
				this:SystemMessage("[F7CC0A]Invalid Set Target[-]")
				return
			end
			myTarg = targObj
		end
		local mySname =string.sub(mySkill,2)
		local mySstart = string.sub(mySkill,1,1)
		skillName = string.upper(mySstart) .. mySname .. "Skill"
		if(IsValidSkill(skillName)) then
			if(tostring(myVal) == "?") then
				local myLev = GetSkillLevel(myTarg,skillName)
				this:SystemMessage(myTarg:GetName() .. " " .. skillName .. " : " .. myLev.."[-]")
				return
			end
			SetSkillLevel(myTarg, skillName, myVal, false)
			if not (myTarg == nil) then
				this:SystemMessage("[F7CC0A]Set ".. myTarg:GetName().. " " .. skillName .. " to " .. myVal.."[-]")
			end
		else
			this:SystemMessage("[F7CC0A]Invalid Skill Set Request : (" .. skillName .. ")[-]")
		end
	end,

	SetAllSkills = function(...)		
		local arg = table.pack(...)
		if(#arg < 1) then 
			Usage("setallskills")
			return
		end
		local myVal = tonumber(arg[1])
		local myTarg = this
		if ( arg[2] ) then
			local objId = tonumber(arg[2])
			if (type(objId) ~= "number") then return end
			local targObj = GameObj(objId)
			if(targObj == nil) or not(targObj:IsValid()) then
				this:SystemMessage("[F7CC0A]Invalid Set Target[-]")
				return
			end
			myTarg = targObj
		end
		local skillDictionary = {}
		for name,data in pairs(SkillData.AllSkills) do
			skillDictionary[name] = {
				SkillLevel = myVal
			}
		end
		SetSkillDictionary(myTarg, skillDictionary)
		myTarg:SystemMessage("All skills set to "..myVal, "event")
	end,

	CreateCoins = function(...)
		local arg = table.pack(...)

		if(#arg > 0) then
			local coinAmount = tonumber(arg[1])
			if (coinAmount == nil) then return end
			if(coinAmount <= 0 ) then return end			

			CreateStackInBackpack(this,"coin_purse",coinAmount)
		else
			ShowCreateCoins()
		end
	end,

	SetName = function(...)
		local arg = table.pack(...)
		if( #arg == 0 ) then
			Usage("setname")
			return
		end

		local name = ""
		for i = 1,#arg do name = name .. tostring(arg[i]) .. " " end
		nameToSet = name

		if( nameToSet ~= nil ) then
			this:RequestClientTargetGameObj(this, "setname")
		end
	end,

	Destroy = function(objId)
		if( objId ~= nil ) then
			local target = GameObj(tonumber(objId))
			DoDestroy(target)
		else
			this:RequestClientTargetGameObj(this, "destroyTarget")
		end
	end,

	KickUser = function(...)
		local arg = table.pack(...)
		if( #arg == 0 ) then Usage("kickuser") return end

		DoKick(arg)		
	end,

	LuaBanUser = function(...)
		local arg = table.pack(...)
		if( #arg == 0 ) then Usage("banuser") return end

		DoUserBan(arg)		
	end,

	LuaUnbanUser = function(userId)
		if(userId ~= nil and userId ~= "") then
			UnBanUser(userId)
		else
			Usage("unbanuser")	
		end
	end,

	LuaBanIP = function(...)
		local arg = table.pack(...)
		if( #arg == 0 ) then Usage("banip") return end

		DoIPBan(arg)		
	end,

	LuaUnbanIP = function(ip)
		if(ip ~= nil and ip ~= "") then
			UnBanIP(ip)
		else
			Usage("unbanip")	
		end
	end,

	LuaClearBans = function()
		ClearBans();
	end,

	LuaGetBans = function()
		GetBans("BanListResults");
	end,

		Broadcast = function(...)
		local line = CombineArgs(...)
		if(line ~= nil) then
			ServerBroadcast(line,true)
		else
			Usage("broadcast")
		end
	end,

	LocalBroadcast = function(...)
		local line = CombineArgs(...)
		if(line ~= nil) then
			local loggedOnUsers = FindPlayersInRegion()
			for index,object in pairs(loggedOnUsers) do
				object:SystemMessage(line,"event")
			end
		else
			Usage("localbroadcast")
		end
	end,

	PushObject = function(id)
		if(id ~= nil) then
			local pushObj = GameObj(tonumber(id))
			StartPush(pushObj)
		end
		this:RequestClientTargetGameObj(this, "setpushtarget")
	end,

	TeleportPlayer = function(nameOrId)
		if( nameOrId ~= nil) then		
			local playerObj = GetPlayerByNameOrId(nameOrId)
			if( playerObj ~= nil ) then
				playerObj:SetWorldPosition(this:GetLoc())
				playerObj:PlayEffect("TeleportToEffect")
			end
		else
			Usage("teleportplayer")
		end
	end,

	OpenContainer = function(nameOrId,equipSlot)
		if( nameOrId ~= nil) then
			if( equipSlot == nil ) then equipSlot = "Backpack" end

			local objRef = GetPlayerByNameOrId(nameOrId)
			if( objRef ~= nil ) then
				if(equipSlot == "Self" or equipSlot == "self") then
					objRef:SendOpenContainer(this)
				elseif( objRef:IsPlayer() ) then
					local contObj = objRef:GetEquippedObject(equipSlot)
					if( contObj ~= nil and contObj:IsContainer() ) then
						contObj:SendOpenContainer(this)
					end
				elseif( objRef:IsContainer() ) then
					objRef:SendOpenContainer(this)
				end
			end
		else
			this:RequestClientTargetGameObj(this, "container")	
		end
	end,

	ContainerInfo = function (id,arg)
		if(id == "all") then
			local containerSizes = {}
			for i,containerObj in pairs(FindObjects(SearchSharedObjectProperty("Capacity",nil))) do
				local count = containerObj:GetItemCount()
				table.insert(containerSizes,{Obj=containerObj,Count = count})
			end

			table.sort(containerSizes,function(a,b)
					return a.Count > b.Count
				end)

			for i=1,50 do
				if(#containerSizes >= i) then
					local objRef = containerSizes[i].Obj
					this:SystemMessage("Container "..objRef:GetName().." ("..objRef.Id..") contains "..containerSizes[i].Count.." items.")
				end
			end
			this:SystemMessage("Total World Containers: "..#containerSizes)
		else
			local objRef = GameObj(tonumber(id))
			if(objRef ~= nil and objRef:IsValid()) then
				local count = objRef:GetItemCount()
				this:SystemMessage("Container "..objRef:GetName().." contains "..count.." items.")
			else
				this:SystemMessage("Container not found. Must pass id!")
			end
		end
	end,

	CreateFromFile = function(filename)
		DoCreateFromFile(filename)
	end,

	SetTime = function(newTime)
		local timeController = GetTimeController()
		if( timeController == nil ) then return end
		--DebugMessage("Time Controller is not nil")
		if( newTime == nil or not timeController:IsValid() ) then 
			DebugMessage("[SetTime] ERROR: NEW TIME IS NIL")
			return 
		end

		local colonLoc = newTime:find(":")
		if(colonLoc ~= nil ) then
			--DebugMessage("Sending time update message")
			local hours = newTime:sub(1,colonLoc-1)
			local minutes = newTime:sub(colonLoc+1,#newTime)
			timeController:SendMessage("SetTime",hours,minutes)
		end
	end,

	KickAll = function(...)
		local arg = table.pack(...)
		local reason = ""
		if( #arg >= 1 ) then
			-- DAB TODO: Only supports one word
			reason = arg[1]
		end

		local loggedOnUsers =  FindPlayersInRegion()
		for index,object in pairs(loggedOnUsers) do
			if not( IsImmortal(object) ) then
				this:SystemMessage(object:GetName().." kicked from server.")
				object:KickUser(reason)
			end
		end
	end,

	Nearby = function()
		local nearbyObjects = FindObjects(SearchObjectInRange(20))
		for i,nearbyObject in pairs(nearbyObjects) do
			this:SystemMessage(nearbyObject:GetCreationTemplateId() .. ": " .. nearbyObject.Id)
		end
	end,

	ToggleInvuln = function(targetId)
		if(targetId ~= nil) then
			local targetObj = nil
			if(targetId == 'self') then
				targetObj = this
			else
				targetObj = GameObj(tonumber(targetId))
			end

			DoToggleInvuln(targetObj)
		else
			this:RequestClientTargetGameObj(this,"invuln")
		end
	end,

	CreateCustom = function()
		OpenCreateCustomWindow()
	end,
	
	GmMessage = function()
		if not(this:HasModule("gm_message_window")) then
            this:AddModule("gm_message_window")        
        end
	end,

	AllegianceRemove = function(id)
		if not( id ) then
			Usage("removeallegiance")
			return
		end
		local targetObj = GameObj(tonumber(id))
		if ( targetObj and targetObj:IsValid() ) then
			AllegianceRemovePlayer(targetObj)
		end
	end,
}
RegisterCommand{ Command="tile", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Tile, Usage="[<target_id|self>]", Desc="Tile a thing" }
RegisterCommand{ Command="invuln", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.ToggleInvuln, Usage="[<target_id|self>]", Desc="Toggle invulnerability", Aliases={"inv"} }
RegisterCommand{ Command="create", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Create, Usage="[<template>]", Desc="[$2478]" }
RegisterCommand{ Command="createequippedobject", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.CreateEquippedObject, Usage="<template> [<targetid]", Desc="Created the object as an equipped object on the target." }
RegisterCommand{ Command="createprefab", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.CreatePrefab, Usage="<prefabname>", Desc="Create a prefab object of the specified name", Aliases={"createp"}}
RegisterCommand{ Command="createcamp", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.CreateCamp, Usage="<campname>", Desc="Create a camp prefab of the specified name", Aliases={"createc"}}
RegisterCommand{ Command="destroy", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Destroy, Usage="[<target_id>]", Desc="[$2479]" }
RegisterCommand{ Command="resurrect", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Resurrect, Desc="[$2480]", Aliases={"res"} }
RegisterCommand{ Command="resall", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.ResurrectAll, Usage="[force]", Desc="[$2481]" }
RegisterCommand{ Command="heal", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Heal, Desc="Completely heal an object. Gives cursor" }
RegisterCommand{ Command="slay", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Slay, Desc="Instantly kill any mobile. Gives cursor" }	
RegisterCommand{ Command="nuke", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Nuke, Usage="[<all|npc>] [<radius>]", Desc="Instantly kill all mobiles in a radius around you." }
RegisterCommand{ Command="freeze", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Freeze, Desc="Freeze/Unfreeze a mobile in place."}
RegisterCommand{ Command="createcoins", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.CreateCoins, Usage="<amount>", Desc="Create a bag of coins in your backpack" }
RegisterCommand{ Command="teleportplayer", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.TeleportPlayer, Usage="<name|id>", Desc="Teleport a player to your location", Aliases={"tp"}}	
RegisterCommand{ Command="broadcast", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Broadcast, Usage="<message>", Desc="Send a message to every player on the server", Aliases={"bcast"}}	
RegisterCommand{ Command="localbroadcast", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.LocalBroadcast, Usage="<message>", Desc="Send a message to every player on this server region", Aliases={"localbcast"}}	
RegisterCommand{ Command="push", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.PushObject, Desc="[$2482]"}	
RegisterCommand{ Command="settime", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.SetTime, Usage="<newtime>", Desc="Sets the current game time (24 hour format)" }
RegisterCommand{ Command="addtitle", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.AddTitle, Usage="<name|id> <title>", Desc="Grant a title to a player" }
RegisterCommand{ Command="kickuser", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.KickUser, Usage="<name|id> [<reason>]", Desc="Kick the user off the shard" }
RegisterCommand{ Command="kickall", Category = "God Power", AccessLevel = AccessLevel.God, Func=DemigodCommandFuncs.KickAll, Usage="[<reason>]", Desc="Kick every user off the shard" }
RegisterCommand{ Command="banuser", Category = "God Power", AccessLevel = AccessLevel.God, Func=DemigodCommandFuncs.LuaBanUser, Usage="<userid> [<hours>]", Desc="Bans the user off the shard. Specify hours for temporary bans." }
RegisterCommand{ Command="unbanuser", Category = "God Power", AccessLevel = AccessLevel.God, Func=DemigodCommandFuncs.LuaUnbanUser, Usage="<userid>", Desc="Unbans a user from the shard" }
RegisterCommand{ Command="banip", Category = "God Power", AccessLevel = AccessLevel.God, Func=DemigodCommandFuncs.LuaBanIP, Usage="<ip address> [<hours>]", Desc="Bans an ip address from the shard, support * wildcards. Specify hours for temporary bans" }
RegisterCommand{ Command="unbanip", Category = "God Power", AccessLevel = AccessLevel.God, Func=DemigodCommandFuncs.LuaUnbanIP, Usage="<ip address>", Desc="Unbans an ip address from the shard, must match exactly a previously banned ip address" }
RegisterCommand{ Command="clearbans", Category = "God Power", AccessLevel = AccessLevel.God, Func=DemigodCommandFuncs.LuaClearBans, Desc="Clears all bans from the server." }
RegisterCommand{ Command="getbans", Category = "God Power", AccessLevel = AccessLevel.God, Func=DemigodCommandFuncs.LuaGetBans, Desc="Returns a list of all active server bans, and their durations." }
RegisterCommand{ Command="info", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Info, Desc="Get information about an object. Gives cursor" }	
RegisterCommand{ Command="globalvar", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.GlobalVar, Usage = "<globalvarpath>", Desc="[$2485]" }	
RegisterCommand{ Command="deleteglobalvar", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.DeleteGlobalVar, Usage = "<globalvarpath>", Desc="Deletes any global variable that matches the path." }	
RegisterCommand{ Command="search", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.SearchDialog, Usage = "<name>", Desc="[$2486]" }		
RegisterCommand{ Command="debug", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Debug, Desc="Sets an object to debug. Gives cursor" }	
RegisterCommand{ Command="aistate", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.AIState, Desc="Gets the current state of an object. Gives cursor" }	
RegisterCommand{ Command="copyform", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.CopyForm, Usage="", Desc="[$2487]" }
RegisterCommand{ Command="possess", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Possess, Desc="Possess a target mobile." }
RegisterCommand{ Command="endpossess", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.EndPossess, Desc="Possess a target mobile." }
RegisterCommand{ Command="tame", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Tame, Desc="Tame a mobile." }
RegisterCommand{ Command="editchar", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.EditChar, "Opens a window that allows you to alter skill/stat values" }
RegisterCommand{ Command="setname", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.SetName, Usage="<name>", Desc="[$2488]" }
RegisterCommand{ Command="setbody", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Body, Usage="<template>", Desc="[$2489]" }
RegisterCommand{ Command="changeform", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.ChangeForm, Usage="<template>", Desc="[$2490]" }
RegisterCommand{ Command="setscale", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Scale, Usage="<scale_multiplier>", Desc="Set the scale of a mobile. Gives you a cursor" }
RegisterCommand{ Command="setcolor", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Color, Usage="<colorcode>", Desc="[$2491]" }	
RegisterCommand{ Command="sethue", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Hue, Usage="<hueindex>", Desc="Set an object's hue via color replacement from the client hue table." }	
RegisterCommand{ Command="setstat", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.SetStat, Usage="<hp|mana|sta|str|agi|int> <value> [<target_id>]", Desc="[$2492]" }
RegisterCommand{ Command="setskill", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.SetSkill, Usage="<skill_name> <value> [<target_id>]", "[$2494]" }
RegisterCommand{ Command="setallskills", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.SetAllSkills, Usage="<value> [<target_id>]", "Set all skills to a level." }

RegisterCommand{ Command="setspeed", AccessLevel = AccessLevel.DemiGod, Func=function(speed) speed = tonumber(speed); if (speed > 4) then speed = 4 end; SetMobileMod(this, "MoveSpeedPlus", "GodCommand", speed)  end, Desc="Add the number given to your movement speed (0.1-4). If no speed is provided, it will remove the modifer." }

RegisterCommand{ Command="opencontainer", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.OpenContainer, Usage="<name|id> [<equipslot>]", Desc="[$2495]", Aliases={"opencont"}}	
RegisterCommand{ Command="containerinfo", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.ContainerInfo, Usage="<id> [detailed]", Desc="[$2496]"}	
RegisterCommand{ Command="createfromfile", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.CreateFromFile, Usage="filenamee", Desc="[$2499]"}	
RegisterCommand{ Command="nearby", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.Nearby, Desc="[$2503]" }
RegisterCommand{ Command="removeallegiance", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.AllegianceRemove, Usage="<id>", Desc="Remove a player by id from their allegiance, if they are in one." }
RegisterCommand{ Command="createcustom", Category = "Dev Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.CreateCustom, Desc="[DEBUG COMMAND] Create a custom object by it's art asset ID (Note: this should not be use to create game items since the game relies on the template name)" }
RegisterCommand{ Command="msg", Category = "God Power", AccessLevel = AccessLevel.DemiGod, Func=DemigodCommandFuncs.GmMessage, Desc="Send GM message to user"}
