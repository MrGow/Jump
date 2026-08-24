/// oWallSaw — Create

event_inherited();

enabled = true;
active  = true;

solid_body = false;


// ====================================================
// SPRITE / COLLISION
// ====================================================

sprite_index =
    spriteWallSawSaw;


// IMPORTANT:
//
// Only the spinning circular blade is lethal.
//
// spriteWallSawMask should:
// - have the same canvas size as spriteWallSawSaw
// - have the same origin as spriteWallSawSaw
// - contain collision only around the blade
//
// The wall clamp / mounting section remains harmless.
mask_index =
    spriteWallSawMask;


// ====================================================
// EDITOR VARIABLES — PATROL
// ====================================================

if (!variable_instance_exists(id, "patrol_enabled"))
{
    patrol_enabled = true;
}

if (!variable_instance_exists(id, "patrol_id"))
{
    patrol_id = "A";
}

if (!variable_instance_exists(id, "move_speed"))
{
    move_speed = 2;
}

if (!variable_instance_exists(id, "hold_start_frames"))
{
    hold_start_frames = 30;
}

if (!variable_instance_exists(id, "hold_end_frames"))
{
    hold_end_frames = 30;
}


// ====================================================
// EDITOR VARIABLES — FACING
//
// 0 = Right
// 1 = Down
// 2 = Left
// 3 = Up
// ====================================================

if (!variable_instance_exists(id, "facing_direction"))
{
    facing_direction = 0;
}


// ====================================================
// EDITOR VARIABLES — ANIMATION
// ====================================================

if (!variable_instance_exists(id, "blade_anim_speed"))
{
    blade_anim_speed = 1;
}


// ====================================================
// EDITOR VARIABLES — AUDIO
// ====================================================

if (!variable_instance_exists(id, "saw_loop_gain"))
{
    saw_loop_gain = 0.65;
}

if (!variable_instance_exists(id, "saw_sound_inner_dist"))
{
    saw_sound_inner_dist = 80;
}

if (!variable_instance_exists(id, "saw_sound_outer_dist"))
{
    saw_sound_outer_dist = 500;
}

if (!variable_instance_exists(id, "saw_sound_falloff_curve"))
{
    saw_sound_falloff_curve = 1.35;
}

if (!variable_instance_exists(id, "saw_sound_max_simultaneous"))
{
    saw_sound_max_simultaneous = 3;
}

if (!variable_instance_exists(id, "saw_sound_gain_lerp"))
{
    saw_sound_gain_lerp = 0.18;
}


// ====================================================
// DEBUG
// ====================================================

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// PATROL DATA
// ====================================================

patrol_start_x =
    x;

patrol_start_y =
    y;

patrol_end_x =
    x;

patrol_end_y =
    y;

patrol_point =
    noone;

patrol_state =
    "stationary";

hold_timer =
    0;


// ====================================================
// AUDIO DATA
// ====================================================

snd_saw_loop =
    asset_get_index(
        "SingleSawLoop1"
    );


saw_emitter =
    audio_emitter_create();


saw_sound_instance =
    -1;


saw_current_gain =
    0;


saw_audio_allowed =
    false;


if (saw_emitter >= 0)
{
    audio_emitter_falloff(
        saw_emitter,
        1,
        100000,
        0
    );


    audio_emitter_gain(
        saw_emitter,
        0
    );
}


// ====================================================
// FIND MATCHING PATROL POINT
// ====================================================

find_patrol_point =
function()
{
    patrol_point =
        noone;


    patrol_end_x =
        patrol_start_x;


    patrol_end_y =
        patrol_start_y;


    if (!patrol_enabled)
    {
        return;
    }


    if (string(patrol_id) == "")
    {
        return;
    }


    var point_count =
        instance_number(
            oSawPatrolPoint
        );


    for (
        var i = 0;
        i < point_count;
        i++
    )
    {
        var pt =
            instance_find(
                oSawPatrolPoint,
                i
            );


        if (pt == noone)
        {
            continue;
        }


        if (
            variable_instance_exists(
                pt,
                "enabled"
            )
            &&
            !pt.enabled
        )
        {
            continue;
        }


        if (
            variable_instance_exists(
                pt,
                "patrol_id"
            )
            &&
            string(pt.patrol_id)
            ==
            string(patrol_id)
        )
        {
            patrol_point =
                pt;


            patrol_end_x =
                pt.x;


            patrol_end_y =
                pt.y;


            return;
        }
    }
};


