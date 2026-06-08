/// oSpringPlatformAngular — End Step

if (!enabled) exit;

var p = instance_find(oPlayer, 0);
if (p == noone) exit;

if (variable_instance_exists(p, "state") && p.state == "dead") exit;

// Per-player retrigger lock
if (!variable_instance_exists(p, "spring_retrigger_lock")) p.spring_retrigger_lock = 0;

if (p.spring_retrigger_lock > 0) {
    p.spring_retrigger_lock--;
    exit;
}

// Basic overlap
var overlap =
    (p.bbox_right  > bbox_left) &&
    (p.bbox_left   < bbox_right) &&
    (p.bbox_bottom > bbox_top) &&
    (p.bbox_top    < bbox_bottom);

if (!overlap) exit;

// Always force a diagonal launch.
// wall_dir:
//  1 = up/right
// -1 = up/left
if (!variable_instance_exists(id, "wall_dir")) {
    wall_dir = (image_xscale >= 0) ? 1 : -1;
}

launch_h = angular_h_power * wall_dir;
launch_v = -angular_v_power;

with (p)
{
    // Nudge player slightly away from the wall pad so collision does not cancel hsp
    x += other.wall_dir * 3;

    // Clear charge / grounded / bounce states
    if (variable_instance_exists(id, "jump_charging"))         jump_charging = false;
    if (variable_instance_exists(id, "jump_charge"))           jump_charge = 0;
    if (variable_instance_exists(id, "jump_charge_level"))     jump_charge_level = 0;
    if (variable_instance_exists(id, "charge_grace"))          charge_grace = 0;
    if (variable_instance_exists(id, "support_grace"))         support_grace = 0;
    if (variable_instance_exists(id, "charge_start_lock"))     charge_start_lock = 0;
    if (variable_instance_exists(id, "support_stable_frames")) support_stable_frames = 0;
    if (variable_instance_exists(id, "edge_charge_fail"))      edge_charge_fail = 0;
    if (variable_instance_exists(id, "bounce_pending"))        bounce_pending = false;
    if (variable_instance_exists(id, "bounce_timer"))          bounce_timer = 0;
    if (variable_instance_exists(id, "prev_on_ground"))        prev_on_ground = false;
    if (variable_instance_exists(id, "coyote_timer"))          coyote_timer = 0;

    if (variable_instance_exists(id, "standing_platform"))      standing_platform = noone;
    if (variable_instance_exists(id, "standing_platform_xoff")) standing_platform_xoff = 0;

    // Force diagonal bounce every time
    hsp = other.launch_h;
    vsp = other.launch_v;

    state = "jumping";
    facing = other.wall_dir;

    spring_retrigger_lock = other.player_retrigger_lock_frames;
}

pressed_timer = pressed_frames;