/// @param name

var _name = argument0;

if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Destroying node \"" + string(_name) + "\"");

var _node = global.__jukebox_names[? _name ];
if (_node == undefined) return false;

//Stops this sound's audio
var _instance   = _node[ JUKEBOX.INSTANCE   ];
if (_instance != undefined) audio_stop_sound(_instance);

jukebox_destroy_children(_name);

//Remove this child from the parent
var _parent_node = global.__jukebox_names[? _node[ JUKEBOX.PARENT ] ];
if (_parent_node != undefined)
{
    var _children = _parent_node[ JUKEBOX.CHILDREN ];
    var _count = array_length_1d(_children);
    for(var _i = 0; _i < _count; _i++) if (_children[_i] == _name) _children[@ _i] = undefined;
}

//Delete the reference in global map
ds_map_delete(global.__jukebox_names, _name);

return true;