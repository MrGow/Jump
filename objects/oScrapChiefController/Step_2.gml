/// oScrapChiefController — End Step

// ====================================================
// CAMERA OVERRIDE
// ====================================================

if (!camera_override_active)
{
    exit;
}

if (!instance_exists(platform))
{
    exit;
}


// ====================================================
// BOSS CAMERA ZOOM
//
// Expand the camera when the boss activates.
// Maintain zoom throughout the encounter.
// Restore normal dimensions during docking.
// ====================================================

var zoom_should_expand =
    boss_active &&
    elevator_state < 10 &&
    !sequence_complete;


// ----------------------------------------------------
// Advance zoom transition
//
// Do not advance during pause or gameplay freeze.
// Screen shake remains independent.
// ----------------------------------------------------

if (!scr_game_frozen())
{
    if (zoom_should_expand)
    {
        var zoom_frames = max(
            1,
            round(
                camera_zoom_out_seconds *
                room_speed
            )
        );

        camera_zoom_progress = min(
            1,
            camera_zoom_progress +
            1 / zoom_frames
        );
    }
    else
    {
        var zoom_frames = max(
            1,
            round(
                camera_zoom_in_seconds *
                room_speed
            )
        );

        camera_zoom_progress = max(
            0,
            camera_zoom_progress -
            1 / zoom_frames
        );
    }
}


// ----------------------------------------------------
// Smoothstep easing
// ----------------------------------------------------

var zoom_t = clamp(
    camera_zoom_progress,
    0,
    1
);

var zoom_eased =
    zoom_t *
    zoom_t *
    (3 - 2 * zoom_t);

camera_zoom_current = lerp(
    1.0,
    camera_boss_zoom,
    zoom_eased
);


// ====================================================
// APPLY CAMERA DIMENSIONS
//
// Preserve exact 16:9 aspect ratio throughout zoom.
// ====================================================

// ====================================================
// SMOOTH CAMERA DIMENSIONS
//
// Allow single-pixel increments rather than
// restricting the camera to 16 x 9 increments.
// ====================================================

var new_view_w = max(
    1,
    round(
        camera_normal_width *
        camera_zoom_current
    )
);

var new_view_h = max(
    1,
    round(
        camera_normal_height *
        camera_zoom_current
    )
);

if (
    new_view_w != view_w ||
    new_view_h != view_h
)
{
    view_w = new_view_w;
    view_h = new_view_h;

    camera_set_view_size(
        cam,
        view_w,
        view_h
    );
}


// ====================================================
// CAMERA EXPANSION
// ====================================================

var extra_width =
    view_w - camera_normal_width;

var extra_height =
    view_h - camera_normal_height;


// ====================================================
// CAMERA TARGET: ELEVATOR CENTRE
//
// The original platform offset was calculated using
// the normal 640px camera width.
//
// Subtract half the additional width to preserve
// horizontal centring during zoom.
// ====================================================

var elevator_target_x =
    platform.x -
    camera_platform_offset_x -
    extra_width * 0.5;

elevator_target_x = clamp(
    elevator_target_x,
    0,
    max(0, room_width - view_w)
);


// ====================================================
// VERTICAL CAMERA POSITION
//
// Always calculate from the original camera position.
// This prevents accumulated vertical drift.
// ====================================================

camera_y =
    camera_base_y -
    extra_height *
    (1 - camera_zoom_vertical_bias);

camera_y = clamp(
    camera_y,
    0,
    max(0, room_height - view_h)
);


// ====================================================
// BEGIN DOCKING HANDOFF
//
// Wait for normal camera dimensions before returning
// control to oCamera.
// ====================================================

if (
    elevator_state == 11 &&
    camera_transition_mode != 2 &&
    camera_zoom_progress <= 0
)
{
    camera_transition_mode = 2;

    camera_transition_frame = 0;

    camera_transition_frames =
        max(
            1,
            round(
                camera_exit_seconds *
                room_speed
            )
        );

    camera_transition_start_x = camera_x;
    camera_transition_start_y = camera_y;
}


