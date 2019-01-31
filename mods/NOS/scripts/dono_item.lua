-- GlobalVarRead
-- GetItemValue

this:ScheduleTimerDelay(TimeSpan.FromMinutes(5),"Donation.Do")
RegisterEventHandler(EventType.Timer, "Donation.Do", function() DonateItem(this) end)