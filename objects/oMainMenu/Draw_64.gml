/// oMainMenu — Draw GUI

scr_settings_init();

var gw = 640;
var gh = 360;
var cx = round(gw * 0.5);


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "crt_inset_left"))
{
    crt_inset_left = 22;
}

if (!variable_instance_exists(id, "crt_inset_right"))
{
    crt_inset_right = 22;
}

if (!variable_instance_exists(id, "crt_inset_top"))
{
    crt_inset_top = 14;
}

if (!variable_instance_exists(id, "crt_inset_bottom"))
{
    crt_inset_bottom = 15;
}

if (!variable_instance_exists(id, "crt_corner_cut"))
{
    crt_corner_cut = 12;
}


// ----------------------------------------------------
// PHOSPHOR / CONTENT INSTABILITY
//
// These affect the actual menu content separately from
// the physical CRT overlays below.
// ----------------------------------------------------

if (!variable_instance_exists(id, "crt_phosphor_min"))
{
    crt_phosphor_min = 0.93;
}

if (!variable_instance_exists(id, "crt_phosphor_logo_min"))
{
    crt_phosphor_logo_min = 0.89;
}

if (!variable_instance_exists(id, "crt_phosphor_level"))
{
    crt_phosphor_level = 1;
}

if (!variable_instance_exists(id, "crt_phosphor_logo_level"))
{
    crt_phosphor_logo_level = 1;
}

if (!variable_instance_exists(id, "crt_selection_level"))
{
    crt_selection_level = 1;
}

if (!variable_instance_exists(id, "crt_dropout_timer"))
{
    crt_dropout_timer =
        irandom_range(
            360,
            600
        );
}

if (!variable_instance_exists(id, "crt_dropout_frames"))
{
    crt_dropout_frames = 0;
}

if (!variable_instance_exists(id, "crt_dropout_strength"))
{
    crt_dropout_strength = 0.13;
}

if (!variable_instance_exists(id, "crt_glass_tint_alpha"))
{
    crt_glass_tint_alpha = 0.018;
}

if (!variable_instance_exists(id, "crt_glass_tint_color"))
{
    crt_glass_tint_color =
        make_color_rgb(
            70,
            150,
            145
        );
}


// ----------------------------------------------------
// Rolling interference band extra side inset
// ----------------------------------------------------

if (!variable_instance_exists(id, "crt_roll_side_inset"))
{
    crt_roll_side_inset = 9;
}


// ----------------------------------------------------
// Rolling interference band vertical safe area.
//
// Extra clearance INSIDE the normal CRT bounds.
//
// This prevents the wide moving band from appearing
// underneath the top/bottom parts of the metal bezel.
// ----------------------------------------------------

if (!variable_instance_exists(id, "crt_roll_top_inset"))
{
    crt_roll_top_inset = 9;
}

if (!variable_instance_exists(id, "crt_roll_bottom_inset"))
{
    crt_roll_bottom_inset = 9;
}


// ====================================================
// FOOTER POSITION
//
// Both use the same Y so they stay perfectly level.
// ====================================================

var footer_side_inset =
    40;

var footer_y =
    328;


// ====================================================
// CRT CLOCK
// ====================================================

if (!variable_instance_exists(id, "crt_time"))
{
    crt_time = 0;
}

crt_time++;


// ====================================================
// POST-SIGNAL UI REVEAL
//
// The background feed is revealed immediately when the
// static clears. The JumpBot logo then comes online first,
// followed shortly afterwards by the menu/UI text.
// ====================================================

var reveal_logo_alpha = 1;
var reveal_ui_alpha = 1;

if (
    variable_instance_exists(id, "menu_signal_intro_timer")
)
{
    // Static finishes at frame 34.
    // Logo: frames 35-50.
    // UI:   frames 41-58.
    reveal_logo_alpha =
        clamp(
            (menu_signal_intro_timer - 34) / 16,
            0,
            1
        );

    reveal_ui_alpha =
        clamp(
            (menu_signal_intro_timer - 40) / 18,
            0,
            1
        );

    // Once the acquisition sequence has finished, keep
    // advancing the reveal timer locally until both are
    // fully visible.
    if (!menu_signal_intro_active)
    {
        if (!variable_instance_exists(id, "menu_reveal_timer"))
        {
            menu_reveal_timer = menu_signal_intro_timer;
        }

        if (menu_reveal_timer < 58)
        {
            menu_reveal_timer++;
        }

        reveal_logo_alpha =
            clamp(
                (menu_reveal_timer - 34) / 16,
                0,
                1
            );

        reveal_ui_alpha =
            clamp(
                (menu_reveal_timer - 40) / 18,
                0,
                1
            );
    }
}


// ====================================================
// PHOSPHOR CONTENT BRIGHTNESS
//
// The menu content has its own slight instability,
// separate from the black CRT flicker overlay.
//
// Two slow waves prevent it from looking like a clean,
// obvious sine-wave pulse.
// ====================================================

var phosphor_wave =
    (
        sin(crt_time * 0.031) * 0.62 +
        sin(crt_time * 0.013 + 1.7) * 0.38
    );


crt_phosphor_level =
    clamp(
        0.965 +
        phosphor_wave * 0.022,
        crt_phosphor_min,
        1
    );


var logo_wave =
    (
        sin(crt_time * 0.026 + 0.4) * 0.58 +
        sin(crt_time * 0.009 + 2.1) * 0.42
    );


crt_phosphor_logo_level =
    clamp(
        0.945 +
        logo_wave * 0.038,
        crt_phosphor_logo_min,
        1
    );


// ----------------------------------------------------
// RARE ONE-FRAME PHOSPHOR DROPOUT
//
// The physical monitor does not glitch here. Only the
// emitted menu/logo content briefly loses intensity.
// ----------------------------------------------------

crt_dropout_timer--;


if (crt_dropout_timer <= 0)
{
    crt_dropout_frames = 1;

    crt_dropout_timer =
        irandom_range(
            360,
            600
        );
}


var dropout_mul = 1;


if (crt_dropout_frames > 0)
{
    dropout_mul =
        1 -
        crt_dropout_strength;

    crt_dropout_frames--;
}


crt_phosphor_level *=
    dropout_mul;


crt_phosphor_logo_level *=
    dropout_mul;


// Selected markers are allowed to feel fractionally
// hotter than ordinary text, but never fully pulse out.
crt_selection_level =
    clamp(
        crt_phosphor_level +
        0.025 +
        (
            0.5 +
            0.5 *
            sin(crt_time * 0.11)
        )
        *
        0.025,
        0,
        1
    );


// ====================================================
// BACKGROUND DARKENING
// ====================================================

draw_set_alpha(
    0.55
);

draw_set_color(
    c_black
);

draw_rectangle(
    0,
    0,
    gw,
    gh,
    false
);

draw_set_alpha(
    1
);


// ====================================================
// VERY SUBTLE CRT GLASS / PHOSPHOR CAST
//
// This sits behind the UI and inside the monitor opening.
// The bezel is still drawn later in Draw GUI End.
// ====================================================

