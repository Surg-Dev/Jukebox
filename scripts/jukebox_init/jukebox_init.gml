/// @param masterName
/// @param masterGain
/// @param masterTrim
/// @param masterPriority

var _name     = argument0;
var _gain     = argument1;
var _trim     = argument2;
var _priority = argument3;

#macro __JUKEBOX_VERSION  "1.1.0"
#macro __JUKEBOX_DATE     "2019/04/23"

#macro __JUKEBOX_EXPECTED_FRAME_LENGTH  game_get_speed(gamespeed_microseconds)  //In microseconds
#macro __JUKEBOX_DEFAULT_STEP_SIZE      (delta_time/__JUKEBOX_EXPECTED_FRAME_LENGTH)

#macro __JUKEBOX_NOT_PLAYING  -1
#macro __JUKEBOX_TYPE_GROUP    0
#macro __JUKEBOX_TYPE_AUDIO    1

//Constants used for jukebox_get()
enum JUKEBOX
{
    GAIN,             // 1
    GAIN_INHERITED,   // 2
    
    TRIM,             // 1
    TRIM_TARGET,      // 2
    
    AUDIO,            // 3
    LOOP,             // 4
    INSTANCE,         // 4
    TIME_REMAINING,   // 5
    QUEUED_AUDIO,     // 6
    QUEUED_LOOP,      // 7
    
    FADE_SPEED,       // 8
    FADE_TARGET_GAIN, // 9
    DESTROY_AT_ZERO,  //10
    
    MUTE,             //11
    MUTE_INHERITED,   //12
    MUTE_GAIN,        //13
    
    NAME,             //16
    PARENT,           //17
    TYPE,             //18
    PRIORITY,         //19
    CHILDREN,         //20
    __INDEX,          //21
    __SIZE            //22
}

global.__jukebox_master_name    = _name;
global.__jukebox_trim         = ds_map_create();
global.__jukebox_names        = ds_map_create();
global.__jukebox_stack        = ds_list_create();

var _node = array_create(JUKEBOX.__SIZE);
_node[@ JUKEBOX.NAME             ] = global.__jukebox_master_name;
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
_node[@ JUKEBOX.DESTROY_AT_ZERO  ] = false;
global.__jukebox_names[? global.__jukebox_master_name ] = _node;