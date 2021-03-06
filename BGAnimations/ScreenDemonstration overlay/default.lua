return Def.ActorFrame{
	LoadActor("base")..{
		InitCommand=function(s) s:align(0,0):xy(SCREEN_LEFT-30,SCREEN_TOP-64) end,
	};
	LoadActor("text")..{
		InitCommand=function(s) s:align(0,0):xy(SCREEN_LEFT+30,SCREEN_TOP+14) end,
	};
	LoadActor("newbar") .. {
		InitCommand=function(s) s:align(1,1):xy(SCREEN_RIGHT,SCREEN_BOTTOM-28):draworder(40):zoom(1) end,
	};
	Def.ActorFrame {
		InitCommand=function(s) s:xy(_screen.cx-80,_screen.cy+266):draworder(45) end,
		-- Title
		Def.BitmapText{
			Font="_itc avant garde std md 20px",
			InitCommand=function(s) s:halign(0):maxwidth(384):playcommand("Update") end,
			CurrentSongChangedMessageCommand=function(s) s:playcommand("Update") end,
			UpdateCommand=function(self)
				local title;
				local song = GAMESTATE:GetCurrentSong();
				if song then
					title = song:GetDisplayFullTitle();
				else
					title = "???";
				end;
				self:settext(title);
			end;
		};
		-- Artist
		Def.BitmapText{
			Font="_itc avant garde std md 20px",
			InitCommand=function(s) s:halign(0):y(36):zoomx(0.9):maxwidth(384):playcommand("Update") end,
			CurrentSongChangedMessageCommand=function(s) s:playcommand("Update") end,
			UpdateCommand=function(self)
				local title;
				local song = GAMESTATE:GetCurrentSong();
				if song then
					title = song:GetDisplayArtist();
				else
					title = "???";
				end;
				self:settext(title);
			end;
		};
	};
	Def.ActorFrame {
		InitCommand=function(s) s:xy(_screen.cx+489,_screen.cy+140):diffusealpha(1):draworder(100) end,
		Def.Quad{
			InitCommand=function(s) s:setsize(260,260):diffuse(Color.Black) end,
		};
	   Def.Sprite {
		   OnCommand=function(self)
			   local song = GAMESTATE:GetCurrentSong();
				   if song then
					   if song:HasJacket() then
						   self:diffusealpha(1);
						   self:LoadBackground(song:GetJacketPath());
						   self:setsize(256,256);
					   elseif song:HasBanner() then
						   self:diffusealpha(1);
						   self:LoadFromSongBanner(GAMESTATE:GetCurrentSong());
						   self:setsize(256,256);
					   else
						   self:Load(THEME:GetPathG("","Common fallback jacket"));
						   self:setsize(256,256);
					   end;
				   else
					   self:diffusealpha(0);
			   end;
		   end;
	   OffCommand=function(s) s:sleep(0.2):bouncebegin(0.175):zoomy(0) end,
	   };
	};
	Def.ActorFrame{
		InitCommand=function(s) s:xy(_screen.cx,_screen.cy-246) end,
		Def.Sprite{
			Texture="EcoBulb",
		};
		Def.Sprite{
			Texture="EcoText",
			InitCommand=function(s) s:y(78) end,
		};
	};
}
