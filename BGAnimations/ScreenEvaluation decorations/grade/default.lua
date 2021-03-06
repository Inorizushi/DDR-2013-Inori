local args = {...}
-- the only arg is arg 1, the player number
local function m(metric)
	metric = metric:gsub("PN", ToEnumShortString(args[1]))
	return THEME:GetMetric(Var "LoadingScreen",metric)
end

local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(args[1])

local tier = pss:GetFailed() and 'Grade_Failed' or pss:GetGrade()

if ThemePrefs.Get("ConvertScoresAndGrades") == true then
	tier = pss:GetFailed() and 'Grade_Failed' or SN2Grading.ScoreToGrade(pss:GetScore())
end

local ring = Def.ActorFrame {};

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	ring[#ring+1] = loadfile(THEME:GetPathB("ScreenEvaluation","decorations/grade/fc_ring"))(pss)..{
		InitCommand=function(s) s:xy(50,-44) end,
	};
end;

return Def.ActorFrame{
	ring;
	Def.Sprite{
		InitCommand = function(s) s:queuecommand("Set") end,
		OnCommand = function(s) s:zoom(0):sleep(0.3):bounceend(0.2):zoom(1) end,
		OffCommand = function(s) s:bounceend(0.2):zoom(0) end,
		SetCommand= function(s)
			s:Load(THEME:GetPathB("ScreenEvaluation decorations/grade/GradeDisplayEval", ToEnumShortString(tier)))
		end;
	};
	Def.Sprite{
		InitCommand = function(s) s:queuecommand("Set"):zoom(0):diffusealpha(0):rotationz(370) end,
		OnCommand=function(s) s:sleep(0.316):linear(0.266):diffusealpha(1):zoom(1):rotationz(-15) end,
		OffCommand=function(s) s:linear(0.1):y(20):diffusealpha(0) end,
		SetCommand=function(s)
			if pss:FullComboOfScore('TapNoteScore_W1') then
				s:Load(THEME:GetPathB("","ScreenEvaluation decorations/grade/MarvelousFullCombo 1x2"))
			elseif pss:FullComboOfScore('TapNoteScore_W2') then
				s:Load(THEME:GetPathB("","ScreenEvaluation decorations/grade/PerfectFullCombo 1x2 1x2"))
			elseif pss:FullComboOfScore('TapNoteScore_W3') or pss:FullComboOfScore('TapNoteScore_W4') then
				s:Load(THEME:GetPathB("","ScreenEvaluation decorations/grade/FullCombo 1x2"))
			end
		end,
	}
};

