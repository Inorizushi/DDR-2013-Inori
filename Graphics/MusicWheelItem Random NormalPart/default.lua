--main backing
local t = Def.ActorFrame {
	OnCommand=cmd(zoomy,0;sleep,0.2;accelerate,0.1;zoomy,1.1;decelerate,0.2;zoomy,1);
	OffCommand=cmd(sleep,0.2;accelerate,0.1;zoom,1.4;decelerate,0.1;zoom,0);
	LoadActor("Item")..{
		InitCommand=cmd(scaletoclipped,256,256);
	};
	LoadActor("Item")..{
		InitCommand=cmd(scaletoclipped,256,256;y,256;rotationx,180;croptop,0.5;diffusealpha,0.5;diffusetopedge,1,1,1,0);
	};
};
return t;