// ====================================================
// CAMERA TRANSITION / LOCK
// ====================================================

if (camera_transition_mode == 1)
{
    // --------------------------------------------
    // Smooth transition onto elevator
    // --------------------------------------------

    camera_transition_frame++;

    var t = clamp(
        camera_transition_frame /
        camera_transition_frames,
        0,
        1
    );

    var eased =
        t * t * (3 - 2 * t);

    camera_x = lerp(
        camera_transition_start_x,
        elevator_target_x,
        eased
    );

    if (t >= 1)
    {
        camera_transition_mode = 0;
    }
}
else if (camera_transition_mode == 2)
{
    // --------------------------------------------
    // Smooth transition back towards JumpBot
    // --------------------------------------------

    var player_target_x =
        elevator_target_x;

    var p = instance_find(
        oPlayer,
        0
    );

    if (p != noone)
    {
        player_target_x =
            (p.bbox_left + p.bbox_right) * 0.5 -
            view_w * 0.5;
    }

    player_target_x = clamp(
        player_target_x,
        0,
        max(0, room_width - view_w)
    );


    // --------------------------------------------
    // Smoothstep easing
    // --------------------------------------------

    camera_transition_frame++;

    var t = clamp(
        camera_transition_frame /
        camera_transition_frames,
        0,
        1
    );

    var eased =
        t * t * (3 - 2 * t);

    camera_x = lerp(
        camera_transition_start_x,
        player_target_x,
        eased
    );
}
else
{
    // --------------------------------------------
    // Normal boss encounter camera
    // --------------------------------------------

    camera_x = elevator_target_x;
}


// ====================================================
// ROOM SAFETY
// ====================================================

camera_x = clamp(
    camera_x,
    0,
    max(0, room_width - view_w)
);


// ====================================================
// FINAL PRESENTATION POSITION
//
// Keep logical camera coordinates separate from shake.
// ====================================================

var final_x = camera_x;
var final_y = camera_y;


// ====================================================
// GLOBAL SCREEN SHAKE
//
// The normal camera skips its Step event during the
// Scrap Chief override, so process its shake here.
//
// Intentionally runs during death_delay.
// ====================================================

if (
    variable_global_exists("shake_time") &&
    variable_global_exists("shake_mag")
)
{
    if (
        global.shake_time > 0 &&
        global.shake_mag > 0
    )
    {
        final_x += irandom_range(
            -global.shake_mag,
            global.shake_mag
        );

        final_y += irandom_range(
            -global.shake_mag,
            global.shake_mag
        );

        global.shake_time--;
    }
}


// ====================================================
// CLAMP FINAL PRESENTATION POSITION
// ====================================================

final_x = clamp(
    final_x,
    0,
    max(0, room_width - view_w)
);

final_y = clamp(
    final_y,
    0,
    max(0, room_height - view_h)
);


// ====================================================
// APPLY CAMERA
// ====================================================

camera_set_view_pos(
    cam,
    round(final_x),
    round(final_y)
);


// ====================================================
// SYNCHRONISE NORMAL CAMERA
//
// Synchronise logical position, not shaken position.
// ====================================================

var normal_camera = instance_find(
    oCamera,
    0
);

if (normal_camera != noone)
{
    normal_camera.cam_logic_x =
        round(camera_x);

    normal_camera.cam_logic_y =
        round(camera_y);
}


// ====================================================
// COMPLETE DOCKING HANDOFF
// ====================================================

if (
    camera_transition_mode == 2 &&
    camera_transition_frame >= camera_transition_frames
)
{
    reset_camera_zoom();

    camera_transition_mode = 0;

    camera_override_active = false;

    if (normal_camera != noone)
    {
        normal_camera.arena_lock_active = false;
        normal_camera.arena_was_locked = false;
        normal_camera.arena_release_frames = 0;

        normal_camera.cam_logic_x =
            round(camera_x);

        normal_camera.cam_logic_y =
            round(camera_y);
    }
}