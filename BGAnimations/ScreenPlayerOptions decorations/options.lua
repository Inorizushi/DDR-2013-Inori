local args = {...}
local pn = args[1];

local screen = SCREENMAN:GetTopScreen()

local function p(text)
    return text:gsub("%%", ToEnumShortString(pn));
end

local function base_x()
	if pn == PLAYER_1 then
		if IsUsingWideScreen() then
			return SCREEN_CENTER_X-566;
		else
			return SCREEN_CENTER_X-360;
		end
    elseif pn == PLAYER_2 then
        if IsUsingWideScreen() then
			return SCREEN_CENTER_X+566;
		else
			return SCREEN_CENTER_X+360;
		end
    else
        error("Pass a valid player number, dingus.",2)
    end
end

local rownames = {
	"Speed",
	"Accel",
	"Appearance",
	"Turn",
	"Step Zone",
	"Scroll",
	"NoteSkins",
	"Remove",
	"Freeze",
	"Jump",
	"Difficulty",
	"Characters",
	"Filter",
	"Gauge",
	"Exit"
}

local rowtoind = {
    ["Speed"] = 0,
	["Accel"] = 1,
	["Appearance"] = 2,
	["Turn"] = 3,
	["Step Zone"] = 4,
	["Scroll"] = 5,
	["NoteSkins"] = 6,
	["Remove"] = 7,
	["Freeze"] = 8,
	["Jump"] = 9,
	["Difficulty"] = 10,
	["Characters"] = 11,
	["Filter"] = 14,
	["Gauge"] = 13,
	["Exit"] = 13,
}

local function GetOptionName(screen, idx)
    return screen:GetOptionRow(idx-1):GetName();
end

local exitIndex = #rownames

function setting(self,screen)
	local index = screen:GetCurrentRowIndex(pn);
	local row = screen:GetOptionRow(index);
	local name = row:GetName();
	local choice = row:GetChoiceInRowWithFocus(pn);
	if index+1 ~= #rownames then
		if name ~= "Exit" then
			if THEME:GetMetric( "ScreenOptionsMaster",name.."Explanation" ) then
				self:settext(THEME:GetString("OptionItemExplanations",name..tostring(choice)));
			else self:settext("");
			end;
		end
	else
		self:settext("")
	end
end

local a  = Def.ActorFrame{}

for i=1,2 do
	a[#a+1] = Def.ActorFrame{
		GainFocusCommand=function(s) s:visible(true) end,
		LoseFocusCommand=function(s) s:visible(false) end,
		Def.Sprite{
			Texture="arrow",
			InitCommand=function(s) s:x(i==1 and -112 or 112):rotationy(i==1 and 0 or 180):queuecommand("Anim") end,
			GainFocusCommand=function(s) s:visible(true) end,
			LoseFocusCommand=function(s) s:visible(false) end,
			AnimCommand=function(s) s:finishtweening():diffuseblink():effectcolor1(Color.White)
				:effectcolor2(color("#7e7e7e")):effectperiod(2)
			end,
		};
		Def.Sprite{
			Texture="arrow",
			InitCommand=function(s) s:x(i==1 and -112 or 112):rotationy(i==1 and 0 or 180):diffusealpha(0) end,
			AnimCommand=function(s)	s:finishtweening():diffuse(Color.White):sleep(0.1):diffuse(color("#7e7e7e"))
				:sleep(0.1):diffuse(Color.White):sleep(0.1):diffuse(color("#7e7e7e"))
				:sleep(0.1):diffuse(Color.White):sleep(0.1):diffusealpha(0)
			end,
			[p"MenuLeft%MessageCommand"]=function(s) 
				if i==1 then
					s:queuecommand("Anim")
				end
			end,
			[p"MenuRight%MessageCommand"]=function(s)
				if i==2 then
					s:queuecommand("Anim")
				end
			end,
		};
	};
end

local OKCheck = {0,0}

