#macro JUKEBOX_MUTE_SPEED  20.0  //How quickly audio fades out when muted (gain/second)
#macro JUKEBOX_TRIM_SPEED   5.0  //How quickly audio fades out when the trim is changed (gain/second)

#macro JUKEBOX_PLAY_OVERWRITE_BEHAVIOUR    1  //Controls what to do when a node name already exists
#macro JUKEBOX_RENAME_OVERWRITE_BEHAVIOUR  1  //Controls what to do when a node name already exists
// = 0: Old node is destroyed instantly
// = 1: Old node is renamed and faded out
// = 2: New node fails to be created and the old node remains
// = 3: Throw an error, and the old node is destroyed

#macro JUKEBOX_DEBUG  true  //Output extra debug information to help find bugs

#region Advanced

#macro JUKEBOX_DEBUG_CLEAN_UP_ORPHANS  false  //Whether to check for unconnected nodes every frame. Recommended to catch bugs
#macro JUKEBOX_FRAME_LEAD              2      //How many frames ahead to play queued audio. <2> is usually a good value
#macro JUKEBOX_MAX_GAIN                1.0    //I don't think gains above 1.0 do anything, but the option's there if you want it

#endregion