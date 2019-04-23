/// @param name
/// @param sound
/// @param loop

var _name  = argument0;
var _index = argument1;
var _loop  = argument2;

var _node = global.__jukebox_names[? _name ];
if (_node == undefined)
{
    show_debug_message("Jukebox: WARNING! Node \"" + string(_name) + "\" doesn't exist. Aborting queue of \"" + string(audio_get_name(_index)) + "\"" + (_loop? " (looped)" : ""));
    return undefined;
}

if (_node[ JUKEBOX.TYPE ] != __JUKEBOX_TYPE_AUDIO)
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
    if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Queuing \"" + string(audio_get_name(_index)) + "\"" + (_loop? " (looped)" : "") + " for play on node \"" + _name + "\"");
}
else
{
    if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Queuing \"" + string(audio_get_name(_index)) + "\"" + (_loop? " (looped)" : "") + " for play on node \"" + _name + "\". This overwrites \"" + string(audio_get_name(_old_queued)) + "\"" + (_old_looped? " (looped)" : ""));
}

return _name;