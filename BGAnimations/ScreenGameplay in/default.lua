local playMode = GAMESTATE:GetPlayMode()
if playMode ~= 'PlayMode_Regular' and playMode ~= 'PlayMode_Rave' and playMode ~= 'PlayMode_Battle' then
	curStage = playMode;
end;
local sStage = GAMESTATE:GetCurrentStage();
local tRemap = {
	Stage_1st		= 1,
	Stage_2nd		= 2,
	Stage_3rd		= 3,
	Stage_4th		= 4,
	Stage_5th		= 5,
	Stage_6th		= 6,
};

if tRemap[sStage] == PREFSMAN:GetPreference("SongsPerPlay") then
	sStage = "Stage_Final";
else
	sStage = sStage;
end;
local t = Def.ActorFrame {};
t[#t+1] = LoadActor(THEME:GetPathB("ScreenStageInformation","in/BG")) .. {
		InitCommand=cmd(FullScreen);
		OnCommand=cmd(sleep,0.2;linear,0.25;diffusealpha,0);
	};
t[#t+1] = Def.Quad{
	InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y;diffuse,color("#000000");zoomto,326,326;diffusealpha,1);
	OnCommand=cmd(zoom,1;linear,0.1;zoomy,0);
	};
--Jacket--
t[#t+1] = Def.ActorFrame {
 	InitCommand=cmd(CenterX;y,SCREEN_CENTER_Y;diffusealpha,1;zoom,1);
	OnCommand=cmd(zoomy,1;linear,0.1;zoomy,0);
	Def.Sprite {
		OnCommand=function(self)
			local song = GAMESTATE:GetCurrentSong();
			local group = song:GetGroupName();
				if song then
					if song:HasJacket() then
						self:LoadBackground(song:GetJacketPath());
						self:setsize(320,320);
					elseif song:HasBackground() then
						self:LoadFromSongBackground(GAMESTATE:GetCurrentSong());
						self:setsize(320,320);
					else
						self:Load(THEME:GetPathG("","Common fallback jacket"));
						self:setsize(320,320);
					end;
				else
					self:diffusealpha(0);
				end;
		end;
	};
};
t[#t+1] = Def.ActorFrame {
	InitCommand=function(s) s:Center() end,
	Def.Sprite{
		Texture=THEME:GetPathB("ScreenStageInformation", "in/_stages/stage " .. ToEnumShortString(sStage) ),
		OnCommand=function(s) s:diffusealpha(1):linear(0.1):diffusealpha(0):zoomx(1.2):zoomy(0) end,
	};
	LoadActor( "ready" ) .. {
		InitCommand=function(s) s:diffusealpha(0):zoomx(1.2):zoomy(0) end,
		OnCommand=function(s) s:sleep(0.05):linear(0.1):diffusealpha(1):zoomx(1):zoomy(1.1)
			:linear(0.1):zoomy(1):sleep(1):linear(0.1):diffusealpha(0):zoomx(1.2):zoomy(0)
		end,
	};
	LoadActor( "go" ) .. {
		InitCommand=function(s) s:diffusealpha(0):zoomx(1.2):zoomy(0) end,
		OnCommand=function(s) s:sleep(1.25):linear(0.1):diffusealpha(1):zoomx(1):zoomy(1.1):linear(0.1):zoomy(1)
			:sleep(0.5):linear(0.1):diffusealpha(0):zoomx(1.2):zoomy(0)
		end,
	};
};

return t;
