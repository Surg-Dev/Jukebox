/// @param [stepSize]

var _step_size = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __JUKEBOX_DEFAULT_STEP_SIZE;

var _per_second_factor = game_get_speed(gamespeed_microseconds)/1000000;


var _root_node = global.__jukebox_names[? global.__jukebox_root_name ];
var _gain        = _root_node[ JUKEBOX.GAIN             ];
var _fade_speed  = _root_node[ JUKEBOX.FADE_SPEED       ];
var _fade_target = _root_node[ JUKEBOX.FADE_TARGET_GAIN ];

if (_fade_speed > 0)
{
    _gain = min(_fade_target, _gain + _fade_speed*_step_size);
}
else if (_fade_speed < 0)
{
    _gain = max(_fade_target, _gain + _fade_speed*_step_size);
}

_root_node[@ JUKEBOX.MUTE_INHERITED ] = _root_node[ JUKEBOX.MUTE ];
_root_node[@ JUKEBOX.__INDEX        ] = 0;
_root_node[@ JUKEBOX.GAIN           ] = _gain;
_root_node[@ JUKEBOX.GAIN_INHERITED ] = _root_node[ JUKEBOX.TRIM ]*_gain;



var _name = global.__jukebox_root_name;
repeat(999)
{
    if (_name == undefined) break;
    
    var _parent_node = global.__jukebox_names[? _name ];
    if (_parent_node == undefined)
    {
        show_debug_message("Jukebox: WARNING! Node \"" + _name + "\" was queued but does not exist");
        _name = _parent_name;
        break;
    }
    
    var _parent_name = _name;
    var _parent_gain = _parent_node[ JUKEBOX.GAIN_INHERITED ];
    var _parent_mute = _parent_node[ JUKEBOX.MUTE_INHERITED ];
    var _children    = _parent_node[ JUKEBOX.CHILDREN       ];
    
    var _index = _parent_node[@ JUKEBOX.__INDEX ];
    _parent_node[@ JUKEBOX.__INDEX ]++;
    if (_index >= array_length_1d(_children))
    {
        _name = _parent_node[ JUKEBOX.PARENT ];
        continue;
    }
    
    _name = _children[ _index ];
    if (_name == undefined)
    {
        _name = _parent_name;
        continue;
    }
    
    
    
    var _node = global.__jukebox_names[? _name ];
    if (_node == undefined)
    {
        _children[@ _index ] = undefined;
        _name = _parent_name;
        continue;
    }
    
    _node[@ JUKEBOX.__INDEX ] = 0;
    
    
    
    
    var _gain        = _node[ JUKEBOX.GAIN             ];
    var _fade_speed  = _node[ JUKEBOX.FADE_SPEED       ];
    var _fade_target = _node[ JUKEBOX.FADE_TARGET_GAIN ];
    var _audio       = _node[ JUKEBOX.AUDIO            ];
    var _loop        = _node[ JUKEBOX.LOOP             ];
    var _instance    = _node[ JUKEBOX.INSTANCE         ];
    var _next_audio  = _node[ JUKEBOX.QUEUED_AUDIO     ];
    var _next_loop   = _node[ JUKEBOX.QUEUED_LOOP      ];
    var _trim        = _node[ JUKEBOX.TRIM             ];
    var _trim_target = _node[ JUKEBOX.TRIM_TARGET      ];
    var _mute        = _node[ JUKEBOX.MUTE             ] || _parent_mute;
    
    //Handle mute gain
    _node[@ JUKEBOX.MUTE_INHERITED ] = _mute;
    var _mute_gain = _node[ JUKEBOX.MUTE_GAIN ];
    if (_mute)
    {
        _mute_gain = max(0, _mute_gain - _step_size*JUKEBOX_MUTE_SPEED*_per_second_factor);
    }
    else
    {
        _mute_gain = min(1, _mute_gain + _step_size*JUKEBOX_MUTE_SPEED*_per_second_factor);
    }
    _node[@ JUKEBOX.MUTE_GAIN ] = _mute_gain;
    
    //Change trim value
    if (_trim != _trim_target)
    {
        var _diff = clamp(_trim_target - _trim, -_per_second_factor*JUKEBOX_TRIM_SPEED, _per_second_factor*JUKEBOX_TRIM_SPEED);
        _trim = clamp(_trim + _step_size*_diff, 0, 1);
        _node[@ JUKEBOX.TRIM ] = _trim;
    }
    
    //Perform fade
    if (_fade_speed > 0)
    {
        _gain = min(_fade_target, _gain + _fade_speed*_step_size);
    }
    else if (_fade_speed < 0)
    {
        _gain = max(_fade_target, _gain + _fade_speed*_step_size);
    }
    
    //If we're at our fade target, set the fade speed to 0
    if (_gain == _fade_target) _node[@ JUKEBOX.FADE_SPEED ] = 0;
    
    //Calculate the final gain
    var _resultant_gain = _trim*_gain*_parent_gain;
    _node[@ JUKEBOX.GAIN           ] = _gain;
    _node[@ JUKEBOX.GAIN_INHERITED ] = _resultant_gain;
    
    if ((_resultant_gain <= 0) && _node[ JUKEBOX.DESTROY_AT_ZERO ])
    {
        if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Node \"" + string(_name) + "\" has reached a final gain of zero");
        jukebox_destroy(_name);
        _name = _parent_name;
        continue;
    }
    
    
    
    if (_node[ JUKEBOX.TYPE ] == __JUKEBOX_TYPE_AUDIO)
    {
        audio_sound_gain(_instance, clamp(_mute_gain*_resultant_gain, 0, JUKEBOX_MAX_GAIN), JUKEBOX_FRAME_LEAD*__JUKEBOX_EXPECTED_FRAME_LENGTH/1000);
        
        var _diff = 0;
        var _is_playing = audio_is_playing(_instance);
        if (_is_playing)
        {
            var _length   = audio_sound_length(_instance)*1000;
            var _position = audio_sound_get_track_position(_instance)*1000;
            _diff = _length - (_position mod _length);
        }
        
        _node[@ JUKEBOX.TIME_REMAINING ] = _diff;
        
        if (audio_exists(_next_audio))
        {
            var _play_queued = false;
                
            if (_diff <= JUKEBOX_FRAME_LEAD*__JUKEBOX_EXPECTED_FRAME_LENGTH/1000)
            {
                _play_queued = true;
            }
            
            if (!_is_playing)
            {
                show_debug_message("Jukebox: WARNING! Missed time-based cue to play next track");
                _play_queued = true;
            }
            
            if (_play_queued)
            {
                if ((_next_audio != _audio) || !_loop)
                {
                    if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Starting new instance of \"" + string(audio_get_name(_next_audio)) + "\" for node \"" + string(_name) + "\"");
                    
                    audio_stop_sound(_instance); //Positive destroy the old instance
                    _instance = audio_play_sound(_next_audio, _node[ JUKEBOX.PRIORITY ], _next_loop);
                    audio_sound_gain(_instance, clamp(_mute_gain*_resultant_gain, 0, JUKEBOX_MAX_GAIN), 0);
                    
                    _node[@ JUKEBOX.AUDIO    ] = _next_audio;
                    _node[@ JUKEBOX.INSTANCE ] = _instance;
                    if (!_node[ JUKEBOX.QUEUED_LOOP ]) _node[@ JUKEBOX.QUEUED_AUDIO ] = -1;
                }
                
                _node[@ JUKEBOX.LOOP ] = _node[@ JUKEBOX.QUEUED_LOOP ];
            }
        }
        else
        {
            if (!_is_playing)
            {
                if (JUKEBOX_DEBUG) show_debug_message("Jukebox: Node \"" + string(_name) + "\" has ended");
                jukebox_destroy(_name);
                _name = _parent_name;
            }
        }
    }
}



