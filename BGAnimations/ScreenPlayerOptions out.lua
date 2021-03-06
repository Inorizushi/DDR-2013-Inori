return Def.ActorFrame{
    StartTransitioningCommand=function(s)
        s:sleep(0.5):queuecommand("AnOff")
        s:sleep(2)
    end,
    AnOffCommand=function(s)
        MESSAGEMAN:Broadcast("AnOff")
    end,
};