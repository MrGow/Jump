/// oPlayer — Begin Step

// ----------------------------------------------------
// Dead player during death_delay
//
// The world is frozen, but spriteBotDeath must remain
// animated. Do not set image_speed to zero here.
// ----------------------------------------------------
if (
    variable_instance_exists(id, "state") &&
    state == "dead"
)
{
    // Preserve information used by crushing hazards.
    crusher_prev_feet_y = bbox_bottom;
    crusher_prev_vsp    = vsp;

    exit;
}


// ----------------------------------------------------
// Freeze a living player during pause/menu/death menu
//
// death_delay is intentionally excluded. A player in
// death_delay is handled by the dead-state block above.
// ----------------------------------------------------
var freeze_player = false;

if (variable_global_exists("game_phase"))
{
    freeze_player =
        global.game_phase == "paused" ||
        global.game_phase == "menu" ||
        global.game_phase == "death_menu";
}

if (freeze_player)
{
    image_speed = 0;
    exit;
}


// ----------------------------------------------------
// Store previous feet for hazards before movement and
// collision alter the player's bounding box or speed.
// ----------------------------------------------------
crusher_prev_feet_y = bbox_bottom;
crusher_prev_vsp    = vsp;