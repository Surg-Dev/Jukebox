var _string = "Jukebox " + __JUKEBOX_VERSION + "    @jujuadams " + __JUKEBOX_DATE + "\n\n\n\n";

_string += "1: Queue \"sndLoop1\"\n";
_string += "2: Queue \"sndLoop2\"\n";
_string += "3: Queue \"sndLoop3\"\n";
_string += "F: Queue \"sndEndBad\"\n";
_string += "G: Queue \"sndEndGood\"\n";
_string += "\n\n\n\n";
_string += jukebox_debug_string();

if (jukebox_exists("loop stem 1") && jukebox_exists("loop stem 2") && jukebox_exists("loop stem 3"))
{
    _string += "\n\n\n";
    _string += "1 -> 2 = " + string(round(abs(jukebox_get("loop stem 1", JUKEBOX.TIME_REMAINING) - jukebox_get("loop stem 2", JUKEBOX.TIME_REMAINING)))) + "\n";
    _string += "2 -> 3 = " + string(round(abs(jukebox_get("loop stem 2", JUKEBOX.TIME_REMAINING) - jukebox_get("loop stem 3", JUKEBOX.TIME_REMAINING)))) + "\n";
    _string += "3 -> 1 = " + string(round(abs(jukebox_get("loop stem 3", JUKEBOX.TIME_REMAINING) - jukebox_get("loop stem 1", JUKEBOX.TIME_REMAINING)))) + "\n";
}

draw_text(10, 10, _string);