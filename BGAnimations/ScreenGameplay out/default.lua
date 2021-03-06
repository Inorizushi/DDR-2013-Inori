local t = Def.ActorFrame{
		-- Def.Quad{
		-- InitCommand=cmd(FullScreen;diffuse,color("0,0,0,0"));
		-- OnCommand=cmd(linear,5;diffusealpha,1);
	-- };

	-- Cleared song --
    LoadActor("ClearedSong.mp3") .. {
		StartTransitioningCommand=cmd(sleep,0.2;queuecommand,"Play");
    PlayCommand=cmd(play);
	};
  LoadActor("../_doors/01.png")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y-380;);
		OnCommand=cmd(sleep,2.2;linear,0.25;y,SCREEN_CENTER_Y);
	};
	LoadActor("../_doors/02.png")..{
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_CENTER_Y+380;);
		OnCommand=cmd(sleep,2.2;linear,0.25;y,SCREEN_CENTER_Y);
	};
};
	--------CLEARED-----------
t[#t+1] = Def.ActorFrame{
--Cleared--
	LoadActor("Cleared.lua") .. {
	InitCommand=function(self)
		local Song;
		if GAMESTATE:IsCourseMode() then
			song = GAMESTATE:GetCurrentCourse();
		else
			song = GAMESTATE:GetCurrentSong();
		end;
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y);
			if song:GetDisplayFullTitle() == "Tohoku EVOLVED" then
				self:visible(false);
			else
				self:visible(true);
		end;
	end;
	};
--tohoku--
	LoadActor("Tohoku") .. {
	InitCommand=function(self)
	if not GAMESTATE:IsCourseMode() then
		local song = GAMESTATE:GetCurrentSong();
		self:x(SCREEN_CENTER_X);
		self:y(SCREEN_CENTER_Y);
			if song:GetDisplayFullTitle() == "Tohoku EVOLVED" then
				self:visible(true);
			else
				self:visible(false);
		end;
	else
		self:diffusealpha(0);
	end;
	end;
	};

};

return t;
