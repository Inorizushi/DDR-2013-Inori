local t = Def.ActorFrame {
	OnCommand=function(s)
		SCREENMAN:GetTopScreen():lockinput(1)
		s:sleep(0.5):queuecommand("Play")
	end,
	PlayCommand=function(s)
		SOUND:PlayOnce(THEME:GetPathS("","_swooshInstructions"))
	end,
};

t[#t+1] = Def.Quad{
	InitCommand=function(self)
		self:diffuse(Color.Black):FullScreen()
	end;
	OnCommand=cmd(diffusealpha,0;sleep,0.2;linear,0.2;diffusealpha,0.5);
	OffCommand=cmd(linear,0.5;diffusealpha,0);
};

local Line = Def.ActorFrame{}

local rownames = {
	"Speed",
	"Accel",
	"Appearance",
	"Turn",
	"Step Zone",
	"Scroll",
	"NoteSkins",
	"Remove",
	"Freeze",
	"Jump",
	"Difficulty",
	"Characters",
	"Filter",
	"Gauge",
}

local rowtoind = {
    ["Speed"] = 0,
	["Accel"] = 1,
	["Appearance"] = 2,
	["Turn"] = 3,
	["Step Zone"] = 4,
	["Scroll"] = 5,
	["NoteSkins"] = 6,
	["Remove"] = 7,
	["Freeze"] = 8,
	["Jump"] = 9,
	["Difficulty"] = 10,
	["Characters"] = 11,
	["Filter"] = 14,
	["Gauge"] = 13,
}

local function MakeRow(rownames,idx)
	hasFocus = idx == 1;
	local function IsExitRow()
		return idx == exitIndex;
	end
	return Def.ActorFrame{
		Name="Row"..idx;
		InitCommand=function(s) s:y(-196+28*(idx-1)) end,
		Def.Sprite{
			Texture="Line",
			InitCommand=function(s)
				s:visible(idx%2 == 1)
			end,
		};
		Def.Sprite{
			Texture="RowName Grey 1x17",
			InitCommand=function(s)
				s:animate(0):setstate(rowtoind[rownames]):xy(-12,0)
			end,
		};
		Def.Sprite{
            Texture="Block 1x2",
            InitCommand=function(s) s:animate(0):setstate(1):diffusealpha(0.15)
                :x(-315)
            end,
		};
		Def.Sprite{
            Texture="Block 1x2",
            InitCommand=function(s) s:animate(0):setstate(1):diffusealpha(0.15)
                :x(315)
            end,
        };
	};
end

local RowList = {};
for i=1,#rownames do
	RowList[#RowList+1] = MakeRow(rownames[i],i)
end

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:xy(_screen.cx,_screen.cy-50) end,
	OnCommand=cmd(addx,-SCREEN_WIDTH;sleep,0.2;accelerate,0.2;addx,SCREEN_WIDTH);
	OffCommand=cmd(sleep,0.2;accelerate,0.2;addx,SCREEN_WIDTH);
	Def.Sprite{
		Texture="page",
	};
	Def.ActorFrame{children=RowList};
};


for i=1,2 do
	t[#t+1] = Def.Sprite{
		Texture="exp",
		InitCommand=function(s) s:xy(i==1 and _screen.cx-250 or _screen.cx+250,SCREEN_BOTTOM-140) end,
		OnCommand=cmd(addx,-SCREEN_WIDTH;sleep,0.2;accelerate,0.2;addx,SCREEN_WIDTH);
	OffCommand=cmd(sleep,0.2;accelerate,0.2;addx,SCREEN_WIDTH);
	}
end

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor("options.lua",pn)
end

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:xy(_screen.cx-320,SCREEN_TOP+18) end,
	OffCommand=function(s)
		s:sleep(0.5):accelerate(0.2):addy(-120)
	end,
	LoadActor(THEME:GetPathG("","ScreenWithMenuElements header/base"));
	Def.Sprite{
		Texture=THEME:GetPathG("","ScreenWithMenuElements header/Text"),
		InitCommand=function(s) s:setstate(5):animate(0):y(20) end,
		OffCommand=function(s) s:sleep(0.5):linear(0.2):diffusealpha(0) end,
	};
};

return t;
