require 'incl_packed_object'
require 'incl_keyhelpers'
require 'incl_player_group'
require 'incl_player_guild'

MAX_LOCK_COUNT = 45

-- current deco target
decoObj = nil
-- fine tuning placement modifier
multiplier = 1
-- does the house owner have his deco window open
controlWindowOpen = false
decoWindowOpen = false

--Warn the player after decay time, delete it after delete time has passed
DEFAULT_DECAY_TIME = TimeSpan.FromHours(408)
DEFAULT_DELETE_TIME = TimeSpan.FromHours(480)
HouseClassDecayTimes = 
{
--[[{Template = "stone_house_tuscan_east", DecayTime = TimeSpan.FromHours(192), DeleteTime = TimeSpan.FromHours(240)},
{Template = "stone_house_tuscan_south", DecayTime = TimeSpan.FromHours(192), DeleteTime = TimeSpan.FromHours(240)},
{Template = "stone_house_estate_west", DecayTime = TimeSpan.FromHours(192), DeleteTime = TimeSpan.FromHours(240)},
{Template = "stone_house_estate_south", DecayTime = TimeSpan.FromHours(192), DeleteTime = TimeSpan.FromHours(240)},
{Template = "stone_house_villa_west", DecayTime = TimeSpan.FromHours(192), DeleteTime = TimeSpan.FromHours(240)},
{Template = "stone_house_villa_south", DecayTime = TimeSpan.FromHours(192), DeleteTime = TimeSpan.FromHours(240)},
{Template = "tudor_house_estate_west", DecayTime = TimeSpan.FromHours(192), DeleteTime = TimeSpan.FromHours(240)},
{Template = "tudor_house_estate_south", DecayTime = TimeSpan.FromHours(192), DeleteTime = TimeSpan.FromHours(240)},
{Template = "tudor_house_manor_west", DecayTime = TimeSpan.FromHours(192), DeleteTime = TimeSpan.FromHours(240)},
{Template = "tudor_house_manor_south", DecayTime = TimeSpan.FromHours(192), DeleteTime = TimeSpan.FromHours(240)},
{Template = "tudor_house_east", DecayTime = TimeSpan.FromHours(96), DeleteTime = TimeSpan.FromHours(120)},
{Template = "tudor_house_south", DecayTime = TimeSpan.FromHours(96), DeleteTime = TimeSpan.FromHours(120)},
{Template = "stone_house_cottage_east", DecayTime = TimeSpan.FromHours(96), DeleteTime = TimeSpan.FromHours(120)},
{Template = "stone_house_cottage_south", DecayTime = TimeSpan.FromHours(96), DeleteTime = TimeSpan.FromHours(120)},
{Template = "stone_house_blacksmith_east", DecayTime = TimeSpan.FromHours(96), DeleteTime = TimeSpan.FromHours(120)},
{Template = "stone_house_blacksmith_south", DecayTime = TimeSpan.FromHours(96), DeleteTime = TimeSpan.FromHours(120)},
{Template = "tudor_house_birch_east", DecayTime = TimeSpan.FromHours(96), DeleteTime = TimeSpan.FromHours(120)},
{Template = "tudor_house_birch_south", DecayTime = TimeSpan.FromHours(96), DeleteTime = TimeSpan.FromHours(120)},
{Template = "tudor_house_mahogany_east", DecayTime = TimeSpan.FromHours(96), DeleteTime = TimeSpan.FromHours(120)},
{Template = "tudor_house_mahogany_south", DecayTime = TimeSpan.FromHours(96), DeleteTime = TimeSpan.FromHours(120)},
{Template = "tudor_house_oak_east", DecayTime = TimeSpan.FromHours(96), DeleteTime = TimeSpan.FromHours(120)},
{Template = "tudor_house_oak_south", DecayTime = TimeSpan.FromHours(96), DeleteTime = TimeSpan.FromHours(120)},
{Template = "wood_house_cottage_east", DecayTime = TimeSpan.FromHours(72), DeleteTime = TimeSpan.FromHours(96)},
{Template = "wood_house_cottage_south", DecayTime = TimeSpan.FromHours(72), DeleteTime = TimeSpan.FromHours(96)},]]--
--Make sure to change this back to hours
{Template = "wood_house_south", DecayTime = TimeSpan.FromHours(144), DeleteTime = TimeSpan.FromHours(168)},
{Template = "wood_house_east", DecayTime = TimeSpan.FromHours(144), DeleteTime = TimeSpan.FromHours(168)},
}

