local pn = ...

local GR = {
    {0,-60, "Stream"}, --STREAM
    {-88,-18, "Voltage"}, --VOLTAGE
    {-68,46, "Air"}, --AIR
    {67,46, "Freeze"}, --FREEZE
    {88,-18, "Chaos"}, --CHAOS
};

local Labels = Def.ActorFrame{}

for i,v in ipairs(GR) do
    Labels[#Labels+1] = Def.ActorFrame{
        InitCommand=function(s)
            s:xy(v[1],v[2]):zoom(0)
        end,
        OnCommand=function(s) s:sleep(0.3):linear(0.2):zoom(1) end,
        AnOffMessageCommand=function(s)
            s:sleep(0.2):linear(0.2):zoom(0)
        end,
        Def.Sprite{
            Texture=THEME:GetPathB("ScreenSelectMusic","decorations/Difficulty/Labels 1x5"),
            OnCommand=function(s) s:animate(0):setstate(i-1):zoom(0.8) end,
        };
    }
end

local yspacing=26
local DiffList = Def.ActorFrame{};

local DiffToIndex = {
    ["Difficulty_Beginner"] = 0,
    ["Difficulty_Easy"] = 1,
    ["Difficulty_Medium"] = 2,
    ["Difficulty_Hard"] = 3,
    ["Difficulty_Challenge"] = 4,
}

local DiffToIndexOut = {
    ["Difficulty_Beginner"] = 4,
    ["Difficulty_Easy"] = 3,
    ["Difficulty_Medium"] = 2,
    ["Difficulty_Hard"] = 1,
    ["Difficulty_Challenge"] = 0,
}

local function DrawDiffListItem(diff)
    local DifficultyListItem = Def.ActorFrame{
        InitCommand=function(s) s:y((Difficulty:Reverse()[diff]*yspacing)-52) end,
        ["CurrentSteps" .. ToEnumShortString(pn) .. "ChangedMessageCommand"]=function(s) s:queuecommand("Set") end,
        CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
        Def.Sprite{
            Texture="DiffLine 1x3",
            InitCommand=function(s) s:animate(0):zoomx(0):setstate(0) end,
            OnCommand=function(s) s:sleep(0.2):sleep(DiffToIndex[diff]/20):decelerate(0.1):zoomx(1) end,
            AnOffMessageCommand=function(s)
                s:sleep(0.2):sleep(DiffToIndexOut[diff]/20):linear(0.2):zoomx(0)
            end,
            SetCommand=function(s)
                if GAMESTATE:GetCurrentSteps(pn):GetDifficulty() == diff then
                    s:setstate(pn==PLAYER_1 and 1 or 2):diffuse(color("0.8,0.8,0.8,1"))
                else
                    s:setstate(0):diffuse(Color.White)
                end
            end,
        };
        Def.ActorFrame{
            InitCommand=function(s) s:diffusealpha(0) end,
            OnCommand=function(s) s:sleep(0.5):diffusealpha(1) end,
            AnOffMessageCommand=function(s) s:sleep(0.1):diffusealpha(0) end,
            Def.Sprite{
                Texture="DiffName 1x5",
                InitCommand=function(s) s:animate(0):setstate(DiffToIndex[diff]):x(-58) end,
                SetCommand=function(s)
                    local song = GAMESTATE:GetCurrentSong()
                    local st=GAMESTATE:GetCurrentStyle():GetStepsType();
                    if song then
                        if song:HasStepsTypeAndDifficulty(st,diff) then
                            s:Load(THEME:GetPathB("ScreenSelectMusic","decorations/DIfficulty/DiffName 1x5"))
                            s:setstate(DiffToIndex[diff]):diffusealpha(1)
                            if GAMESTATE:GetCurrentSteps(pn):GetDifficulty() == diff then
                                s:zoom(1.1)
                            else
                                s:zoom(1)
                            end
                        else
                            s:Load(THEME:GetPathB("ScreenSelectMusic","decorations/DIfficulty/DiffNameGrey 1x5"))
                            s:diffusealpha(0.5):setstate(DiffToIndex[diff])
                        end
                    else
                        s:Load(THEME:GetPathB("ScreenSelectMusic","decorations/DIfficulty/DiffNameGrey 1x5"))
                        s:diffusealpha(0.5):setstate(DiffToIndex[diff])
                    end
                end,
            };
            Def.Sprite{
                Texture="DiffFoot 1x6",
                InitCommand=function(s) s:animate(0):setstate(DiffToIndex[diff]):x(6) end,
                SetCommand=function(s)
                    local song = GAMESTATE:GetCurrentSong()
                    local st=GAMESTATE:GetCurrentStyle():GetStepsType();
                    if song then
                        if song:HasStepsTypeAndDifficulty(st,diff) then
                            s:setstate(DiffToIndex[diff]):diffusealpha(1)
                        else
                            s:diffusealpha(0):setstate(5)
                        end
                    else
                        s:diffusealpha(0):setstate(5)
                    end
                end,
            };
            Def.BitmapText{
                Font="_itc avant garde std bk 20px",
                Text="10",
                InitCommand=function(s) s:zoom(0.8):strokecolor(Color.Black):xy(36,2):halign(1)
                    :diffuse(CustomDifficultyToColor(diff))
                end,
                SetCommand=function(s)
                    local song = GAMESTATE:GetCurrentSong()
                    local st=GAMESTATE:GetCurrentStyle():GetStepsType();
                    if song then
                        if song:HasStepsTypeAndDifficulty(st,diff) then
                            local steps = song:GetOneSteps( st, diff )
                            s:settext(steps:GetMeter()):diffusealpha(1)
                        else
                            s:diffusealpha(0):settext("00")
                        end
                    else
                        s:diffusealpha(0):settext("00")
                    end
                end,
    
            };
        };
    };
    return DifficultyListItem
