/// oSpinner — Create


// ====================================================
// VARIANT DEFAULTS
//
// Child objects can define these BEFORE event_inherited()
// to override the parent defaults.
// ====================================================

var _spinner_sprite =
    spriteSpinner;

var _platform_object =
    oSpinnerPlatform;

var _default_orbit_radius =
    42;


// ----------------------------------------------------
// CHILD OVERRIDES
// ----------------------------------------------------

if (
    variable_instance_exists(
        id,
        "spinner_sprite_override"
    )
)
{
    _spinner_sprite =
        spinner_sprite_override;
}


if (
    variable_instance_exists(
        id,
        "platform_object_override"
    )
)
{
    _platform_object =
        platform_object_override;
}


if (
    variable_instance_exists(
        id,
        "orbit_radius_default_override"
    )
)
{
    _default_orbit_radius =
        orbit_radius_default_override;
}


// Store resolved values for debugging / future use.
spinner_sprite =
    _spinner_sprite;

platform_object =
    _platform_object;

default_orbit_radius =
    _default_orbit_radius;


// ====================================================
// SPRITE
// ====================================================

sprite_index =
    spinner_sprite;

image_speed =
    0;

image_index =
    0;

visible =
    true;


// ====================================================
// ENABLED
// ====================================================

if (!variable_instance_exists(id, "enabled"))
{
    enabled =
        true;
}


// Keep disc in front of crane/background.
depth =
    -200;


// ====================================================
// FIXED CENTRE
// ====================================================

base_x =
    x;

base_y =
    y;


// ====================================================
// ROTATION SPEED
//
// Editor:
// 1 = very slow
// 2 = slow
// 3 = normal
// 4 = fast
// 5 = very fast
// ====================================================

if (
    !variable_instance_exists(
        id,
        "spinner_speed_level"
    )
)
{
    spinner_speed_level =
        3;
}


if (spinner_speed_level == 1)
{
    spin_speed =
        0.35;
}
else if (spinner_speed_level == 2)
{
    spin_speed =
        0.65;
}
else if (spinner_speed_level == 3)
{
    spin_speed =
        1.00;
}
else if (spinner_speed_level == 4)
{
    spin_speed =
        1.50;
}
else if (spinner_speed_level == 5)
{
    spin_speed =
        2.25;
}
else
{
    spin_speed =
        1.00;
}


// ====================================================
// PLATFORM COUNT
// ====================================================

if (
    !variable_instance_exists(
        id,
        "platform_count"
    )
)
{
    platform_count =
        2;
}


platform_count =
    max(
        1,
        round(
            platform_count
        )
    );


// ====================================================
// ORBIT RADIUS
//
// -1 = automatic based on spinner size.
// ====================================================

if (
    !variable_instance_exists(
        id,
        "orbit_radius_override"
    )
)
{
    orbit_radius_override =
        -1;
}


if (orbit_radius_override >= 0)
{
    orbit_radius =
        orbit_radius_override;
}
else
{
    orbit_radius =
        default_orbit_radius;
}


// ====================================================
// START ANGLE
// ====================================================

if (
    !variable_instance_exists(
        id,
        "start_angle"
    )
)
{
    start_angle =
        0;
}


// ====================================================
// CREATE PLATFORMS
// ====================================================

platforms =
    array_create(
        platform_count,
        noone
    );


for (
    var i = 0;
    i < platform_count;
    i++
)
{
    var ang =
        start_angle
        +
        (
            360 /
            platform_count
        )
        *
        i;


    var px =
        base_x
        +
        lengthdir_x(
            orbit_radius,
            ang
        );


    var py =
        base_y
        +
        lengthdir_y(
            orbit_radius,
            ang
        );


    var inst =
        instance_create_layer(
            px,
            py,
            "Instances",
            platform_object
        );


    if (inst != noone)
    {
        inst.owner_spinner =
            id;

        inst.orbit_angle =
            ang;

        inst.orbit_radius =
            orbit_radius;

        inst.platform_index =
            i;


        platforms[i] =
            inst;
    }
}


// ====================================================
// SPINNER LOOP SFX
// ====================================================

snd_spinner_loop =
    asset_get_index(
        "CircularSpinnerLoop1"
    );


spinner_loop_instance =
    noone;


// ====================================================
// AUDIO TUNING
// ====================================================

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


// Shared across Small / Medium / Large.
spinner_sound_max_simultaneous =
    3;


spinner_audio_allowed =
    false;


// ====================================================
// CLOSEST-THREE AUDIO TEST
//
// oSpinner is the parent of Medium and Large, so this
// searches the complete spinner family.
// ====================================================

spinner_is_audio_candidate =
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


    if (
        my_dist >=
        spinner_loop_outer_dist
    )
    {
        return false;
    }


    var closer_count =
        0;


    var spinner_count =
        instance_number(
            oSpinner
        );


    for (
        var i = 0;
        i < spinner_count;
        i++
    )
    {
        var other_spinner =
            instance_find(
                oSpinner,
                i
            );


        if (
            other_spinner == noone
            ||
            other_spinner == id
        )
        {
            continue;
        }


        if (
            variable_instance_exists(
                other_spinner,
                "enabled"
            )
            &&
            !other_spinner.enabled
        )
        {
            continue;
        }


        var other_outer =
            variable_instance_exists(
                other_spinner,
                "spinner_loop_outer_dist"
            )
            ?
            other_spinner.spinner_loop_outer_dist
            :
            spinner_loop_outer_dist;


        var other_dist =
            point_distance(
                other_spinner.x,
                other_spinner.y,
                _player.x,
                _player.y
            );


        if (
            other_dist >=
            other_outer
        )
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
            other_spinner.id < id;


        if (
            definitely_closer
            ||
            tied_but_wins
        )
        {
            closer_count++;


            if (
                closer_count >=
                spinner_sound_max_simultaneous
            )
            {
                return false;
            }
        }
    }


    return true;
};