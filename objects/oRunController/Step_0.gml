/// oRunController — Step

if (!variable_global_exists("game_phase")) global.game_phase = "playing";

if (global.game_phase == "death_delay")
{
    death_delay_timer--;

    if (death_delay_timer <= 0)
    {
        global.game_phase = "death_menu";

        if (!instance_exists(oDeathMenu))
        {
            var layer_name = layer_exists("GUI") ? "GUI" : "Instances";
            instance_create_layer(0, 0, layer_name, oDeathMenu);
        }
    }
}