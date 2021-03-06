local gc = Var("GameCommand");

return Def.ActorFrame {
	LoadFont("_itc avant garde std bk 20px") .. {
		Text=gc:GetText();
		InitCommand=function(s) s:y(100):uppercase(true):shadowlength(2):strokecolor(Color.Black):diffusealpha(0) end,
		OnCommand=function(s) s:sleep(1):linear(0.2):diffusealpha(1) end,
		GainFocusCommand=function(s) s:stoptweening():diffuseshift():effectcolor1(color("#FFFD86")):effectcolor2(Color.White)
			:effectperiod(2)
		end,
		LoseFocusCommand=function(s) s:stopeffect() end,
	};

};