if (
    variable_instance_exists(id, "crt_enabled") &&
    crt_enabled
)
{
    draw_set_alpha(
        crt_glass_tint_alpha
    );

    draw_set_color(
        crt_glass_tint_color
    );

    draw_rectangle(
        crt_inset_left,
        crt_inset_top,
        gw - crt_inset_right,
        gh - crt_inset_bottom,
        false
    );
}


draw_set_alpha(
    1
);

draw_set_color(
    c_white
);


// ====================================================
// JUMPBOT LOGO + TAGLINE
//
// The artwork is tightly cropped into two sprites.
//
// Main logo:
//     spriteJumpBotLogo
//
// Tagline:
//     spriteJumpBotLogoTagline
//
// The main logo remains mostly stable. The tagline has
// a tiny continuous bob / pendulum sway. Both pieces
// participate in the occasional little JumpBot hop.
// ====================================================

if (!variable_instance_exists(id, "logo_tagline_sprite"))
{
    logo_tagline_sprite =
        asset_get_index(
            "spriteJumpBotLogoTagline"
        );
}

if (!variable_instance_exists(id, "logo_tagline_scale"))
{
    logo_tagline_scale =
        0.15;
}

if (!variable_instance_exists(id, "logo_main_y"))
{
    logo_main_y =
        86;
}

if (!variable_instance_exists(id, "logo_tagline_y"))
{
    logo_tagline_y =
        140;
}

if (!variable_instance_exists(id, "logo_tagline_bob_height"))
{
    logo_tagline_bob_height =
        0.85;
}

if (!variable_instance_exists(id, "logo_tagline_bob_speed"))
{
    logo_tagline_bob_speed =
        0.017;
}

if (!variable_instance_exists(id, "logo_tagline_sway_degrees"))
{
    logo_tagline_sway_degrees =
        0.28;
}

if (!variable_instance_exists(id, "logo_tagline_sway_speed"))
{
    logo_tagline_sway_speed =
        0.014;
}


// ----------------------------------------------------
// BASE TRANSFORMS
// ----------------------------------------------------

var logo_draw_y =
    logo_main_y;

var logo_scale_x =
    logo_scale;

var logo_scale_y =
    logo_scale;


var tagline_draw_y =
    logo_tagline_y;

var tagline_scale_x =
    logo_tagline_scale;

var tagline_scale_y =
    logo_tagline_scale;

var tagline_angle =
    sin(
        logo_anim_time *
        logo_tagline_sway_speed
    )
    *
    logo_tagline_sway_degrees;


// Continuous tiny hanging-sign movement.
tagline_draw_y +=
    sin(
        logo_anim_time *
        logo_tagline_bob_speed
        +
        0.7
    )
    *
    logo_tagline_bob_height;


// ----------------------------------------------------
// ENTRANCE — LOGO BOUNCES / PUNCHES INTO PLACE
//
// The CRT reveal now feels like the logo jumps toward
// the screen:
//
// 1. starts small and faint
// 2. rapidly grows past full size
// 3. rebounds slightly under full size
// 4. settles at 100%
//
// The tagline follows a couple of frames behind so it
// feels attached rather than perfectly rigid.
// ----------------------------------------------------

if (
    logo_entrance_timer <
    logo_entrance_duration
)
{
    var entrance_p =
        clamp(
            logo_entrance_timer /
            max(
                1,
                logo_entrance_duration
            ),
            0,
            1
        );


    // Main logo: piecewise spring scale.
    var main_mult = 1;

    if (entrance_p < 0.58)
    {
        var p1 =
            entrance_p /
            0.58;

        p1 =
            1 -
            power(
                1 - p1,
                3
            );

        main_mult =
            lerp(
                0.60,
                1.075,
                p1
            );
    }
    else if (entrance_p < 0.80)
    {
        var p2 =
            (
                entrance_p -
                0.58
            )
            /
            0.22;

        p2 =
            0.5 -
            0.5 *
            cos(
                p2 *
                pi
            );

        main_mult =
            lerp(
                1.075,
                0.982,
                p2
            );
    }
    else
    {
        var p3 =
            (
                entrance_p -
                0.80
            )
            /
            0.20;

        p3 =
            0.5 -
            0.5 *
            cos(
                p3 *
                pi
            );

        main_mult =
            lerp(
                0.982,
                1.0,
                p3
            );
    }


    logo_scale_x *=
        main_mult;

    logo_scale_y *=
        main_mult;


    // Small vertical lift as the logo grows toward us.
    // It begins slightly low, pops a touch high, then
    // lands on logo_main_y.
    var entrance_y = 0;

    if (entrance_p < 0.58)
    {
        var yp1 =
            entrance_p /
            0.58;

        yp1 =
            1 -
            power(
                1 - yp1,
                3
            );

        entrance_y =
            lerp(
                5.0,
                -2.0,
                yp1
            );
    }
    else
    {
        var yp2 =
            (
                entrance_p -
                0.58
            )
            /
            0.42;

        yp2 =
            0.5 -
            0.5 *
            cos(
                yp2 *
                pi
            );

        entrance_y =
            lerp(
                -2.0,
                0,
                yp2
            );
    }

    logo_draw_y +=
        entrance_y;


    // ---------------------------------------------
    // TAGLINE FOLLOW-THROUGH
    //
    // Roughly 2 frames behind the main logo.
    // ---------------------------------------------

    var tagline_delay =
        2 /
        max(
            1,
            logo_entrance_duration
        );

    var tagline_p =
        clamp(
            (
                entrance_p -
                tagline_delay
            )
            /
            max(
                0.001,
                1 - tagline_delay
            ),
            0,
            1
        );

    var tagline_mult = 0.60;

    if (tagline_p < 0.58)
    {
        var tp1 =
            tagline_p /
            0.58;

        tp1 =
            1 -
            power(
                1 - tp1,
                3
            );

        tagline_mult =
            lerp(
                0.60,
                1.065,
                tp1
            );
    }
    else if (tagline_p < 0.80)
    {
        var tp2 =
            (
                tagline_p -
                0.58
            )
            /
            0.22;

        tp2 =
            0.5 -
            0.5 *
            cos(
                tp2 *
                pi
            );

        tagline_mult =
            lerp(
                1.065,
                0.987,
                tp2
            );
    }
    else
    {
        var tp3 =
            (
                tagline_p -
                0.80
            )
            /
            0.20;

        tp3 =
            0.5 -
            0.5 *
            cos(
                tp3 *
                pi
            );

        tagline_mult =
            lerp(
                0.987,
                1.0,
                tp3
            );
    }


    tagline_scale_x *=
        tagline_mult;

    tagline_scale_y *=
        tagline_mult;


    // Tagline travels with the logo but has a tiny
    // delayed vertical settle of its own.
    tagline_draw_y +=
        entrance_y;

    if (tagline_p > 0)
    {
        var tagline_follow =
            sin(
                tagline_p *
                pi *
                2.0
            )
            *
            (1 - tagline_p);

        tagline_draw_y +=
            tagline_follow *
            1.25;

        tagline_angle +=
            tagline_follow *
            0.45;
    }
}