--Note this function uses nasty C# code.
--the bane of players
function CheckDecay()	
	this:ScheduleTimerDelay(TimeSpan.FromMinutes(5) + TimeSpan.FromMilliseconds(math.random(1,20000)),"CheckDecay")

	--DebugMessage("Firing")
	if (this:HasObjVar("NoDecay") or this:HasObjVar("VacationMode")) then return end

	if not(this:HasObjVar("LastVisitedTime")) then 
		this:SetObjVar("LastVisitedTime",DateTime.UtcNow:ToString())
	end
	local currentTimeStampStr = this:GetObjVar("LastVisitedTime") or DateTime.UtcNow:ToString()
	local currentTimeStamp = DateTime.Parse(currentTimeStampStr)
	
	local houseObj = this:GetObjVar("HouseObject")
	if(houseObj == nil or not(houseObj:IsValid())) then
		DebugMessage("ERROR: [house_control] House control object has no associated house!",tostring(this.Id))
		--ForceHouseDestroy()
		this:RemoveTimer("CheckDecay")
		return
	end
	local template = houseObj:GetCreationTemplateId()

	local DecayTime = DEFAULT_DECAY_TIME
	local DeleteTime = DEFAULT_DELETE_TIME

	--DebugMessage("Template is "..tostring(template))
	local houseTemplateEntry = nil
	for i,j in pairs(HouseClassDecayTimes) do
		if (j.Template == template) then
			houseTemplateEntry = j
		end
	end

	if (houseTemplateEntry ~= nil) then
		DecayTime = houseTemplateEntry.DecayTime
		DeleteTime = houseTemplateEntry.DeleteTime
	end

	local TimeToDecay = currentTimeStamp:Add(DecayTime)
	local TimeToDestroy = currentTimeStamp:Add(DeleteTime)

	-- optionally override the decay and destroy time in objvars
	if(this:HasObjVar("DecayTime")) then
		TimeToDecay = DateTime.Parse(this:GetObjVar("DecayTime"))
	end
	if(this:HasObjVar("DestroyTime")) then
		TimeToDestroy = DateTime.Parse(this:GetObjVar("DestroyTime"))
	end
	
	local owner = this:GetObjVar("Owner")
	--DebugMessage("Destroy EST: "..TimeToDestroy:ToString())
	--DebugMessage("Now:".. DateTime.UtcNow:ToString())
	if (TimeToDestroy:CompareTo(DateTime.UtcNow) < 0) then
		DebugMessage("INFO: [house_control] Autodestroying House",tostring(this.Id),template)

		--DebugMessage("Id = "..tostring(this.Id))
		ForceHouseDestroy()	
		if(owner ~= nil and owner:IsValid()) then
			owner:SystemMessage("[D70000]Your house has been destroyed![-]")
		end
	elseif (TimeToDecay:CompareTo(DateTime.UtcNow) < 0) then
		if(owner ~= nil and owner:IsValid()) then
			--DebugMessage("Decay EST:".. TimeToDecay:ToString())
			--DebugMessage("Now:".. DateTime.UtcNow:ToString())
			
			ClientDialog.Show{
			    TargetUser = owner,
			    DialogId = "",
			    TitleStr = "WARNING",
			    DescStr = "[$1824]"..TimeToDestroy:ToString().." UTC time then you will lose your house!",
			    Button1Str = "OK",
			    ResponseFunc = function( user, buttonId ) end
			}
		end
		SetTooltipEntry(this,"decay","[FF0000]*In Decay*[-]")
	else
		RemoveTooltipEntry(this,"decay","[FF0000]*In Decay*[-]")
	end
end

function OnLoad()
	local housePlot = GetHouseControlPlot(this)
	if(housePlot ~= nil) then		
		AddView("MobsInPlot",SearchMulti({
			SearchRect(housePlot),
			SearchMobile()
		}),2.0)
	end
end

selectedTab = "Manage"
function ShowControlWindow(user)
	local controlWindow = DynamicWindow("HouseControl",StripColorFromString(this:GetName()),350,334,0,0,"")

	AddTabMenu(controlWindow,
	{
        ActiveTab = selectedTab, 
        Buttons = {
			{ Text = "Manage" },
			{ Text = "Decorate" },
        }
    })	

	controlWindow:AddImage(8,32,"BasicWindow_Panel",314,244,"Sliced")
	if(selectedTab == "Manage") then
		ShowOptionsTab(controlWindow)
	elseif(selectedTab == "Decorate") then
		ShowDecorateTab(controlWindow)
	end
	
	user:OpenDynamicWindow(controlWindow,this)

	controlWindowOpen = true
end

function ShowOptionsTab(controlWindow)
	controlWindow:AddLabel(24,52,"Name: "..this:GetName(),0,0,18)
	controlWindow:AddButton(20,80,"Rename","Rename",290,26,"Max 20 characters","",false,"List")
	controlWindow:AddButton(20,106,"Destroy","Destroy",290,26,"Destroy this home.","",false,"List")	
	controlWindow:AddButton(20,132,"HouseKey","Change House Locks",290,26,"[$1825]","",false,"List")	
	controlWindow:AddButton(20,158,"RekeyContainer","Change Container Lock",290,26,"[$1826]","",false,"List")	
	controlWindow:AddButton(20,184,"Transfer","Transfer Ownership",290,26,"Opens a secure trade transaction containing the deed to the house.","",false,"List")	
end

decorateButtonSprites = 
{
	East = {"HouseDecorationWindow_EastButtonDefault","HouseDecorationWindow_EastButtonHover","HouseDecorationWindow_EastButtonClick"},
	North = {"HouseDecorationWindow_NorthButtonDefault","HouseDecorationWindow_NorthButtonHover","HouseDecorationWindow_NorthButtonClick"},
	South = {"HouseDecorationWindow_SouthButtonDefault","HouseDecorationWindow_SouthButtonHover","HouseDecorationWindow_SouthButtonClick"},
	West = {"HouseDecorationWindow_WestButtonDefault","HouseDecorationWindow_WestButtonHover","HouseDecorationWindow_WestButtonClick"},
	RotateCW = {"HouseDecorationWindow_RotateCW_Default","HouseDecorationWindow_RotateCW_Hover","HouseDecorationWindow_RotateCW_Click"},
	RotateCCW = {"HouseDecorationWindow_RotateCCW_Default","HouseDecorationWindow_RotateCCW_Hover","HouseDecorationWindow_RotateCCW_Click"},	
	Blank = {"HouseDecorationWindow_Button_Default","HouseDecorationWindow_Button_Hover","HouseDecorationWindow_Button_Click"}
}

