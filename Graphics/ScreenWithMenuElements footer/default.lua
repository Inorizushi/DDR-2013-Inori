local screen = Var "LoadingScreen"
local screenName = THEME:GetMetric(screen,"FooterText");
local screenDelay = THEME:GetMetric(screen,"ScreenInDelay")


local t = Def.ActorFrame{
  InitCommand=function(s) s:xy(_screen.cx,SCREEN_BOTTOM-40) end,
  OnCommand=function(s)
    s:draworder(5):zoomy(0):sleep(screenDelay):linear(0.175):zoomy(1)
  end,
  OffCommand=function(s)
    s:linear(0.175):zoomy(0)
  end,
  LoadActor(THEME:GetPathG("","_footer/"..screenName))
};

return t;
