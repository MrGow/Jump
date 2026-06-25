/// oElectricCableLarge — End Step

if (scr_game_frozen()) exit;

if (!enabled) exit;
if (!active) exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;

if (!variable_instance_exists(p, "electric_hit_lock")) p.electric_hit_lock = 0;

if (p.electric_hit_lock > 0)
{
    p.electric_hit_lock--;
    exit;
}

if (variable_instance_exists(p, "state") && p.state == "dead") exit;

if (!place_meeting(x, y, oPlayer)) exit;

with (p)
{
    if (state == "dead") exit;

    scr_player_died();
    electric_hit_lock = other.player_hit_lock_frames;
}