function ShowDecorateTab(controlWindow)	
	local targetName = "No Target"
	local iconId = nil
	local iconHue = nil
	if(decoObj ~= nil) then
		targetName = decoObj:GetName()
		iconId = decoObj:GetIconId()
		iconHue = decoObj:GetColor()
	end

	targetName = ShortenColoredString(targetName,20)
	
	controlWindow:AddLabel(20,52,"Set Target:",0,0,18)
	controlWindow:AddImage(100,46,"TextFieldChatUnsliced",210,30,"Sliced")
	controlWindow:AddLabel(110,52,targetName,170,20,18)

	controlWindow:AddButton(284,49,"SetDecoTarget","",0,0,"Select an item to arrange.","",false,"Plus")

	controlWindow:AddLabel(80,80,"Height",80,0,16,"center")
	controlWindow:AddButton(50,100,"PushUp","",0,0,"Push an item a little up in the air.","",false,"UpButtonSquare")
	controlWindow:AddButton(85,100,"PushDown","",0,0,"Push an item a little down towards the ground.","",false,"DownButtonSquare")

	controlWindow:AddLabel(80,130,"Rotation",80,0,16,"center")
	controlWindow:AddButton(50,150,"RotCCW","",0,0,"Rotate counter-clockwise.","",false,"","",decorateButtonSprites.RotateCCW)
	controlWindow:AddButton(85,150,"RotCW","",0,0,"Rotate clockwise.","",false,"","",decorateButtonSprites.RotateCW)

	controlWindow:AddLabel(80,180,"Move Speed",80,0,16,"center")
	local multiplierStr = "x"..multiplier
	controlWindow:AddButton(60,200,"Multiplier",multiplierStr,40,0,"[$1827]","",false,"","",decorateButtonSprites.Blank)

	controlWindow:AddImage(157,105,"TextFieldChatUnsliced",94,94,"Sliced")
	if(iconId ~= nil) then
		controlWindow:AddImage(172,122,tostring(iconId),0,0,"Object",iconHue)
	end

	controlWindow:AddButton(180,80,"PushNorth","",0,0,"Push an item a little towards the North.","",false,"","",decorateButtonSprites.North)
	controlWindow:AddButton(180,200,"PushSouth","",0,0,"Push an item a little towards the South.","",false,"","",decorateButtonSprites.South)
	controlWindow:AddButton(132,126,"PushWest","",0,0,"Push an item a little towards the West.","",false,"","",decorateButtonSprites.West)
	controlWindow:AddButton(250,126,"PushEast","",0,0,"Push an item a little towards the East.","",false,"","",decorateButtonSprites.East)	

	controlWindow:AddImage(32,230,"Divider",264,1,"Sliced")
	controlWindow:AddButton(35,238,"LockDownItem","Lock Down",120,0,"[$1828]","",false,"","")
	controlWindow:AddButton(175,238,"ReleaseItem","Release/Pack",120,0,"Select an item to release from lock down.","",false,"","")	
end

function ForceHouseDestroy()		
	-- destroy the doors and plot markers
	local parentHouseObj = this:GetObjVar("HouseObject")
	if(parentHouseObj ~= nil and parentHouseObj:IsValid()) then
		local houseObjects = FindObjects(SearchObjVar("HouseObject",parentHouseObj,40))
		for i,houseObj in pairs(houseObjects) do
			houseObj:Destroy()
		end
		parentHouseObj:Destroy()

		-- put the trees back to stumps
		local bounds = GetHouseControlPlot(this)
		local treesInBounds = GetTreesInBounds(bounds)
		for i,objRef in pairs(treesInBounds) do
			objRef:SetVisualState("Stump")
		end		
	else
		DebugMessage("ERROR: House object is missing! Clean up any objects that have an invalid HouseObject reference")
		local houseObjects = FindObjects(SearchHasObjVar("HouseObject",40))
		for i,houseObj in pairs(houseObjects) do
			local parentHouseObj = houseObj:GetObjVar("HouseObject")
			if(parentHouseObj == nil or not(parentHouseObj:IsValid())) then
				DebugMessage("ERROR: House object is missing! Destroying Id: "..tostring(houseObj.Id))
				houseObj:Destroy()
			end
		end
	end

	-- unlock all locked down objects
	local lockedDownObjects = FindObjects(SearchObjVar("LockedDown",true,40))
	for i,lockedDownObj in pairs(lockedDownObjects) do
		local containingHouse = GetContainingHouseForObj(lockedDownObj)
		if(containingHouse == this or containingHouse == nil or not(containingHouse:IsValid())) then
			ReleaseObject(lockedDownObj)
			lockedDownObj:SetObjVar("DecayTime",15*60)
			lockedDownObj:SendMessage("RepackObject")
		end
	end

	local merchantSaleItems = FindObjects(SearchMulti({SearchModule("hireling_merchant_sale_item"),SearchRange(this:GetLoc(),25),SearchObjVar("itemOwner",this:GetObjVar("Owner"))}))
	for i,j in pairs(merchantSaleItems) do
		j:SendMessage("RemoveFromSale")
	end

	local merchant = FindObject(SearchMulti({SearchModule("ai_hireling_merchant"),SearchRange(this:GetLoc(),25),SearchObjVar("HirelingOwner",this:GetObjVar("Owner"))}))
	if (merchant ~= nil) then
		merchant:SendMessage("DismissMerchant")
	end

	if(notifyUser) then
		local user = this:GetObjVar("Owner")
		if(user ~= nil and user:IsValid()) then
			user:SystemMessage("You house has been destroyed!","event")
		end
	end

	-- remove the house from the users global housing record
	local ownerUserId = this:GetObjVar("OwnerUserId")
	if(ownerUserId ~= nil) then		
		RegisterSingleEventHandler(EventType.GlobalVarUpdateResult,"deleterecord",
			function()
				this:Destroy()
			end)
		DeleteGlobalHouseRecord(ownerUserId, this, "deleterecord")
		
		-- make sure we destroy the control object no matter what happens with the global write
		CallFunctionDelayed(TimeSpan.FromSeconds(3),
			function ()
				this:Destroy()
			end)
	else
		this:Destroy()
	end
	
	controlWindowOpen = false