// ----------------------------------------------------
// OCCASIONAL WHOLE-LOGO HOP
//
// Shorter and more decisive:
//
// 1. quick pre-jump squash
// 2. sharp 4-5 px pop upward
// 3. fast fall
// 4. tiny landing squash
//
// The tagline travels with the main sign during the
// actual jump. Its independent reaction happens mainly
// AFTER impact, making it feel attached / hanging.
// ----------------------------------------------------

if (logo_hop_active)
{
    var hop_p =
        clamp(
            logo_hop_frame /
            max(
                1,
                logo_hop_duration
            ),
            0,
            1
        );


    // ---------------------------------------------
    // PRE-JUMP SQUASH
    // ---------------------------------------------

    if (hop_p < 0.16)
    {
        var squash_p =
            sin(
                (
                    hop_p /
                    0.16
                )
                *
                pi
            );


        logo_scale_x *=
            1 +
            0.022 *
            squash_p;


        logo_scale_y *=
            1 -
            0.032 *
            squash_p;


        tagline_scale_x *=
            1 +
            0.016 *
            squash_p;


        tagline_scale_y *=
            1 -
            0.022 *
            squash_p;
    }


    // ---------------------------------------------
    // SHARP JUMP ARC
    //
    // Nothing moves vertically during the initial
    // squash. The rise then happens quickly and the
    // logo returns firmly to its resting position.
    // ---------------------------------------------

    var jump_p =
        clamp(
            (
                hop_p -
                0.12
            )
            /
            0.60,
            0,
            1
        );


    var hop_arch =
        sin(
            jump_p *
            pi
        );


    // Slightly bias the sine arc so lift-off feels
    // snappier rather than floaty.
    hop_arch =
        power(
            max(
                0,
                hop_arch
            ),
            0.72
        );


    var hop_y =
        -4.7 *
        hop_arch;


    logo_draw_y +=
        hop_y;


    // During the actual jump the tagline stays attached.
    tagline_draw_y +=
        hop_y;


    // Tiny stretch around the airborne peak.
    var stretch_amount =
        hop_arch *
        0.010;


    logo_scale_x *=
        1 -
        stretch_amount *
        0.45;


    logo_scale_y *=
        1 +
        stretch_amount;


    tagline_scale_x *=
        1 -
        stretch_amount *
        0.35;


    tagline_scale_y *=
        1 +
        stretch_amount *
        0.70;


    // ---------------------------------------------
    // LANDING IMPACT
    // ---------------------------------------------

    if (
        hop_p >= 0.68 &&
        hop_p < 0.82
    )
    {
        var land_p =
            (
                hop_p -
                0.68
            )
            /
            0.14;


        var land_squash =
            sin(
                land_p *
                pi
            );


        logo_scale_x *=
            1 +
            0.014 *
            land_squash;


        logo_scale_y *=
            1 -
            0.020 *
            land_squash;
    }


    // ---------------------------------------------
    // TAGLINE FOLLOW-THROUGH
    //
    // The independent motion is concentrated after
    // landing: it dips, rebounds and swings once with
    // rapid damping.
    // ---------------------------------------------

    if (hop_p >= 0.68)
    {
        var reaction_p =
            clamp(
                (
                    hop_p -
                    0.68
                )
                /
                0.32,
                0,
                1
            );


        var reaction_decay =
            1 -
            reaction_p;


        var reaction_wave =
            sin(
                reaction_p *
                pi *
                2.15
            )
            *
            reaction_decay;


        // Starts by moving downward after impact.
        tagline_draw_y +=
            2.1 *
            sin(
                reaction_p *
                pi
            )
            *
            reaction_decay;


        tagline_angle +=
            reaction_wave *
            1.05;
    }
}


// ----------------------------------------------------
// DRAW MAIN LOGO
// ----------------------------------------------------

if (logo_sprite != -1)
{
    draw_sprite_ext(
        logo_sprite,
        0,
        cx,
        logo_draw_y,
        logo_scale_x,
        logo_scale_y,
        0,
        c_white,
        crt_phosphor_logo_level *
        reveal_logo_alpha
    );
}


// ----------------------------------------------------
// DRAW TAGLINE
// ----------------------------------------------------

if (logo_tagline_sprite != -1)
{
    draw_sprite_ext(
        logo_tagline_sprite,
        0,
        cx,
        tagline_draw_y,
        tagline_scale_x,
        tagline_scale_y,
        tagline_angle,
        c_white,
        crt_phosphor_logo_level *
        reveal_logo_alpha
    );
}


// All text below inherits the shared phosphor level
// unless a selected marker temporarily overrides it.
draw_set_alpha(
    crt_phosphor_level * reveal_ui_alpha
);


// ====================================================
// MAIN MENU
// ====================================================

if (menu_mode == "main")
{
    draw_set_font(
        PIXELOPERATORBOLD18
    );

    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_middle
    );


    var yy =
        185;

    var line_gap =
        36;


    for (
        var i = 0;
        i < array_length(menu_items);
        i++
    )
    {
        var txt =
            string(
                menu_items[i]
            );


        var is_sel =
            i == selected_index;


        draw_set_color(
            is_sel
            ? make_color_rgb(
                255,
                220,
                80
            )
            : make_color_rgb(
                200,
                200,
                200
            )
        );


        draw_text(
            cx,
            round(yy),
            txt
        );


        if (is_sel)
        {
            var tw =
                string_width(
                    txt
                );


            draw_set_halign(
                fa_left
            );


            draw_set_color(
                make_color_rgb(
                    255,
                    235,
                    110
                )
            );


            draw_set_alpha(
                crt_selection_level * reveal_ui_alpha
            );


            draw_text(
                round(
                    cx -
                    tw * 0.5 -
                    26
                ),
                round(yy),
                ">"
            );


            draw_set_alpha(
                crt_phosphor_level * reveal_ui_alpha
            );


            draw_set_halign(
                fa_center
            );
        }


        yy +=
            line_gap;
    }


    // =================================================
    // DYNAMIC CONFIRM PROMPT
    // =================================================

    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_valign(
        fa_middle
    );


    var prompt_y =
        footer_y;


    var prompt_right =
        gw -
        footer_side_inset;


    var prompt_gap =
        6;


    var prompt_scale =
        0.75;


    var prompt_text =
        "SELECT";


    draw_set_color(
        make_color_rgb(
            140,
            150,
            160
        )
    );


    var prompt_text_w =
        string_width(
            prompt_text
        );


    var prompt_icon_slot_w =
        34;


    var prompt_total_w =
        prompt_icon_slot_w +
        prompt_gap +
        prompt_text_w;


    var prompt_left =
        prompt_right -
        prompt_total_w;


    if (instance_exists(oInputPromptController))
    {
        var ipc =
            instance_find(
                oInputPromptController,
                0
            );


        if (ipc != noone)
        {
            var icon_x =
                prompt_left +
                prompt_icon_slot_w * 0.5;


            ipc.draw_prompt(
                "confirm",
                round(icon_x),
                round(prompt_y),
                prompt_scale,
                crt_phosphor_level * reveal_ui_alpha
            );
        }
    }


    draw_set_halign(
        fa_left
    );


    draw_set_color(
        make_color_rgb(
            140,
            150,
            160
        )
    );


    draw_text(
        round(
            prompt_left +
            prompt_icon_slot_w +
            prompt_gap
        ),
        round(prompt_y),
        prompt_text
    );
}


