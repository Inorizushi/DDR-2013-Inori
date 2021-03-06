local t = LoadFallbackB()

t[#t+1] = StandardDecorationFromFile("Version","Version")

--if Endless mode didn't get a chance to clean up after itself properly,
--ComboContinuesBetweenSongs will still be set. IMO it's not commonly used enough
--that just forcing it off will be a problem. Maybe it could be a theme pref.
if PREFSMAN:GetPreference("ComboContinuesBetweenSongs") then
	print("ComboContinuesBetweenSongs was disabled.")
	PREFSMAN:SetPreference("ComboContinuesBetweenSongs", false)
end

local counter = 0;
local t = Def.ActorFrame{};


t[#t+1] = Def.ActorFrame {
	Def.BitmapText{
	Font="Common normal",
	Text=themeInfo["Name"] .. " " .. themeInfo["Version"] .. " by " .. themeInfo["Author"] .. (SN3Debug and " (debug mode)" or "") ,
	InitCommand=cmd(halign,0;valign,0;x,SCREEN_LEFT+40;y,SCREEN_TOP+5;shadowlength,1; zoom, 0.6;diffusealpha,0.5)
	};
}

return t
