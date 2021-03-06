local pn = ...

local function base_x()
	if pn == PLAYER_1 then
	  if IsUsingWideScreen() then
		return _screen.cx-361
	  else
		return _screen.cx-420
	  end
	elseif pn == PLAYER_2 then
	  if IsUsingWideScreen() then
		return _screen.cx+361
	  else
		return _screen.cx+420
	  end
	else
	  error("Pass a valid player number, dingus.",2)
	end
end
return Def.ActorFrame{
    Name="LifeFrame",
	InitCommand=function(s)
		s:xy(base_x(),SCREEN_TOP+38):draworder(99):zoom(IsUsingWideScreen() and 1 or 0.8)
	end,
	Def.Sprite{
		Texture="under",
		InitCommand=function(s) s:x(pn==PLAYER_1 and -10 or -4):visible(not GAMESTATE:IsDemonstration()) end,
	};
	Def.Sprite{
		Texture="stream/normal",
		OnCommand=function(s)
			s:scaletoclipped(1080,28):x(pn==PLAYER_1 and -10 or -4)
			s:MaskDest():ztestmode("ZTestMode_WriteOnFail"):customtexturerect(0,0,1,1)
			:texcoordvelocity(pn=="PlayerNumber_P2" and -0.5 or 0.2,0)
		end;
		HealthStateChangedMessageCommand=function(self, param)
			if param.PlayerNumber == pn then
				if param.HealthState == "HealthState_Danger" then
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/danger (stretch).png"))
				elseif param.HealthState == "HealthState_Hot" then
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/hot (stretch).png"))
					self:glowshift():effectcolor1(Alpha(Color.Black,0.1)):effectcolor2(Alpha(Color.White,0)):effectperiod(0.05)
		  		else
					self:Load(THEME:GetPathB("","ScreenGameplay decorations/lifeframe/stream/normal (stretch).png"))
					self:stopeffect()
		  		end;
		  		self:scaletoclipped(1080,28)
			end;
		end;
	};
	Def.Sprite{
		Name="LifeFrame"..pn,
		InitCommand=function(s) s:x(pn==PLAYER_1 and -10 or -4):rotationy(pn==PLAYER_2 and 180 or 0):visible(not GAMESTATE:IsDemonstration()) end,
		BeginCommand=function(self)
			if GAMESTATE:PlayerIsUsingModifier(pn,'battery') or GAMESTATE:GetPlayMode() == 'PlayMode_Oni' or GAMESTATE:IsAnExtraStage() then
			  self:Load(THEME:GetPathB("ScreenGameplay","decorations/lifeframe/4live.png"))  
			else
				self:Load(THEME:GetPathB("ScreenGameplay","decorations/lifeframe/normal.png"))
			end;
		end;
	}
}