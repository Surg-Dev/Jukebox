var _string = "Jukebox " + __JUKEBOX_VERSION + "\n@jujuadams " + __JUKEBOX_DATE + "\nAudio: @slimefiend\n\n\n\n";

_string += "1: Queue \"sndLoop1\"  /  Fade in parallel track \"sndLoop1\"\n";
_string += "2: Queue \"sndLoop2\"  /  Fade in parallel track \"sndLoop2\"\n";
_string += "3: Queue \"sndLoop3\"  /  Fade in parallel track \"sndLoop3\"\n";
_string += "F: Queue \"sndEndBad\"\n";
_string += "G: Queue \"sndEndGood\"\n";
_string += "E: Swap example\n";
_string += "S: Play sound effect\n";
_string += "M: Mute master\n";
_string += "\n\n\n\n";
_string += jukebox_debug_string();

draw_text(10, 10, _string);