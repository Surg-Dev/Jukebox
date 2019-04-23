/// @param base

var _base = argument0;

var _name = string(_base);
if (is_real(_base))
{
    var _asset_name = audio_get_name(_base);
}

var _i = 0;
do
{
    var _new_name = _name + " (" + string(_i) + ")";
    _i++;
}
until !ds_map_exists(global.__jukebox_names, _new_name);

return _new_name;