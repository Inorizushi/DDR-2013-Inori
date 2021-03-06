local t = Def.ActorFrame {
	InitCommand=function(s) s:CenterX() end,
	Def.Sprite{
		Texture=THEME:GetPathB("","_doors/01.png"),
		InitCommand=function(s) s:valign(1):y(_screen.cy) end,
		OnCommand=function(s) s:sleep(0.25):linear(0.25):y(_screen.cy-370) end,
    };
	Def.Sprite{
		Texture=THEME:GetPathB("","_doors/02.png"),
		InitCommand=function(s) s:valign(0):y(_screen.cy) end,
		OnCommand=function(s) s:sleep(0.25):linear(0.25):y(_screen.cy+370) end,
    };
};
return t;
