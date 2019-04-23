/// @param name
/// @param property

var _name     = argument0;
var _property = argument1;

var _node = global.__jukebox_names[? _name ];
if (_node == undefined) return true;

return _node[ _property ];