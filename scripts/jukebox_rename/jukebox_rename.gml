/// @param oldName
/// @param [newName]

var _old_name = argument[0];
var _new_name = (argument_count > 1)? argument[1] : undefined;

var _node = global.__jukebox_names[? _old_name ];
if (_node == undefined)
{
    show_debug_message("Jukebox: WARNING! Node \"" + string(_old_name) + "\" could not be found. Aborting rename (to \"" + string(_new_name) + "\")");
    return undefined;
}

if (_new_name == undefined)
{
    var _sound = _node[ JUKEBOX.AUDIO ];
    var _i = 0;
    do
    {
        _new_name = audio_get_name(_sound) + " (" + string(_i) + ")";
        _i++;
    }
    until !ds_map_exists(global.__jukebox_names, _new_name);
}

if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Renaming node \"" + string(_old_name) + "\" to \"" + string(_new_name) + "\"");



if (ds_map_exists(global.__jukebox_names, _new_name))
{
    switch(JUKEBOX_RENAME_OVERWRITE_BEHAVIOUR)
    {
        case 0:
            show_debug_message("Jukebox: WARNING! New node name \"" + _new_name + "\" already exists. Destroying extant node");
            jukebox_destroy(_new_name);
        break;
        
        case 1:
            var _i = 0;
            var _new_extant_name = _new_name + " (old " + string(_i) + ")";
            do
            {
                _i++;
                _new_extant_name = _new_name + " (old " + string(_i) + ")";
            }
            until !ds_map_exists(global.__jukebox_names, _new_extant_name);
            
            show_debug_message("Jukebox: WARNING! New node name \"" + _new_name + "\" already exists. Renaming extant node to \"" + _new_extant_name + "\" and fading out");
            jukebox_rename(_new_name, _new_extant_name);
            jukebox_fade(_new_extant_name, JUKEBOX_MUTE_SPEED, 0);
        break;
        
        case 2:
            show_debug_message("Jukebox: WARNING! Node name \"" + _new_name + "\" already exists. Aborting node renaming");
            return undefined;
        break;
        
        case 3:
            show_error("Jukebox:\nNew node name \"" + _new_name + "\" already exists. Destroying extant node.\n ", false);
            jukebox_destroy(_new_name);
        break;
    }
}



//Rename children's parent
var _children = _node[ JUKEBOX.CHILDREN ];
var _count = array_length_1d(_children);
for(var _i = 0; _i < _count; _i++)
{
    var _child_node = global.__jukebox_names[? _children[ _i ] ];
    if (_child_node == undefined) continue;
    _child_node[ JUKEBOX.PARENT ] = _new_name;
}

//Rename parent's child
var _parent_node = global.__jukebox_names[? _node[ JUKEBOX.PARENT ] ];
if (_parent_node != undefined)
{
    var _children = _parent_node[ JUKEBOX.CHILDREN ];
    var _count = array_length_1d(_children);
    for(var _i = 0; _i < _count; _i++) if (_children[_i] == _old_name) _children[@ _i] = _new_name;
}

//Rename the reference in global map
global.__jukebox_names[? _new_name ] = _node;
ds_map_delete(global.__jukebox_names, _old_name);

return _new_name;