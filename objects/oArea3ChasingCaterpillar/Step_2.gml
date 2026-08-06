/// oArea3ChasingCaterpillar — End Step


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    visual_shake_x = 0;
    visual_shake_y = 0;

    exit;
}


// ====================================================
// FIND UPWARD CHASE CONTROLLER
// ====================================================

var ctrl =
    instance_find(
        oUpwardsChaseController,
        0
    );


// ====================================================
// CALCULATE CAMERA-RELATIVE EDITOR POSITION
// ====================================================

if (
    !screen_offsets_initialized &&
    ctrl != noone
)
{
    screen_offset_x =
        start_x -
        ctrl.start_cam_x;

    screen_offset_y =
        start_y -
        ctrl.start_cam_y;

    screen_offsets_initialized = true;
}


// ====================================================
// ANIMATION SPEED TARGETS
// ====================================================

var target_head_anim_speed =
    burst_active
    ? head_anim_speed_burst
    : head_anim_speed_normal;

var target_body_anim_speed =
    burst_active
    ? body_anim_speed_burst
    : body_anim_speed_normal;


head_anim_speed_current =
    lerp(
        head_anim_speed_current,
        target_head_anim_speed,
        anim_speed_lerp
    );

body_anim_speed_current =
    lerp(
        body_anim_speed_current,
        target_body_anim_speed,
        anim_speed_lerp
    );


// ====================================================
// ADVANCE HEAD ANIMATION
// ====================================================

if (head_sprite != -1)
{
    var head_frame_count =
        max(
            1,
            sprite_get_number(
                head_sprite
            )
        );

    head_anim_position +=
        head_anim_speed_current;

    while (
        head_anim_position >=
        head_frame_count
    )
    {
        head_anim_position -=
            head_frame_count;
    }
}


// ====================================================
// ADVANCE BODY ANIMATION
// ====================================================

if (body_sprite != -1)
{
    var body_frame_count =
        max(
            1,
            sprite_get_number(
                body_sprite
            )
        );

    body_anim_position +=
        body_anim_speed_current;

    while (
        body_anim_position >=
        body_frame_count
    )
    {
        body_anim_position -=
            body_frame_count;
    }
}


// ====================================================
// DETECT BURST START
// ====================================================

var burst_started =
    burst_active &&
    !burst_was_active;


// ====================================================
// CAMERA JOLT AT BURST START
// ====================================================

if (burst_started)
{
    if (!variable_global_exists("shake_mag"))
    {
        global.shake_mag = 0;
    }

    if (!variable_global_exists("shake_time"))
    {
        global.shake_time = 0;
    }

    global.shake_mag =
        max(
            global.shake_mag,
            burst_start_shake_strength
        );

    global.shake_time =
        max(
            global.shake_time,
            burst_start_shake_frames
        );
}


// ====================================================
// CONTINUOUS BURST RUMBLE
// ====================================================

if (burst_active)
{
    if (!variable_global_exists("shake_mag"))
    {
        global.shake_mag = 0;
    }

    if (!variable_global_exists("shake_time"))
    {
        global.shake_time = 0;
    }

    global.shake_mag =
        max(
            global.shake_mag,
            burst_rumble_strength
        );

    global.shake_time =
        max(
            global.shake_time,
            burst_rumble_frames
        );
}


// ====================================================
// BURST VISUAL VIBRATION
// ====================================================

if (burst_active)
{
    visual_shake_x =
        irandom_range(
            -burst_visual_shake_pixels,
            burst_visual_shake_pixels
        );

    visual_shake_y =
        irandom_range(
            -burst_visual_shake_pixels,
            burst_visual_shake_pixels
        );
}
else
{
    visual_shake_x = 0;
    visual_shake_y = 0;
}


// ====================================================
// CHASE MOVEMENT
// ====================================================

if (
    enabled &&
    ctrl != noone &&
    ctrl.chase_active
)
{
    // ------------------------------------------------
    // Burst upward toward player
    // ------------------------------------------------

    if (burst_active)
    {
        burst_offset +=
            burst_speed;

        if (
            burst_offset >=
            burst_target
        )
        {
            burst_offset =
                burst_target;

            burst_active = false;
            burst_speed  = 0;
        }
    }


    // ------------------------------------------------
    // Follow camera while preserving editor placement
    // ------------------------------------------------

    x =
        ctrl.cam_x +
        screen_offset_x;

    y =
        ctrl.cam_y +
        screen_offset_y -
        burst_offset;
}


// ====================================================
// STORE BURST STATE
// ====================================================

burst_was_active =
    burst_active;


// ====================================================
// FIND PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );


if (
    p == noone ||
    (
        variable_instance_exists(
            p,
            "state"
        )
        &&
        p.state == "dead"
    )
)
{
    exit;
}


// ====================================================
// COMPOSITE POSITION
// ====================================================

var composite_x =
    round(
        x +
        visual_shake_x
    );

var composite_y =
    round(
        y +
        visual_shake_y
    );


var player_hit =
    false;


// ====================================================
// HEAD COLLISION
// ====================================================

if (head_sprite != -1)
{
    var head_w =
        sprite_get_width(
            head_sprite
        );

    var head_h =
        sprite_get_height(
            head_sprite
        );


    var head_left =
        composite_x -
        head_w * 0.5 +
        head_draw_offset_x +
        head_collision_inset_left;

    var head_right =
        composite_x +
        head_w * 0.5 +
        head_draw_offset_x -
        head_collision_inset_right;

    var head_top =
        composite_y +
        head_draw_offset_y +
        head_collision_inset_top;

    var head_bottom =
        composite_y +
        head_draw_offset_y +
        head_h -
        head_collision_inset_bottom;


    player_hit =
        p.bbox_right > head_left &&
        p.bbox_left < head_right &&
        p.bbox_bottom > head_top &&
        p.bbox_top < head_bottom;
}


// ====================================================
// BODY COLLISION
// ====================================================

if (
    !player_hit &&
    head_sprite != -1 &&
    body_sprite != -1
)
{
    var head_height =
        sprite_get_height(
            head_sprite
        );

    var body_width =
        sprite_get_width(
            body_sprite
        );

    var body_height =
        sprite_get_height(
            body_sprite
        );


    // Fixed body-to-body spacing.
    var body_step =
        max(
            1,
            body_segment_step
        );


    var body_start_y =
        composite_y +
        head_draw_offset_y +
        head_height +
        body_draw_offset_y;


    for (
        var segment = 0;
        segment < body_segment_count;
        segment++
    )
    {
        var segment_x =
            composite_x +
            body_draw_offset_x;

        var segment_y =
            body_start_y +
            segment *
            body_step;


        var body_left =
            segment_x -
            body_width * 0.5 +
            body_collision_inset_left;

        var body_right =
            segment_x +
            body_width * 0.5 -
            body_collision_inset_right;

        var body_top =
            segment_y +
            body_collision_inset_top;

        var body_bottom =
            segment_y +
            body_height -
            body_collision_inset_bottom;


        if (
            p.bbox_right > body_left &&
            p.bbox_left < body_right &&
            p.bbox_bottom > body_top &&
            p.bbox_top < body_bottom
        )
        {
            player_hit = true;
            break;
        }
    }
}


// ====================================================
// KILL PLAYER
// ====================================================

if (player_hit)
{
    with (p)
    {
        scr_player_died();
    }
}