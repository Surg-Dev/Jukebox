/// @param emitter
/// @param sound
/// @param [parent]
/// @param [name]
/// @param [startGain]
/// @param [loop]
/// @param [destroyAtZero]
/// @param [priority]

var _emitter         = argument[0];
var _sound           = argument[1];
var _parent          = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : global.__jukebox_root_name;
var _name            = ((argument_count > 3)                              )? argument[3] : undefined;
var _gain            = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 1.0;
var _loop            = ((argument_count > 5) && (argument[5] != undefined))? argument[5] : false;
var _destroy_at_zero = ((argument_count > 6) && (argument[6] != undefined))? argument[6] : JUKEBOX_DEFAULT_DESTROY_AT_ZERO;
var _priority        = ((argument_count > 7)                              )? argument[7] : undefined;

global.__jukebox_last_modified = undefined;

if (ds_map_exists(global.__jukebox_names, _name))
{
    switch(JUKEBOX_CREATE_OVERWRITE_BEHAVIOUR)
    {
        case 0:
            show_debug_message("Jukebox: WARNING! Node name \"" + _name + "\" already exists. Destroying old node");
            jukebox_destroy(_name);
        break;
        
        case 1:
            var _i = 0;
            var _new_name = _name + " (old " + string(_i) + ")";
            do
            {
                _i++;
                _new_name = _name + " (old " + string(_i) + ")";
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
            jukebox_destroy(_name);
        break;
    }
}

if (_name == undefined)
{
    var _i = 0;
    _name = audio_get_name(_sound) + " " + string(_i);
    do
    {
        _i++;
        _name = audio_get_name(_sound) + " " + string(_i);
    }
    until !ds_map_exists(global.__jukebox_names, _name);
}



var _parent_array = global.__jukebox_names[? _parent ];
if (_priority == undefined) _priority = _parent_array[ JUKEBOX.PRIORITY ];

var _children = _parent_array[ JUKEBOX.CHILDREN ];
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

var _resultant_gain = _trim*_gain*_parent_array[ JUKEBOX.GAIN ];
var _instance = audio_play_sound_on(_emitter, _sound, false, _priority);
audio_sound_gain(_instance, _resultant_gain, 0);

show_debug_message("Jukebox: Playing \"" + string(audio_get_name(_sound)) + "\"" + (_loop? " (looped)" : "") + " on node \"" + _name + "\"");

var _node = array_create(JUKEBOX.__SIZE);
_node[@ JUKEBOX.NAME             ] = _name;
_node[@ JUKEBOX.TYPE             ] = JUKEBOX_TYPE_AUDIO;
_node[@ JUKEBOX.PRIORITY         ] = _priority;
_node[@ JUKEBOX.EMITTER          ] = _emitter;
_node[@ JUKEBOX.TRIM             ] = _trim;
_node[@ JUKEBOX.GAIN             ] = _gain;
_node[@ JUKEBOX.GAIN_INHERITED   ] = _resultant_gain;
_node[@ JUKEBOX.MUTE             ] = false;
_node[@ JUKEBOX.MUTE_INHERITED   ] = false;
_node[@ JUKEBOX.MUTE_GAIN        ] = 1;
_node[@ JUKEBOX.AUDIO            ] = _sound;
_node[@ JUKEBOX.INSTANCE         ] = _instance;
_node[@ JUKEBOX.QUEUED_AUDIO       ] = _loop? _sound : -1;
_node[@ JUKEBOX.QUEUED_LOOP      ] = _loop;
_node[@ JUKEBOX.PARENT           ] = _parent;
_node[@ JUKEBOX.FADE_SPEED       ] = 0;
_node[@ JUKEBOX.FADE_TARGET_GAIN ] = _gain;
_node[@ JUKEBOX.CHILDREN         ] = [];
_node[@ JUKEBOX.DESTROY_AT_ZERO  ] = _destroy_at_zero;
global.__jukebox_names[? _name ] = _node;

global.__jukebox_last_modified = _name;
return _instance;