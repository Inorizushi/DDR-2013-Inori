local t = LoadFallbackB()
local screen = Var "LoadingScreen"
local screenName = THEME:GetMetric(screen,"HeaderText");
local screenDelay = THEME:GetMetric(screen,"ScreenInDelay")

t[#t+1] = StandardDecorationFromFileOptional("StageDisplay","StageDisplay");

t[#t+1] = Def.ActorFrame{
    OnCommand=function(self)
      SCREENMAN:GetTopScreen():AddInputCallback(DDR.Input(self))
      SCREENMAN:set_input_redirected(PLAYER_1,false)
      SCREENMAN:set_input_redirected(PLAYER_2,false)
    end,
    OffMessageCommand=function(self)
      SCREENMAN:GetTopScreen():RemoveInputCallback(DDR.Input(self))
    end,
    StartReleaseCommand=function(self)
      local mw = SCREENMAN:GetTopScreen("ScreenSelectMusic"):GetChild("MusicWheel");
          local song = GAMESTATE:GetCurrentSong()
          if song then
              SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
              MESSAGEMAN:Broadcast("AnOff")
          end
      end,
    StartRepeatCommand=function(self)
        local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
        local song = GAMESTATE:GetCurrentSong()
        if song then
            self:hibernate(math.huge)
            SCREENMAN:AddNewScreenToTop("ScreenPlayerOptions","SM_GoToNextScreen")
        end
    end,
  };

for i=1,2 do
    Name="Arrows";
    t[#t+1] = Def.ActorFrame{
        InitCommand=function(s) s:xy(i==1 and _screen.cx-154 or _screen.cx+154,_screen.cy):zoomx(i==1 and -1 or 1) end,
        OnCommand=function(s)
            s:diffusealpha(0):addx(i==1 and -100 or 100)
            :sleep(0.6):decelerate(0.3):addx(i==1 and 100 or -100):diffusealpha(1)
        end,
        AnOffMessageCommand=function(s)
            s:accelerate(0.2):addx(i==1 and -100 or 100):diffusealpha(0)
        end,
        NextSongMessageCommand=function(s)
            if i==2 then s:stoptweening():linear(0.05):x(_screen.cx+170):decelerate(0.5):x(_screen.cx+154) end
        end, 
        PreviousSongMessageCommand=function(s)
            if i==1 then s:stoptweening():linear(0.05):x(_screen.cx-170):decelerate(0.5):x(_screen.cx-154) end
        end, 
        Def.Sprite{
            Texture=THEME:GetPathG("","_shared/SMArrow 1x2");
            InitCommand=function(s) s:pause() end,
            ResetCommand=function(s) s:setstate(0) end,
            NextSongMessageCommand=function(s)
                if i==2 then
                    s:finishtweening():setstate(1):sleep(0.6):queuecommand("Reset")
                end
            end, 
            PreviousSongMessageCommand=function(s)
                if i==1 then
                    s:finishtweening():setstate(1):sleep(0.6):queuecommand("Reset")
                end
            end, 
        };
    };
end;

local numwh = THEME:GetMetric("MusicWheel","NumWheelItems")+2
t[#t+1] = Def.Actor{
	OnCommand=function(s)
		if SCREENMAN:GetTopScreen() then
            local wheel = SCREENMAN:GetTopScreen():GetChild("MusicWheel"):GetChild("MusicWheelItem")
			for i=1,numwh do
                local inv = numwh-math.floor(i-numwh/2+0.5)+1
                if i == 2 or i == 3 or i == 4 or i == 5 or i == 6 or i == 7 then
					wheel[i]:addx(-SCREEN_WIDTH):sleep(0.3):decelerate(0.4):addx(SCREEN_WIDTH)
				elseif i == 9 or i == 10 or i == 11 or i == 12 or i == 13 or i == 14 then
                    wheel[i]:addx(SCREEN_WIDTH):sleep(0.3):decelerate(0.4):addx(-SCREEN_WIDTH)
                else
                    wheel[i]:zoom(0):sleep(0.3):decelerate(0.4):zoom(1)
				end
            end
		end
    end,
    OffMessageCommand=function(s)
        if SCREENMAN:GetTopScreen() then
            local wheel = SCREENMAN:GetTopScreen():GetChild("MusicWheel"):GetChild("MusicWheelItem")
			for i=1,numwh do
                local inv = numwh-math.floor(i-numwh/2+0.5)+1
                if i == 2 or i == 3 or i == 4 or i == 5 or i == 6 or i == 7 then
					wheel[i]:sleep(0.3):decelerate(0.4):addx(-SCREEN_WIDTH)
				elseif i == 9 or i == 10 or i == 11 or i == 12 or i == 13 or i == 14 then
                    wheel[i]:sleep(0.3):decelerate(0.4):addx(SCREEN_WIDTH)
                else
                    wheel[i]:sleep(0.3):decelerate(0.4):zoom(0)
				end
            end
        end
    end,
};

for _,pn in pairs(GAMESTATE:GetEnabledPlayers()) do
    t[#t+1] = Def.ActorFrame{
        loadfile(THEME:GetPathB("ScreenSelectMusic","decorations/Difficulty"))(pn)..{
            InitCommand=function(s)
                s:xy(pn==PLAYER_1 and SCREEN_LEFT+208 or SCREEN_RIGHT-208,_screen.cy+148)
            end,
        }
    };
end

return Def.ActorFrame{
    Def.Sound{
        File=THEME:GetPathS("ScreenSelectMusic","in"),
        OnCommand=function(s) s:sleep(0.2):queuecommand("Play") end,
        PlayCommand=function(s) s:play() end,
    };
    t;
    Def.ActorFrame{
        Name="TitleBox",
        InitCommand=function(s) s:xy(_screen.cx,_screen.cy+116) end,
        CurrentSongChangedMessageCommand=function(s) s:stoptweening():queuecommand("Set") end,
        Def.ActorFrame{
            InitCommand=function(s) s:xy(-196,-42):diffusealpha(0) end,
            OnCommand=function(s) s:sleep(0.2):linear(0.2):diffusealpha(1) end,
            AnOffMessageCommand=function(s) s:sleep(0.4):linear(0.2):diffusealpha(0) end,
            SetCommand=function(s)
                if GAMESTATE:GetCurrentSong() then
                    s:visible(true)
                else
                    s:visible(false)
                end
            end,
            Def.Sprite{
                Texture="BPM",
            };
            LoadActor("SNBPMDisplay.lua")..{
                InitCommand=function(s) s:xy(42,3):zoomx(1.1):zoomy(0.9) end,
            }
        };
        Def.ActorFrame{
            InitCommand=function(s) s:diffusealpha(0) end,
            OnCommand=function(s) s:sleep(0.2):linear(0.2):diffusealpha(1) end,
            AnOffMessageCommand=function(s) s:sleep(0.2):linear(0.2):diffusealpha(0) end,
            Def.Sprite{
                Texture="TitleBox 1x6",
                InitCommand=function(s) s:animate(false):queuecommand("Set"):zoomx(0) end,
                OnCommand=function(s) s:sleep(0.2):bounceend(0.2):zoomx(1) end,
                AnOffMessageCommand=function(s) s:sleep(0.4):bouncebegin(0.2):zoomx(0) end,
                SetCommand=function(s)
                    local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
                    local song = GAMESTATE:GetCurrentSong()
                    if not mw then return end
                    if song then
                        s:setstate(0)
                    else
                        if mw:GetSelectedType() == 'WheelItemDataType_Section' then
                            if mw:GetSelectedSection() ~= "" then
                                s:setstate(1)
                            end
                        else
                            if mw:GetSelectedType() == "WheelItemDataType_Random" then
                                s:setstate(2)
                            end
                        end
                    end
                end,
            };
            Def.BitmapText{
                Font="_helvetica Bold 24px",
                InitCommand=function(s) s:DiffuseAndStroke(Color.Black,Color.White):zoomy(0.85):zoomx(1):maxwidth(360):y(-12):diffusealpha(0) end,
                OnCommand=function(s) s:sleep(0.5):diffusealpha(1) end,
                AnOffMessageCommand=function(s) s:sleep(0.3):diffusealpha(0) end,
                SetCommand=function(s)
                    local song = GAMESTATE:GetCurrentSong()
                    local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
                    if not mw then return end
                    if song then
                        s:settext(song:GetDisplayMainTitle())
                    else
                        if mw:GetSelectedSection() ~= "" then
                            s:settext(mw:GetSelectedSection())
                        else
                            if mw:GetSelectedType() == "WheelItemDataType_Random" then
                                s:settext("RANDOM")
                            end
                        end
                    end
                end,
            };
            Def.BitmapText{
                Font="_helvetica Bold 24px",
                InitCommand=function(s) s:DiffuseAndStroke(Color.Black,Color.White):zoomy(0.85):zoomx(1):maxwidth(260):y(12):diffusealpha(0) end,
                OnCommand=function(s) s:sleep(0.5):diffusealpha(1) end,
                AnOffMessageCommand=function(s) s:sleep(0.2):diffusealpha(0) end,
                SetCommand=function(s)
                    local song = GAMESTATE:GetCurrentSong()
                    local mw = SCREENMAN:GetTopScreen():GetChild("MusicWheel")
                    if not mw then return end
                    if song then
                        s:settext(song:GetDisplayArtist())
                    else
                        s:settext("")
                    end
                end,
            };
        };
    };
}