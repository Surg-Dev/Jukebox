/// @param name

var _name = argument0;

show_debug_message("Jukebox: Destroying node \"" + string(_name) + "\"'s children");

var _node = global.__jukebox_names[? _name ];
if (_node == undefined) return false;

//Destroy children
var _children = _node[ JUKEBOX.CHILDREN ];
var _count = array_length_1d(_children);
for(var _i = 0; _i < _count; _i++)
{
    var _child_name = _children[ _i ];
    var _child_node = global.__jukebox_names[? _child_name ];
    if (_child_node == undefined) continue;
    jukebox_destroy(_child_name);
}

return true;