return Def.ActorFrame{
    Def.Sprite{
        Texture="base",
        InitCommand=function(s) s:FullScreen():diffusealpha(0) end,
    };
};