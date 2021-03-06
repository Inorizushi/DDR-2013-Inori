return Def.ActorFrame{
    Def.ActorFrame{
        InitCommand=function(s) s:xy(_screen.cx,_screen.cy-60):diffusealpha(0):zoom(2) end,
        OnCommand=function(s) s:sleep(0.3):linear(0.5):diffusealpha(1):zoom(1) end,
        Def.Sprite{
            Texture="logo",
        };
        Def.Sprite{
            Texture="logo",
            OnCommand=function(s) s:blend(Blend.Add):playcommand("Anim") end, 
            AnimCommand=function(s) s:diffusealpha(0):sleep(1):linear(0.75):diffusealpha(1):sleep(0.1):linear(0.4):diffusealpha(0):queuecommand("Anim") end,
        };
    };
    Def.ActorFrame{
        InitCommand=function(s) s:xy(_screen.cx,_screen.cy-60):diffusealpha(0) end,
        OnCommand=function(s) s:sleep(1):diffusealpha(1):linear(1):diffusealpha(0):zoom(1.5) end,
        Def.Sprite{
            Texture="logo",
            InitCommand=function(s) s:blend(Blend.Add) end, 
        };
    };
    Def.ActorFrame{
        InitCommand=function(s) s:xy(SCREEN_RIGHT+34,_screen.cy+20):rotationz(0) end,
        OnCommand=function(s) s:linear(0.4):x(SCREEN_LEFT-34):rotationz(360):sleep(0):y(_screen.cy-146):linear(0.4):x(SCREEN_RIGHT-165):rotationz(720):linear(0.25):rotationz(1080) end,
        Def.Sprite{
            Texture="shine.png",
            OnCommand=function(s) s:sleep(0.8):linear(0.15):zoom(1.4):linear(0.2):zoom(0) end,
        };
    };
    Def.Sprite{
        Texture="copyright2013",
        InitCommand=function(s) s:xy(_screen.cx+4,SCREEN_BOTTOM-48):diffusealpha(0) end,
        OnCommand=function(s) s:sleep(1.3):linear(0.2):diffusealpha(1) end,
    };
};