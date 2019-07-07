require 'globals.lua.extensions'

--- Saves this controller's gameObj ID to global
function SaveControllerIDtoGlobal()
  local allegianceId = this:GetObjVar("Allegiance")
  if ( allegianceId == nil ) then return false end

  SetGlobalVar(string.format("Allegiance.%s.%s", "RosterController", allegianceId),
  function(record)
    record["ID"] = this
    return true
  end,
  function(success)
    if ( success ) then
      --DebugMessage("[AllegianceRosterController] Allegiance roster control ID "..tostring(this).." saved to globals")
    end
  end)
end

RegisterEventHandler(EventType.Message,"AdjustFavorTable",
--- Updates FavorTable on this controller with for a player and creates a time(from current+server setting) when the player would be considered inactive, optionally removes their entry instead
-- @param playerObj
-- @param favor, favor value to set to
-- @param (optional) remove, set true to remove player from the favor table instead
function (playerObj, favor, remove)
  if ( playerObj == nil or favor == nil ) then return false end
  local favorTable = this:GetObjVar("FavorTable") or {}--could this clear the roster if it exists?
  if ( remove ) then
    favorTable[playerObj] = nil
  else
    favorTable[playerObj] = {
      math.round(favor, 4),
      DateTime.UtcNow:Add(ServerSettings.Allegiance.InactiveTime),
    }
  end

  this:SetObjVar("FavorTable", favorTable)
end)

--- Gets and sorts favor data from controller's FavorTable ObjVar, rewrites global Standings var with current rank and percentile info
function CalculateStandings()
  local standingTable = SortRosterByFavor()
  if ( standingTable == nil ) then return false end

  local allegianceId = this:GetObjVar("Allegiance")
  if ( allegianceId == nil ) then return false end

  local update = {}
  SetGlobalVar(string.format("Allegiance.%s.%s", "Standings", allegianceId),
  function(record)
    record["SeasonStartDate"] = nil
    record["CalculationDate"] = nil
    for k, v in pairs(record) do
      record[k] = nil
      update[k] = 1
    end
	  for k, v in pairs(standingTable) do
      record[k] = v
      update[k] = 1
    end

    local seasonStartDate = GlobalVarReadKey("Allegiance.CurrentSeason", "StartDate")
    record["SeasonStartDate"] = seasonStartDate
    local calculationDate = DateTime.UtcNow
    record["CalculationDate"] = calculationDate

    return true
  end,
  function(success)
    if ( success ) then
      if ( update ~= nil and update ~= {} ) then
        for k, v in pairs(update) do
          k:SendMessageGlobal("UpdateAllegianceObjVars") 
        end
      end
      DebugMessage("[AllegianceRosterController] Allegiance #"..allegianceId.." standings calculation successful and saved to globals")
    end
  end)
end

RegisterEventHandler(EventType.Message,"WipeRosterTable",
function()
    local favorTable = this:GetObjVar("FavorTable")
    if not( favorTable ) then
      DebugMessage("[AllegianceRosterController] Couldn't get FavorTable ObjVar on "..tostring(this))
      return false
    end
    local deleteResult = this:DelObjVar("FavorTable")
    if ( deleteResult ) then
      DebugMessage("[AllegianceRosterController] Wiping of FavorTable ObjVar successful on "..tostring(this))
      CalculateStandings()
      return true
    else
      DebugMessage("[AllegianceRosterController] Wiping of FavorTable ObjVar failed on "..tostring(this))
      return false
    end
end)

function SortRosterByFavor()
  local t = this:GetObjVar("FavorTable") or {}
  --remove inactive players
  local now = DateTime.UtcNow
  for k, v in pairs(t) do
    if ( v[2] == nil or now > v[2] ) then
      t[k] = nil
    end
  end
  local length = CountTable(t)
  local standing = length
  local count = 1
  for x, y in sortpairs(t, function(t, a, b) return t[a][1] < t[b][1] end) do
    t[x] = {math.round(count/length, 2), standing}
    standing = standing - 1
    count = count + 1
  end
  return t
end

function OnLoad()
  SaveControllerIDtoGlobal()
  CalculateStandings()
end
OnLoad()