end

function DestroyHouseConfirm( user, buttonId )
	buttonId = tonumber(buttonId)
	
	if(buttonId == 0 and HasControl(user) ) then
		ForceHouseDestroy()
		user:CloseDynamicWindow("HouseControl")
	end
end

function ShowDestroyConfirm(user)
	ClientDialog.Show{
		TargetUser = user,
	    DialogId = "DestroyHouse",
	    TitleStr = "Destroy House",
	    DescStr = "[$1829]",
	    Button1Str = "Confirm",
	    Button2Str = "Cancel",
	    ResponseObj = this,
	    ResponseFunc = DestroyHouseConfirm,
	}
end

function ShowRenameHouse(user)
	TextFieldDialog.Show{
        TargetUser = user,
        ResponseObj = this,
        Title = "Rename House",
        Description = "Maximum 20 characters",
        ResponseFunc = function(user,newName)
        	if(newName == "" or newName == nil) then
        		user:SystemMessage("Invalid house name. Try again.")
        		return
        	end
        	
			local stripped, color = StripColorFromString(newName)
			if(stripped:len() > 20) then
				newName = stripped:sub(0,20)
				if(color ~= nil) then
					newName = color .. newName .. "[-]"
				end
			end

			this:SetName(newName)
			ShowControlWindow(user)
			ShowRenameHouseConfirm(user)
        end
    }
end

function ShowRenameHouseConfirm(user)
	ClientDialog.Show{
		TargetUser = user,
	    DialogId = "RenameHouseConfirm",
	    TitleStr = "House Name Changed",
	    DescStr = "This house has been renamed to "..this:GetName()..".",
	    Button1Str = "Ok",
	}
end

function HasControl(user)
	if(IsDemiGod(user) or (this:GetObjVar("Owner") == user)) then
		return true
	end

	local immortalHouse = this:GetObjVar("ImmortalHouse")
	if(immortalHouse) then
		return IsImmortal(user)
	end

	return false
end

RegisterEventHandler(EventType.Message,"Initialize",
	function (houseArgs)
		local owner = houseArgs.User

		this:SetObjVar("Owner", owner)		
		this:SetObjVar("OwnerUserId", owner:GetAttachedUserId())

		SetUserHouse(owner,this)

		this:SetObjVar("HouseObject", houseArgs.HouseObj)
		this:SetObjVar("DoorObject", houseArgs.DoorObj)

		local houseName = "Unknown's House"
		if(owner ~= nil and owner:IsValid()) then
			local ownerName = owner:GetName()
			this:SetObjVar("OwnerName", ownerName)
			SetTooltipEntry(this,"house_control_owner", "Owner: "..ownerName)
			houseName = StripColorFromString(owner:GetName()) .. "'s House"
			ShowControlWindow(owner)

			local lockUniqueId = uuid()
			local keyName = GetKeyName(houseName)
			this:SetObjVar("HouseLockUniqueId", lockUniqueId)
			houseArgs.DoorObj:SetObjVar("lockUniqueId", lockUniqueId)
			CreateKeyInBackpack(owner,keyName,lockUniqueId)
			RegisterSingleEventHandler(EventType.CreatedObject,"keyhelpers_key_created",
				function(success,objRef)
					this:SetObjVar("HouseKeyObject", objRef)
					objRef:SetObjVar("IsHouseKey", true)
					-- add it to their key ring
					AddKeyToKeyRing(owner, objRef)
					owner:SystemMessage("'"..keyName.."' was added to your key ring.")
				end)


		end
		this:SetName(houseName)

		OnLoad()
	end)

RegisterEventHandler(EventType.Message,"UseObject",
	function (user,usedType)
		if(usedType ~= "Use") then return end
		
		if(HasControl(user)) then			
			ShowControlWindow(user)
		else
			user:SystemMessage("Welcome to "..this:GetName())
		end
	end)

