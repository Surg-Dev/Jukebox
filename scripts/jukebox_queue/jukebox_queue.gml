/// @param name
/// @param newIndex
/// @param newLoop

var _name  = argument0;
var _index = argument1;
var _loop  = argument2;

global.__jukebox_last_modified = undefined;

var _node = global.__jukebox_names[? _name ];
if (_node == undefined)
{
    show_debug_message("Jukebox: WARNING! Node \"" + string(_name) + "\" doesn't exist. Aborting queue of \"" + string(audio_get_name(_index)) + "\"" + (_loop? " (looped)" : ""));
    return undefined;
}

if (_node[ JUKEBOX.TYPE ] != JUKEBOX_TYPE_AUDIO)
{
    show_debug_message("Jukebox: WARNING! Cannot queue to a group");
    return undefined;
}

var _old_queued = _node[ JUKEBOX.QUEUED_AUDIO ];
var _old_looped = _node[ JUKEBOX.QUEUED_LOOP  ];
_node[@ JUKEBOX.QUEUED_AUDIO ] = _index;
_node[@ JUKEBOX.QUEUED_LOOP  ] = _loop;

if (!audio_exists(_old_queued))
{
    show_debug_message("Jukebox: Queuing \"" + string(audio_get_name(_index)) + "\"" + (_loop? " (looped)" : "") + " for play on node \"" + _name + "\"");
}
else
{
    show_debug_message("Jukebox: Queuing \"" + string(audio_get_name(_index)) + "\"" + (_loop? " (looped)" : "") + " for play on node \"" + _name + "\". This overwrites \"" + string(audio_get_name(_old_queued)) + "\"" + (_old_looped? " (looped)" : ""));
}

global.__jukebox_last_modified = _name;
return _name;