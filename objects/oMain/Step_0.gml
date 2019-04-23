jukebox_step();

#region Queue example

if (keyboard_check_pressed(ord("1"))) jukebox_queue("queue", sndLoop1, true);
if (keyboard_check_pressed(ord("2"))) jukebox_queue("queue", sndLoop2, true);
if (keyboard_check_pressed(ord("3"))) jukebox_queue("queue", sndLoop3, true);
if (keyboard_check_pressed(ord("F"))) jukebox_queue("queue", sndEndBad, false);
if (keyboard_check_pressed(ord("G"))) jukebox_queue("queue", sndEndGood, false);

#endregion

#region Parallel example

if (keyboard_check_pressed(ord("1")))
{
    jukebox_fade("parallel 1", 1/3, 1.0);
    jukebox_fade("parallel 2", 1/3, 0.0);
    jukebox_fade("parallel 3", 1/3, 0.0);
}

if (keyboard_check_pressed(ord("2")))
{
    jukebox_fade("parallel 1", 1/3, 0.0);
    jukebox_fade("parallel 2", 1/3, 1.0);
    jukebox_fade("parallel 3", 1/3, 0.0);
}

if (keyboard_check_pressed(ord("3")))
{
    jukebox_fade("parallel 1", 1/3, 0.0);
    jukebox_fade("parallel 2", 1/3, 0.0);
    jukebox_fade("parallel 3", 1/3, 1.0);
}

#endregion

#region Swap example

if (keyboard_check_pressed(ord("E")))
{
    if (jukebox_get("queue example", JUKEBOX.FADE_TARGET_GAIN) == 0.0)
    {
        jukebox_fade("queue example", 2, 1.0);
        jukebox_fade("parallel example", 2, 0.0);
    }
    else
    {
        jukebox_fade("queue example", 2, 0.0);
        jukebox_fade("parallel example", 2, 1.0);
    }
}

#endregion

if (keyboard_check_pressed(ord("S"))) jukebox_play(choose(sndSfx1, sndSfx2, sndSfx3, sndSfx4, sndSfx5), "sfx");
if (keyboard_check_pressed(ord("M"))) jukebox_mute_set("master", !jukebox_mute_get("master"));