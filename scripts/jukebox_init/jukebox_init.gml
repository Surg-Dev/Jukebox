/// @param rootName
/// @param rootGain
/// @param rootTrim
/// @param rootPriority

var _name     = argument0;
var _gain     = argument1;
var _trim     = argument2;
var _priority = argument3;

#macro __JUKEBOX_VERSION  "0.0.1"
#macro __JUKEBOX_DATE     "2019/04/23"

#macro __JUKEBOX_EXPECTED_FRAME_LENGTH  game_get_speed(gamespeed_microseconds)  //In microseconds
#macro __JUKEBOX_DEFAULT_STEP_SIZE      (delta_time/__JUKEBOX_EXPECTED_FRAME_LENGTH)

global.__jukebox_root_name    = _name;
global.__jukebox_flipflop     = 0;
global.__jukebox_trim         = ds_map_create();
global.__jukebox_names        = ds_map_create();
global.__jukebox_stack        = ds_list_create();
global.__jukebox_last_modified = undefined;

var _node = array_create(JUKEBOX.__SIZE);
_node[@ JUKEBOX.NAME             ] = global.__jukebox_root_name;
_node[@ JUKEBOX.PRIORITY         ] = 10;
_node[@ JUKEBOX.TRIM             ] = _trim;
_node[@ JUKEBOX.GAIN             ] = _gain;
_node[@ JUKEBOX.GAIN_INHERITED   ] = _gain;
_node[@ JUKEBOX.MUTE             ] = false;
_node[@ JUKEBOX.MUTE_INHERITED   ] = false;
_node[@ JUKEBOX.MUTE_GAIN        ] = 1;
_node[@ JUKEBOX.AUDIO            ] = undefined;
_node[@ JUKEBOX.INSTANCE         ] = undefined;
_node[@ JUKEBOX.QUEUED_AUDIO     ] = undefined;
_node[@ JUKEBOX.PARENT           ] = undefined;
_node[@ JUKEBOX.PRIORITY         ] = _priority;
_node[@ JUKEBOX.FADE_SPEED       ] = 0;
_node[@ JUKEBOX.FADE_TARGET_GAIN ] = _gain;
_node[@ JUKEBOX.CHILDREN         ] = [];
_node[@ JUKEBOX.__FLIPFLOP       ] = 0;
_node[@ JUKEBOX.DESTROY_AT_ZERO  ] = false;
global.__jukebox_names[? global.__jukebox_root_name ] = _node;