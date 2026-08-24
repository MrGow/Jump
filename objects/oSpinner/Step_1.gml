/// oSpinner — Begin Step


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (
    !variable_instance_exists(
        id,
        "snd_spinner_loop"
    )
)
{
    snd_spinner_loop =
        asset_get_index(
            "CircularSpinnerLoop1"
        );
}


if (
    !variable_instance_exists(
        id,
        "spinner_loop_instance"
    )
)
{
    spinner_loop_instance =
        noone;
}


if (
    !variable_instance_exists(
        id,
        "spinner_loop_gain"
    )
)
{
    spinner_loop_gain =
        0.16;
}


if (
    !variable_instance_exists(
        id,
        "spinner_loop_pitch"
    )
)
{
    spinner_loop_pitch =
        1.0;
}


if (
    !variable_instance_exists(
        id,
        "spinner_loop_inner_dist"
    )
)
{
    spinner_loop_inner_dist =
        100;
}


if (
    !variable_instance_exists(
        id,
        "spinner_loop_outer_dist"
    )
)
{
    spinner_loop_outer_dist =
        340;
}


if (
    !variable_instance_exists(
        id,
        "spinner_sound_max_simultaneous"
    )
)
{
    spinner_sound_max_simultaneous =
        3;
}


if (
    !variable_instance_exists(
        id,
        "spinner_audio_allowed"
    )
)
{
    spinner_audio_allowed =
        false;
}


// ====================================================
// PAUSE / FREEZE
// ====================================================

if (scr_game_frozen())
{
    image_speed =
        0;


    for (
        var fp = 0;
        fp < array_length(platforms);
        fp++
    )
    {
        if (
            instance_exists(
                platforms[fp]
            )
        )
        {
            platforms[fp].dx =
                0;

            platforms[fp].dy =
                0;
        }
    }


    if (
        spinner_loop_instance != noone
    )
    {
        audio_stop_sound(
            spinner_loop_instance
        );


        spinner_loop_instance =
            noone;
    }


    spinner_audio_allowed =
        false;


    exit;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    for (
        var ep = 0;
        ep < array_length(platforms);
        ep++
    )
    {
        if (
            instance_exists(
                platforms[ep]
            )
        )
        {
            platforms[ep].dx =
                0;

            platforms[ep].dy =
                0;
        }
    }


    if (
        spinner_loop_instance != noone
    )
    {
        audio_stop_sound(
            spinner_loop_instance
        );


        spinner_loop_instance =
            noone;
    }


    spinner_audio_allowed =
        false;


    exit;
}


// ====================================================
// LOCK DISC TO CENTRE
// ====================================================

x =
    base_x;

y =
    base_y;


// ====================================================
// ROTATE DISC
// ====================================================

image_angle +=
    spin_speed;


// ====================================================
// MOVE PLATFORMS
// ====================================================

for (
    var i = 0;
    i < array_length(platforms);
    i++
)
{
    var p =
        platforms[i];


    if (!instance_exists(p))
    {
        continue;
    }


    var old_x =
        p.x;

    var old_y =
        p.y;


    p.orbit_angle +=
        spin_speed;


    p.x =
        base_x
        +
        lengthdir_x(
            p.orbit_radius,
            p.orbit_angle
        );


    p.y =
        base_y
        +
        lengthdir_y(
            p.orbit_radius,
            p.orbit_angle
        );


    // Player carry
    p.dx =
        p.x -
        old_x;


    p.dy =
        p.y -
        old_y;


    // Platforms stay horizontal.
    p.image_angle =
        0;
}


// ====================================================
// CLOSEST-THREE AUDIO
// ====================================================

var p_audio =
    instance_find(
        oPlayer,
        0
    );


spinner_audio_allowed =
    false;


var target_gain =
    0;


if (p_audio != noone)
{
    spinner_audio_allowed =
        spinner_is_audio_candidate(
            p_audio
        );
}


// ====================================================
// DISTANCE GAIN
// ====================================================

if (
    p_audio != noone
    &&
    spinner_audio_allowed
)
{
    var d =
        point_distance(
            x,
            y,
            p_audio.x,
            p_audio.y
        );


    if (
        d <=
        spinner_loop_inner_dist
    )
    {
        target_gain =
            spinner_loop_gain;
    }


    else if (
        d <
        spinner_loop_outer_dist
    )
    {
        var tdist =
            (
                d -
                spinner_loop_inner_dist
            )
            /
            max(
                1,
                spinner_loop_outer_dist
                -
                spinner_loop_inner_dist
            );


        target_gain =
            spinner_loop_gain
            *
            (
                1
                -
                clamp(
                    tdist,
                    0,
                    1
                )
            );
    }
}


// ====================================================
// STOP LOOP
// ====================================================

if (target_gain <= 0)
{
    if (
        spinner_loop_instance != noone
    )
    {
        audio_stop_sound(
            spinner_loop_instance
        );


        spinner_loop_instance =
            noone;
    }
}


// ====================================================
// PLAY / UPDATE LOOP
// ====================================================

else if (
    snd_spinner_loop != -1
    &&
    audio_group_is_loaded(
        audiogroupsfx
    )
)
{
    if (
        spinner_loop_instance ==
        noone
    )
    {
        spinner_loop_instance =
            audio_play_sound(
                snd_spinner_loop,
                -58,
                true
            );


        audio_sound_gain(
            spinner_loop_instance,
            0,
            0
        );


        audio_sound_pitch(
            spinner_loop_instance,
            spinner_loop_pitch
        );
    }


    audio_sound_gain(
        spinner_loop_instance,
        target_gain,
        100
    );
}