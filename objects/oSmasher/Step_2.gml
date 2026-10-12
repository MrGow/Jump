/// oSmasher — End Step
///
/// Airborne players are punted downward. If they land
/// beneath the still-extended smasher, the pending hit
/// becomes a crush death—even if the plate has just
/// started retracting.


if (!variable_instance_exists(id, "smasher_punt_pending"))
{
    smasher_punt_pending = false;
}

if (!variable_instance_exists(id, "smasher_punt_timer"))
{
    smasher_punt_timer = 0;
}

if (!variable_instance_exists(id, "smasher_punt_crush_frames"))
{
    smasher_punt_crush_frames =
        round(room_speed * 1.25);
}


if (scr_game_frozen())
{
    exit;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    smasher_punt_pending = false;
    smasher_punt_timer = 0;

    exit;
}


// Once the plate is no longer meaningfully extended,
// the pending crush is cancelled.
if (!active)
{
    smasher_punt_pending = false;
    smasher_punt_timer = 0;

    exit;
}


// ====================================================
// FIND PLAYER
// ====================================================

var player =
    instance_find(
        oPlayer,
        0
    );

if (player == noone)
{
    smasher_punt_pending = false;
    smasher_punt_timer = 0;

    exit;
}


if (
    variable_instance_exists(
        player,
        "state"
    )
    &&
    player.state == "dead"
)
{
    smasher_punt_pending = false;
    smasher_punt_timer = 0;

    exit;
}


// ====================================================
// UPDATE PENDING PUNT
// ====================================================

if (smasher_punt_pending)
{
    smasher_punt_timer--;

    if (smasher_punt_timer <= 0)
    {
        smasher_punt_pending = false;
        smasher_punt_timer = 0;
    }
}


// A normally retracting plate cannot begin a new hit.
//
// An existing pending punt is allowed to finish during
// the early part of the retraction.
if (
    plate_direction < 0 &&
    !smasher_punt_pending
)
{
    exit;
}


// ====================================================
// OPTIONAL FALLING-PLAYER REQUIREMENT
// ====================================================

if (
    kill_only_when_falling &&
    !smasher_punt_pending
)
{
    var player_vsp =
        variable_instance_exists(
            player,
            "vsp"
        )
        ? player.vsp
        : 0;

    if (player_vsp < 0)
    {
        exit;
    }
}


// ====================================================
// HORIZONTAL OVERLAP
// ====================================================

var inset_x =
    variable_instance_exists(
        id,
        "crush_inset_x"
    )
    ? crush_inset_x
    : 5;


var plate_left =
    bbox_left +
    inset_x;

var plate_right =
    bbox_right -
    inset_x;


if (plate_right < plate_left)
{
    var plate_mid =
        (
            bbox_left +
            bbox_right
        )
        *
        0.5;

    plate_left = plate_mid;
    plate_right = plate_mid;
}


var player_side_inset =
    variable_instance_exists(
        id,
        "crush_player_side_inset"
    )
    ? crush_player_side_inset
    : 5;


var player_kill_left =
    player.bbox_left +
    player_side_inset;

var player_kill_right =
    player.bbox_right -
    player_side_inset;


if (player_kill_right < player_kill_left)
{
    var player_mid =
        (
            player.bbox_left +
            player.bbox_right
        )
        *
        0.5;

    player_kill_left = player_mid;
    player_kill_right = player_mid;
}


var horizontal_overlap =
    player_kill_right > plate_left &&
    player_kill_left < plate_right;


if (!horizontal_overlap)
{
    // Player escaped sideways before being pinned.
    smasher_punt_pending = false;
    smasher_punt_timer = 0;

    exit;
}


// ====================================================
// DETERMINE REAL FLOOR SUPPORT
// ====================================================

var player_supported = false;


// Main player-ground result.
if (
    variable_instance_exists(
        player,
        "airborne_frames"
    )
)
{
    player_supported =
        player.airborne_frames <= 0;
}