end

local difficulties = {"Difficulty_Beginner", "Difficulty_Easy", "Difficulty_Medium", "Difficulty_Hard", "Difficulty_Challenge"}

for diff in ivalues(difficulties) do
    DiffList[#DiffList+1] = DrawDiffListItem(diff)
end

return Def.ActorFrame{
    OnCommand=function(s) s:zoomy(0):sleep(0.2):linear(0.1):zoomy(1) end,
    AnOffMessageCommand=function(s) s:sleep(0.5):linear(0.15):zoomy(0) end,
    Def.ActorFrame{
        Name="DiffPane",
        InitCommand=function(s) s:y(68) end,
        Def.Sprite{Texture="DiffPane",};
        DiffList;
    };
    Def.ActorFrame{
        Name="RadarPane",
        InitCommand=function(s) s:y(-66) end,
        Def.Sprite{Texture="Top",};
        Def.ActorFrame{
            InitCommand=function(s) s:y(6):zoom(0):diffusealpha(0) end,
            OnCommand=function(s) s:sleep(0.2):linear(0.15):zoom(1):diffusealpha(1) end,
            AnOffMessageCommand=function(s) s:sleep(0.4):linear(0.2):zoom(0):diffusealpha(0) end,
            Labels;
            Def.Sprite{
                Texture="GR 1x2",
                InitCommand=function(s) s:animate(false):setstate(pn==PLAYER_1 and 0 or 1) end,
            };
            create_ddr_groove_radar("radar",0,0,pn,50,Alpha(PlayerColor(pn),0.1),
                {Alpha(PlayerColor(pn),0.75),Alpha(PlayerColor(pn),0.75),
                Alpha(PlayerColor(pn),0.75),Alpha(PlayerColor(pn),0.75),
                Alpha(PlayerColor(pn),0.75)}
            )..{
                InitCommand=function(s) s:zoom(0) end,
                CurrentSongChangedMessageCommand=function(s)
                    if GAMESTATE:GetCurrentSong() then
                        s:visible(true)
                    else
                           s:visible(false)
                    end
                end,
                OnCommand=function(s) s:sleep(0.5):linear(0.1):zoom(1) end,
                AnOffMessageCommand=function(s) s:sleep(0.1):linear(0.2):zoom(0) end,
            };
        };
    };
}