function CreateNewHouseKey(user,createKey)
	if(createKey) then
		CreateObjInBackpack(user,"key","HouseKey",user)
		return
	end

	local blankKey = GetBlankKey(user)
	if not(blankKey) then
		user:SystemMessage("[$1830]")
		return
	end

	local lockUniqueId = uuid()
	local houseName = this:GetName()
	local keyName = GetKeyName(houseName)
	local oldUID = this:GetObjVar("HouseLockUniqueId")

	-- support for existing data before the change
	if ( oldUID == nil ) then
		local doorObj = this:GetObjVar("DoorObject")
		if ( doorObj ~= nil and doorObj:IsValid() ) then
			oldUID = doorObj:GetObjVar("lockUniqueId")
		end
	end

	blankKey:SetObjVar("lockUniqueId", lockUniqueId)
	blankKey:SetObjVar("IsHouseKey", true)
	blankKey:SetName(keyName)

	local lockChangedOn = 0
	if ( oldUID ~= nil ) then
		-- set all the objects that used the old key to use the new one
		local foundObjs = FindObjects(SearchObjVar("lockUniqueId",oldUID,40))
		for i,foundObj in pairs(foundObjs) do
			local containingHouse = GetContainingHouseForObj(foundObj)
			if( containingHouse == this and not( foundObj:HasModule("key") ) ) then
				foundObj:SetObjVar("lockUniqueId", lockUniqueId)
				lockChangedOn = lockChangedOn + 1
			end
		end
	end

	-- rename old key
	local oldKey = this:GetObjVar("HouseKeyObject")
	if ( oldKey ~= nil and oldKey:IsValid() ) then
		local oldName, oldColor = StripColorFromString(oldKey:GetName())
		local name = "Old "..oldName
		if ( oldColor ~= nil ) then
			name = oldColor .. name .. "[-]"
		end
		oldKey:SetName(name)
	end

	this:SetObjVar("HouseKeyObject", blankKey)
	this:SetObjVar("HouseLockUniqueId", lockUniqueId)
	user:SystemMessage("Locks changed on "..lockChangedOn.." objects.")

	-- add it to their key ring
	AddKeyToKeyRing(user, blankKey)
	user:SystemMessage("'"..keyName.."' was added to your key ring.")
end
RegisterEventHandler(EventType.Message,"RekeyHouse",function (user,createKey) CreateNewHouseKey(user,createKey) end)

RegisterEventHandler(EventType.CreatedObject,"HouseKey",
	function(success,objRef,user)
		CreateNewHouseKey(user)
	end)

RegisterEventHandler(EventType.DynamicWindowResponse,"HouseControl",
	function (user,returnId)		
		if(HasControl(user) and not(HandleDecorateWindowResponse(user,returnId))) then
			local newTab = HandleTabMenuResponse(returnId)
			if(newTab) then
				selectedTab = newTab
				ShowControlWindow(user)
				return
			end

			if(returnId == "Rename") then
				ShowRenameHouse(user)
			elseif(returnId == "Destroy") then
				ShowDestroyConfirm(user)
			elseif(returnId == "HouseKey") then
				CreateNewHouseKey(user)
			elseif(returnId == "RekeyContainer") then
				-- ask for target of container
				user:SystemMessage("Please select the container you wish to re-key.")
				user:RequestClientTargetGameObj(this, "RekeyContainerTargeted")
			elseif(returnId == "Transfer") then
				user:SystemMessage("Please select the person you wish to transfer this house to.")
				user:RequestClientTargetGameObj(this, "HouseTransfer")				
			else
				controlWindowOpen = false
			end
		end
	end)

-- used for passing info from container target to key target during re-key container
mRekeyContainerTarget = nil
mHouseKey = nil

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "RekeyContainerTargeted",
	function(targetObj,user)
		if ( targetObj == nil or user == nil ) then return end
		-- determine if it's a lockable container
		local lockUniqueId = targetObj:GetObjVar("lockUniqueId")
		if ( lockUniqueId ~= nil ) then
			-- ensure the container is in their plot
			local houseControlObj = GetContainingHouseForObj(targetObj)
			if ( houseControlObj ~= nil and houseControlObj:GetObjVar("Owner") == user ) then
				-- check user has key to this container
				local key = GetKey(user, targetObj)
				if ( key == nil ) then
					user:SystemMessage("[$1831]")
				else
					mRekeyContainerTarget = targetObj
					-- request a target of key
					user:SystemMessage("Please select the key.")
					user:RequestClientTargetGameObj(this, "RekeyContainerKeyTargeted")
					return
				end
			else
				user:SystemMessage("That is not yours!")
			end
		else
			user:SystemMessage("That is not a lockable container.")
		end
		mRekeyContainerTarget = nil
		mHouseKey = nil
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "RekeyContainerKeyTargeted",
	function(targetObj,user)
		if ( targetObj ~= nil and user ~= nil and mRekeyContainerTarget ~= nil ) then
			-- check it's a key
			if ( targetObj:HasModule("key") ) then
				-- make sure they are holding it
				if ( targetObj:TopmostContainer() == user ) then
					local blank = IsBlankKey(targetObj)
					if ( blank or targetObj:GetObjVar("IsHouseKey") ) then
						local lockUniqueId = nil
						if ( blank ) then
							-- it's blank, generate a new lockUniqueId
							lockUniqueId = uuid()
							-- set the blank key's lock uuid
							targetObj:SetObjVar("lockUniqueId", lockUniqueId)
							local containerName, color = StripColorFromString(mRekeyContainerTarget:GetName())
							-- update blank key's name
							targetObj:SetName(containerName.." key")
							-- make the key a house key
							targetObj:SetObjVar("IsHouseKey", true)
						else
							-- not a blank key, this key might unlock other stuff too, let's use the uuid from it
							lockUniqueId = targetObj:GetObjVar("lockUniqueId")
						end
						-- set the container to use the key's uniqueID
						mRekeyContainerTarget:SetObjVar("lockUniqueId", lockUniqueId)

						local newHouseKeyInfo = ""
						local houseKey = this:GetObjVar("HouseKeyObject")
						if ( not( blank ) and houseKey:GetObjVar("lockUniqueId") == lockUniqueId ) then
							newHouseKeyInfo = "[$1832]"
						else
							newHouseKeyInfo = "[$1833]"
						end

						user:SystemMessage("[$1834]" .. newHouseKeyInfo)
					
					else
						user:SystemMessage("[$1835]")
					end
				else
					user:SystemMessage("You cannot reach that key.")
				end
			else
				user:SystemMessage("That is not a key.")
			end
			mRekeyContainerTarget = nil
			mHouseKey = nil
		end
	end)

