RegisterEventHandler(EventType.ModuleAttached,"guard_tower_controller",
    function ( ... )
        local towerPrefab = this:GetObjVar("TowerPrefab") or "GuardTower"
        CreatePrefab(towerPrefab,this:GetLoc(), this:GetRotation())
    end)