// ====================================================
// SAVE SLOT SELECT
// ====================================================

else if (
    menu_mode == "new_slot_select" ||
    menu_mode == "continue_slot_select"
)
{
    var is_continue =
        menu_mode ==
        "continue_slot_select";


    draw_set_font(
        PIXELOPERATORBOLD18
    );

    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_middle
    );

    draw_set_color(
        make_color_rgb(
            230,
            235,
            235
        )
    );


    draw_text(
        cx,
        170,
        is_continue
        ? "LOAD SAVE SLOT"
        : "SELECT SAVE SLOT"
    );


    draw_set_font(
        PIXELOPERATORBOLD14
    );


    var yy =
        210;

    var line_gap =
        26;


    for (
        var i = 0;
        i < array_length(slot_items);
        i++
    )
    {
        var is_sel =
            is_continue
            ? i == continue_slot_index
            : i == slot_index;


        var txt =
            "";

        var disabled =
            false;


        if (i < 3)
        {
            var slot_num =
                i + 1;


            if (scr_save_exists(slot_num))
            {
                var chip_count =
                    scr_save_get_chip_count(
                        slot_num
                    );


                txt =
                    "SLOT " +
                    string(slot_num) +
                    "  -  CHIPS " +
                    string(chip_count) +
                    " / " +
                    string(global.chips_total);
            }
            else
            {
                txt =
                    "SLOT " +
                    string(slot_num) +
                    "  -  EMPTY";


                if (is_continue)
                {
                    disabled =
                        true;
                }
            }
        }
        else
        {
            txt =
                "BACK";
        }


        var col;


        if (disabled)
        {
            col =
                make_color_rgb(
                    95,
                    100,
                    105
                );
        }
        else if (is_sel)
        {
            col =
                make_color_rgb(
                    255,
                    220,
                    80
                );
        }
        else
        {
            col =
                make_color_rgb(
                    200,
                    200,
                    200
                );
        }


        draw_set_color(
            col
        );


        draw_text(
            cx,
            yy,
            txt
        );


        if (is_sel)
        {
            var tw =
                string_width(
                    txt
                );


            draw_set_halign(
                fa_left
            );


            draw_set_color(
                make_color_rgb(
                    255,
                    235,
                    110
                )
            );


            draw_set_alpha(
                crt_selection_level * reveal_ui_alpha
            );


            draw_text(
                round(
                    cx -
                    tw * 0.5 -
                    24
                ),
                yy,
                ">"
            );


            draw_set_alpha(
                crt_phosphor_level * reveal_ui_alpha
            );


            draw_set_halign(
                fa_center
            );
        }


        yy +=
            line_gap;
    }


    // =================================================
    // DYNAMIC BACK PROMPT
    // =================================================

    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_valign(
        fa_middle
    );


    var prompt_y =
        footer_y;


    var prompt_right =
        gw -
        footer_side_inset;


    var prompt_gap =
        6;


    var prompt_scale =
        0.75;


    var prompt_text =
        "BACK";


    var prompt_text_w =
        string_width(
            prompt_text
        );


    var prompt_icon_slot_w =
        34;


    var prompt_total_w =
        prompt_icon_slot_w +
        prompt_gap +
        prompt_text_w;


    var prompt_left =
        prompt_right -
        prompt_total_w;


    if (instance_exists(oInputPromptController))
    {
        var ipc =
            instance_find(
                oInputPromptController,
                0
            );


        if (ipc != noone)
        {
            var icon_x =
                prompt_left +
                prompt_icon_slot_w * 0.5;


            ipc.draw_prompt(
                "back",
                round(icon_x),
                round(prompt_y),
                prompt_scale,
                crt_phosphor_level * reveal_ui_alpha
            );
        }
    }


    draw_set_halign(
        fa_left
    );


    draw_set_color(
        make_color_rgb(
            140,
            150,
            160
        )
    );


    draw_text(
        round(
            prompt_left +
            prompt_icon_slot_w +
            prompt_gap
        ),
        round(prompt_y),
        prompt_text
    );
}


// ====================================================
// OVERWRITE CONFIRM
// ====================================================

else if (
    menu_mode ==
    "overwrite_confirm"
)
{
    draw_set_font(
        PIXELOPERATORBOLD18
    );

    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_middle
    );

    draw_set_color(
        make_color_rgb(
            255,
            220,
            80
        )
    );


    draw_text(
        cx,
        170,
        "OVERWRITE SLOT " +
        string(pending_new_slot) +
        "?"
    );


    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_color(
        make_color_rgb(
            200,
            200,
            200
        )
    );


    draw_text(
        cx,
        198,
        "Existing progress will be lost."
    );


    draw_set_font(
        PIXELOPERATORBOLD18
    );


    var yy =
        240;

    var line_gap =
        32;


    for (
        var i = 0;
        i < array_length(overwrite_items);
        i++
    )
    {
        var txt =
            overwrite_items[i];


        var is_sel =
            i == overwrite_index;


        draw_set_color(
            is_sel
            ? make_color_rgb(
                255,
                220,
                80
            )
            : make_color_rgb(
                200,
                200,
                200
            )
        );


        draw_text(
            cx,
            yy,
            txt
        );


        if (is_sel)
        {
            var tw =
                string_width(
                    txt
                );


            draw_set_halign(
                fa_left
            );


            draw_set_color(
                make_color_rgb(
                    255,
                    235,
                    110
                )
            );


            draw_set_alpha(
                crt_selection_level * reveal_ui_alpha
            );


            draw_text(
                round(
                    cx -
                    tw * 0.5 -
                    24
                ),
                yy,
                ">"
            );


            draw_set_alpha(
                crt_phosphor_level * reveal_ui_alpha
            );


            draw_set_halign(
                fa_center
            );
        }


        yy +=
            line_gap;
    }


    // =================================================
    // DYNAMIC BACK PROMPT
    // =================================================

    draw_set_font(
        PIXELOPERATORREGULAR10
    );

    draw_set_valign(
        fa_middle
    );


    var prompt_y =
        footer_y;


    var prompt_right =
        gw -
        footer_side_inset;


    var prompt_gap =
        6;


    var prompt_scale =
        0.75;


    var prompt_text =
        "BACK";


    var prompt_text_w =
        string_width(
            prompt_text
        );


    var prompt_icon_slot_w =
        34;


    var prompt_total_w =
        prompt_icon_slot_w +
        prompt_gap +
        prompt_text_w;


    var prompt_left =
        prompt_right -
        prompt_total_w;


    if (instance_exists(oInputPromptController))
    {
        var ipc =
            instance_find(
                oInputPromptController,
                0
            );


        if (ipc != noone)
        {
            var icon_x =
                prompt_left +
                prompt_icon_slot_w * 0.5;


            ipc.draw_prompt(
                "back",
                round(icon_x),
                round(prompt_y),
                prompt_scale,
                crt_phosphor_level * reveal_ui_alpha
            );
        }
    }


    draw_set_halign(
        fa_left
    );


    draw_set_color(
        make_color_rgb(
            140,
            150,
            160
        )
    );


    draw_text(
        round(
            prompt_left +
            prompt_icon_slot_w +
            prompt_gap
        ),
        round(prompt_y),
        prompt_text
    );
}


