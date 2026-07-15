/// oRunController — Step

if (!variable_global_exists("game_phase"))
{
    global.game_phase = "playing";
}


// ----------------------------------------------------
// Conveyor-strip shared SFX cooldowns
// ----------------------------------------------------
if (!variable_global_exists("green_strip_sfx_cooldown"))
{
    global.green_strip_sfx_cooldown = 0;
}

if (!variable_global_exists("red_strip_sfx_cooldown"))
{
    global.red_strip_sfx_cooldown = 0;
}


// Only advance sound cooldowns during active gameplay.
if (global.game_phase == "playing")
{
    if (global.green_strip_sfx_cooldown > 0)
    {
        global.green_strip_sfx_cooldown--;
    }

    if (global.red_strip_sfx_cooldown > 0)
    {
        global.red_strip_sfx_cooldown--;
    }
}


// ----------------------------------------------------
// Death animation delay
// ----------------------------------------------------
if (global.game_phase == "death_delay")
{
    death_delay_timer--;

    if (death_delay_timer <= 0)
    {
        global.game_phase = "death_menu";

        if (!instance_exists(oDeathMenu))
        {
            var layer_name =
                layer_exists("GUI")
                ? "GUI"
                : "Instances";

            instance_create_layer(
                0,
                0,
                layer_name,
                oDeathMenu
            );
        }
    }
}