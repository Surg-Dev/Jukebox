jukebox_step();

if (jukebox_will_finish("loop start") && !jukebox_exists("loop stem 1"))
{
    jukebox_play(sndLoop1, "loop", "loop stem 1", 1.0, true, false);
    jukebox_play(sndLoop2, "loop", "loop stem 2", 0.0, true, false);
    jukebox_play(sndLoop3, "loop", "loop stem 3", 0.0, true, false);
}

if (keyboard_check_pressed(ord("M"))) jukebox_set("loop", JUKEBOX.MUTE, !jukebox_get("loop", JUKEBOX.MUTE));
if (keyboard_check_pressed(ord("F"))) jukebox_queue("loop", sndEndBad, false);
if (keyboard_check_pressed(ord("G"))) jukebox_queue("loop", sndEndGood, false);

if (keyboard_check_pressed(ord("1"))) jukebox_fade("loop stem 1", 1/10, 1.0);
if (keyboard_check_pressed(ord("2"))) jukebox_fade("loop stem 1", 1/10, 0.0);
if (keyboard_check_pressed(ord("3"))) jukebox_fade("loop stem 2", 1/10, 1.0);
if (keyboard_check_pressed(ord("4"))) jukebox_fade("loop stem 2", 1/10, 0.0);
if (keyboard_check_pressed(ord("5"))) jukebox_fade("loop stem 3", 1/10, 1.0);
if (keyboard_check_pressed(ord("6"))) jukebox_fade("loop stem 3", 1/10, 0.0);