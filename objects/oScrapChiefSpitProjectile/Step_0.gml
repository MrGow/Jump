/// oScrapChiefSpitProjectile — Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// INITIALIZATION SAFETY
// ====================================================

if (!initialized)
{
    exit;
}


// ====================================================
// CONTROLLER SAFETY
// ====================================================

if (!instance_exists(controller))
{
    instance_destroy();
    exit;
}

if (
    !controller.boss_active ||
    controller.sequence_complete
)
{
    instance_destroy();
    exit;
}

if (!instance_exists(platform))
{
    instance_destroy();
    exit;
}


// ====================================================
// SPAWN POP ANIMATION
//
// Rapid expansion followed by a small settle.
// Visual only — collision remains unchanged.
// ====================================================

var pop_total_frames =
    pop_expand_frames +
    pop_settle_frames;

if (pop_timer < pop_total_frames)
{
    pop_timer++;

    if (pop_timer <= pop_expand_frames)
    {
        // ----------------------------------------
        // Rapid expansion with ease-out
        // ----------------------------------------

        var t = clamp(
            pop_timer / max(1, pop_expand_frames),
            0,
            1
        );

        var eased =
            1 - power(1 - t, 2);

        pop_scale = lerp(
            pop_start_scale,
            pop_peak_scale,
            eased
        );
    }
    else
    {
        // ----------------------------------------
        // Settle back to normal size
        // ----------------------------------------

        var t = clamp(
            (pop_timer - pop_expand_frames) /
            max(1, pop_settle_frames),
            0,
            1
        );

        var eased =
            t * t * (3 - 2 * t);

        pop_scale = lerp(
            pop_peak_scale,
            1.0,
            eased
        );
    }
}
else
{
    pop_scale = 1.0;
}


// ====================================================
// PREVIOUS POSITION
// ====================================================

prev_x = x;
prev_y = y;


// ====================================================
// OFFSCREEN DESPAWN CONFIGURATION
// ====================================================

if (!variable_instance_exists(id, "offscreen_timer"))
{
    offscreen_timer = 0;
}

if (!variable_instance_exists(id, "offscreen_despawn_seconds"))
{
    offscreen_despawn_seconds = 3.0;
}


// ====================================================
// MOVEMENT
//
// Inherit elevator movement, then apply the
// projectile's independent ballistic movement.
// ====================================================

x += platform.dx;

velocity_y += gravity_amount;

x += velocity_x;
y += velocity_y;


// ====================================================
// ROTATION
// ====================================================

image_angle += rotation_speed;


// ====================================================
// OFFSCREEN DESPAWN
//
// Allow scrap to fall through the elevator.
// Only begin the despawn timer once the entire
// projectile has passed below the camera.
// ====================================================

var cam = view_camera[0];

var camera_bottom =
    camera_get_view_y(cam) +
    camera_get_view_height(cam);

if (
    velocity_y > 0 &&
    bbox_top > camera_bottom + 32
)
{
    offscreen_timer++;

    if (
        offscreen_timer >=
        round(offscreen_despawn_seconds * room_speed)
    )
    {
        instance_destroy();
        exit;
    }
}
else
{
    offscreen_timer = 0;
}