local sStage = GAMESTATE:GetCurrentStage();
local song = GAMESTATE:GetCurrentSong();

local tRemap = {
	Stage_1st		= 1,
	Stage_2nd		= 2,
	Stage_3rd		= 3,
	Stage_4th		= 4,
	Stage_5th		= 5,
	Stage_6th		= 6,
};

local function ordinal(num)
    last_digit = num % 10
    if last_digit == 1 and num ~= 11
        then return 'st'
    elseif last_digit == 2 and num ~= 12
        then return 'nd'
    elseif last_digit == 3 and num ~= 13
        then return 'rd'
    else 
        return 'th'
    end
end

local t = Def.ActorFrame{
    InitCommand=function(s)
        s:y(10)
    end,
};

-- Long or Marathon for Final
if tRemap[sStage] == PREFSMAN:GetPreference("SongsPerPlay") then
	t[#t+1] = Def.BitmapText{
        Font="Gameplay StageDisplay",
        SetCommand=function(s)
            s:settext(StageToLocalizedString(sStage))
        end,
    };
elseif not GAMESTATE:IsEventMode() and song:IsLong() and tRemap[sStage]+1 == PREFSMAN:GetPreference("SongsPerPlay") then
	t[#t+1] = Def.Sprite{ Texture="Stage 1x5",
        SetCommand=function(s) s:animate(0):setstate(0) end,
    };
elseif not GAMESTATE:IsEventMode() and song:IsMarathon() and tRemap[sStage]+2 == PREFSMAN:GetPreference("SongsPerPlay") then
	t[#t+1] = Def.Sprite{ Texture="Stage 1x5",
        SetCommand=function(s) s:animate(0):setstate(0) end,
    };
elseif GAMESTATE:IsEventMode() then
    t[#t+1] = Def.BitmapText{ Font="Gameplay StageDisplay",
        SetCommand=function(s)
            local stage = GAMESTATE:GetCurrentStageIndex()+1
            s:settext(stage..ordinal(stage))
        end,
    };
else
    t[#t+1] = Def.Sprite{ Texture="Stage 1x5",
        SetCommand=function(s) s:animate(0)
            if sStage == "Stage_Final" then s:setstate(0)
            elseif sStage == "Stage_Event" then s:setstate(1)
            elseif sStage == "Stage_Extra1" then s:setstate(3)
            elseif sStage == "Stage_Extra2" then s:setstate(4)
            end
        end,
    };
end;

return Def.ActorFrame{
    OnCommand=function(s) s:queuecommand("Set") end,
    CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
    Def.Sprite{
        Texture="normal",
    };
    t;
};