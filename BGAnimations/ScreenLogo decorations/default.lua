return Def.ActorFrame{
    LoadActor(THEME:GetPathB("ScreenTitleMenu","underlay/default.lua"));
    Def.ActorFrame{
        Name="Decorations",
        InitCommand=function(s) s:diffusealpha(0) end,
        OnCommand=function(s) s:sleep(2):diffusealpha(1) end,
        Def.ActorFrame{
            InitCommand=function(s) s:xy(_screen.cx-4,_screen.cy+230) end,
            Def.ActorFrame{
                Name="Start",
                InitCommand=function(s) s:diffuseblink():effectcolor1(Color.White):effectcolor2(Alpha(Color.White,0)):effectperiod(4) end,
                Def.Sprite{
                    Texture="start1",
                };
                Def.Sprite{
                    Texture="start2",
                    InitCommand=function(s) s:diffuseshift():effectcolor1(Color.White):effectcolor2(Alpha(Color.White,0)):effectperiod(1) end,
                };
            };
            Def.ActorFrame{
                Name="eAmu",
                InitCommand=function(s) s:diffuseblink():effectcolor1(Alpha(Color.White,0)):effectcolor2(Alpha(Color.White,1)):effectperiod(4) end,
                Def.Sprite{
                    Texture="eamuse1",
                };
                Def.Sprite{
                    Texture="eamuse2",
                    InitCommand=function(s) s:diffuseshift():effectcolor1(Color.White):effectcolor2(Alpha(Color.White,0)):effectperiod(1) end,
                };
            };
        };
        Def.Sprite{
            Texture="eALogo",
            InitCommand=function(s) s:xy(SCREEN_RIGHT-50,SCREEN_TOP+50) end,
        };

    };
}