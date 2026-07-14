/// oCamera - Step (unified/final)

if (!instance_exists(target))
{
    var p = instance_find(target_obj, 0);

    if (p != noone)
    {
        target = p;
    }
}

if (!instance_exists(target))
{
    exit;
}


// ----------------------------------------------------
// SPECIAL CHASE CAMERA HANDOVER
//
// Chase rooms own view_camera[0].
// The persistent normal camera must not follow the
// player or apply camera zones in these rooms.
// ----------------------------------------------------
if (
    instance_exists(oHorizontalChaseController) ||
    instance_exists(oVerticalChaseController)   ||
    instance_exists(oUpwardsChaseController)
)
{
    exit;
}


// ----------------------------------------------------
// Compatibility guards
// ----------------------------------------------------
if (!variable_instance_exists(id, "fade_state"))
{
    fade_state = 0;
}

if (!variable_instance_exists(id, "fade_alpha"))
{
    fade_alpha = 0;
}

if (!variable_instance_exists(id, "fade_hold_timer"))
{
    fade_hold_timer = 0;
}

if (!variable_instance_exists(id, "post_fade_settle"))
{
    post_fade_settle = 0;
}

if (!variable_instance_exists(id, "pending_zone"))
{
    pending_zone = noone;
}

if (!variable_instance_exists(id, "active_zone"))
{
    active_zone = noone;
}

if (!variable_instance_exists(id, "transition_guard"))
{
    transition_guard = 0;
}

if (!variable_instance_exists(id, "fade_speed_out"))
{
    fade_speed_out = 0.12;
}

if (!variable_instance_exists(id, "fade_speed_in"))
{
    fade_speed_in = 0.06;
}

if (!variable_instance_exists(id, "fade_speed"))
{
    fade_speed = fade_speed_out;
}

if (!variable_instance_exists(id, "fade_hold_frames"))
{
    fade_hold_frames = 14;
}

if (!variable_instance_exists(id, "post_fade_settle_frames"))
{
    post_fade_settle_frames = 10;
}

if (!variable_instance_exists(id, "settle_frames"))
{
    settle_frames = post_fade_settle_frames;
}

if (!variable_instance_exists(id, "transition_guard_max"))
{
    transition_guard_max = 3;
}

if (!variable_instance_exists(id, "zone_transition_lock_frames"))
{
    zone_transition_lock_frames = transition_guard_max;
}

if (!variable_instance_exists(id, "cam_logic_x"))
{
    cam_logic_x = camera_get_view_x(cam);
}

if (!variable_instance_exists(id, "cam_logic_y"))
{
    cam_logic_y = camera_get_view_y(cam);
}


// ----------------------------------------------------
// Camera dimensions
// ----------------------------------------------------
var vw = camera_get_view_width(cam);
var vh = camera_get_view_height(cam);


// ----------------------------------------------------
// 0) Zone-edge predictive fade trigger
// ----------------------------------------------------
if (zone_fade_enable)
{
    if (fade_state != 0)
    {
        cam_transition_freeze_player();
    }

    // Fading out
    if (fade_state == 1)
    {
        fade_alpha += fade_speed_out;

        if (fade_alpha >= 1)
        {
            fade_alpha = 1;
            fade_state = 2;

            fade_hold_timer =
                max(0, fade_hold_frames);

            // Commit zone switch under black
            if (instance_exists(pending_zone))
            {
                if (debug_cam)
                {
                    show_debug_message(
                        "FADE COMMIT zone -> id=" +
                        string(pending_zone)
                    );
                }

                active_zone = pending_zone;
            }
            else
            {
                if (debug_cam)
                {
                    show_debug_message(
                        "FADE COMMIT but pending_zone was noone"
                    );
                }
            }

            pending_zone = noone;

            // Snap logical camera to new zone
            if (instance_exists(active_zone))
            {
                if (is_callable(active_zone.update_rect))
                {
                    active_zone.update_rect();
                }

                var zl2 = active_zone.left;
                var zt2 = active_zone.top;
                var zr2 = active_zone.right;
                var zb2 = active_zone.bottom;

                cam_logic_x = clamp(
                    round(target.x - vw * 0.5),
                    zl2,
                    zr2 - vw
                );

                cam_logic_y = clamp(
                    round(
                        (target.y + y_bias) -
                        vh * 0.5
                    ),
                    zt2,
                    zb2 - vh
                );
            }

            cam_transition_freeze_player();
        }
    }
    // Hold black
    else if (fade_state == 2)
    {
        cam_transition_freeze_player();

        if (fade_hold_timer > 0)
        {
            fade_hold_timer--;
        }
        else
        {
            fade_state = 3;
        }
    }
    // Fading in
    else if (fade_state == 3)
    {
        cam_transition_freeze_player();

        fade_alpha -= fade_speed_in;

        if (fade_alpha <= 0)
        {
            fade_alpha = 0;
            fade_state = 0;

            post_fade_settle =
                max(0, settle_frames);

            var _lock_frames = 0;

            if (
                variable_instance_exists(
                    id,
                    "zone_transition_lock_frames"
                )
            )
            {
                _lock_frames =
                    zone_transition_lock_frames;
            }
            else if (
                variable_instance_exists(
                    id,
                    "transition_guard_max"
                )
            )
            {
                _lock_frames =
                    transition_guard_max;
            }

            transition_guard =
                max(0, _lock_frames);

            // Release frozen movement
            if (instance_exists(target))
            {
                if (
                    variable_instance_exists(
                        target,
                        "zone_transition_freeze"
                    )
                )
                {
                    target.zone_transition_freeze =
                        false;
                }

                if (
                    variable_instance_exists(
                        target,
                        "hsp"
                    )
                )
                {
                    target.hsp = 0;
                }

                if (
                    variable_instance_exists(
                        target,
                        "vsp"
                    )
                )
                {
                    target.vsp = 0;
                }
            }

            if (debug_cam)
            {
                var _zid =
                    instance_exists(active_zone)
                    ? string(active_zone)
                    : "noone";

                show_debug_message(
                    "FADE END zone=" +
                    _zid +
                    " cam=(" +
                    string(cam_logic_x) +
                    "," +
                    string(cam_logic_y) +
                    ")"
                );
            }
        }
    }
}


