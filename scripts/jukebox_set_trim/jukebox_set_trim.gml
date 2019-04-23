/// @param name
/// @param trimGain

var _name = argument0;
var _trim = argument1;

var _node = global.__jukebox_names[? _name ];
if (_node == undefined) return true;

_node[@ JUKEBOX.TRIM_TARGET ] = _trim;