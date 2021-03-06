local t = Def.ActorFrame {};
local NumPlayers = GAMESTATE:GetNumPlayersEnabled()

local path = THEME:GetAbsolutePath("Graphics/ScreenSelectStyle Scroll/Versus/")

--Info
t[#t+1] = Def.ActorFrame{
  InitCommand=function(s) s:xy(244,-134) end,
  LoseFocusCommand=cmd(queuecommand,"Off");
  Def.Sprite{
    Texture=THEME:GetPathG("","_sharedX3/SelectStyle/infomiddle"),
    OnCommand=function(self)
      if NumPlayers == 2 then
        self:diffusealpha(0):zoomy(0):sleep(0.5):smooth(0.2):zoomy(1):diffusealpha(0.5)
      else
        self:diffusealpha(0);
      end;
    end;
    OffCommand=function(s) s:smooth(0.1):zoomy(0):diffusealpha(0) end,
    GainFocusCommand=function(s) s:diffusealpha(0):zoomy(0):smooth(0.2):zoomy(1):diffusealpha(0.5) end,
  };
	Def.Sprite{
    Texture="text",
		InitCommand=function(s) s:y(-24) end,
		OnCommand=function(self)
      if NumPlayers == 2 then
        self:diffusealpha(0):sleep(0.55):smooth(0.2):diffusealpha(1)
      else
        self:diffusealpha(0);
      end;
    end;
    OffCommand=function(s) s:smooth(0.1):diffusealpha(0) end,
    GainFocusCommand=function(s) s:diffusealpha(0):sleep(0.1):smooth(0.2):diffusealpha(1) end,
	};
  LoadActor("infoPad")..{
    InitCommand=function(s) s:xy(160,34) end,
    OnCommand=function(self)
      if NumPlayers == 2 then
        self:diffusealpha(0):sleep(0.55):smooth(0.2):diffusealpha(1)
      else
        self:diffusealpha(0);
      end;
    end;
    OffCommand=function(s) s:smooth(0.1):diffusealpha(0) end,
    GainFocusCommand=function(s) s:diffusealpha(0):sleep(0.1):smooth(0.2):diffusealpha(1) end,
  };
  Def.ActorFrame{
    InitCommand=function(s) s:y(-94) end,
    OnCommand=function(self)
      if NumPlayers == 2 then
        self:diffusealpha(0):y(0):sleep(0.5):smooth(0.2):y(-94):diffusealpha(1)
      else
        self:diffusealpha(0);
      end;
    end;
    OffCommand=function(s) s:smooth(0.1):y(0):diffusealpha(0) end,
    GainFocusCommand=function(s) s:diffusealpha(0):y(0):smooth(0.2):y(-94):diffusealpha(1) end,
    Def.Sprite{Texture=THEME:GetPathG("","_shared/SelectStyle/infotop")};
    Def.Sprite{
      Texture="title.png",
      InitCommand=function(s) s:x(-50) end,
    }
  };
  Def.Sprite{
    Texture=THEME:GetPathG("","_shared/SelectStyle/infobottom"),
    InitCommand=function(s) s:y(72) end,
    OnCommand=function(self)
      if NumPlayers == 2 then
        self:diffusealpha(0):y(0):sleep(0.5):smooth(0.2):y(72):diffusealpha(1)
      else
        self:diffusealpha(0);
      end;
    end;
    OffCommand=function(s) s:smooth(0.1):y(0):diffusealpha(0) end,
    GainFocusCommand=function(s) s:diffusealpha(0):y(0):smooth(0.2):y(72):diffusealpha(1) end,
  };
};

