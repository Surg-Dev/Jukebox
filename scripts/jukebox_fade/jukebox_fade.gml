/// @param name
/// @param speed{gain/second}
/// @param [targetGain]
/// @param [destroyAtZero]

var _name            = argument[0];
var _speed           = argument[1];
var _target_gain     = (_speed != 0)? argument[2] : undefined;
var _destroy_at_zero = (argument_count > 3)? argument[3] : undefined;

if (_name == undefined)
{
    _name = global.__jukebox_last_modified;
    show_debug_message("Jukebox: Name was <undefined>, using last created Jukebox node \"" + string(global.__jukebox_last_modified) + "\"");
}

global.__jukebox_last_modified = undefined;

var _node = global.__jukebox_names[? _name ];
if (_node == undefined) return false;

var _gain = _node[ JUKEBOX.GAIN ];
_speed *= (game_get_speed(gamespeed_microseconds)/1000000); //Apply a coefficient to scale the speed
if (_speed == 0)
{
    if (_target_gain == undefined) _target_gain = _gain;
    _node[@ JUKEBOX.FADE_SPEED       ] = 0;
    _node[@ JUKEBOX.FADE_TARGET_GAIN ] = _target_gain;
    return true;
}

if (_target_gain == _gain)
{
    _node[@ JUKEBOX.FADE_SPEED       ] = 0;
    _node[@ JUKEBOX.FADE_TARGET_GAIN ] = _gain;
    return true;
}

if (_target_gain < _gain)
{
    _speed = -abs(_speed);
}
else
{
    _speed = abs(_speed);
}

_node[@ JUKEBOX.FADE_SPEED       ] = _speed;
_node[@ JUKEBOX.FADE_TARGET_GAIN ] = _target_gain;
if (_destroy_at_zero != undefined) _node[@ JUKEBOX.DESTROY_AT_ZERO ] = _destroy_at_zero;

global.__jukebox_last_modified = _name;
return _name;