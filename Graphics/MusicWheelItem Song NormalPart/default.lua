local t = Def.ActorFrame {
	SetMessageCommand=function(s,p)
		if p.Index then
			if p.HasFocus then
				s:y(34)
			else
				s:y(0)
			end
		end
	end,
	--Main
	Def.Sprite{
		Name="Banner";
		InitCommand=cmd(scaletoclipped,256,256);
		SetCommand=function(self,param)
			local Song = param.Song;
			if Song then
				if Song:HasJacket() then
					self:Load(Song:GetJacketPath() );
				elseif Song:HasBackground() then
					self:Load(Song:GetBackgroundPath());
				elseif Song:HasBanner() then
					self:Load(Song:GetBannerPath());
				else
					self:Load(THEME:GetPathG("","Common fallback Jacket"));
				end;
			end;
		end;
	};
	Def.Sprite{
		Name="BannerReflection";
		InitCommand=cmd(scaletoclipped,256,256;y,256;rotationx,180;croptop,0.8;diffusealpha,0.6;fadetop,0.5);
		SetCommand=function(self,param)
			local Song = param.Song;
			if Song then
				if Song:HasJacket() then
					self:Load(Song:GetJacketPath() );
				elseif Song:HasBackground() then
					self:Load(Song:GetBackgroundPath());
				elseif Song:HasBanner() then
					self:Load(Song:GetBannerPath());
				else
					self:Load(THEME:GetPathG("","Common fallback Jacket"));
				end;
			end;
		end;
	};
};

t[#t+1] = Def.ActorFrame{
	Def.Sprite{
		Texture="new 2x1.png";
		InitCommand=cmd(x,86;y,-116;draworder,106);
		OnCommand=cmd(diffusealpha,0;sleep,1;diffusealpha,1);
		SetCommand=function(self,param)
			if param.Song then
				if PROFILEMAN:IsSongNew(param.Song) then
					self:visible(true);
				else
					self:visible(false);
				end
			else
				self:visible(false);
			end
		end;
		OffCommand=function(s) s:visible(false) end;
	};
};

for _, pn in pairs(GAMESTATE:GetEnabledPlayers()) do
	table.insert(t, WheelBadge(pn, true))
end

return t;
