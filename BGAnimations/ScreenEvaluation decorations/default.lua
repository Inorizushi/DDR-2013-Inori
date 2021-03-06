local t = LoadFallbackB();

t[#t+1] = Def.ActorFrame{
	Def.Sprite{
		Texture="base",
		InitCommand=function(s) s:FullScreen():diffusealpha(0) end,
	}
}

t[#t+1] = LoadActor("RES_RANK")..{
	OnCommand=cmd(play);
};


t[#t+1] = Def.ActorFrame {
	Condition=GAMESTATE:HasEarnedExtraStage() and GAMESTATE:IsExtraStage() and not GAMESTATE:IsExtraStage2();
	InitCommand=cmd(draworder,105);
	LoadActor( THEME:GetPathS("ScreenEvaluation","try Extra1" ) ) .. {
		Condition=THEME:GetMetric( Var "LoadingScreen","Summary" ) == false;
		OnCommand=cmd(play);
	};
};

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor("grade", pn)..{
		InitCommand=function(s) s:xy(pn==PLAYER_1 and _screen.cx-390 or _screen.cx+390,_screen.cy-170) end,
	};
end

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:xy(_screen.cx,_screen.cy-180) end,
	OffCommand=function(s) s:sleep(0.333):decelerate(0.066):zoom(1.05):diffusealpha(0) end,
	Def.Sprite{ Texture="jacket frame"}..{
		InitCommand=function(s) s:zoom(0) end,
		OnCommand=function(s)
			s:sleep(0.333):decelerate(0.133)
			:zoom(1.1):decelerate(0.1):zoom(1)
		end,
	};
	Def.Sprite{
		InitCommand=function(s) s:x(-180):zoom(0.5):diffusealpha(0) end,
		OnCommand=function(s)
			local song = GAMESTATE:GetCurrentSong()
			if song:HasJacket() then
				s:LoadBackground(song:GetJacketPath());
			elseif song:HasBackground() then
				s:LoadFromSongBackground(GAMESTATE:GetCurrentSong());
			else
				s:Load(THEME:GetPathG("","Common fallback jacket"));
			end;
			s:setsize(102,102)
			s:sleep(0.333):decelerate(0.133)
			:zoom(1.1):diffusealpha(0.75):decelerate(0.1):zoom(1):diffusealpha(1)
		end,
	};
	Def.ActorFrame{
		InitCommand=function(s)
			s:xy(44,8):diffusealpha(0)
		end,
		OnCommand=function(s)
			s:sleep(0.333):decelerate(0.133)
			:xy(33,0):diffusealpha(0.75):decelerate(0.1):diffusealpha(1):xy(44,8)
		end,
		Def.BitmapText{
			Name="Title",
			Font="_helvetica Bold 24px",
			InitCommand=function(s) s:DiffuseAndStroke(Color.Black,Color.White):zoom(0.85):y(-12):maxwidth(400) end,
			OnCommand=function(s) 
				local song = GAMESTATE:GetCurrentSong()
				if song then
					s:settext(song:GetDisplayMainTitle())
				end
			end,
		};
		Def.BitmapText{
			Name="Artist",
			Font="_helvetica Bold 24px",
			InitCommand=function(s) s:DiffuseAndStroke(Color.Black,Color.White):zoom(0.85):y(12):maxwidth(400) end,
			OnCommand=function(s)
				local song = GAMESTATE:GetCurrentSong()
				if song then
					s:settext(song:GetDisplayArtist())
				end
			end,
		}
	};
};

t[#t+1] = Def.ActorFrame{
	InitCommand=function(s) s:xy(_screen.cx,SCREEN_CENTER_Y-64):zoomy(0) end,
	OnCommand=function(s) s:sleep(0.333):linear(0.2):zoomy(1) end,
	OffCommand=function(s) s:sleep(0.2):linear(0.2):zoomy(0) end,
	Def.Sprite{Texture="judgement frame",
		InitCommand=function(s) s:valign(0) end,
	};
	Def.Sprite{Texture="judgement lines",
		InitCommand=function(s) s:valign(0):y(36) end,
	};
};

local DiffToInd = {
	['Difficulty_Beginner'] = 0;
	['Difficulty_Easy'] = 1;
	['Difficulty_Medium'] = 2;
	['Difficulty_Hard'] = 3;
	['Difficulty_Challenge'] = 4;
};

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = Def.ActorFrame{
		InitCommand=function(s) s:xy(pn==PLAYER_1 and _screen.cx-340 or _screen.cx+340,_screen.cy-30) end,
		LoadActor("player indent")..{
			OnCommand=function(s) s:zoomy(0):sleep(0.7):linear(0.2):zoomy(1) end,
			OffCommand=function(s) s:linear(0.2):zoomy(0) end,
		};
		Def.Sprite{
			Texture="Player 1x2",
			InitCommand=function(self)
				self:animate(0):setstate(pn==PLAYER_1 and 0 or 1)
				self:x(pn==PLAYER_1 and 5 or -5):y(-11)
			end;
			OnCommand=function(s) s:zoomy(0):sleep(1):linear(0.2):zoomy(1) end,
			OffCommand=function(s) s:linear(0.2):zoomy(0) end,
		};
		Def.Sprite{
			Texture=THEME:GetPathG("","_shared/"..ToEnumShortString(pn).." BADGE"),
			InitCommand=function(self)
				self:x(pn==PLAYER_1 and -92 or 276):y(-2)
			end;
			OnCommand=cmd(diffusealpha,0;rotationz,90;sleep,1;linear,0.2;rotationz,0;diffusealpha,1);
			OffCommand=cmd(linear,0.2;rotationz,90;diffusealpha,0);
		};
		Def.Sprite{
			Texture="Diff 1x5";
			InitCommand=function(self)
				self:pause()
				self:x(pn==PLAYER_1 and 28 or -28):y(8)
				local song = GAMESTATE:GetCurrentSong()
				local steps = GAMESTATE:GetCurrentSteps(pn):GetDifficulty()
				if song then
					self:setstate(DiffToInd[steps])
				end
			end;
			OnCommand=cmd(diffusealpha,0;zoomy,0;sleep,1.05;linear,0.2;zoomy,1;diffusealpha,1);
			OffCommand=cmd(linear,0.2;zoomy,0);
		};
	};
end

--StatsP1--

t[#t+1] = Def.Sprite{
	Texture="Score.png",
	InitCommand=function(s)
		s:xy(_screen.cx,_screen.cy+228):zoomy(0)
	end,
	OnCommand=function(s) s:sleep(0.8):linear(0.2):zoomy(1) end,
	OffCommand=function(s) s:linear(0.2):zoomy(0) end,
}

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = LoadActor("stats.lua",pn)..{
		InitCommand=function(s) s:addy(0):zoom(1):x(_screen.cx-100):diffusealpha(0) end,
		OnCommand=function(s) s:sleep(0.7):diffusealpha(1) end,
		OffCommand=function(s) s:linear(0.2):diffusealpha(0) end,
	};
	t[#t+1] = Def.RollingNumbers {
		File = THEME:GetPathF("","ScreenEvaluation Score");
		InitCommand=function(s) s:draworder(6):xy(pn==PLAYER_1 and _screen.cx-338 or _screen.cx+338,_screen.cy+230)
			:queuecommand("Set")
		end,
		OnCommand=cmd(diffusealpha,0;sleep,1;diffusealpha,1);
		OffCommand=cmd(sleep,0.067;zoom,0);
		SetCommand = function(self)
			local score = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetScore();
			self:Load("RollingNumbersEval")
			:targetnumber(score)
		end;
	};
end

return t
