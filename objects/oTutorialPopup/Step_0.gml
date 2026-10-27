
/// oTutorialPopup — Step


// ====================================================
// FIRST SPAWN CINEMATIC
//
// Hide the tutorial until JumpBot has completed his
// entrance and the cinematic bars have disappeared.
//
// Outside the first-spawn sequence, the tutorial
// behaves normally.
// ====================================================

var first_spawn_running = false;

if (instance_exists(oFirstSpawn))
{
    var fs = instance_find(oFirstSpawn, 0);

    if (fs != noone)
    {
        first_spawn_running =
            variable_instance_exists(
                fs,
                "started"
            ) &&
            fs.started;
    }
}


// ====================================================
// PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );


// ====================================================
// PLAYER INSIDE TRIGGER
// ====================================================

popup_active =
    false;


if (p != noone && !first_spawn_running)
{
    popup_active =
    (
        p.bbox_right >=
            bbox_left &&

        p.bbox_left <=
            bbox_right &&

        p.bbox_bottom >=
            bbox_top &&

        p.bbox_top <=
            bbox_bottom
    );
}


// ====================================================
// FADE
// ====================================================

var target_alpha =
    popup_active
    ? 1
    : 0;


// Keep the popup completely invisible during
// the cinematic, including its landing and
// black-bar retraction stages.

if (first_spawn_running)
{
    popup_alpha = 0;
}
else
{
    popup_alpha =
        lerp(
            popup_alpha,
            target_alpha,
            fade_speed
        );

    if (
        abs(
            popup_alpha -
            target_alpha
        )
        < 0.01
    )
    {
        popup_alpha =
            target_alpha;
    }
}


// ====================================================
// BOB
// ====================================================

if (popup_alpha > 0.001)
{
    bob_phase +=
        bob_speed;

    if (bob_phase >= pi * 2)
    {
        bob_phase -=
            pi * 2;
    }
}


// ====================================================
// CAMERA-RELATIVE DRAW POSITION
// ====================================================

var cam =
    view_camera[0];


if (cam != -1)
{
    var cam_x =
        camera_get_view_x(
            cam
        );

    var cam_y =
        camera_get_view_y(
            cam
        );

    var cam_w =
        camera_get_view_width(
            cam
        );

    var cam_h =
        camera_get_view_height(
            cam
        );


    popup_draw_x =
        cam_x +
        cam_w *
        popup_screen_x;


    popup_draw_y =
        cam_y +
        cam_h *
        popup_screen_y;
}