// Additional confirmation from the player's current
// floor/platform reference.
if (
    !player_supported &&
    variable_instance_exists(
        player,
        "standing_platform"
    ) &&
    instance_exists(
        player.standing_platform
    )
)
{
    var support_vsp =
        variable_instance_exists(
            player,
            "vsp"
        )
        ? player.vsp
        : 0;

    if (abs(support_vsp) <= 0.01)
    {
        player_supported = true;
    }
}


// Fallback for older player instances.
if (
    !player_supported &&
    variable_instance_exists(
        player,
        "prev_on_ground"
    ) &&
    player.prev_on_ground
)
{
    player_supported = true;
}


var player_is_airborne =
    !player_supported;


// ====================================================
// PENDING FOLLOW-UP CRUSH
// ====================================================

var punt_followup_crush =
    smasher_punt_pending &&
    player_supported;


// ====================================================
// PLATE-TO-PLAYER CONTACT
// ====================================================

var tolerance =
    variable_instance_exists(
        id,
        "crush_contact_tolerance"
    )
    ? crush_contact_tolerance
    : 4;


var player_head =
    player.bbox_top;

var player_bottom =
    player.bbox_bottom;

var plate_now =
    plate_y_current;

var plate_prev =
    plate_y_previous;


var crossed_head =
    plate_prev <
        player_head -
        tolerance
    &&
    plate_now >=
        player_head -
        tolerance;


var touching_head =
    plate_now >=
        player_head -
        tolerance
    &&
    plate_now <=
        player_bottom +
        tolerance;


var normal_plate_contact =
    crossed_head ||
    touching_head;


// A landed player with a pending punt bypasses the
// second contact test. The initial impact already came
// from this plate.
if (
    !normal_plate_contact &&
    !punt_followup_crush
)
{
    exit;
}


// ====================================================
// AIRBORNE PLATE HIT
// ====================================================

if (player_is_airborne)
{
    var move_threshold =
        variable_instance_exists(
            id,
            "crush_move_threshold"
        )
        ? crush_move_threshold
        : 0.01;


    var plate_is_descending =
        plate_direction > 0 &&
        plate_move_y >
            move_threshold;


    // Do not create a new punt while stationary or
    // retracting. An existing latch remains intact.
    if (!plate_is_descending)
    {
        exit;
    }


    var punt_min =
        variable_instance_exists(
            id,
            "smasher_punt_min_speed"
        )
        ? smasher_punt_min_speed
        : 7;


    var punt_max =
        variable_instance_exists(
            id,
            "smasher_punt_max_speed"
        )
        ? smasher_punt_max_speed
        : 12;


    var punt_multiplier =
        variable_instance_exists(
            id,
            "smasher_punt_plate_multiplier"
        )
        ? smasher_punt_plate_multiplier
        : 1.15;


    var punt_speed =
        clamp(
            max(
                punt_min,
                plate_move_y *
                punt_multiplier
            ),
            punt_min,
            punt_max
        );


    // Remember that this player was struck by this
    // smasher while airborne.
    smasher_punt_pending = true;

    smasher_punt_timer =
        max(
            1,
            smasher_punt_crush_frames
        );


    // =================================================
    // MECHANICAL HIT SOUND
    // =================================================

    if (!smasher_player_hit_sfx_lock)
    {
        if (snd_smasher_floor_hit != -1)
        {
            scr_play_sfx(
                snd_smasher_floor_hit,
                smasher_floor_hit_gain,
                random_range(
                    0.96,
                    1.02
                )
            );
        }

        smasher_player_hit_sfx_lock = true;
    }


    // =================================================
    // APPLY DOWNWARD PUNT
    // =================================================

    with (player)
{
    // Allow this speed to exceed the player's normal
    // terminal velocity for several movement frames.
    smasher_punt_speed =
        punt_speed;

    smasher_punt_frames =
        6;


    vsp =
        max(
            vsp,
            punt_speed
        );


        if (
            variable_instance_exists(
                id,
                "jump_charging"
            )
        )
        {
            jump_charging = false;
        }

        if (
            variable_instance_exists(
                id,
                "jump_charge"
            )
        )
        {
            jump_charge = 0;
        }

        if (
            variable_instance_exists(
                id,
                "jump_charge_level"
            )
        )
        {
            jump_charge_level = 0;
        }

        if (
            variable_instance_exists(
                id,
                "jump_charge_sfx_last"
            )
        )
        {
            jump_charge_sfx_last = 0;
        }

        if (
            variable_instance_exists(
                id,
                "bounce_pending"
            )
        )
        {
            bounce_pending = false;
        }

        if (
            variable_instance_exists(
                id,
                "bounce_timer"
            )
        )
        {
            bounce_timer = 0;
        }

        if (
            variable_instance_exists(
                id,
                "bounce_v"
            )
        )
        {
            bounce_v = 0;
        }

        if (
            variable_instance_exists(
                id,
                "standing_platform"
            )
        )
        {
            standing_platform = noone;
        }

        if (
            variable_instance_exists(
                id,
                "standing_platform_xoff"
            )
        )
        {
            standing_platform_xoff = 0;
        }

        if (
            variable_instance_exists(
                id,
                "coyote_timer"
            )
        )
        {
            coyote_timer = 0;
        }

        if (
            variable_instance_exists(
                id,
                "support_grace"
            )
        )
        {
            support_grace = 0;
        }

        if (
            variable_instance_exists(
                id,
                "charge_grace"
            )
        )
        {
            charge_grace = 0;
        }

        if (
            variable_instance_exists(
                id,
                "support_stable_frames"
            )
        )
        {
            support_stable_frames = 0;
        }

        if (
            variable_instance_exists(
                id,
                "prev_on_ground"
            )
        )
        {
            prev_on_ground = false;
        }

        if (
            variable_instance_exists(
                id,
                "airborne_frames"
            )
        )
        {
            airborne_frames =
                max(
                    1,
                    airborne_frames
                );
        }

        if (
            variable_instance_exists(
                id,
                "jump_pose_timer"
            )
        )
        {
            jump_pose_timer = 0;
        }


        state = "glide";


        var glide_sprite =
            asset_get_index(
                "spriteBotGliding"
            );

        if (glide_sprite != -1)
        {
            sprite_index = glide_sprite;
            image_index  = 0;
            image_speed  = 1;
        }
    }


    // Never crush during the initial airborne impact.
    exit;
}


