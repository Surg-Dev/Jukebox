#macro JUKEBOX_LAST_MODIFIED            global.__jukebox_last_modified

#macro JUKEBOX_MUTE_SPEED               20    //How quickly audio fades out when muted
#macro JUKEBOX_DEFAULT_DESTROY_AT_ZERO  true  //The default behaviour for audio nodes that have been faded to zero

#macro JUKEBOX_CREATE_OVERWRITE_BEHAVIOUR  1  //Controls what to do when a node name already exists
#macro JUKEBOX_RENAME_OVERWRITE_BEHAVIOUR  1  //JUKEBOX_OVERWRITE_BEHAVIOUR = 0: Old node is destroyed
                                              //JUKEBOX_OVERWRITE_BEHAVIOUR = 1: Old node is renamed and faded out
                                              //JUKEBOX_OVERWRITE_BEHAVIOUR = 2: New node fails to be created and the old node remains
                                              //JUKEBOX_OVERWRITE_BEHAVIOUR = 3: Throw an error, and the old node is destroyed

//Constants used for jukebox_get() and jukebox_set()
enum JUKEBOX
{
    TRIM,             // 0
    GAIN,             // 1
    GAIN_INHERITED,   // 2
    
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
    EMITTER,          //20
    CHILDREN,         //21
    __FLIPFLOP,       //22
    __SIZE            //23
}

// Constants returned by jukebox_get("node", JUKEBOX.TYPE)
#macro JUKEBOX_TYPE_GROUP  0
#macro JUKEBOX_TYPE_AUDIO  1

//Debug
#macro JUKEBOX_DEBUG_CLEAN_UP_ORPHANS  false  //Whether to check for unconnected nodes every frame. Recommended to catch bugs
#macro JUKEBOX_FRAME_LEAD              2      //How many frames ahead to play queued audio
#macro JUKEBOX_MAX_GAIN                1      //I don't gains above 1.0 do anything, but the option's there if you want it