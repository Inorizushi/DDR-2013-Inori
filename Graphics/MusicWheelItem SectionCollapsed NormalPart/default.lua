local function GetGroupJacketPath(groupName, fallback)
	local paths = {
		"/Songs/"..groupName.."/jacket.png",
		"/Songs/"..groupName.."/jacket.jpg",
		"/AdditionalSongs/"..groupName.."/jacket.png",
		"/AdditionalSongs/"..groupName.."/jacket.jpg"
	}
	for path in ivalues(paths) do
		if FILEMAN:DoesFileExist(path) then
			return path
		end
	end
	return fallback or THEME:GetPathG("MusicWheelItem", "fallback")
end

return Def.ActorFrame{
	SetMessageCommand=function(s,p)
		if p.Index then
			if p.HasFocus then
				s:y(34)
			else
				s:y(0)
			end
		end
	end,
	Def.Sprite {
		SetMessageCommand=function(self,params)
			local group = params.Text;
			local so = ToEnumShortString(GAMESTATE:GetSortOrder())
			if group then
				if so == "Group" then
					local groupPath = GetGroupJacketPath(group, SONGMAN:GetSongGroupBannerPath(group))
					if FILEMAN:DoesFileExist(groupPath) then
						self:Load(groupPath)
					else
						self:Load(THEME:GetPathG("","Common fallback jacket"))
					end
				end
			end;
			self:scaletoclipped(256,256)
		end;
	};
	LoadFont("_helvetica Bold 24px")..{
		InitCommand=function(s) s:y(-84):addx(-5):maxwidth(150):strokecolor(Color.Black) end,
		SetMessageCommand=function(self,params)
			local group = params.Text;
			local so = ToEnumShortString(GAMESTATE:GetSortOrder())
			if group then
				if so == "Group" then
					local groupPath = GetGroupJacketPath(group, SONGMAN:GetSongGroupBannerPath(group))
					if FILEMAN:DoesFileExist(groupPath) then
						self:settext("")
					else
						self:settext(group)
					end
				end
			end;
		end;
	};
	Def.Sprite{
		Texture="GroupOverlay",
		SetMessageCommand=function(self,params)
			self:visible(false)
			local so = ToEnumShortString(GAMESTATE:GetSortOrder())
			if so == "Group" then
				self:visible(true)
			end
		end
	};
	Def.ActorFrame{
		LoadActor("folder top")..{
			InitCommand=cmd(y,-128);
		};
		LoadActor("folder bottom")..{
			InitCommand=cmd(y,112);
		};
	};
};
