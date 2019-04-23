/// @param name
/// @param mute

var _name = argument0;
var _mute = argument1;

var _node = global.__jukebox_names[? _name ];
if (_node == undefined) exit;

_node[@ JUKEBOX.MUTE ] = _mute;