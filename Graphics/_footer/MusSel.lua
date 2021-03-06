local t = Def.ActorFrame{
  LoadActor("confirm")..{
    InitCommand=cmd(x,80;);
    OnCommand=cmd(diffusealpha,1;sleep,3;diffusealpha,0;sleep,6;queuecommand,"On");
    OffCommand=cmd(stoptweening);
  };
  LoadActor("select")..{
    InitCommand=cmd(x,-80);
    OnCommand=cmd(diffusealpha,1;sleep,3;diffusealpha,0;sleep,6;queuecommand,"On");
    OffCommand=cmd(stoptweening);
  };
  LoadActor("difficulty")..{
    OnCommand=cmd(diffusealpha,0;sleep,3;diffusealpha,1;sleep,3;diffusealpha,0;sleep,3;queuecommand,"On");
    OffCommand=cmd(stoptweening);
  };
  LoadActor("sort")..{
    OnCommand=cmd(diffusealpha,0;sleep,6;diffusealpha,1;sleep,3;diffusealpha,0;queuecommand,"On");
    OffCommand=cmd(stoptweening);
  };
};

return t;