// ====================================================
// APPLY FACING
// ====================================================

apply_facing =
function()
{
    facing_direction =
        clamp(
            round(facing_direction),
            0,
            3
        );


    switch (facing_direction)
    {
        case 0:
            image_angle = 0;
        break;


        case 1:
            image_angle = 270;
        break;


        case 2:
            image_angle = 180;
        break;


        case 3:
            image_angle = 90;
        break;
    }
};


// ====================================================
// MOVE TOWARD TARGET
// ====================================================

move_to_target =
function(_tx, _ty)
{
    var dist =
        point_distance(
            x,
            y,
            _tx,
            _ty
        );


    if (dist <= move_speed)
    {
        x =
            _tx;

        y =
            _ty;


        return true;
    }


    var dir =
        point_direction(
            x,
            y,
            _tx,
            _ty
        );


    x +=
        lengthdir_x(
            move_speed,
            dir
        );


    y +=
        lengthdir_y(
            move_speed,
            dir
        );


    return false;
};


// ====================================================
// CLOSEST-THREE AUDIO CHECK
//
// Counts BOTH wall and floor saws.
// ====================================================

saw_is_audio_candidate =
function(_player)
{
    if (_player == noone)
    {
        return false;
    }


    var my_dist =
        point_distance(
            x,
            y,
            _player.x,
            _player.y
        );


    if (my_dist > saw_sound_outer_dist)
    {
        return false;
    }


    var closer_count =
        0;


    var saw_objects =
    [
        oWallSaw,
        oFloorSaw
    ];


    for (
        var oi = 0;
        oi < array_length(saw_objects);
        oi++
    )
    {
        var saw_obj =
            saw_objects[oi];


        var count =
            instance_number(
                saw_obj
            );


        for (
            var si = 0;
            si < count;
            si++
        )
        {
            var other_saw =
                instance_find(
                    saw_obj,
                    si
                );


            if (
                other_saw == noone
                ||
                other_saw == id
            )
            {
                continue;
            }


            if (
                variable_instance_exists(
                    other_saw,
                    "enabled"
                )
                &&
                !other_saw.enabled
            )
            {
                continue;
            }


            var other_dist =
                point_distance(
                    other_saw.x,
                    other_saw.y,
                    _player.x,
                    _player.y
                );


            var other_outer =
                variable_instance_exists(
                    other_saw,
                    "saw_sound_outer_dist"
                )
                ?
                other_saw.saw_sound_outer_dist
                :
                saw_sound_outer_dist;


            if (other_dist > other_outer)
            {
                continue;
            }


            var definitely_closer =
                other_dist <
                my_dist - 0.001;


            var tied_but_wins =
                abs(
                    other_dist -
                    my_dist
                )
                <= 0.001
                &&
                other_saw.id < id;


            if (
                definitely_closer
                ||
                tied_but_wins
            )
            {
                closer_count++;


                if (
                    closer_count >=
                    saw_sound_max_simultaneous
                )
                {
                    return false;
                }
            }
        }
    }


    return true;
};


// ====================================================
// STOP SAW AUDIO
// ====================================================

stop_saw_audio =
function()
{
    if (
        saw_sound_instance != -1
        &&
        audio_is_playing(
            saw_sound_instance
        )
    )
    {
        audio_stop_sound(
            saw_sound_instance
        );
    }


    saw_sound_instance =
        -1;


    saw_current_gain =
        0;


    if (saw_emitter >= 0)
    {
        audio_emitter_gain(
            saw_emitter,
            0
        );
    }
};


// ====================================================
// INITIAL VISUAL
// ====================================================

apply_facing();

image_index =
    0;

image_speed =
    blade_anim_speed;