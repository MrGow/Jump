/// oSavePopup — Step

popup_timer++;


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "save_icon_sprite"))
{
    save_icon_sprite =
        asset_get_index("spriteSaveIcon");
}

if (!variable_instance_exists(id, "save_icon_scale"))
{
    save_icon_scale = 0.65;
}

if (!variable_instance_exists(id, "save_loop_first_frame"))
{
    save_loop_first_frame = 0;
}

if (!variable_instance_exists(id, "save_loop_last_frame"))
{
    save_loop_last_frame = 13;
}

if (!variable_instance_exists(id, "save_complete_frame_1"))
{
    save_complete_frame_1 = 14;
}

if (!variable_instance_exists(id, "save_complete_frame_2"))
{
    save_complete_frame_2 = 15;
}

if (!variable_instance_exists(id, "save_icon_anim_speed"))
{
    save_icon_anim_speed = 0.35;
}

if (!variable_instance_exists(id, "popup_total_frames"))
{
    popup_total_frames =
        round(room_speed * 2.0);
}

if (!variable_instance_exists(id, "saving_frames"))
{
    saving_frames =
        round(room_speed * 1.35);
}

if (!variable_instance_exists(id, "complete_frame_1_frames"))
{
    complete_frame_1_frames =
        round(room_speed * 0.18);
}

if (!variable_instance_exists(id, "fade_frames"))
{
    fade_frames =
        round(room_speed * 0.40);
}

if (!variable_instance_exists(id, "popup_timer"))
{
    popup_timer = 0;
}

if (!variable_instance_exists(id, "alpha"))
{
    alpha = 1;
}


// ====================================================
// ICON ANIMATION
// ====================================================

if (popup_timer < saving_frames)
{
    // Loop only the animated saving frames.
    save_icon_frame +=
        save_icon_anim_speed;

    var loop_length =
        max(
            1,
            save_loop_last_frame -
            save_loop_first_frame +
            1
        );

    if (
        save_icon_frame >=
        save_loop_last_frame + 1
    )
    {
        save_icon_frame =
            save_loop_first_frame +
            (
                (
                    save_icon_frame -
                    save_loop_first_frame
                )
                mod
                loop_length
            );
    }
}
else if (
    popup_timer <
    saving_frames +
    complete_frame_1_frames
)
{
    save_icon_frame =
        save_complete_frame_1;
}
else
{
    save_icon_frame =
        save_complete_frame_2;
}


// ====================================================
// FADE OUT
// ====================================================

var fade_start =
    popup_total_frames -
    fade_frames;

if (popup_timer >= fade_start)
{
    alpha =
        clamp(
            (
                popup_total_frames -
                popup_timer
            )
            /
            max(
                1,
                fade_frames
            ),
            0,
            1
        );
}
else
{
    alpha = 1;
}


// ====================================================
// FINISH
// ====================================================

if (popup_timer >= popup_total_frames)
{
    instance_destroy();
}