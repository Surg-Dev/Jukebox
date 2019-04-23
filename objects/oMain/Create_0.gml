jukebox_init("master", 1.0, 1.0, 10);

jukebox_group("music", "master", 1.0, false);
jukebox_group("sfx", "master", 1.0, false);

jukebox_group("queue example", "music", 0.0, false);
jukebox_fade("queue example", 1/17.5, 1.0);
jukebox_play(sndStart, "queue example", "queue");
jukebox_queue("queue", sndLoop1, true);

jukebox_group("parallel example", "music", 0.0, false);
jukebox_play(sndLoop1, "parallel example", "parallel 1", 1.0, true, false);
jukebox_play(sndLoop2, "parallel example", "parallel 2", 0.0, true, false);
jukebox_play(sndLoop3, "parallel example", "parallel 3", 0.0, true, false);