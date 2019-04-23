jukebox_init("root", 1.0, 1.0, 10);
jukebox_global_trim(sndStart  , 0.75);
jukebox_global_trim(sndLoop1  , 0.75);
jukebox_global_trim(sndLoop2  , 0.75);
jukebox_global_trim(sndLoop3  , 0.75);
jukebox_global_trim(sndEndBad , 0.75);
jukebox_global_trim(sndEndGood, 0.75);

jukebox_group("bgm", "root", 1.0, 1.0, false);
jukebox_group("loop group", "bgm", 0.0, 1.0, false);
jukebox_fade("loop group", 1/17.5, 1.0);

jukebox_play(sndStart, "loop group", "loop");