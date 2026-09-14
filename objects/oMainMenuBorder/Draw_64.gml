/// oMainMenuBorder — Draw GUI


// ====================================================
// INTRO CUTSCENE VISIBILITY
//
// 0 = CRT power-on
// 1 = terminal
// 2 = CRT shutdown
// 3 = cinematic slides
//
// Border belongs to the physical CRT terminal only.
// ====================================================

if (room == IntroCutsceneRoom)
{
    if (
        instance_exists(oIntroCutsceneController)
        &&
        oIntroCutsceneController.intro_phase >= 3
    )
    {
        exit;
    }
}


// ====================================================
// BORDER SPRITE
// ====================================================

if (border_sprite == -1)
{
    exit;
}


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_alpha(1);

draw_set_color(c_white);

draw_set_halign(fa_left);

draw_set_valign(fa_top);


// ====================================================
// DRAW CRT BORDER
//
// spriteMainMenuBorder:
//     Size   = 640 x 360
//     Origin = Top Centre
//
// GUI:
//     640 x 360
//
// Therefore:
//     X = 320
//     Y = 0
// ====================================================

draw_sprite(
    border_sprite,
    0,
    320,
    0
);


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_alpha(1);

draw_set_color(c_white);