RegisterEventHandler(EventType.ClientTargetGameObjResponse, "HouseTransfer",
	function(targetObj,user)
		if(targetObj:IsPlayer()) then
			-- gods can transfer houses to themselves
			if(targetObj == user and IsGod(user)) then
				TransferHouseOwnership(user,this,user)
			elseif(user:HasModule("trading_controller")) then
				user:SystemMessage("You already have an active trade in progress.","info")
			else
				user:AddModule("trading_controller",{TradeTarget=targetObj,HouseTarget=this})
			end
		end
	end)

function GetKeyName(houseName)
	local a,b = string.find(string.lower(houseName), "house")
	if ( b == #houseName) then
		-- ends in house, remove house from end
		houseName = string.sub(houseName, 1, -6)
	end
	return StringTrim(houseName) .. " House Key"
end

function PushDecoObject(user,direction)
	if(decoObj == nil) then
		user:SystemMessage("[$1836]")
		return
	end

	local newLoc = decoObj:GetLoc() + (multiplier*direction)
	if not(IsLocInHouse(this,newLoc)) then
		user:SystemMessage("[$1837]")
		return
	end

	decoObj:SetWorldPosition(newLoc)
end

function RotateDecoObject(user,direction)
	if(decoObj == nil) then
		user:SystemMessage("[$1838]")
		return
	end

	local newRot = decoObj:GetRotation() + (multiplier*direction)
	decoObj:SetRotation(newRot)
end

function HandleDecorateWindowResponse(user,returnId)
	if(HasControl(user)) then
		if(returnId == "LockDownItem") then
			user:RequestClientTargetGameObj(this, "lockdownitem")
		elseif(returnId == "ReleaseItem") then
			user:RequestClientTargetGameObj(this, "releaseitem")
		elseif(returnId == "SetDecoTarget") then
			user:RequestClientTargetGameObj(this, "setdecotarget")
		elseif(returnId == "PushNorth") then
			PushDecoObject(user,Loc(0,0,0.1))
		elseif(returnId == "PushSouth") then
			PushDecoObject(user,Loc(0,0,-0.1))
		elseif(returnId == "PushEast") then
			PushDecoObject(user,Loc(0.1,0,0))
		elseif(returnId == "PushWest") then
			PushDecoObject(user,Loc(-0.1,0,0))
		elseif(returnId == "PushUp") then
			PushDecoObject(user,Loc(0,0.1,0))
		elseif(returnId == "PushDown") then
			PushDecoObject(user,Loc(0,-0.1,0))
		elseif(returnId == "RotCW") then	
			RotateDecoObject(user,Loc(0,5,0))			
		elseif(returnId == "RotCCW") then
			RotateDecoObject(user,Loc(0,-5,0))
		elseif(returnId == "Multiplier") then
			if(multiplier == 1) then
				multiplier = 10
			elseif(multiplier == 10) then
				multiplier = 1
			end
			ShowControlWindow(user)
		else
			return false			
		end

		return true
	end
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse,"lockdownitem",
	function(targetObj,user)
		if(targetObj ~= nil and HasControl(user)) then
			local houseObj = this:GetObjVar("HouseObject")
			if( targetObj:IsMobile() ) then
				user:SystemMessage("You cannot lock down humans or creatures.")
			elseif( targetObj:HasObjVar("HouseObject") or houseObj == targetObj ) then
				user:SystemMessage("That item is automatically locked down.")
			elseif( targetObj:IsInContainer() ) then
				user:SystemMessage("You cannot lock down items inside containers.")
			elseif not(IsObjInHouse(this,targetObj)) then
				user:SystemMessage("That item is not inside your house plot.")
			elseif (targetObj:HasObjVar("DisableLockDown")) then
				user:SystemMessage("You cannot lock down that.")
			elseif( targetObj:HasModule("hireling_merchant_sale_item")) then
				user:SystemMessage("[$1839]")
			elseif(IsLockedDown(targetObj)) then
				user:SystemMessage("That item is already locked down.")
			elseif(RemainingLockCount() < 1) then
				user:SystemMessage("You cannot lockdown anymore items in this home.")
			else
				user:SystemMessage("That item has been locked down.")
				LockDownObject(targetObj)
				AlterLockCountBy(1)
				decoObj = targetObj
				ShowControlWindow(user)
			end
		end
	end)