// ====================================================
// SETTINGS
// ====================================================

else if (
    menu_mode ==
    "settings"
)
{
    draw_set_font(
        PIXELOPERATORBOLD18
    );

    draw_set_halign(
        fa_center
    );

    draw_set_valign(
        fa_middle
    );

    draw_set_color(
        make_color_rgb(
            230,
            235,
            235
        )
    );


    draw_text(
        cx,
        170,
        "SYSTEM SETTINGS"
    );


    var spr_left =
        asset_get_index(
            "spritePauseUILeftNavigator"
        );


    var spr_right =
        asset_get_index(
            "spritePauseUIRightNavigator"
        );


    var spr_bar =
        asset_get_index(
            "spritePauseUIEmptyDialBox"
        );


    var spr_dial =
        asset_get_index(
            "spritePauseUIDial"
        );


    var widget_scale =
        0.62;


    var arrow_scale =
        widget_scale * 0.5;


    draw_set_font(
        PIXELOPERATORREGULAR10
    );


    draw_set_halign(
        fa_left
    );


    draw_set_valign(
        fa_middle
    );


    var label_x =
        180;


    var value_x =
        390;


    var yy =
        188;


    var gap =
        16;


    for (
        var i = 0;
        i < array_length(settings_items);
        i++
    )
    {
        var item =
            settings_items[i];


        var is_sel =
            i == settings_index;


        var disabled =
            item == "resolution" &&
            !scr_settings_resolution_enabled();


        var col_text;


        if (disabled)
        {
            col_text =
                make_color_rgb(
                    95,
                    100,
                    105
                );
        }
        else if (is_sel)
        {
            col_text =
                make_color_rgb(
                    255,
                    220,
                    80
                );
        }
        else
        {
            col_text =
                make_color_rgb(
                    200,
                    200,
                    200
                );
        }


        draw_set_color(
            col_text
        );


        var label =
            scr_settings_label(
                item
            );


        if (is_sel)
        {
            draw_set_color(
                make_color_rgb(
                    255,
                    235,
                    110
                )
            );


            draw_set_alpha(
                crt_selection_level * reveal_ui_alpha
            );


            draw_text(
                label_x - 16,
                yy,
                ">"
            );


            draw_set_alpha(
                crt_phosphor_level * reveal_ui_alpha
            );


            draw_set_color(
                col_text
            );
        }


        draw_text(
            label_x,
            yy,
            label
        );


        // ---------------------------------------------
        // SLIDERS
        // ---------------------------------------------

        if (
            item == "master_volume" ||
            item == "atmosphere_volume" ||
            item == "music_volume" ||
            item == "sfx_volume" ||
            item == "brightness" ||
            item == "contrast"
        )
        {
            var val =
                scr_settings_value01(
                    item
                );


            var bx =
                value_x;


            var by =
                yy;


            var bar_w =
                70;


            var bar_h =
                8;


            if (spr_bar != -1)
            {
                bar_w =
                    sprite_get_width(
                        spr_bar
                    )
                    *
                    widget_scale;


                bar_h =
                    sprite_get_height(
                        spr_bar
                    )
                    *
                    widget_scale;


                draw_sprite_ext(
                    spr_bar,
                    0,
                    bx,
                    by - bar_h * 0.5,
                    widget_scale,
                    widget_scale,
                    0,
                    c_white,
                    crt_phosphor_level * reveal_ui_alpha
                );
            }


            var dial_x =
                bx +
                round(
                    bar_w *
                    val
                );


            if (spr_dial != -1)
            {
                draw_sprite_ext(
                    spr_dial,
                    0,
                    dial_x,
                    by,
                    widget_scale,
                    widget_scale,
                    0,
                    c_white,
                    crt_phosphor_level * reveal_ui_alpha
                );
            }
        }


        // ---------------------------------------------
        // CYCLING SETTINGS
        // ---------------------------------------------

        if (
            item == "display_mode" ||
            item == "resolution"
        )
        {
            draw_set_halign(
                fa_center
            );


            draw_set_color(
                col_text
            );


            var out_txt =
                "";


            if (item == "display_mode")
            {
                out_txt =
                    global.display_mode_labels[
                        global.display_mode_index
                    ];
            }
            else
            {
                out_txt =
                    global.resolution_labels[
                        global.resolution_index
                    ];
            }


            var tx =
                value_x + 70;


            var lx =
                tx - 62;


            var rx =
                tx + 62;


            var arrow_col =
                disabled
                ? make_color_rgb(
                    80,
                    85,
                    90
                )
                : c_white;


            if (spr_left != -1)
            {
                draw_sprite_ext(
                    spr_left,
                    0,
                    lx,
                    yy,
                    arrow_scale,
                    arrow_scale,
                    0,
                    arrow_col,
                    crt_phosphor_level * reveal_ui_alpha
                );
            }


            draw_text(
                tx,
                yy,
                out_txt
            );


            if (spr_right != -1)
            {
                draw_sprite_ext(
                    spr_right,
                    0,
                    rx,
                    yy,
                    arrow_scale,
                    arrow_scale,
                    0,
                    arrow_col,
                    crt_phosphor_level * reveal_ui_alpha
                );
            }


            draw_set_halign(
                fa_left
            );
        }


        yy +=
            gap;
    }


    // =================================================
    // DYNAMIC CHANGE PROMPT
    // =================================================

    draw_set_font(
        PIXELOPERATORREGULAR10
    );


    draw_set_valign(
        fa_middle
    );


    var prompt_y =
        footer_y;


    var prompt_right =
        gw -
        footer_side_inset;


    var prompt_scale =
        0.75;


    var icon_gap =
        4;


    var text_gap =
        6;


    var prompt_text =
        "CHANGE";


    var prompt_text_w =
        string_width(
            prompt_text
        );


    var icon_slot_w =
        20;


    var icons_w =
        icon_slot_w * 2 +
        icon_gap;


    var prompt_total_w =
        icons_w +
        text_gap +
        prompt_text_w;


    var prompt_left =
        prompt_right -
        prompt_total_w;


    if (instance_exists(oInputPromptController))
    {
        var ipc =
            instance_find(
                oInputPromptController,
                0
            );


        if (ipc != noone)
        {
            var left_icon_x =
                prompt_left +
                icon_slot_w * 0.5;


            var right_icon_x =
                prompt_left +
                icon_slot_w +
                icon_gap +
                icon_slot_w * 0.5;


            if (ipc.using_keyboard())
            {
                var frame_a =
                    ipc.get_letter_frame(
                        "A"
                    );


                var frame_d =
                    ipc.get_letter_frame(
                        "D"
                    );


                if (frame_a >= 0)
                {
                    ipc.draw_keyboard_all(
                        frame_a,
                        round(left_icon_x),
                        round(prompt_y),
                        prompt_scale,
                        crt_phosphor_level * reveal_ui_alpha
                    );
                }


                if (frame_d >= 0)
                {
                    ipc.draw_keyboard_all(
                        frame_d,
                        round(right_icon_x),
                        round(prompt_y),
                        prompt_scale,
                        crt_phosphor_level * reveal_ui_alpha
                    );
                }
            }
            else
            {
                ipc.draw_controller_sprite(
                    ipc.spr_controller_left,
                    round(left_icon_x),
                    round(prompt_y),
                    prompt_scale,
                    crt_phosphor_level * reveal_ui_alpha
                );


                ipc.draw_controller_sprite(
                    ipc.spr_controller_right,
                    round(right_icon_x),
                    round(prompt_y),
                    prompt_scale,
                    crt_phosphor_level * reveal_ui_alpha
                );
            }
        }
    }


    var change_text_x =
        prompt_left +
        icons_w +
        text_gap;


    draw_set_halign(
        fa_left
    );


    draw_set_color(
        make_color_rgb(
            140,
            150,
            160
        )
    );


    draw_text(
        round(change_text_x),
        round(prompt_y),
        prompt_text
    );
}


