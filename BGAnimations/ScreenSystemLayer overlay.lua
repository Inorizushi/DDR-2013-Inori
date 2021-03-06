local function CreditsText()
	local text = LoadFont("_sys1") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X;y,SCREEN_BOTTOM-16;zoom,1.2;playcommand,"Refresh");
		RefreshCommand=function(self)
		--Other coin modes
			if GAMESTATE:IsEventMode() then self:settext('EVENT MODE') return end
			if GAMESTATE:GetCoinMode()=='CoinMode_Free' then self:settext('FREE PLAY') return end
			if GAMESTATE:GetCoinMode()=='CoinMode_Home' then self:settext('HOME MODE') return end
		--Normal pay
			local coins=GAMESTATE:GetCoins()
			local coinsPerCredit=PREFSMAN:GetPreference('CoinsPerCredit')
			local credits=math.floor(coins/coinsPerCredit)
			local remainder=math.mod(coins,coinsPerCredit)
			local s='CREDIT:'
			if credits > 1 then
				s='CREDITS:'..credits
			elseif credits == 1 then
				s=s..credits
			else
				s=s..0
			end
			self:horizalign(left)
			self:settext(s)
		end;
		UpdateVisibleCommand=function(self)
			local screen = SCREENMAN:GetTopScreen();
			local bShow = true;
			if screen then
				local sClass = screen:GetName();
				bShow = THEME:GetMetric( sClass, "ShowCreditDisplay" );
			end;

			self:visible( bShow );
		end;
		CoinInsertedMessageCommand=cmd(stoptweening;playcommand,"Refresh");
		RefreshCreditTextMessageCommand=cmd(stoptweening;playcommand,"Refresh");
		PlayerJoinedMessageCommand=cmd(stoptweening;playcommand,"Refresh");
		ScreenChangedMessageCommand=cmd(stoptweening;playcommand,"Refresh");
	};
	return text;
end;

local function CoinsText()
	local text = LoadFont("_sys1") .. {
		InitCommand=cmd(x,SCREEN_CENTER_X+281;y,SCREEN_BOTTOM-16;zoom,1.2;horizalign,center;playcommand,"Refresh");
		RefreshCommand=function(self)
			local coins=GAMESTATE:GetCoins()
			local coinsPerCredit=PREFSMAN:GetPreference('CoinsPerCredit')
			local remainder=math.mod(coins,coinsPerCredit)
			local s='COIN(S):'
			if coinsPerCredit > 1 then
				s=s..remainder..'/'..coinsPerCredit
			else
				s=''
			end

			if GAMESTATE:GetCoinMode() == 'CoinMode_Pay' then
				self:visible(true);
			else
				self:visible(false);
			end

			self:settext(s)
		end;
		UpdateVisibleCommand=function(self)
			local screen = SCREENMAN:GetTopScreen();
			local bShow = true;
			if screen then
				local sClass = screen:GetName();
				bShow = THEME:GetMetric( sClass, "ShowCreditDisplay" );
			end;

			self:visible( bShow );
		end;
		CoinInsertedMessageCommand=cmd(stoptweening;playcommand,"Refresh");
		RefreshCreditTextMessageCommand=cmd(stoptweening;playcommand,"Refresh");
		PlayerJoinedMessageCommand=cmd(stoptweening;playcommand,"Refresh");
		ScreenChangedMessageCommand=cmd(stoptweening;playcommand,"Refresh");
	};
	return text;
end;

local function NetworkText()
	local text = LoadFont("_sys1") .. {
		InitCommand=function (self)
			self:name("NetworkStatus");
			self:settext("-----");
			self:x(SCREEN_CENTER_X-103);
			self:y(SCREEN_BOTTOM-16);
			self:zoom(1.2);
			self:horizalign(right);
		end;
		RefreshCommand=function (self)
		local netConnected = IsNetConnected();
		local loggedOnSMO = IsNetSMOnline();
			if netConnected then
				self:diffuse(color("#00FFFF"));
				self:settext("ONLINE");
			else
				self:diffuse(color("#999999"));
				self:settext("LOCAL MODE");
			end;
		end;
		UpdateVisibleCommand=function(self)
			local screen = SCREENMAN:GetTopScreen();
			local bShow = true;
			if screen then
				local sClass = screen:GetName();
				bShow = THEME:GetMetric( sClass, "ShowCreditDisplay" );
			end

			self:visible( bShow );
		end;
		CoinInsertedMessageCommand=cmd(stoptweening;playcommand,"Refresh");
		RefreshCreditTextMessageCommand=cmd(stoptweening;playcommand,"Refresh");
		PlayerJoinedMessageCommand=cmd(stoptweening;playcommand,"Refresh");
		ScreenChangedMessageCommand=cmd(stoptweening;playcommand,"Refresh");
	};
	return text;
end;

local t = Def.ActorFrame {}

t[#t+1] = Def.ActorFrame {
 	--CreditsText( PLAYER_1 );
	--CreditsText( PLAYER_2 );
	NetworkText();
	CreditsText();
	CoinsText();
};

-- Text
t[#t+1] = Def.ActorFrame {
	Def.Quad {
		InitCommand=function(s) s:zoomto(SCREEN_WIDTH,30):align(0,0):y(SCREEN_TOP):diffuse(color("0,0,0,0")) end,
		OnCommand=function(s) s:finishtweening():diffusealpha(0.85) end,
		OffCommand=function(s) s:sleep(3):linear(0.5):diffusealpha(0) end,
	};
	Def.BitmapText{
		Font="Common Normal";
		Name="Text";
		InitCommand=function(s) s:maxwidth(750):align(0,0):xy(SCREEN_LEFT+10,SCREEN_TOP+10):shadowlength(1):diffusealpha(0) end,
		OnCommand=function(s) s:finishtweening():diffusealpha(1):zoom(0.5) end,
		OffCommand=function(s) s:sleep(3):linear(0.5):diffusealpha(0) end,
	};
	SystemMessageMessageCommand = function(self, params)
		self:GetChild("Text"):settext( params.Message );
		self:playcommand( "On" );
		if params.NoAnimate then
			self:finishtweening();
		end
		self:playcommand( "Off" );
	end;
	HideSystemMessageMessageCommand = function(s) s:finishtweening() end,
};

return t;
