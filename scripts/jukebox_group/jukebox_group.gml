/// @param name
/// @param [parent]
/// @param [startGain]
/// @param [destroyAtZero]
/// @param [trim]
/// @param [priority]

var _name            = argument[0];
var _parent          = ((argument_count > 1) && (argument[1] != undefined))? argument[1] : global.__jukebox_root_name;
var _gain            = ((argument_count > 2) && (argument[2] != undefined))? argument[2] : 1.0;
var _destroy_at_zero = ((argument_count > 3) && (argument[3] != undefined))? argument[3] : true;
var _trim            = ((argument_count > 4) && (argument[4] != undefined))? argument[4] : 1.0;
var _priority        = ((argument_count > 5)                              )? argument[5] : undefined;

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
            jukebox_stop(_name);
        break;
    }
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



var _resultant_gain = _trim*_gain*_parent_array[ JUKEBOX.GAIN ];

if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Creating group \"" + _name + "\", child of \"" + string(_parent) + "\"");

var _node = array_create(JUKEBOX.__SIZE);
_node[@ JUKEBOX.GAIN             ] = _gain;
_node[@ JUKEBOX.GAIN_INHERITED   ] = _resultant_gain;

_node[@ JUKEBOX.TRIM             ] = _trim;
_node[@ JUKEBOX.TRIM_TARGET      ] = _trim;

_node[@ JUKEBOX.AUDIO            ] = -1;
_node[@ JUKEBOX.INSTANCE         ] = -1;
_node[@ JUKEBOX.TIME_REMAINING   ] =  0;
_node[@ JUKEBOX.QUEUED_AUDIO     ] = -1;
_node[@ JUKEBOX.QUEUED_LOOP      ] = false;

_node[@ JUKEBOX.FADE_SPEED       ] = 0;
_node[@ JUKEBOX.FADE_TARGET_GAIN ] = _gain;
_node[@ JUKEBOX.DESTROY_AT_ZERO  ] = _destroy_at_zero;

_node[@ JUKEBOX.MUTE             ] = false;
_node[@ JUKEBOX.MUTE_INHERITED   ] = false;
_node[@ JUKEBOX.MUTE_GAIN        ] = 1;

_node[@ JUKEBOX.NAME             ] = _name;
_node[@ JUKEBOX.PARENT           ] = _parent;
_node[@ JUKEBOX.TYPE             ] = __JUKEBOX_TYPE_GROUP;
_node[@ JUKEBOX.PRIORITY         ] = _priority;
_node[@ JUKEBOX.CHILDREN         ] = [];
global.__jukebox_names[? _name ] = _node;

return _name;