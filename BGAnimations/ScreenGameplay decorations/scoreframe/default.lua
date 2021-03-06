local t = Def.ActorFrame{}

local DiffToIndex = {
    ["Difficulty_Beginner"] = 0,
    ["Difficulty_Easy"] = 1,
    ["Difficulty_Medium"] = 2,
    ["Difficulty_Hard"] = 3,
    ["Difficulty_Challenge"] = 4,
    ["Difficulty_Edit"] = 5,
}

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
    t[#t+1] = Def.ActorFrame{
        InitCommand=function(s) s:x(pn==PLAYER_1 and SCREEN_LEFT+192 or SCREEN_LEFT-192) end,
        Def.Sprite{
            Texture="scoreframe",
            InitCommand=function(s) s:y(SCREEN_BOTTOM-58) end,
        };
        Def.ActorFrame{
            Name="Difficulty Frame",
            SetCommand=function(s)
                local reverse = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):Reverse() == 1
                s:y(reverse and SCREEN_TOP+64 or SCREEN_BOTTOM-86)
            end,
            Def.Sprite{
                Texture="diffframe",
                SetCommand=function(s)
                    local reverse = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):Reverse() == 1
                    s:zoomy(reverse and -1 or 1)
                end,
            };
            Def.Sprite{
                Texture="diff 1x6.png",
                InitCommand=function(s) s:x(pn==PLAYER_1 and -110 or 110) end,
                SetCommand=function(s)
                    local reverse = GAMESTATE:GetPlayerState(pn):GetPlayerOptions("ModsLevel_Preferred"):Reverse() == 1
                    local diff = GAMESTATE:GetCurrentSteps(pn):GetDifficulty()
                    s:animate(0):setstate(DiffToIndex[diff])
                    s:y(reverse and -1 or 1)
                end,
            };
        };
    };
end


return Def.ActorFrame{
    InitCommand=function(s) s:visible(not GAMESTATE:IsDemonstration()):draworder(2) end,
    CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
    Def.ActorFrame{
        InitCommand=function(s) s:CenterX():y(SCREEN_BOTTOM-58) end,
        Def.Sprite{
            Texture="mid",
            InitCommand=function(s) s:setsize(376,54) end,
        };
        Def.BitmapText{
            Name="Title",
            Font="_helvetica Bold 24px",
            InitCommand=function(s)
                s:xy(-170,-8):maxwidth(300):strokecolor(Color.Black):halign(0)
            end,
            SetCommand=function(s)
                local song = GAMESTATE:GetCurrentSong()
                if song then
                    s:settext(song:GetDisplayMainTitle())
                end
            end,
        };
        Def.BitmapText{
            Name="Title",
            Font="_helvetica Bold 24px",
            InitCommand=function(s)
                s:xy(-170,12):maxwidth(300):strokecolor(Color.Black):halign(0):zoom(0.8)
            end,
            SetCommand=function(s)
                local song = GAMESTATE:GetCurrentSong()
                if song then
                    s:settext(song:GetDisplayArtist())
                end
            end,
        };
    };
    t;
}