// ====================================================
// VERSION NUMBER
//
// Exact same Y centre as the prompt on the right.
// ====================================================

draw_set_font(
    PIXELOPERATORREGULAR10
);


draw_set_halign(
    fa_left
);


draw_set_valign(
    fa_middle
);


draw_set_color(
    make_color_rgb(
        140,
        150,
        160
    )
);


draw_text(
    footer_side_inset,
    footer_y,
    "v1.0.0"
);


// Content modulation ends here. CRT overlays below use
// their own explicit alpha values.
draw_set_alpha(
    1
);


// ============================================================================
// CRT DISPLAY OVERLAY
// ============================================================================

if (
    variable_instance_exists(id, "crt_enabled") &&
    crt_enabled
)
{
    var sx1 =
        crt_inset_left;


    var sy1 =
        crt_inset_top;


    var sx2 =
        gw -
        crt_inset_right;


    var sy2 =
        gh -
        crt_inset_bottom;


    var cut =
        max(
            0,
            round(
                crt_corner_cut
            )
        );


    // =================================================
    // FLICKER
    // =================================================

    var flicker_wave =
        (
            sin(crt_time * 0.21) +
            sin(crt_time * 0.073)
        )
        *
        0.5;


    var flicker_amount =
        crt_flicker_alpha *
        (
            0.45 +
            0.55 *
            abs(flicker_wave)
        );


    draw_set_alpha(
        flicker_amount
    );


    draw_set_color(
        c_black
    );


    draw_rectangle(
        sx1,
        sy1,
        sx2,
        sy2,
        false
    );


    // =================================================
    // CHAMFERED SCANLINES
    // =================================================

    var scan_gap =
        max(
            2,
            round(
                crt_scan_gap
            )
        );


    var scan_offset =
        floor(
            crt_time *
            crt_scan_drift
        )
        mod
        scan_gap;


    draw_set_alpha(
        crt_scan_alpha
    );


    draw_set_color(
        c_black
    );


    for (
        var scan_y =
            sy1 +
            scan_offset;

        scan_y <
            sy2;

        scan_y +=
            scan_gap
    )
    {
        var line_left =
            sx1;


        var line_right =
            sx2;


        // ---------------------------------------------
        // TOP CHAMFER
        // ---------------------------------------------

        if (
            cut > 0 &&
            scan_y <
            sy1 + cut
        )
        {
            var top_progress =
                scan_y -
                sy1;


            var top_inset =
                cut -
                top_progress;


            line_left +=
                top_inset;


            line_right -=
                top_inset;
        }


        // ---------------------------------------------
        // BOTTOM CHAMFER
        // ---------------------------------------------

        else if (
            cut > 0 &&
            scan_y >
            sy2 - cut
        )
        {
            var bottom_progress =
                scan_y -
                (
                    sy2 -
                    cut
                );


            var bottom_inset =
                bottom_progress;


            line_left +=
                bottom_inset;


            line_right -=
                bottom_inset;
        }


        if (line_right > line_left)
        {
            draw_line(
                round(line_left),
                round(scan_y),
                round(line_right),
                round(scan_y)
            );
        }
    }


    // =================================================
    // ROLLING INTERFERENCE BAND
    //
    // Uses its own safe rectangle INSIDE the CRT.
    //
    // This means the band:
    //
    // - first becomes visible below the top bezel
    // - never passes underneath the top frame
    // - disappears before reaching the bottom frame
    // - remains pulled inward from the side borders
    // =================================================

    if (crt_roll_enabled)
    {
        var roll_left =
            sx1 +
            crt_roll_side_inset;


        var roll_right =
            sx2 -
            crt_roll_side_inset;


        var roll_top =
            sy1 +
            crt_roll_top_inset;


        var roll_bottom =
            sy2 -
            crt_roll_bottom_inset;


        var roll_visible_height =
            max(
                1,
                roll_bottom -
                roll_top
            );


        // ------------------------------------------------
        // The band travels ONLY through its safe region.
        //
        // Starting above roll_top lets it enter naturally,
        // but it is clipped mathematically so nothing is
        // ever drawn underneath the frame.
        // ------------------------------------------------

        var roll_range =
            roll_visible_height +
            crt_roll_height;


        var raw_roll_y =
            roll_top -
            crt_roll_height +
            (
                crt_time *
                crt_roll_speed
            )
            mod
            roll_range;


        var band_top =
            max(
                roll_top,
                raw_roll_y
            );


        var band_bottom =
            min(
                roll_bottom,
                raw_roll_y +
                crt_roll_height
            );


        // ------------------------------------------------
        // MAIN LIGHT BAND
        // ------------------------------------------------

        if (band_bottom > band_top)
        {
            draw_set_alpha(
                crt_roll_alpha
            );


            draw_set_color(
                c_white
            );


            draw_rectangle(
                roll_left,
                band_top,
                roll_right,
                band_bottom,
                false
            );
        }


        // ------------------------------------------------
        // DARK TRAILING LINE
        //
        // Only draw it if it is inside the safe screen.
        // ------------------------------------------------

        var trailing_y =
            raw_roll_y +
            crt_roll_height +
            1;


        if (
            trailing_y >=
                roll_top
            &&
            trailing_y <
                roll_bottom
        )
        {
            draw_set_alpha(
                crt_roll_alpha *
                0.75
            );


            draw_set_color(
                c_black
            );


            draw_line(
                roll_left,
                trailing_y,
                roll_right,
                trailing_y
            );
        }
    }


    // =================================================
    // HORIZONTAL SYNC GLITCH
    // =================================================

    if (
        crt_glitch_enabled &&
        crt_glitch_interval > 0
    )
    {
        var glitch_phase =
            crt_time
            mod
            crt_glitch_interval;


        if (
            glitch_phase <
            crt_glitch_frames
        )
        {
            var glitch_y =
                sy1 +
                28 +
                (
                    (
                        floor(
                            crt_time /
                            max(
                                1,
                                crt_glitch_interval
                            )
                        )
                        *
                        97
                    )
                    mod
                    max(
                        1,
                        sy2 -
                        sy1 -
                        56
                    )
                );


            var glitch_h =
                2 +
                floor(glitch_phase)
                mod
                3;


            draw_set_alpha(
                crt_glitch_alpha
            );


            draw_set_color(
                c_black
            );


            draw_rectangle(
                sx1,
                glitch_y,
                sx2,
                min(
                    sy2,
                    glitch_y +
                    glitch_h
                ),
                false
            );


            if (glitch_y - 1 >= sy1)
            {
                draw_set_alpha(
                    crt_glitch_alpha *
                    0.55
                );


                draw_set_color(
                    make_color_rgb(
                        90,
                        220,
                        235
                    )
                );


                draw_line(
                    sx1,
                    glitch_y - 1,
                    sx2,
                    glitch_y - 1
                );
            }


            if (
                glitch_y +
                glitch_h +
                2 <
                sy2
            )
            {
                draw_set_alpha(
                    crt_glitch_alpha *
                    0.28
                );


                draw_set_color(
                    c_white
                );


                draw_line(
                    sx1,
                    glitch_y +
                    glitch_h +
                    2,
                    sx2,
                    glitch_y +
                    glitch_h +
                    2
                );
            }
        }
    }


    // =================================================
    // CRT EDGE DARKENING
    // =================================================

    var edge =
        max(
            1,
            round(
                crt_edge_size
            )
        );


    draw_set_color(
        c_black
    );


    draw_set_alpha(
        crt_edge_alpha
    );


    draw_rectangle(
        sx1 + cut,
        sy1,
        sx2 - cut,
        sy1 + edge,
        false
    );


    draw_rectangle(
        sx1 + cut,
        sy2 - edge,
        sx2 - cut,
        sy2,
        false
    );


    draw_rectangle(
        sx1,
        sy1 + cut,
        sx1 + edge,
        sy2 - cut,
        false
    );


    draw_rectangle(
        sx2 - edge,
        sy1 + cut,
        sx2,
        sy2 - cut,
        false
    );


    draw_set_alpha(
        crt_edge_alpha *
        0.45
    );


    draw_rectangle(
        sx1 + cut,
        sy1 + edge,
        sx2 - cut,
        sy1 + edge + 2,
        false
    );


    draw_rectangle(
        sx1 + cut,
        sy2 - edge - 2,
        sx2 - cut,
        sy2 - edge,
        false
    );
}