t[#t+1] = Def.ActorFrame {
  GainFocusCommand=function(s) s:stoptweening():smooth(0.3):y(0):zoom(1) end,
  LoseFocusCommand=function(s) s:stoptweening():smooth(0.3):y(70):zoom(1) end,
  Def.ActorFrame{
    InitCommand=function(s) s:xy(-4,96) end,
    OnCommand=function(s) s:zoom(0):sleep(0.5):linear(0.1):diffusealpha(1)
      :zoom(1):smooth(0.1):zoom(0.9):smooth(0.1):zoom(1)
    end,
    Def.Sprite{
      Texture="offPad.png",
      OffCommand=function(s) s:smooth(0.2):zoom(0):diffuse(Alpha(Color.Black,0)) end,
    };
    LoadActor("Pad.png")..{
      OffCommand=function(s) s:smooth(0.2):zoom(0):diffuse(Alpha(Color.Black,0)) end,
      GainFocusCommand=function(s) s:smooth(0.3):diffusealpha(1):diffuseshift()
        :effectcolor1(Color.White):effectcolor2(Alpha(Color.White,0)):effectperiod(2)
      end,
      LoseFocusCommand=function(s) s:diffusealpha(0):stopeffect() end,
    };
  };
  Def.ActorFrame{
    InitCommand=function(s) s:diffusealpha(0) end,
    OnCommand=function(s) s:sleep(0.5):linear(0.3):diffusealpha(1) end,
    LoadActor("Character") .. {
      InitCommand=function(s) s:zoomx(0.9):xy(-66,-8):fadebottom(0.4) end,
      OffCommand=function(s) s:smooth(0.2):zoom(0):diffuse(Alpha(Color.Black,0)) end,
      OnCommand=function(s) s:sleep(0.5):linear(0.075):zoomy(1.05)
        :linear(0.075):zoomy(1):zoomx(1.2):zoomy(0.8):linear(0.075):zoomx(1):zoomy(1)
      end,
    };
  }
};

t[#t+1] = Def.ActorFrame{
  Def.Sprite{
    Texture="title small",
    InitCommand=function(s) s:diffusealpha(0):xy(175,-190):zoom(1.75) end,
    MenuLeftP1MessageCommand=function(s) s:playcommand("Change1") end,
    MenuRightP1MessageCommand=function(s) s:playcommand("Change1") end,
    MenuUpP1MessageCommand=function(s) s:playcommand("Change1") end,
    MenuDownP1MessageCommand=function(s) s:playcommand("Change1") end,
    MenuLeftP2MessageCommand=function(s) s:playcommand("Change1") end,
    MenuRightP2MessageCommand=function(s) s:playcommand("Change1") end,
    MenuUpP2MessageCommand=function(s) s:playcommand("Change1") end,
    MenuDownP2MessageCommand=function(s) s:playcommand("Change1") end,
    OnCommand=function(self)
      if NumPlayers == 1 then
        self:sleep(0.6):linear(0.2):diffusealpha(1)
      else return end
    end;
    Change1Command=function(self)
      local env = GAMESTATE:Env()
      if env.VERSUSSELECT then
        self:queuecommand("GainFocus")
      else
        self:finishtweening():linear(0.1):x(100):zoom(0):sleep(0.3):queuecommand("Change2")
      end;
    end;
    Change2Command=function(s) s:x(100):zoom(0):diffusealpha(1):linear(0.1)
      :zoom(2):x(158):linear(0.1):zoom(1.75):queuecommand("Animate")
    end,
    GainFocusCommand=function(self)
      local env = GAMESTATE:Env()
      env.VERSUSSELECT = true
      self:stoptweening():linear(0.1):zoomy(0)
    end;
    LoseFocusCommand=function(self)
      local env = GAMESTATE:Env()
      env.VERSUSSELECT = false
    end;
    AnimateCommand=function(s) s:linear(0.05):rotationz(3):linear(0.05):rotationz(-3)
      :linear(0.05):rotationz(3):linear(0.05):rotationz(-3):linear(0.05):rotationz(0)
      :sleep(1):queuecommand("Animate")
    end,
    OffCommand=function(s) s:stoptweening():smooth(0.2):zoom(0):diffusealpha(0) end,
  };
};

return t;
