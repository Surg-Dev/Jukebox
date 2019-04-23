/// @param [stepSize]

var _step_size = ((argument_count > 0) && (argument[0] != undefined))? argument[0] : __JUKEBOX_DEFAULT_STEP_SIZE;

global.__jukebox_flipflop = !global.__jukebox_flipflop;
ds_list_clear(global.__jukebox_stack);



var _name = global.__jukebox_root_name;
var _node = global.__jukebox_names[? _name ];

var _gain        = _node[ JUKEBOX.GAIN             ];
var _fade_speed  = _node[ JUKEBOX.FADE_SPEED       ];
var _fade_target = _node[ JUKEBOX.FADE_TARGET_GAIN ];

if (_fade_speed > 0)
{
    _gain = min(_fade_target, _gain + _fade_speed*_step_size);
}
else if (_fade_speed < 0)
{
    _gain = max(_fade_target, _gain + _fade_speed*_step_size);
}

_node[@ JUKEBOX.MUTE_INHERITED ] = _node[ JUKEBOX.MUTE ];
_node[@ JUKEBOX.__FLIPFLOP     ] = global.__jukebox_flipflop;
_node[@ JUKEBOX.GAIN           ] = _gain;
_node[@ JUKEBOX.GAIN_INHERITED ] = _node[ JUKEBOX.TRIM ]*_gain;
ds_list_add(global.__jukebox_stack, 0);



repeat(999)
{
    if (ds_list_empty(global.__jukebox_stack)) break;
    
    var _node = global.__jukebox_names[? _name ];
    if (_node == undefined)
    {
        show_debug_message("Jukebox: ERROR! Node \"" + _name + "\" was queued but does not exist");
        _name = _parent_name;
        ds_list_delete(global.__jukebox_stack, 0);
        break;
    }
    var _parent_name = _name;
    
    var _parent_gain = _node[ JUKEBOX.GAIN_INHERITED ];
    var _parent_mute = _node[ JUKEBOX.MUTE_INHERITED ];
    var _children    = _node[ JUKEBOX.CHILDREN       ];
    
    var _index = global.__jukebox_stack[| 0];
    if (_index >= array_length_1d(_children))
    {
        _name = _node[ JUKEBOX.PARENT ];
        ds_list_delete(global.__jukebox_stack, 0);
        continue;
    }
    
    _name = _children[ _index ];
    global.__jukebox_stack[| 0]++;
    if (_name == undefined)
    {
        _name = _parent_name;
        continue;
    }
    
    _node = global.__jukebox_names[? _name ];
    if (_node == undefined)
    {
        _children[@ _index ] = undefined;
        _name = _parent_name;
        continue;
    }
    
    _node[@ JUKEBOX.__FLIPFLOP ] = global.__jukebox_flipflop;
    
    var _mute = _parent_mute || _node[ JUKEBOX.MUTE ];
    _node[@ JUKEBOX.MUTE_INHERITED ] = _mute;
    
    var _mute_gain = _node[ JUKEBOX.MUTE_GAIN ];
    if (_mute)
    {
        _mute_gain = max(0, _mute_gain - JUKEBOX_MUTE_SPEED*(game_get_speed(gamespeed_microseconds)/1000000));
    }
    else
    {
        _mute_gain = min(1, _mute_gain + JUKEBOX_MUTE_SPEED*(game_get_speed(gamespeed_microseconds)/1000000));
    }
    _node[@ JUKEBOX.MUTE_GAIN ] = _mute_gain;
    
    
    
    var _trim        = _node[ JUKEBOX.TRIM             ];
    var _gain        = _node[ JUKEBOX.GAIN             ];
    var _fade_speed  = _node[ JUKEBOX.FADE_SPEED       ];
    var _fade_target = _node[ JUKEBOX.FADE_TARGET_GAIN ];
    var _audio       = _node[ JUKEBOX.AUDIO            ];
    var _loop        = _node[ JUKEBOX.LOOP             ];
    var _instance    = _node[ JUKEBOX.INSTANCE         ];
    var _next_audio  = _node[ JUKEBOX.QUEUED_AUDIO     ];
    var _next_loop   = _node[ JUKEBOX.QUEUED_LOOP      ];
    
    if (_fade_speed > 0)
    {
        _gain = min(_fade_target, _gain + _fade_speed*_step_size);
    }
    else if (_fade_speed < 0)
    {
        _gain = max(_fade_target, _gain + _fade_speed*_step_size);
    }
    
    if (_gain == _fade_target) _node[@ JUKEBOX.FADE_SPEED ] = 0;
    
    var _resultant_gain = _trim*_gain*_parent_gain;
    _node[@ JUKEBOX.GAIN           ] = _gain;
    _node[@ JUKEBOX.GAIN_INHERITED ] = _resultant_gain;
    
    
    
    if ((_resultant_gain <= 0) && _node[ JUKEBOX.DESTROY_AT_ZERO ])
    {
        show_debug_message("Jukebox: Node \"" + string(_name) + "\" has reached a resultant gain of zero");
        jukebox_destroy(_name);
        _name = _parent_name;
        continue;
    }
    
    
    
    if (_node[ JUKEBOX.TYPE ] == JUKEBOX_TYPE_AUDIO)
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
                    show_debug_message("Jukebox: Starting new instance of \"" + string(audio_get_name(_next_audio)) + "\" for node \"" + string(_name) + "\"");
                    
                    audio_stop_sound(_instance); //Positive destroy the old instance
                    
                    var _emitter = _node[ JUKEBOX.EMITTER ];
                    if (_emitter == undefined)
                    {
                        _instance = audio_play_sound(_next_audio, _node[ JUKEBOX.PRIORITY ], _next_loop);
                    }
                    else
                    {
                        _instance = audio_play_sound_on(_emitter, _next_audio, _next_loop, _node[ JUKEBOX.PRIORITY ]);
                    }
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
                show_debug_message("Jukebox: Node \"" + string(_name) + "\" has ended");
                jukebox_destroy(_name);
            }
        }
    }
    
    ds_list_insert(global.__jukebox_stack, 0, 0);
}



if (JUKEBOX_DEBUG_CLEAN_UP_ORPHANS)
{
    var _key = ds_map_find_first(global.__jukebox_names);
    while(_key != undefined)
    {
        _node = global.__jukebox_names[? _key ];
        if (_node[ JUKEBOX.__FLIPFLOP ] != global.__jukebox_flipflop)
        {
            show_debug_message("Jukebox: Cleaning up node \"" + _key + "\" as it has been orphaned");
            jukebox_destroy(_key);
        }
        _key = ds_map_find_next(global.__jukebox_names, _key);
    }
}