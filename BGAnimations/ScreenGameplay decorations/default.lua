local t = Def.ActorFrame{};

local LoadingScreen = Var "LoadingScreen"

--This is a helper function to make it easier to load metrics from the current screen definition.
local function m(metric,pn)
	if pn then
		metric = metric:gsub("PN", ToEnumShortString(pn))
	end
	return THEME:GetMetric(LoadingScreen,metric)
end

local ScoringPlayers = {}

local tns_reverse = Enum.Reverse(TapNoteScore)

t[#t+1] = Def.Actor{
	Name="ScoringController",
    JudgmentMessageCommand = function(_,params)
		SN2Scoring.PrepareScoringInfo(false)
        if not ScoringPlayers[params.Player] then
            ScoringPlayers[params.Player] = true
        end
		--worstJudge is used by the combo code
		if not ScoringInfo.worstJudge then
			ScoringInfo.worstJudge = {}
		end

		local wj = ScoringInfo.worstJudge[params.Player]
		if tns_reverse[params.TapNoteScore] <= tns_reverse['TapNoteScore_W1'] and
			tns_reverse[params.TapNoteScore] >= tns_reverse['TapNoteScore_Miss'] then
			if (not wj) or tns_reverse[params.TapNoteScore] < tns_reverse[wj] then
				ScoringInfo.worstJudge[params.Player] = params.TapNoteScore
			end
		end
        local es = (GAMESTATE:Env()).EndlessState
        if es then
            local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(params.Player)
            es.scoring.handleNoteScore(params.HoldNoteScore or params.TapNoteScore,
                GAMESTATE:GetCurrentStageIndex()+1,
                pss:GetCurrentCombo())
            --SCREENMAN:SystemMessage(es.scoring.getScoreString())
        end
    end,
}

local function ScoreUpdate()
    for pn, _ in pairs(ScoringPlayers) do
        local info = ScoringInfo[pn]
        local stage = GAMESTATE:IsCourseMode() and GAMESTATE:GetCourseSongIndex() + 1 or nil
        local pss = STATSMAN:GetCurStageStats():GetPlayerStageStats(pn)
        local score = info.GetCurrentScore(pss, stage)
        pss:SetScore(score)
        local scoreDisplay = SCREENMAN:GetTopScreen():GetChild("Score"..ToEnumShortString(pn))
        if scoreDisplay and scoreDisplay:GetChild("Text") then
            scoreDisplay:GetChild("Text"):targetnumber(score)
        end
        pss:SetCurMaxScore(info.GetCurrentMaxScore(pss, stage))
    end
end

t[#t+1] = Def.ActorFrame{
    Name = "ScoringController2",
    InitCommand = function(s) s:SetUpdateFunction(ScoreUpdate) end
};

t[#t+1] = Def.ActorFrame{
	Name="StageFrame";
	InitCommand=function(s)
		s:xy(_screen.cx,SCREEN_TOP+38):visible(not GAMESTATE:IsDemonstration()):draworder(2)
	end,
	LoadActor("stageframe");
}

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	t[#t+1] = Def.Actor{
		InitCommand=function(s)
			if PREFSMAN:GetPreference("FailOffForFirstStageEasy") == false and GAMESTATE:GetCurrentSteps(pn):GetDifficulty() == 'Difficulty_Easy' then
				if GAMESTATE:GetCurrentStage() == 0 or GAMESTATE:GetCurrentStage() == 13 then
				  GAMESTATE:SetFailTypeExplicitlySet()
				end
			end
			if PREFSMAN:GetPreference("FailOffInBeginner") == false and GAMESTATE:GetCurrentSteps(pn):GetDifficulty() == 'Difficulty_Beginner' then
				GAMESTATE:SetFailTypeExplicitlySet()
			end
		end,
	};
	t[#t+1] = LoadActor("lifeframe",pn);
	t[#t+1] = LoadActor("scoreframe");
	t[#t+1] = Def.Sound{
		File="FullCombo/Combo_Splash",
		Name="ComboSplash"..ToEnumShortString(pn),
		SupportPan=true,
	};
	t[#t+1] = LoadActor("FullCombo",pn)..{
		InitCommand=function(s) s:x(pn==PLAYER_1 and ScreenGameplay_P1X() or ScreenGameplay_P2X()) end,
	};
end

--[[t[#t+1] = LoadActor( THEME:GetPathB("","optionicon_P1") ) .. {
	InitCommand=cmd(player,PLAYER_1;zoom,1.4;x,WideScale(SCREEN_LEFT+140,SCREEN_LEFT+140);draworder,1);
	OnCommand=function(self)
		if GAMESTATE:PlayerIsUsingModifier(PLAYER_1,'reverse') then
			self:y(SCREEN_TOP+70);
		else
			self:y(SCREEN_BOTTOM-70);
		end;
	end;
};
t[#t+1] = LoadActor( THEME:GetPathB("","optionicon_P2") ) .. {
	InitCommand=cmd(player,PLAYER_2;zoom,1.4;x,WideScale(SCREEN_RIGHT-140,SCREEN_RIGHT-140);draworder,1);
	OnCommand=function(self)
		if GAMESTATE:PlayerIsUsingModifier(PLAYER_2,'reverse') then
			self:y(SCREEN_TOP+70);
		else
			self:y(SCREEN_BOTTOM-70);
		end;
	end;
};]]--

return t