local function MakeRow(rownames, idx)
    --the first row begins with focus
    local hasFocus = idx == 1;
    local function IsExitRow()
        return idx == exitIndex;
    end
	return Def.ActorFrame{
		Name="Row"..idx;
		InitCommand=function(s) s:y(-196+28*(idx-1)) end,
		OnCommand=function(self)
			self:playcommand(hasFocus and "GainFocus" or "LoseFocus");
		end;
		ChangeRowMessageCommand=function(self,param)
            if param.PlayerNumber ~= pn then return end
			if param.RowIndex+1 == idx then
                if not hasFocus then
                    hasFocus = true;
				    self:stoptweening();
				    self:queuecommand("GainFocus");
                end;
			elseif hasFocus then
                hasFocus = false;
				self:queuecommand("LoseFocus");
			end;
		end;
		Def.Sprite{
			Texture=ToEnumShortString(pn).."_OK",
			InitCommand=function(s) s:xy(pn==PLAYER_1 and -250 or 250,70):zoomy(0):draworder(100) end,
			GainFocusCommand=function(self)
                if IsExitRow() then
					self:bounceend(0.2):zoomy(1):diffusealpha(1);       
					SCREENMAN:set_input_redirected(pn,true)
					SOUND:PlayOnce(THEME:GetPathS("","Common start"))    
					if pn == PLAYER_1 then OKCheck[1] = 1
					else
						OKCheck[2] = 1
					end
					if GAMESTATE:GetNumPlayersEnabled() >= 2 then
						if OKCheck[1] == 1 and OKCheck[2] == 1 then
							s:Load(THEME:GetPathB("ScreenPlayerOptions","decorations/"..ToEnumShortString(pn).."_OK"))
							self:sleep(0.5):queuecommand("NextScreen")
						else
							s:Load(THEME:GetPathB("ScreenPlayerOptions","decorations/"..ToEnumShortString(pn).."_WAIT"))
						end
					else
						self:sleep(0.5):queuecommand("NextScreen")
					end
                end;
			end;
			LoseFocusCommand=function(self)
				self:accelerate(0.1):zoomy(0):diffusealpha(1)
			end;
			NextScreenCommand=function(s)
				s:Load(THEME:GetPathB("ScreenPlayerOptions","decorations/"..ToEnumShortString(pn).."_WAIT"))
				SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_GoToNextScreen")
			end,
		};
		Def.ActorFrame{
			GainFocusCommand=function(s)
				if IsExitRow() then
					s:y(-28)
				end
				s:visible(true)
			end,
			LoseFocusCommand=function(s) s:visible(false) end,
			Def.Sprite{
				Texture="HL",
				InitCommand=function(s) s:diffusealpha(0.5) end,
			};
			Def.Sprite{
				Texture="Block 1x2",
				InitCommand=function(s) s:animate(0):setstate(1)
					:x(pn==PLAYER_1 and -315 or 315)
				end,
			};
			Def.Sprite{
				Texture="Badge 1x2",
				InitCommand=function(s) s:setstate(pn==PLAYER_1 and 0 or 1)
					:x(pn==PLAYER_1 and -460 or 460):animate(0)
				end,
				GainFocusCommand=function(s) s:bob()
					:effectmagnitude(pn==PLAYER_1 and 2 or -2,0,0):effectperiod(0.5)
				end,
				LoseFocusCommand=function(s) s:stopeffect() end,
			};
		};
        Def.Sprite{
            Texture="RowName Green 1x17",
			InitCommand=function(s)
				s:animate(0):setstate(rowtoind[rownames]):xy(-12,0)
				if rownames == "Exit" then
					s:setstate(13):y(-28)
				end
            end,
            GainFocusCommand=function(s) s:finishtweening():diffusealpha(1):diffuseshift():effectcolor1(Color.White)
                :effectcolor2(color("#757575")):effectperiod(1)
            end,
			LoseFocusCommand=function(s) s:finishtweening():stopeffect():diffusealpha(0) end,
        };
		LoadFont("_helvetica Bold 24px")..{
			Name="Item",
            InitCommand=function(s) s:x(pn==PLAYER_1 and -315 or 315)
                :uppercase(true):zoom(0.7):maxwidth(150)
            end,
            OnCommand=function(s) s:queuecommand("Set") end,
			SetCommand=function(self)
				--if IsExitRow() then return end
				local screen = SCREENMAN:GetTopScreen();
                if screen then
                    local SongOrCourse;
					if GAMESTATE:IsCourseMode() then
						SongOrCourse = GAMESTATE:GetCurrentCourse()
					else
						SongOrCourse = GAMESTATE:GetCurrentSong()
					end
                    local name = GetOptionName(screen, idx);
                    local choice = screen:GetOptionRow(idx-1):GetChoiceInRowWithFocus(pn);
                    local function ChoiceToText(choice)
                        if THEME:GetMetric("ScreenOptionsMaster",name.."Explanation") then
                            return THEME:GetString("OptionItemNames",name..tostring(choice))
                        else
                            return ""
                        end
                    end
					if name ~= "NoteSkins" and name ~= "Steps" and name ~= "Characters" and name ~= "Exit" then
                        --normal option, handle default choice coloring.
                        local ChoiceText = ChoiceToText(choice)
                        --for most options, 0 is the default choice, for Speed it is 3.
						if screen:GetCurrentRowIndex(pn) ~= idx-1 then
							self:diffuse(color("#5e5e5e"))
                        else
                            if ChoiceText and ChoiceText == ChoiceToText(name == "Speed" and 3 or 0) then
						    	self:diffuse(color("#07ff07"))
						    else
						    	self:diffuse(Color.White)
                            end;
                        end
						self:settext(ChoiceText);
					elseif name == "Exit" then
						self:y(-28)
						local row = screen:GetOptionRow(idx-2)
						local choice = row:GetChoiceInRowWithFocus(pn)
						local name = GetOptionName(screen, idx-1)
						local function ChoiceToText(choice)
							if THEME:GetMetric("ScreenOptionsMaster",name.."Explanation") then
								return THEME:GetString("OptionItemNames",name..tostring(choice))
							else
								return ""
							end
						end
						local ChoiceText = ChoiceToText(choice)
						if screen:GetCurrentRowIndex(pn) == 14 then
							if ChoiceText and ChoiceText == ChoiceToText(0) then
								self:diffuse(color("#07ff07"))
							else
							    self:diffuse(Color.White)
							end;
						else
							self:diffusealpha(0)
						end
						self:settext(ChoiceText);

                    elseif name == "NoteSkins" then
						--self:settext(choice)
						--Wow that actually worked lol, add 1 to choice otherwise it shows the noteskin before the actual chosen one. -Inori
                        self:settext(NOTESKIN:GetNoteSkinNames()[choice+1])
                        if screen:GetCurrentRowIndex(pn) ~= idx-1 then
                            self:diffuse(color("#5e5e5e"))
                        else
                            self:diffuse(Color.White)
                        end
					elseif name == "Steps" then
						local difftable = SongOrCourse:GetStepsByStepsType(GAMESTATE:GetCurrentStyle():GetStepsType())
                        local diff = difftable[choice+1]
                        if screen:GetCurrentRowIndex(pn) ~= idx-1 then
                            self:diffuse(color("#5e5e5e"))
                        else
                            self:diffuse(CustomDifficultyToColor(diff:GetDifficulty()))
                        end
						self:settext(THEME:GetString("CustomDifficulty",ToEnumShortString(diff:GetDifficulty())));
					elseif name == "Characters" then
						if choice == 0 then
							self:settext(THEME:GetString('OptionNames','Off'))
						elseif choice == 1 then
							self:settext("RANDOM")
						else
							self:settext(Characters.GetAllCharacterNames()[choice-1])
                        end;
                        if screen:GetCurrentRowIndex(pn) ~= idx-1 then
                            self:diffuse(color("#5e5e5e"))
                        else
                            self:diffuse(Color.White)
                        end
					else
                        self:settext("");
                    end;
				end;
			end;
	        [p"MenuLeft%MessageCommand"]=function(s) s:queuecommand("Set") end,
		    [p"MenuRight%MessageCommand"]=function(s) s:queuecommand("Set") end,
            CurrentSongChangedMessageCommand=function(s) s:queuecommand("Set") end,
            GainFocusCommand=cmd(queuecommand,"Set");
			LoseFocusCommand=cmd(diffuse,color("#5e5e5e"));
		};
		a..{
			InitCommand=function(s)
				s:x(pn==PLAYER_1 and -315 or 315)
				if idx == 15 then
					s:y(-28)
				end
			end,
		};
	};
