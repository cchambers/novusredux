
-- Apply this to the loot container of the mob ( backpack )
_SparkleColor = "Color=00FFFF"
_SparkleEffect = "StarsEffect"


_TopMost = this:TopmostContainer() or this
_players = {}

_playingLocalEffect = false
_playingGlobalEffect = false

function ClearLocalEffect()
    if ( _playingLocalEffect ) then
        for i=1,#_players do
            local player = _players[i]
            if ( player:IsValid() ) then
                player:StopLocalEffect(_TopMost, _SparkleEffect, 2.0)
            end
        end
        _playingLocalEffect = false
    end
end

function ClearGlobalEffect()
    if ( _playingGlobalEffect ) then
        _TopMost:StopEffect(_SparkleEffect, 2.0)
        _playingGlobalEffect = false
    end
end

RegisterEventHandler(EventType.Message, "Tag", function(player)
    if ( player and player:IsValid() ) then
        table.insert(_players, player)
        -- make it sparkle
        CallFunctionDelayed(TimeSpan.FromSeconds(2), function()
            if ( #this:GetContainedObjects() > 0 ) then
                player:PlayLocalEffect(_TopMost,_SparkleEffect,0,_SparkleColor)
                _playingLocalEffect = true
            end
        end)
        -- in 5 minutes it's free for all
        if not( this:HasTimer("TagClearTimer") ) then
            this:ScheduleTimerDelay(TimeSpan.FromMinutes(5), "TagClearTimer")
        end
    end
end)

RegisterEventHandler(EventType.Timer, "TagClearTimer", function()
    _TopMost:DelObjVar("Tag")
    ClearLocalEffect()
    if ( #this:GetContainedObjects() > 0 ) then
        -- there's still stuff left, make it sparkle for everyone
        _TopMost:PlayEffectWithArgs(_SparkleEffect, 0.0, _SparkleColor)
        _playingGlobalEffect = true
    end
end)

RegisterEventHandler(EventType.ContainerItemRemoved, "", function(contObj)
    CallFunctionDelayed(TimeSpan.FromMilliseconds(1), function()
        if ( #this:GetContainedObjects() == 0 ) then
            -- remove the tag timer, it's empty.
            if ( this:HasTimer("TagClearTimer") ) then
                this:RemoveTimer("TagClearTimer")
            end
            -- clear any/all effects, the mob is empty.
            ClearLocalEffect()
            ClearGlobalEffect()
        end
    end)
end)

RegisterEventHandler(EventType.Message, "ClearMobTag", function()
    ClearLocalEffect()
    ClearGlobalEffect()
    this:DelModule("tagged_mob")
end)