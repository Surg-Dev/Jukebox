/// @param sound
/// @param [parent]
/// @param [name]
/// @param [startGain]
/// @param [loop]
/// @param [destroyAtZero]
/// @param [priority]

var _sound           = argument[0];
var _parent          = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : global.__jukebox_master_name;
var _name            = ((argument_count > 2)                              )? argument[2] : undefined;
var _gain            = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : 1.0;
var _loop            = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : false;
var _destroy_at_zero = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : true;
var _priority        = ((argument_count > 6)                              )? argument[6] : undefined;

if (ds_map_exists(global.__jukebox_names, _name))
{
    switch(JUKEBOX_PLAY_OVERWRITE_BEHAVIOUR)
    {
        case 0:
            show_debug_message("Jukebox: WARNING! Node name \"" + _name + "\" already exists. Destroying old node");
            jukebox_stop(_name);
        break;
        
        case 1:
            var _i = 0;
            do
            {
                var _new_name = _name + " (old) (" + string(_i) + ")";
                _i++;
            }
            until !ds_map_exists(global.__jukebox_names, _new_name);
            
            show_debug_message("Jukebox: WARNING! Node name \"" + _name + "\" already exists. Renaming to \"" + _new_name + "\" and fading out");
            jukebox_rename(_name, _new_name);
            jukebox_fade(_new_name, JUKEBOX_MUTE_SPEED, 0);
        break;
        
        case 2:
            show_debug_message("Jukebox: WARNING! Node name \"" + _name + "\" already exists. Aborting new node creation");
            return undefined;
        break;
        
        case 3:
            show_error("Jukebox:\nNode name \"" + _name + "\" already exists. Destroying old node.\n ", false);
            jukebox_stop(_name);
        break;
    }
}

if (_name == undefined)
{
    var _i = 0;
    do
    {
        _name = audio_get_name(_sound) + " (" + string(_i) + ")";
        _i++;
    }
    until !ds_map_exists(global.__jukebox_names, _name);
}



var _parent_array = global.__jukebox_names[? _parent ];
var _mute        = _parent_array[ JUKEBOX.MUTE ];
var _children    = _parent_array[ JUKEBOX.CHILDREN ];
var _parent_gain = _parent_array[ JUKEBOX.GAIN ];
if (_priority == undefined) _priority = _parent_array[ JUKEBOX.PRIORITY ];



var _count = array_length_1d(_children);
for(var _i = 0; _i < _count; _i++) if (_children[_i] == undefined) break;
if (_i < _count)
{
    _children[@ _i ] = _name;
}
else
{
    _children[@ _count ] = _name;
}



var _trim = global.__jukebox_trim[? _sound ];
    _trim = (_trim == undefined)? 1 : _trim;
var _resultant_gain = _trim*_gain*_parent_gain;

var _instance = audio_play_sound(_sound, _priority, _loop);
audio_sound_gain(_instance, _mute? 0 : _resultant_gain, 0);
if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Playing \"" + string(audio_get_name(_sound)) + "\"" + (_loop? " (looped)" : "") + " on node \"" + _name + "\", child of \"" + string(_parent) + "\"");



var _node = array_create(JUKEBOX.__SIZE);
_node[@ JUKEBOX.GAIN             ] = _gain;
_node[@ JUKEBOX.GAIN_INHERITED   ] = _resultant_gain;

_node[@ JUKEBOX.TRIM             ] = _trim;
_node[@ JUKEBOX.TRIM_TARGET      ] = _trim;

_node[@ JUKEBOX.AUDIO            ] = _sound;
_node[@ JUKEBOX.LOOP             ] = _loop;
_node[@ JUKEBOX.INSTANCE         ] = _instance;
_node[@ JUKEBOX.TIME_REMAINING   ] = audio_sound_length(_instance)*1000;
_node[@ JUKEBOX.QUEUED_AUDIO     ] = _loop? _sound : -1;
_node[@ JUKEBOX.QUEUED_LOOP      ] = _loop;

_node[@ JUKEBOX.FADE_SPEED       ] = 0;
_node[@ JUKEBOX.FADE_TARGET_GAIN ] = _gain;
_node[@ JUKEBOX.DESTROY_AT_ZERO  ] = _destroy_at_zero

_node[@ JUKEBOX.MUTE             ] = false;
_node[@ JUKEBOX.MUTE_INHERITED   ] = _mute? 0.0 : 1.0;
_node[@ JUKEBOX.MUTE_GAIN        ] = _mute? 0.0 : 1.0;

_node[@ JUKEBOX.NAME             ] = _name;
_node[@ JUKEBOX.PARENT           ] = _parent;
_node[@ JUKEBOX.TYPE             ] = __JUKEBOX_TYPE_AUDIO;
_node[@ JUKEBOX.PRIORITY         ] = _priority;
_node[@ JUKEBOX.CHILDREN         ] = [];
global.__jukebox_names[? _name ] = _node;

return _name;