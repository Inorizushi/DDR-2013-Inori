return Def.ActorFrame{
  LoadActor("base")..{
    InitCommand=cmd(FullScreen;visible,false);
  }
};
