return Def.ActorFrame{
	InitCommand=function(s) s:Center() end,
	--Background Colored 1p vs2p ------------------------------------------
	LoadActor( "Background_ddr2013.png" )..{
		InitCommand=function(s) s:setsize(2000,2000):spin():effectmagnitude(0,0,-5) end,
	};
	-- BACKGROUND ROTATION EFFECTS ---------------------------------------------------
	Def.Sprite{
		Texture="Effectbg_ddr2013.png",
		InitCommand=function(s) s:diffusealpha(0.3):blend(Blend.Add):setsize(2000,2000):spin():effectmagnitude(0,0,-3) end,
	};
	Def.Sprite{
		Texture="Effectbg_ddr2013.png",
		InitCommand=function(s) s:zoom(0.9):diffusealpha(0.5):blend(Blend.Add):setsize(2000,2000):spin():effectmagnitude(0,0,5) end,
	};
	Def.Sprite{
		Texture="Effectbg_ddr2013.png",
		InitCommand=function(s) s:rotationz(90):zoom(1.3):diffusealpha(0.3):blend(Blend.Add):setsize(2000,2000):spin():effectmagnitude(0,0,10) end,
	};
};
