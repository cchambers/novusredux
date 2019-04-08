MobileEffectLibrary.Cut = {
    ShouldStack = false,
    OnEnterState = function(self, root, target, args)
        EndMobileEffect(root)
        return
    end,
    
    OnExitState = function(self, root)
    end,
    Target = nil,
}
