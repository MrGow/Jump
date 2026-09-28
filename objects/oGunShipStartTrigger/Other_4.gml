/// oGunShipStartTrigger — Room Start

activated = false;
encounter_active = false;

waiting_for_player_clear = false;


// ----------------------------------------------------
// Remove anything left from direct testing / restart.
// ----------------------------------------------------

with (oGunShip)
{
    instance_destroy();
}


if (asset_get_index("oGunShipMine") != -1)
{
    with (oGunShipMine)
    {
        instance_destroy();
    }
}

completed = false;

if (instance_exists(oGunShipController))
{
    with (oGunShipController)
    {
        ship = noone;
        active = false;
        hp = max_hp;
    }
}