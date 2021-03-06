local screen = Var "LoadingScreen"
local screenName = THEME:GetMetric(screen,"HeaderText");
local screenDelay = THEME:GetMetric(screen,"ScreenInDelay")


--Base Anchoring
local out = Def.ActorFrame{
	InitCommand=function(s) s:xy(_screen.cx-320,SCREEN_TOP+18) end,
	OnCommand=function(s)
		s:addy(-120):sleep(screenDelay):decelerate(0.2):addy(120)
	end,
	OffCommand=function(s)
		s:accelerate(0.2):addy(-120)
	end,
	Def.Sprite{Texture="base",};
}

if screenName then
	table.insert(out,Def.Sprite{
		Texture="Text",
		InitCommand=function(s) s:y(20):animate(false):setstate(screenName):diffusealpha(0) end,
		OnCommand=function(s) s:sleep(screenDelay):sleep(0.1):linear(0.2):diffusealpha(1) end,
		OffCommand=function(s) s:linear(0.2):diffusealpha(0) end,
	})
end

return out
