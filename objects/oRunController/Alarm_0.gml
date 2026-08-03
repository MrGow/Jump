/// oRunController — Alarm 0

if (!instance_exists(oPlayer))
{
    is_resetting = false;
    exit;
}


// ====================================================
// REMOVE OLD EXPLOSION-DEATH VISUALS
// ====================================================
var death_explosion_object =
    asset_get_index("oDeathExplosion");

if (death_explosion_object != -1)
{
    with (death_explosion_object)
    {
        instance_destroy();
    }
}

var death_part_object =
    asset_get_index("oBotDeathPart");

if (death_part_object != -1)
{
    with (death_part_object)
    {
        instance_destroy();
    }
}


// ----------------------------------------------------
// Prefer active checkpoint
// ----------------------------------------------------
if (
    variable_global_exists("checkpoint_set") &&
    global.checkpoint_set &&
    variable_global_exists("checkpoint_room") &&
    global.checkpoint_room == room
)
{
    spawn_x = global.checkpoint_x;
    spawn_y = global.checkpoint_y;
}


// ----------------------------------------------------
// Reset player
// ----------------------------------------------------
with (oPlayer)
{
    x = other.spawn_x;
    y = other.spawn_y;

    hsp = 0;
    vsp = 0;

    state = "idle";

    if (variable_instance_exists(id, "death_fall"))
    {
        death_fall = false;
    }

    if (variable_instance_exists(id, "death_cam_lock_x"))
    {
        death_cam_lock_x = x;
    }

    if (variable_instance_exists(id, "death_cam_lock_y"))
    {
        death_cam_lock_y = y;
    }

    if (!variable_instance_exists(id, "max_hp"))
    {
        max_hp = 1;
    }

    if (!variable_instance_exists(id, "hp"))
    {
        hp = max_hp;
    }

    hp = max_hp;

    sprite_index = spriteBotIdle;

    // Place player directly on the floor below checkpoint.
    y =
        scr_player_respawn_floor_y(
            x,
            y
        );

    if (variable_instance_exists(id, "death_cam_lock_y"))
    {
        death_cam_lock_y = y;
    }

    image_index  = 0;
    image_speed  = 0.2;
    image_xscale = facing;
    image_yscale = 1;
    image_angle  = 0;
    image_alpha  = 1;
    image_blend  = c_white;


    // =================================================
    // RESPAWN INVULNERABILITY
    // =================================================
    if (!variable_instance_exists(id, "invincible_frames"))
    {
        invincible_frames =
            room_speed;
    }

    invincible = true;

    invincible_timer =
        invincible_frames;


    if (variable_instance_exists(id, "jump_charging"))
    {
        jump_charging = false;
    }

    if (variable_instance_exists(id, "jump_charge"))
    {
        jump_charge = 0;
    }

    if (variable_instance_exists(id, "jump_charge_level"))
    {
        jump_charge_level = 0;
    }

    if (variable_instance_exists(id, "bounce_pending"))
    {
        bounce_pending = false;
    }

    if (variable_instance_exists(id, "bounce_timer"))
    {
        bounce_timer = 0;
    }

    if (variable_instance_exists(id, "standing_platform"))
    {
        standing_platform = noone;
    }

    if (variable_instance_exists(id, "coyote_timer"))
    {
        coyote_timer = 0;
    }

    if (variable_instance_exists(id, "airborne_frames"))
    {
        airborne_frames = 0;
    }

    if (variable_instance_exists(id, "prev_on_ground"))
    {
        prev_on_ground = true;
    }

    if (variable_instance_exists(id, "prev_jump_h"))
    {
        prev_jump_h = true;
    }

    if (variable_instance_exists(id, "respawn_input_lock"))
    {
        respawn_input_lock = 8;
    }
}

global.inp_jump_block_until_release = true;
global.inp_jump_press = false;
global.inp_jump_held  = false;


// ----------------------------------------------------
// Lose carried chips
// ----------------------------------------------------
if (variable_global_exists("chips_carried"))
{
    global.chips_carried = 0;
}

if (variable_global_exists("chips_carried_ids"))
{
    ds_map_clear(
        global.chips_carried_ids
    );
}


// ====================================================
// RESET MILLIPEEDES AND SPAWNERS
// ====================================================
if (
    variable_instance_exists(
        id,
        "reset_millipede_hazards"
    ) &&
    is_callable(
        reset_millipede_hazards
    )
)
{
    reset_millipede_hazards();
}


// ====================================================
// RESET HOLOGRAPHIC PLATFORM CHALLENGE
// ====================================================
if (
    variable_instance_exists(
        id,
        "reset_holo_platform_challenge"
    ) &&
    is_callable(
        reset_holo_platform_challenge
    )
)
{
    reset_holo_platform_challenge();
}


// ----------------------------------------------------
// Reset horizontal chase
// ----------------------------------------------------
var h_chase_obj =
    asset_get_index(
        "oHorizontalChaseController"
    );

if (h_chase_obj != -1)
{
    var h_chase_ctrl =
        instance_find(
            h_chase_obj,
            0
        );

    if (
        h_chase_ctrl != noone &&
        variable_instance_exists(
            h_chase_ctrl,
            "reset_chase"
        ) &&
        is_callable(
            h_chase_ctrl.reset_chase
        )
    )
    {
        h_chase_ctrl.reset_chase();
    }
}


// ----------------------------------------------------
// Reset downward chase
// ----------------------------------------------------
var v_chase_obj =
    asset_get_index(
        "oVerticalChaseController"
    );

if (v_chase_obj != -1)
{
    var v_chase_ctrl =
        instance_find(
            v_chase_obj,
            0
        );

    if (
        v_chase_ctrl != noone &&
        variable_instance_exists(
            v_chase_ctrl,
            "reset_chase"
        ) &&
        is_callable(
            v_chase_ctrl.reset_chase
        )
    )
    {
        v_chase_ctrl.reset_chase();
    }
}


// ----------------------------------------------------
// Reset upward chase
// ----------------------------------------------------
var up_chase_obj =
    asset_get_index(
        "oUpwardsChaseController"
    );

if (up_chase_obj != -1)
{
    var up_chase_ctrl =
        instance_find(
            up_chase_obj,
            0
        );

    if (
        up_chase_ctrl != noone &&
        variable_instance_exists(
            up_chase_ctrl,
            "reset_chase"
        ) &&
        is_callable(
            up_chase_ctrl.reset_chase
        )
    )
    {
        up_chase_ctrl.reset_chase();
    }
}


// ----------------------------------------------------
// Finish reset
// ----------------------------------------------------
is_resetting = false;

global.cam_death_lock_active = false;