function RefreshHouse(mob)
	local currentTimeStamp = DateTime.UtcNow:ToString()
	this:SetObjVar("LastVisitedTime",currentTimeStamp)
	RemoveTooltipEntry(this,"decay")
	if (mob ~= nil) then
		mob:SystemMessage("Your house has restored.")
	end
	-- if a god has overriden the destroy and decay times then clear them when he comes back
	if(this:HasObjVar("DestroyTime")) then
		this:DelObjVar("DestroyTime")
	end
	if(this:HasObjVar("DecayTime")) then
		this:DelObjVar("DecayTime")
	end
	if(this:HasObjVar("VacationMode")) then
		this:DelObjVar("VacationMode")
	end
end

function OnDoorUnlocked()
	this:RemoveTimer("houseSecure")
end

function CanEnterLockedHouse(targetObj)
	if(IsImmortal(targetObj)) then
		return true
	end
	if(targetObj:GetCreationTemplateId() == "player_corpse") then return true end
	
	if (GetKey(targetObj,this:GetObjVar("DoorObject"))) then
		--DebugMessage("Has key")
		return true
	end
	local owner = GetHouseOwner(this)
	if(owner == targetObj) then
		--DebugMessage(" is owner")
		return true
	end
	local petOwner = targetObj:GetObjectOwner()
	if( petOwner ~= nil ) then
		-- it's a pet
		--DebugMessage("Is pet")
		return CanEnterLockedHouse(petOwner)
	end
	if ( ShareGroup(targetObj,owner) ) then
		--DebugMessage(" In Group")
		return true
	end
	if(Guild.IsInGuildWith(targetObj,owner) and not targetObj:GetObjVar("Guild") == NEW_PLAYER_GUILD_ID) then
		--DebugMessage(" in teh guidl")
		return true
	end
	return false
end

--RegisterEventHandler(EventType.Message,"DoorLocked",function() OnDoorLocked() end)
--RegisterEventHandler(EventType.Message,"DoorUnlocked",function() OnDoorUnlocked() end)

--[[
function OnDoorLocked()
	this:ScheduleTimerDelay(TimeSpan.FromSeconds(1),"houseSecure")
end

RegisterEventHandler(EventType.Timer,"houseSecure",
	function ( ... )
		local nearbyMobs = GetViewObjects("MobsInPlot")
		if (nearbyMobs ~= nil) then
			for i,nearbyMob in pairs(nearbyMobs) do
				if(IsObjInInterior(this,nearbyMob) and not(CanEnterLockedHouse(nearbyMob))) then
					local doorObj = this:GetObjVar("DoorObject")
					if(doorObj ~= nil) then
						local teleportLoc = doorObj:GetLoc():Project(this:GetFacing()+180,6)
						nearbyMob:SetWorldPosition(teleportLoc)
						nearbyMob:PlayEffect("TeleportFromEffect")
						nearbyMob:PlayObjectSound("Teleport")					
						nearbyMob:SystemMessage("You do not have permission to enter that house.")					
					end
				end
			end
		else
			DebugMessage("[house_control] ERROR: House controller with ID of "..tostring(this.Id).." does not have a view for house objects!")
		end

		-- between 0.25 and 0.75 seconds
		this:ScheduleTimerDelay(TimeSpan.FromSeconds(0.25 + (math.random()/2)),"houseSecure")
	end)

if(IsHouseLocked(this)) then
	OnDoorLocked()
end]]

packTarget = nil
RegisterEventHandler(EventType.ClientTargetGameObjResponse,"releaseitem",
function(targetObj,user)
	if(targetObj ~= nil and HasControl(user)) then
		if(targetObj:HasObjVar("HouseObject") or targetObj:HasObjVar("IsHouse")) then
			user:SystemMessage("That cannot be released.")
		else
			if not(IsObjInHouse(this,targetObj)) then
				user:SystemMessage("That item is not inside your house plot.")
			elseif(targetObj:HasObjVar("PackedTemplate")) then
				local notemptyWarning = ""
				local objectsInContainer = FindItemsInContainerRecursive(targetObj)
		        if #objectsInContainer > 0 then
		        	notemptyWarning = "[$1840]"
		        end
				packTarget = targetObj
				ClientDialog.Show{
				    TargetUser = user,
					ResponseObj = this,
				    DialogId = "PackObjectConfirm",
				    TitleStr = "Confirm",
				    DescStr = "Do you wish to pack up this object?"..notemptyWarning,
				    Button1Str = "Yes",
				    Button2Str = "No",
				}
			elseif not(IsLockedDown(targetObj)) then
				user:SystemMessage("That item is not locked down.")
			else
				local houseObj = this:GetObjVar("HouseObject")
				if(targetObj == houseObj) then
					user:SystemMessage("That cannot be released.")
				else
					user:SystemMessage("That item has been released.")
					if (targetObj:IsContainer()) then
						if(targetObj:GetObjVar("LockedDown") == true) then
						    CloseContainerRecursive(user, targetObj)
						end
					end
					ReleaseObject(targetObj)
					AlterLockCountBy(-1)
					if(targetObj==decoObj) then
						decoObj = nil
						ShowControlWindow(user)
					end
				end
			end
		end
	end
end)