end;

local RowList = {};
for i=1,#rownames do
	RowList[#RowList+1] = MakeRow(rownames[i],i)
end;


local t = Def.ActorFrame{
	OnCommand=function(s)
		SCREENMAN:GetTopScreen():AddInputCallback(DDR.Input(s))
	end,
	OffCommand=function(s)
		SCREENMAN:set_input_redirected(pn,false)
	end,
};

t[#t+1] = Def.ActorFrame{
    InitCommand=function(s) s:xy(_screen.cx,_screen.cy-50) end,
	OnCommand=cmd(addx,-SCREEN_WIDTH;sleep,0.2;accelerate,0.2;addx,SCREEN_WIDTH);
	OffCommand=cmd(sleep,0.2;accelerate,0.2;addx,SCREEN_WIDTH);
    Def.ActorFrame{children=RowList};
	LoadFont("_helvetica Bold 24px")..{
        InitCommand=function(s) s:xy(pn==PLAYER_1 and -368 or 250,230):align(0,0)
            :wrapwidthpixels(400):zoom(0.75)
        end,
		BeginCommand=function(s) s:queuecommand("Set") end,
	    SetCommand=function(self)
	        local screen = SCREENMAN:GetTopScreen();
	        if screen then
	            setting(self,screen);
	         end;
	    end;
	    [p"MenuLeft%MessageCommand"]=function(s) s:playcommand("Set") end,
	    [p"MenuRight%MessageCommand"]=function(s) s:playcommand("Set") end,
	    ChangeRowMessageCommand=function(s,param)
            if param.PlayerNumber == pn then s:playcommand "Set"; end;
        end;
	};
}

return t;