#region Clean up orphans

if (JUKEBOX_DEBUG_CLEAN_UP_ORPHANS)
{
    var _key = ds_map_find_first(global.__jukebox_names);
    while(_key != undefined)
    {
        var _node = global.__jukebox_names[? _key ];
        
        var _parent = _node[ JUKEBOX.PARENT ];
        if (_parent == undefined)
        {
            if (_key != global.__jukebox_root_name)
            {
                if (JUKEBOX_DEBUG) show_debug_message("Jukebox: \"" + string(_key) + "\" destroyed as it has an undefined parent");
                jukebox_destroy(_key);
            }
            
            _key = ds_map_find_next(global.__jukebox_names, _key);
            continue;
        }
        
        var _parent_node = global.__jukebox_names[? _parent ];
        if (_parent_node == undefined)
        {
            if (JUKEBOX_DEBUG) show_debug_message("Jukebox: \"" + string(_key) + "\" destroyed as its parent \"" + string(_parent) + "\" does not exist");
            jukebox_destroy(_key);
            
            _key = ds_map_find_next(global.__jukebox_names, _key);
            continue;
        }
        
        var _children = _parent_node[ JUKEBOX.CHILDREN ];
        var _size = array_length_1d(_children);
        for(var _i = 0; _i < _size; _i++) if (_children[ _i ] == _key) break;
        if (_i >= _size)
        {
            if (JUKEBOX_DEBUG) show_debug_message("Jukebox: \"" + string(_key) + "\" destroyed as its parent \"" + string(_parent) + "\" does have it as a child");
            jukebox_destroy(_key);
        }
        
        _key = ds_map_find_next(global.__jukebox_names, _key);
    }
}

#endregion