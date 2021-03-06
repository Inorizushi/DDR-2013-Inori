local args = {...}
-- the only arg is arg 1, the player number
local function m(metric)
	metric = metric:gsub("PN", ToEnumShortString(args[1]))
	return THEME:GetMetric(Var "LoadingScreen",metric)
end

local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(args[1])

local tier = SN2Grading.ScoreToGrade(pss:GetScore(), pss:GetPlayedSteps()[1]:GetDifficulty())

local t = Def.ActorFrame {};

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
t[#t+1] = Def.ActorFrame{
	Def.Sprite{
		InitCommand = function(s) s:draworder(98):player(pn):x(m "RingPNX"):y(m "RingPNY"):zoom(0) end,
		OnCommand=function(self)
		local staw = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetStageAward();
			if staw ~= nil then
				if((staw =="StageAward_SingleDigitW4") or (staw =="StageAward_OneW4") or (staw =="StageAward_FullComboW4") or string.find(staw,"W4")) then
					self:Load(THEME:GetPathB("","ScreenEvaluationNormal overlay/grade/GoodFullcombo_ring.png"));
				elseif((staw =="StageAward_SingleDigitW3") or (staw =="StageAward_OneW3") or (staw =="StageAward_FullComboW3") or string.find(staw,"W3")) then
					self:Load(THEME:GetPathB("","ScreenEvaluationNormal overlay/grade/GreatFullcombo_ring.png"));
				elseif((staw =="StageAward_SingleDigitW2") or (staw =="StageAward_OneW2") or (staw =="StageAward_FullComboW2") ) then
					self:Load(THEME:GetPathB("","ScreenEvaluationNormal overlay/grade/PerfectFullcombo_ring.png"));
				elseif (staw =="StageAward_FullComboW1") then
					self:Load(THEME:GetPathB("","ScreenEvaluationNormal overlay/grade/MarvelousFullcombo_ring.png"));
				end;
				(cmd(linear,0.2;zoom,0.65;spin;effectmagnitude,0,0,170))(self);
			end;
		end;
		OffCommand=cmd(linear,0.2;zoom,0);
	};
	--Lines
	Def.Sprite{
		InitCommand = function(s) s:draworder(98):player(pn):x(m "RingPNX"):y(m "RingPNY"):zoom(0) end,
		OnCommand=function(self)
		local staw = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetStageAward();
			if staw ~= nil then
				if((staw =="StageAward_SingleDigitW4") or (staw =="StageAward_OneW4") or (staw =="StageAward_FullComboW4") or string.find(staw,"W4")) then
					self:Load(THEME:GetPathB("","ScreenEvaluationNormal overlay/grade/GoodFullcombo_lines.png"));
			elseif((staw =="StageAward_SingleDigitW3") or (staw =="StageAward_OneW3") or (staw =="StageAward_FullComboW3") or string.find(staw,"W3")) then
					self:Load(THEME:GetPathB("","ScreenEvaluationNormal overlay/grade/GreatFullcombo_lines.png"));
				elseif((staw =="StageAward_SingleDigitW2") or (staw =="StageAward_OneW2") or (staw =="StageAward_FullComboW2") ) then
					self:Load(THEME:GetPathB("","ScreenEvaluationNormal overlay/grade/PerfectFullcombo_lines.png"));
				elseif (staw =="StageAward_FullComboW1") then
					self:Load(THEME:GetPathB("","ScreenEvaluationNormal overlay/grade/MarvelousFullcombo_lines.png"));
				end;
				(cmd(linear,0.2;zoom,0.65;spin;effectmagnitude,0,0,-170))(self);
			end;
		end;
		OffCommand=cmd(linear,0.2;zoom,0);
	};
} ;
end;

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
t[#t+1] = Def.ActorFrame{
	Def.Sprite{
		InitCommand = function(s) s:x(m "GradePNX"):y(m "GradePNY"):playcommand("Set") end,
		OnCommand = m "GradePNOnCommand",
		OffCommand = m "GradePNOffCommand",
		SetCommand= function(s)
			local failed = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn):GetFailed();
			if failed then
				s:Load(THEME:GetPathB("","ScreenEvaluationNormal overlay/grade/GradeDisplayEval Failed"))
			else
				s:Load(THEME:GetPathB("ScreenEvaluationNormal overlay/grade/GradeDisplayEval", ToEnumShortString(tier)))
			end;
		end;
	};
};
end;

return t;