// ====================================================
// MAIN MENU SIGNAL ACQUISITION INTRO
//
// Same visual language as the New Game -> terminal
// handoff, but with NO diagnostic text.
//
// The incoming channel is almost entirely black, with
// sparse white/grey fragments, horizontal tears and
// dropout bands. The existing menu sits underneath and
// becomes visible only as the signal locks.
//
// The CRT border is drawn afterwards, so the physical
// monitor itself remains perfectly stationary.
// ====================================================

if (
    variable_instance_exists(
        id,
        "menu_signal_intro_active"
    )
    &&
    menu_signal_intro_active
)
{
    // ------------------------------------------------
    // HOT-RELOAD SAFETY
    // ------------------------------------------------

    if (!variable_instance_exists(id, "menu_signal_intro_timer"))
    {
        menu_signal_intro_timer = 0;
    }

    if (!variable_instance_exists(id, "menu_signal_black_frames"))
    {
        menu_signal_black_frames = 4;
    }

    if (!variable_instance_exists(id, "menu_signal_static_full_end"))
    {
        menu_signal_static_full_end = 22;
    }

    if (!variable_instance_exists(id, "menu_signal_static_fade_end"))
    {
        menu_signal_static_fade_end = 34;
    }

    if (!variable_instance_exists(id, "menu_signal_intro_duration"))
    {
        menu_signal_intro_duration = 40;
    }

    if (!variable_instance_exists(id, "menu_signal_noise_phase"))
    {
        menu_signal_noise_phase = 0;
    }

    if (!variable_instance_exists(id, "menu_signal_lock_y"))
    {
        menu_signal_lock_y = 88;
    }

    if (!variable_instance_exists(id, "menu_signal_lock_h"))
    {
        menu_signal_lock_h = 3;
    }


    var intro_t =
        menu_signal_intro_timer;


    var ix1 =
        crt_inset_left;

    var iy1 =
        crt_inset_top;

    var ix2 =
        gw -
        crt_inset_right;

    var iy2 =
        gh -
        crt_inset_bottom;


    // =================================================
    // STAGE 1 — BLACK / NO SIGNAL
    // =================================================

    if (
        intro_t <=
        menu_signal_black_frames
    )
    {
        draw_set_alpha(1);
        draw_set_color(c_black);


        draw_rectangle(
            ix1,
            iy1,
            ix2,
            iy2,
            false
        );
    }


    // =================================================
    // STAGE 2/3 — BLACK-SCREEN SIGNAL CORRUPTION
    // =================================================

    else if (
        intro_t <=
        menu_signal_static_fade_end
    )
    {
        var static_alpha =
            1;


        // Full-strength corruption first, then the black
        // channel peels away and reveals the actual menu.
        if (
            intro_t >
            menu_signal_static_full_end
        )
        {
            static_alpha =
                1 -
                clamp(
                    (
                        intro_t -
                        menu_signal_static_full_end
                    )
                    /
                    max(
                        1,
                        menu_signal_static_fade_end -
                        menu_signal_static_full_end
                    ),
                    0,
                    1
                );


            static_alpha *=
                static_alpha;
        }


        // ---------------------------------------------
        // BLACK CHANNEL BASE
        // ---------------------------------------------

        draw_set_alpha(
            static_alpha
        );

        draw_set_color(c_black);


        draw_rectangle(
            ix1,
            iy1,
            ix2,
            iy2,
            false
        );


        // ---------------------------------------------
        // SPARSE WHITE / GREY FRAGMENTS
        //
        // Deterministic integer hashes only.
        // No random()/irandom(), so this visual cannot
        // disturb gameplay RNG.
        // ---------------------------------------------

        var sparse_count =
            150;


        for (
            var sn = 0;
            sn < sparse_count;
            sn++
        )
        {
            var sx =
                ix1
                +
                (
                    (
                        sn * 73
                        +
                        menu_signal_noise_phase * 41
                        +
                        sn * sn * 3
                    )
                    mod
                    max(
                        1,
                        ix2 - ix1
                    )
                );


            var sy =
                iy1
                +
                (
                    (
                        sn * 47
                        +
                        menu_signal_noise_phase * 29
                        +
                        sn * sn * 5
                    )
                    mod
                    max(
                        1,
                        iy2 - iy1
                    )
                );


            var sw =
                1
                +
                (
                    (
                        sn * 17
                        +
                        menu_signal_noise_phase * 3
                    )
                    mod
                    13
                );


            var sh =
                1
                +
                (
                    (
                        sn * 11
                        +
                        menu_signal_noise_phase
                    )
                    mod
                    3
                );


            var grain =
                50
                +
                (
                    (
                        sn * 61
                        +
                        menu_signal_noise_phase * 17
                    )
                    mod
                    190
                );


            var fragment_alpha =
                static_alpha
                *
                (
                    0.20
                    +
                    (
                        (
                            sn * 19
                            +
                            menu_signal_noise_phase
                        )
                        mod
                        58
                    )
                    /
                    100
                );


            draw_set_alpha(
                fragment_alpha
            );


            draw_set_color(
                make_color_rgb(
                    grain,
                    grain,
                    grain
                )
            );


            draw_rectangle(
                sx,
                sy,
                min(
                    ix2,
                    sx + sw
                ),
                min(
                    iy2,
                    sy + sh
                ),
                false
            );
        }


        // ---------------------------------------------
        // HORIZONTAL SIGNAL TEARS
        // ---------------------------------------------

        var tear_a =
            sin(
                menu_signal_noise_phase *
                0.83
            );


        var tear_b =
            sin(
                menu_signal_noise_phase *
                1.37
                +
                2.2
            );


        if (tear_a > 0.55)
        {
            var tear_y_a =
                iy1
                +
                (
                    menu_signal_noise_phase *
                    7
                    mod
                    max(
                        1,
                        iy2 - iy1 - 2
                    )
                );


            draw_set_alpha(
                static_alpha *
                0.40
            );


            draw_set_color(
                make_color_rgb(
                    205,
                    205,
                    205
                )
            );


            draw_rectangle(
                ix1,
                tear_y_a,
                ix2,
                min(
                    iy2,
                    tear_y_a + 2
                ),
                false
            );
        }


        if (tear_b > 0.72)
        {
            var tear_y_b =
                iy1
                +
                (
                    menu_signal_noise_phase *
                    11
                    mod
                    max(
                        1,
                        iy2 - iy1 - 3
                    )
                );


            draw_set_alpha(
                static_alpha *
                0.62
            );


            draw_set_color(
                make_color_rgb(
                    235,
                    235,
                    235
                )
            );


            draw_rectangle(
                ix1 + 18,
                tear_y_b,
                ix2 - 24,
                min(
                    iy2,
                    tear_y_b + 1
                ),
                false
            );
        }


        // ---------------------------------------------
        // DARK SIGNAL DROPOUT BAND
        // ---------------------------------------------

        var dropout_signal =
            sin(
                menu_signal_noise_phase *
                0.61
                +
                1.3
            );


        if (dropout_signal > 0.66)
        {
            var dropout_y =
                iy1
                +
                (
                    menu_signal_noise_phase *
                    13
                    mod
                    max(
                        1,
                        iy2 - iy1 - 9
                    )
                );


            draw_set_alpha(
                static_alpha *
                0.88
            );

            draw_set_color(c_black);


            draw_rectangle(
                ix1,
                dropout_y,
                ix2,
                min(
                    iy2,
                    dropout_y + 6
                ),
                false
            );
        }


        // ---------------------------------------------
        // THIN MOVING SIGNAL BREAK
        // ---------------------------------------------

        var break_y =
            iy1
            +
            (
                menu_signal_noise_phase *
                17
                mod
                max(
                    1,
                    iy2 - iy1
                )
            );


        draw_set_alpha(
            static_alpha *
            0.14
        );

        draw_set_color(c_white);


        draw_line(
            ix1,
            break_y,
            ix2,
            break_y
        );


        // ---------------------------------------------
        // BRIEF CHANNEL-SYNC FLASH
        // ---------------------------------------------

        if (
            intro_t >=
            menu_signal_static_full_end - 2
            &&
            intro_t <=
            menu_signal_static_full_end + 2
        )
        {
            var snap_alpha =
                1 -
                abs(
                    intro_t -
                    menu_signal_static_full_end
                )
                /
                3;


            draw_set_alpha(
                static_alpha *
                0.30 *
                snap_alpha
            );

            draw_set_color(c_white);


            draw_rectangle(
                ix1,
                173,
                ix2,
                175,
                false
            );
        }
    }


    // =================================================
    // STAGE 4 — SIGNAL LOCK
    //
    // The black corruption has cleared. One last tiny
    // sync tear crosses the logo area before the feed
    // becomes fully stable.
    // =================================================

    else
    {
        var lock_p =
            clamp(
                (
                    intro_t -
                    menu_signal_static_fade_end
                )
                /
                max(
                    1,
                    menu_signal_intro_duration -
                    menu_signal_static_fade_end
                ),
                0,
                1
            );


        var lock_alpha =
            sin(
                lock_p *
                pi
            );


        if (lock_alpha > 0)
        {
            var lock_shift =
                round(
                    lerp(
                        -7,
                        5,
                        lock_p
                    )
                );


            draw_set_alpha(
                0.20 *
                lock_alpha
            );


            draw_set_color(c_black);


            draw_rectangle(
                ix1,
                menu_signal_lock_y,
                ix2,
                menu_signal_lock_y +
                menu_signal_lock_h,
                false
            );


            draw_set_alpha(
                0.25 *
                lock_alpha
            );


            draw_set_color(
                make_color_rgb(
                    205,
                    225,
                    225
                )
            );


            draw_rectangle(
                max(
                    ix1,
                    ix1 +
                    lock_shift
                ),
                menu_signal_lock_y - 1,
                min(
                    ix2,
                    ix2 +
                    lock_shift
                ),
                menu_signal_lock_y,
                false
            );
        }
    }
}


// ====================================================
// CRT BORDER
// ====================================================

draw_set_alpha(1);
draw_set_color(c_white);

draw_sprite_ext(
    spriteMainMenuBorder,
    0,
    320,
    0,
    1,
    1,
    0,
    c_white,
    1
);


// ====================================================
// RESET DRAW STATE
// ====================================================

draw_set_font(
    -1
);


draw_set_halign(
    fa_left
);


draw_set_valign(
    fa_top
);


draw_set_alpha(
    1
);


draw_set_color(
    c_white
);