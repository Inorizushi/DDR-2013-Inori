local pn = ...

local Combo = 	STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):MaxCombo();

local Marvelous = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetTapNoteScores("TapNoteScore_W1");
local Perfect = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetTapNoteScores("TapNoteScore_W2");
local Great = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetTapNoteScores("TapNoteScore_W3");
local Good = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetTapNoteScores("TapNoteScore_W4");
local Ok = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetHoldNoteScores("HoldNoteScore_Held");
local Miss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetTapNoteScores("TapNoteScore_Miss");

local JudgeNumber = Def.RollingNumbers{
	File=THEME:GetPathF("","ScreenEvaluation judge"),
	InitCommand=function(s) s:strokecolor(Color.Black):zoom(1):draworder(5)
		:halign(pn==PLAYER_1 and 1 or 0):Load("RollingNumbersJudgment")
	end,
};

--Max Combo--

return Def.ActorFrame{
	JudgeNumber..{
		Name="Combo",
		InitCommand=function(s) s:y(_screen.cy+178) end,
		OnCommand=function(s) s:targetnumber(Combo) end,
	};
	JudgeNumber..{
		Name="Marvelous",
		InitCommand=function(s) s:y(_screen.cy-14) end,
		OnCommand=function(s) s:targetnumber(Marvelous) end,
	};
	JudgeNumber..{
		Name="Perfect",
		InitCommand=function(s) s:y(_screen.cy+18) end,
		OnCommand=function(s) s:targetnumber(Perfect) end,
	};
	JudgeNumber..{
		Name="Great",
		InitCommand=function(s) s:y(_screen.cy+50) end,
		OnCommand=function(s) s:targetnumber(Great) end,
	};
	JudgeNumber..{
		Name="Good",
		InitCommand=function(s) s:y(_screen.cy+82) end,
		OnCommand=function(s) s:targetnumber(Good) end,
	};
	JudgeNumber..{
		Name="Ok",
		InitCommand=function(s) s:y(_screen.cy+114) end,
		OnCommand=function(s) s:targetnumber(Ok) end,
	};
	JudgeNumber..{
		Name="Miss",
		InitCommand=function(s) s:y(_screen.cy+146) end,
		OnCommand=function(s) s:targetnumber(Miss) end,
	};
}
