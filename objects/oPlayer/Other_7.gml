/// oPlayer — Animation End

if (state == "dead") {
    image_speed = 0;
    image_index = image_number - 1;

    if (!instance_exists(oDeathMenu)) {
        global.scrap_total += global.scrap_run;
        global.scrap_run = 0;

        global.game_phase = "death_menu";

        instance_create_layer(x, y, "GUI", oDeathMenu);
    }
}
