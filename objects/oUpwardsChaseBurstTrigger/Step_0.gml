/// oUpwardsChaseBurstTrigger — Step

if (scr_game_frozen())
{
    exit;
}

if (activated)
{
    exit;
}

var p = instance_find(oPlayer, 0);

if (p == noone)
{
    exit;
}


// ----------------------------------------------------
// Upward chase:
//
// Activate when the player climbs above this trigger.
// ----------------------------------------------------
if (p.y <= y)
{
    var caterpillar_obj =
        asset_get_index("oArea3ChasingCaterpillar");

    if (caterpillar_obj != -1)
    {
        var caterpillar =
            instance_find(caterpillar_obj, 0);

        if (caterpillar != noone)
        {
            caterpillar.burst_target =
                caterpillar.burst_offset +
                burst_distance;

            caterpillar.burst_speed  = burst_speed;
            caterpillar.burst_active = true;
        }
    }

    activated = true;

    show_debug_message("UPWARDS CATERPILLAR BURST");
}