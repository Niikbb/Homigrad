resource.AddFile("resource/localization/en/homigrad.properties")
resource.AddFile("resource/localization/ru/homigrad.properties")
resource.AddFile("resource/localization/uk/homigrad.properties")
hook.Add("PreGamemodeLoaded", "widgets_disabler_cpu", function() function widgets.PlayerTick() end hook.Remove("PlayerTick", "TickWidgets") end)