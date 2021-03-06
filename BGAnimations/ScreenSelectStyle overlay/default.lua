local t = Def.ActorFrame{
  OnCommand=function(s) s:sleep(0.4):queuecommand("Swoosh") end,
  SwooshCommand=function(s) SOUND:PlayOnce(THEME:GetPathS("","_swoosh in")) end,
  OffCommand=function(s) SOUND:PlayOnce(THEME:GetPathS("","_swoosh out")) end,
};

for i=1,2 do
  t[#t+1] = Def.ActorFrame{
    InitCommand=function(s)
      s:xy(i==1 and SCREEN_LEFT or SCREEN_RIGHT,SCREEN_BOTTOM-80)
    end,
    PlayerJoinedMessageCommand=function(s,p)
      if p.Player then
        s:queuecommand("Off")
      end
    end,
    Def.Sprite{
      Texture="Frame";
      InitCommand=function(s)
        s:zoomx(i==1 and -1 or 1):halign(1):zoomy(0)
      end,
      OnCommand=function(s) s:sleep(0.4):linear(0.05):zoomy(1) end,
      OffCommand=function(s) s:sleep(0.2):linear(0.05):zoomy(0) end,
    };
    Def.Sprite{
      Texture=THEME:GetPathG("","_shared/P"..i.." BADGE");
      InitCommand=function(s)
        s:xy(i==1 and 106 or -106,-36):rotationz(90):diffusealpha(0)
      end,
      OnCommand=function(s) s:sleep(0.4):linear(0.05):rotationz(0):diffusealpha(1) end,
      OffCommand=function(s) s:sleep(0.1):linear(0.05):rotationz(90):diffusealpha(0) end,
    };
    Def.Sprite{
      Name="Messages",
      InitCommand=function(s) s:xy(i==1 and 280 or -280,0):zoomx(1):zoomy(0):queuecommand("Set") end,
      OnCommand=function(s) s:sleep(0.5):linear(0.05):zoomy(1) end,
      OffCommand=function(s) s:sleep(0.1):linear(0.05):zoomy(0) end,
      SetCommand=function(s)
        local GetP1 = GAMESTATE:IsPlayerEnabled(PLAYER_1)
        local GetP2 = GAMESTATE:IsPlayerEnabled(PLAYER_2)
        local masterPlayer = GAMESTATE:GetMasterPlayerNumber()
        if i == 1 then
          if GetP1 == true and GAMESTATE:GetNumPlayersEnabled() == 1 then
            s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/P1here"));
          elseif GetP1 == false and GAMESTATE:PlayersCanJoin() and GAMESTATE:GetMasterPlayerNumber() == PLAYER_2 then
            s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/P1CanJoin"));
          elseif GetP1 == false and GAMESTATE:GetMasterPlayerNumber() == PLAYER_2  then
            if GAMESTATE:GetCoins() ~= GAMESTATE:GetCoinsNeededToJoin() and GAMESTATE:IsEventMode() == false then
              s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/credit"));
            end;
          else
            s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/P1here"));
          end;
        elseif i == 2 then
          if GetP2 == true and GAMESTATE:GetNumPlayersEnabled() == 1 then
            s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/P2here"));
          elseif GetP2 == false and GAMESTATE:GetMasterPlayerNumber() == PLAYER_1  then
            if GAMESTATE:GetCoins() ~= GAMESTATE:GetCoinsNeededToJoin()  and GAMESTATE:IsEventMode() == false then
              s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/credit"));
            else
              s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/P2CanJoin"));
            end;
          else
            s:Load(THEME:GetPathB("","ScreenSelectStyle overlay/P2here"));
          end
        end
      end,
    };
  };

  t[#t+1] = Def.ActorFrame{
    InitCommand=function(s) s:xy(_screen.cx,_screen.cy+190):draworder(200) end,
    Def.Sprite{
      Texture=THEME:GetPathG("","_shared/_selectarrow 1x2");
      InitCommand=function(s)
        s:pause():x(i==1 and -255 or 255):zoomx(i==1 and 1 or -1):diffusealpha(0)
      end,
      OnCommand=function(s) s:sleep(0.5):smooth(0.1):diffusealpha(1) end,
      OffCommand=function(s) s:smooth(0.2):addx(i==1 and-50 or 50):diffusealpha(0) end,
      ResetCommand=function(s) s:setstate(0) end,
      MenuLeftP2MessageCommand=function(s) s:queuecommand("MenuLeftP1") end,
      MenuLeftP1MessageCommand=function(s)
        if i==1 then
          s:setstate(1)
          s:smooth(0.1):addx(-20):smooth(0.1):addx(20):sleep(0):queuecommand("Reset")
        end
      end,
      MenuRightP1MessageCommand=function(s)
        if i==2 then
          s:setstate(1)
          s:smooth(0.1):addx(20):smooth(0.1):addx(-20):sleep(0):queuecommand("Reset")
        end
      end,
      MenuRightP2MessageCommand=function(s) s:queuecommand("MenuRightP1") end,
    };
  };
end

t[#t+1] = Def.Actor{
  PlayerJoinedMessageCommand=function(self)
    self:queuecommand("Delay1")
  end;
  Delay1Command=function(self)
    self:sleep(2)
    self:queuecommand("SetScreen")
  end;
  SetScreenCommand=function(self)
    GAMESTATE:SetCurrentStyle("versus")
    SCREENMAN:GetTopScreen():SetNextScreenName("ScreenProfileLoad"):StartTransitioningScreen("SM_GoToNextScreen")
  end;
};

return t
