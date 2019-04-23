/// @param name
/// @param property
/// @param value

var _name     = argument0;
var _property = argument1;
var _value    = argument2;

var _node = global.__jukebox_names[? _name ];
if (_node == undefined) return false;

_node[@ _property ] = _value;
return true;