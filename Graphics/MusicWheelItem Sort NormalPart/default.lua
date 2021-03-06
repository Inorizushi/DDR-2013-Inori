return Def.ActorFrame {
	Def.Quad{
		InitCommand=function(s) s:setsize(256,256):diffuse(Color.Black) end,
	};
	Def.BitmapText{
		Font="Common Normal",
		SetMessageCommand=function(s,p)
			local so = GAMESTATE:GetSortOrder()
			if so == "SortOrder_ModeMenu" then
				s:settext(p.Label)
			end
		end,
	};
};
