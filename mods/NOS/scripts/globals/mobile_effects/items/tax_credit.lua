MobileEffectLibrary.TaxCredit = 
{
    OnEnterState = function(self,root,target,args)
        if ( self.ParentObj:HasTimer("TaxCreditTimer") ) then
            self.ParentObj:SystemMessage("Please wait to use this again.", "info")
            EndMobileEffect(root)
            return false
        end
        self.ParentObj:ScheduleTimerDelay(TimeSpan.FromSeconds(2.5), "TaxCreditTimer")

        self.Amount = args:GetObjVar("TaxCreditAmount") or 0

        if ( self.Amount < 1 ) then
            self.ParentObj:SystemMessage("Invalid Tax Credit.", "info")
            EndMobileEffect(root)
            return false
        end

        if ( not target or not target:IsValid() or target:GetCreationTemplateId() ~= "plot_controller" ) then
            self.ParentObj:SystemMessage("Invalid target, please target a plot's mailbox.", "info")
            EndMobileEffect(root)
            return false
        end
        if ( self.ParentObj:GetLoc():Distance(target:GetLoc()) > 15 ) then
            self.ParentObj:SystemMessage("Too far away.", "info")
            EndMobileEffect(root)
            return false
        end

        if ( Plot.TaxPayment(target, self.ParentObj, self.Amount) ) then
            self.ParentObj:SystemMessage(ValueToAmountStr(self.Amount,false,true).." credited toward this plot's tax balance.", "event")
        else
            self.ParentObj:SystemMessage("Failed to credit the tax balance.", "info")
        end

        EndMobileEffect(root)

        return true
	end,

}