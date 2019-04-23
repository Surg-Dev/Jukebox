/// @param name

var _name = argument0;

var _node = global.__jukebox_names[? _name ];
if (_node == undefined) return __JUKEBOX_NOT_PLAYING;

var _instance = _node[ JUKEBOX.INSTANCE ];

var _is_playing = audio_is_playing(_instance);
if (!_is_playing) return __JUKEBOX_NOT_PLAYING;

var _length = audio_sound_length(_instance)*1000;
var _position = audio_sound_get_track_position(_instance)*1000;
var _diff = _length - (_position mod _length);

return (_diff <= JUKEBOX_FRAME_LEAD*__JUKEBOX_EXPECTED_FRAME_LENGTH/1000);