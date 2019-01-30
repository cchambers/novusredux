-- GlobalVarRead
-- GetItemValue

this:ScheduleTimerDelay(TimeSpan.FromSeconds(5),"Donation.Do")
RegisterEventHandler(EventType.Timer, "Donation.Do", function() DonateItem(this) end)