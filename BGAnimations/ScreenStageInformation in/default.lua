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

return Def.ActorFrame {
	InitCommand=function(s) s:Center() end,
	-- Door sound
	Def.Sound{
		File=THEME:GetPathS( "", "_Door" ),
		StartTransitioningCommand=function(s) s:play() end;
	};

	--- Load Background Doors Song Frame ---
	Def.Sprite{
		Texture="BG.png",
		InitCommand=function(s) s:diffusealpha(0) end,
		OnCommand=function(s) s:sleep(1):diffusealpha(1):sleep(3.5) end,
	};
	Def.Sprite{
		Texture="BG.png",
		InitCommand=function(s) s:diffusealpha(0):blend(Blend.Add) end,
		OnCommand=function(s) s:zoom(1):sleep(2.2):diffusealpha(0.5):linear(1):zoom(3):diffusealpha(0) end,
	};

	---- DOOR OPEN > CLOSE  CLOSE > OPEN
	Def.Sprite{
		Texture=THEME:GetPathB("","_doors/01.png"),
		InitCommand=function(s) s:y(-360) end,
		OnCommand=function(s) s:linear(0.25):y(0):sleep(1.80):linear(0.45):y(-380) end,
	};
	Def.Sprite{
		Texture=THEME:GetPathB("","_doors/02.png"),
		InitCommand=function(s) s:y(360) end,
		OnCommand=function(s) s:linear(0.25):y(0):sleep(1.80):linear(0.45):y(380) end,
	};

	--- DDR2013 LOGO  apparition > disparition ---
    Def.Sprite{
		Texture=THEME:GetPathB("","_doors/logo.png"),
		OnCommand=function(s) s:diffusealpha(0):sleep(0.25):linear(0.25)
			:diffusealpha(1):sleep(1.50):linear(0.25):diffusealpha(0)
		end,
	};
	Def.Sprite{
		Texture=THEME:GetPathB("","_doors/logo.png"),
		InitCommand=function(s) s:diffuse(Alpha(Color.White,0.5)):blend(Blend.Add) end,
		OnCommand=function(s) s:diffusealpha(0):sleep(0.3):linear(0.1):diffusealpha(0.5):linear(0.1):diffusealpha(0) end,
	};

	--- Flash SONG BANNER  sound------
	LoadActor("SoundStage");

	Def.ActorFrame{
		Name="Jacket",
		OnCommand=function(s) s:diffusealpha(0):zoom(4):sleep(2.1):linear(0.1):diffusealpha(1):zoom(0.9):linear(0.1):zoom(1) end,
		Def.Quad{
			InitCommand=function(s) s:diffuse(Color.Black):setsize(464,464) end,
		};
		Def.Sprite{
			InitCommand=function(s)
				if not GAMESTATE:IsCourseMode() then
					local song = GAMESTATE:GetCurrentSong();
					if song:HasJacket() then
						s:Load(song:GetJacketPath())
					elseif song:HasBackground() then
						s:LoadFromSongBackground(song)
					else
						s:Load(THEME:GetPathG("","Common fallback jacket"))
					end
				else
					local song = GAMESTATE:GetCurrentCourse()
					if course:GetBackgroundPath() then
						s:Load(course:GetBackgroundPath())
					else
						s:Load(THEME:GetPathG("","Common fallback jacket"))
					end
				end
				s:setsize(456,456)
			end,
		};
	};
	LoadActor("StageDisplay");
};