RegisterEventHandler(EventType.DynamicWindowResponse, "PackObjectConfirm", function(user,buttonId)
	buttonId = tonumber(buttonId)
	--DebugMessage("A",tostring(user),tostring(buttonId),tostring(packTarget))
	if(buttonId == 0 and packTarget ~= nil and packTarget:IsValid()) then			
		--DebugMessage("B")
		if(packTarget==decoObj) then
			decoObj = nil
			ShowControlWindow(user)
		end
		PackObject(user,packTarget)
		packTarget:Destroy()
		AlterLockCountBy(-1)
	end
end)

function RemainingLockCount()
	return MAX_LOCK_COUNT - ( this:GetObjVar("LockCount") or 0 )
end

function AlterLockCountBy(amount)
	local lockCount = ( this:GetObjVar("LockCount") or 0 ) + amount
	if ( lockCount > MAX_LOCK_COUNT ) then
		-- problem here...
	end
	if ( lockCount < 1 ) then
		this:DelObjVar("LockCount")
	else
		this:SetObjVar("LockCount", lockCount)
	end
end

RegisterEventHandler(EventType.ClientTargetGameObjResponse,"setdecotarget",
	function(targetObj,user)
		if(targetObj ~= nil and HasControl(user)) then
			local houseObj = this:GetObjVar("HouseObject")
			if( targetObj:HasObjVar("HouseObject") or houseObj == targetObj ) then
				user:SystemMessage("That item cannot be moved.")
			elseif not(IsObjInHouse(this,targetObj)) then
				user:SystemMessage("That item is not inside your house plot.")
			elseif not(IsLockedDown(targetObj)) then
				user:SystemMessage("[$1841]")
			else
				decoObj = targetObj
				ShowControlWindow(user)
			end
		end
	end)

RegisterEventHandler(EventType.ClientObjectCommand,"ToggleHouseWindow",
	function(user,...)
		if(HasControl(user)) then
			if(controlWindowOpen) then
				user:CloseDynamicWindow("HouseControl")
				controlWindowOpen = false
			else
				ShowControlWindow(user)
			end
		else
			user:SystemMessage("You do not have control of this structure.")
		end
	end)

RegisterEventHandler(EventType.Timer,"place_delay",
	function(placedObj, user)
		-- Validate placed object
		local houseKey = GetKey(user,this:GetObjVar("DoorObject"))

		if(placedObj == nil 
				or not(placedObj:IsValid()) 
				or placedObj:IsInContainer()
				or (not(IsHouseOwner(user,this)) and houseKey == nil)) then 
			return 
		end
		
		local isPackedObject = placedObj:HasObjVar("PackedTemplate")
		if ( isPackedObject and RemainingLockCount() < 1 ) then
			PackObject(user,placedObj)
			placedObj:Destroy()
			user:SystemMessage("You cannot place anymore items in this house, limit reached.")
			return
		end
		if(isPackedObject or decoWindowOpen) then
			LockDownObject(placedObj)
			AlterLockCountBy(1)
			decoObj = placedObj
			if (IsHouseOwner(user,this)) then
				ShowControlWindow(user)
			end
		else
			Decay(placedObj, ServerSettings.Misc.ObjectDecayTimeSecs)
		end
	end)

RegisterEventHandler(EventType.Message,"ObjectPlaced",
	function (objRef,userObj)
		-- wait one frame so the objects world position has a chance to update
		this:FireTimer("place_delay",objRef,userObj)
	end)

RegisterEventHandler(EventType.EnterView,"MobsInPlot",
	function (mob)
		if(HasControl(mob)) then
			--set the timestamp if this is the player so the house does not decay
			if (mob:IsPlayer() and IsHouseOwner(mob,this)) then
				RefreshHouse(mob)
			end
			mob:SendClientMessage("EnterHousePlot",this)
		end
	end)

RegisterEventHandler(EventType.Message,"RefreshHouse",function ()
		RefreshHouse()	
	end)

RegisterEventHandler(EventType.LeaveView,"MobsInPlot",
	function (mob)
		if(HasControl(mob)) then
			if(controlWindowOpen) then
				this:CloseDynamicWindow("HouseControl")
			end
			mob:SendClientMessage("LeaveHousePlot",this)
		end
	end)

RegisterSingleEventHandler(EventType.LoadedFromBackup,"",
	function ( ... )
		OnLoad()

		local houseObj = this:GetObjVar("HouseObject")
		if(houseObj == nil or not(houseObj:IsValid())) then
			DebugMessage("ERROR: [house_control] House control object has no associated house!",tostring(this.Id))
		elseif(not(houseObj:GetObjVar("IsHouse"))) then
			houseObj:SetObjVar("IsHouse",true)
		end
	end)

RegisterEventHandler(EventType.Message,"ForceDestroy",
	function ( ... )
		ForceHouseDestroy()
	end)

RegisterEventHandler(EventType.Message,"OnCharDelete",
	function (deletedChar)
		if(IsHouseOwner(deletedChar,this)) then
			ForceHouseDestroy()
		end
	end)


RegisterEventHandler(EventType.Message,"OnWorldReset",
	function ( ... )
		local bounds = GetHouseControlPlot(this)
		if (bounds == nil) then return end
		local treesInBounds = GetTreesInBounds(bounds)
		for i,objRef in pairs(treesInBounds) do
			objRef:SetVisualState("Hidden")
		end		
	end)

RegisterEventHandler(EventType.Timer,"CheckDecay",function ()
	CheckDecay()
end)
-- stagger the decay timers
this:ScheduleTimerDelay(TimeSpan.FromMilliseconds(math.random(10000,30000)),"CheckDecay")