// ====================================================
// PLAYER IS NOW PINNED
// ====================================================

smasher_punt_pending = false;
smasher_punt_timer = 0;


var sink =
    variable_instance_exists(
        id,
        "sink_px"
    )
    ? sink_px
    : 6;


var lock_y =
    player.bbox_bottom +
    sink;


var death_shake_strength =
    variable_instance_exists(
        id,
        "smasher_death_shake_strength"
    )
    ? smasher_death_shake_strength
    : -1;

var death_shake_frames =
    variable_instance_exists(
        id,
        "smasher_death_shake_frames"
    )
    ? smasher_death_shake_frames
    : -1;

var death_type =
    variable_instance_exists(
        id,
        "smasher_death_type"
    )
    ? smasher_death_type
    : "crush";


var shake_strength_argument =
    death_shake_strength >= 0
    ? death_shake_strength
    : undefined;

var shake_frames_argument =
    death_shake_frames >= 0
    ? death_shake_frames
    : undefined;


// ====================================================
// MECHANICAL IMPACT LAYER
// ====================================================

if (!smasher_player_hit_sfx_lock)
{
    if (snd_smasher_floor_hit != -1)
    {
        scr_play_sfx(
            snd_smasher_floor_hit,
            smasher_floor_hit_gain,
            random_range(
                0.96,
                1.02
            )
        );
    }

    smasher_player_hit_sfx_lock = true;
}


// ====================================================
// KILL PLAYER WITH CRUSH PROFILE
// ====================================================

with (player)
{
    if (
        script_exists(
            asset_get_index(
                "scr_player_died"
            )
        )
    )
    {
        scr_player_died(
            lock_y,
            false,
            shake_strength_argument,
            shake_frames_argument,
            death_type
        );
    }
    else
    {
        state = "dead";
    }
}