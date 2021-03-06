local t = Def.ActorFrame{
	Def.Quad{
		InitCommand=cmd(FullScreen;diffuse,color("0,0,0,1"));
	};
};
t[#t+1] = Def.ActorFrame{
	InitCommand=cmd(Center);
	LoadActor("sound")..{
		OnCommand=cmd(queuecommand,"Play");
		PlayCommand=cmd(play);
	};
	Def.Quad{
		InitCommand=cmd(setsize,SCREEN_WIDTH,SCREEN_HEIGHT;diffusealpha,0);
		OnCommand=cmd(diffusealpha,0;linear,0.5;diffusealpha,1;sleep,9.3;diffusealpha,0);
	};
	LoadActor("Konami")..{
		OnCommand=cmd(diffusealpha,0;linear,0.2;diffusealpha,1;sleep,2;linear,0.2;diffusealpha,0);
	};
	LoadActor("EAmuse")..{
		OnCommand=cmd(diffusealpha,0;sleep,2.9;linear,0.2;diffusealpha,1;sleep,2;linear,0.2;diffusealpha,0);
	};
	LoadActor("Bemani")..{
		OnCommand=cmd(diffusealpha,0;sleep,5.8;linear,0.2;diffusealpha,1;sleep,2;linear,0.2;diffusealpha,0);
	};
	LoadActor("RSA")..{
		OnCommand=cmd(diffusealpha,0;sleep,8.7;linear,0.2;diffusealpha,1;sleep,2;linear,0.2;diffusealpha,0);
	};
	LoadActor("1")..{
		OnCommand=cmd(diffusealpha,0;sleep,12;linear,0.5;diffusealpha,1;sleep,2;linear,0.1;diffusealpha,0);
	};
	LoadActor("2")..{
		OnCommand=cmd(diffusealpha,0;sleep,14.6;linear,0.5;diffusealpha,1;sleep,2;linear,0.1;diffusealpha,0);
	};
	LoadActor("3")..{
		OnCommand=cmd(diffusealpha,0;sleep,17.2;linear,0.5;diffusealpha,1;sleep,2;linear,0.1;diffusealpha,0);
	};
	LoadActor("4")..{
		OnCommand=cmd(diffusealpha,0;sleep,19.8;linear,0.5;diffusealpha,1;sleep,2;linear,0.5;diffusealpha,0);
	};

};
return t;