// ----------------------------------------------------
// Guard countdown
// ----------------------------------------------------
if (transition_guard > 0)
{
    transition_guard--;
}


// ----------------------------------------------------
// 1) Ensure active zone
// ----------------------------------------------------
if (
    !instance_exists(active_zone) &&
    fade_state == 0
)
{
    active_zone =
        cam_find_zone(
            target.x,
            target.y,
            noone
        );

    if (instance_exists(active_zone))
    {
        if (debug_cam)
        {
            show_debug_message(
                "ZONE INIT -> " +
                string(active_zone)
            );
        }

        post_fade_settle =
            max(0, settle_frames);
    }
}


// ----------------------------------------------------
// 2) Predictive trigger near zone boundary
// ----------------------------------------------------
if (
    fade_state == 0 &&
    zone_fade_enable &&
    instance_exists(active_zone) &&
    transition_guard <= 0
)
{
    if (is_callable(active_zone.update_rect))
    {
        active_zone.update_rect();
    }

    var il =
        active_zone.left +
        zone_fade_margin;

    var it =
        active_zone.top +
        zone_fade_margin;

    var ir =
        active_zone.right -
        zone_fade_margin;

    var ib =
        active_zone.bottom -
        zone_fade_margin;

    if (ir <= il)
    {
        il = active_zone.left;
        ir = active_zone.right;
    }

    if (ib <= it)
    {
        it = active_zone.top;
        ib = active_zone.bottom;
    }

    var px0 = target.x;
    var py0 = target.y + y_bias;

    var in_inner =
        px0 >= il &&
        px0 <= ir &&
        py0 >= it &&
        py0 <= ib;

    if (!in_inner)
    {
        var nz =
            cam_find_zone(
                px0,
                py0,
                active_zone
            );

        if (nz == noone)
        {
            nz =
                cam_find_zone(
                    px0,
                    py0,
                    noone
                );
        }

        if (
            instance_exists(nz) &&
            nz != active_zone
        )
        {
            pending_zone = nz;
            fade_state = 1;

            if (debug_cam)
            {
                show_debug_message(
                    "ZONE FADE START (predictive) -> " +
                    string(nz)
                );
            }
        }
    }
}


// ----------------------------------------------------
// 3) Compute desired camera position
// ----------------------------------------------------
if (!instance_exists(active_zone))
{
    var tx_fb = clamp(
        round(target.x - vw * 0.5),
        0,
        max(0, room_width - vw)
    );

    var ty_fb = clamp(
        round(
            (target.y + y_bias) -
            vh * 0.5
        ),
        0,
        max(0, room_height - vh)
    );

    cam_logic_x = tx_fb;
    cam_logic_y = ty_fb;
}
else
{
    if (is_callable(active_zone.update_rect))
    {
        active_zone.update_rect();
    }

    var zl = active_zone.left;
    var zt = active_zone.top;
    var zr = active_zone.right;
    var zb = active_zone.bottom;

    var px = target.x;
    var py = target.y + y_bias;

    var tx =
        round(px - vw * 0.5);

    var ty =
        round(py - vh * 0.5);

    tx = clamp(
        tx,
        zl,
        zr - vw
    );

    ty = clamp(
        ty,
        zt,
        zb - vh
    );

    var sf = 1.0;

    if (post_fade_settle > 0)
    {
        sf = 0.25;
        post_fade_settle--;
    }

    cam_logic_x =
        round(
            lerp(
                cam_logic_x,
                tx,
                sf
            )
        );

    cam_logic_y =
        round(
            lerp(
                cam_logic_y,
                ty,
                sf
            )
        );
}


var final_x = cam_logic_x;
var final_y = cam_logic_y;


// ----------------------------------------------------
// Death-fall lock override
// ----------------------------------------------------
if (instance_exists(target))
{
    var _fall_dead =
        variable_instance_exists(
            target,
            "death_fall"
        ) &&
        target.death_fall &&
        variable_instance_exists(
            target,
            "death_cam_lock_x"
        ) &&
        variable_instance_exists(
            target,
            "death_cam_lock_y"
        );

    if (_fall_dead)
    {
        final_x =
            target.death_cam_lock_x;

        final_y =
            target.death_cam_lock_y;

        cam_logic_x = final_x;
        cam_logic_y = final_y;
    }
}


// ----------------------------------------------------
// Camera shake
// ----------------------------------------------------
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
        final_x +=
            irandom_range(
                -global.shake_mag,
                global.shake_mag
            );

        final_y +=
            irandom_range(
                -global.shake_mag,
                global.shake_mag
            );

        global.shake_time--;
    }
}


// ----------------------------------------------------
// Final room clamp
// ----------------------------------------------------
final_x = clamp(
    final_x,
    0,
    max(0, room_width - vw)
);

final_y = clamp(
    final_y,
    0,
    max(0, room_height - vh)
);


// ----------------------------------------------------
// Apply normal camera position
// ----------------------------------------------------
camera_set_view_pos(
    cam,
    final_x,
    final_y
);