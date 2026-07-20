/// oBotDeathPart — Step

// ====================================================
// FREEZE RULES
//
// The pieces continue moving during death_delay, but
// stop during an actual pause or once the death menu is
// fully open.
// ====================================================

var freeze_part = false;

if (variable_global_exists("game_phase"))
{
    freeze_part =
        global.game_phase == "paused" ||
        global.game_phase == "menu" ||
        global.game_phase == "death_menu";
}

if (freeze_part)
{
    exit;
}


// ====================================================
// LIFETIME
// ====================================================

life_timer--;

if (life_timer <= 0)
{
    instance_destroy();
    exit;
}


// ====================================================
// SETTLED PIECE
// ====================================================

if (settled)
{
    hsp = 0;
    vsp = 0;
    spin_speed = 0;

    exit;
}


// ====================================================
// GRAVITY
// ====================================================

vsp += gravity_amount;

if (vsp > maximum_fall_speed)
{
    vsp = maximum_fall_speed;
}

hsp *= horizontal_drag;


// ====================================================
// HORIZONTAL MOVEMENT
// ====================================================

var move_x = hsp;

if (move_x != 0)
{
    var direction_x =
        sign(move_x);

    var amount_x =
        abs(move_x);

    repeat (floor(amount_x))
    {
        if (
            !death_part_solid_at(
                x + direction_x,
                y
            )
        )
        {
            x += direction_x;
        }
        else
        {
            hsp *=
                -horizontal_bounce_amount;

            spin_speed *= -0.8;

            break;
        }
    }

    var fraction_x =
        amount_x -
        floor(amount_x);

    if (fraction_x > 0)
    {
        if (
            !death_part_solid_at(
                x +
                direction_x *
                fraction_x,
                y
            )
        )
        {
            x +=
                direction_x *
                fraction_x;
        }
        else
        {
            hsp *=
                -horizontal_bounce_amount;

            spin_speed *= -0.8;
        }
    }
}


// ====================================================
// VERTICAL MOVEMENT
// ====================================================

var move_y = vsp;

if (move_y != 0)
{
    var direction_y =
        sign(move_y);

    var amount_y =
        abs(move_y);

    var vertical_collision =
        false;

    repeat (floor(amount_y))
    {
        if (
            !death_part_solid_at(
                x,
                y + direction_y
            )
        )
        {
            y += direction_y;
        }
        else
        {
            vertical_collision = true;
            break;
        }
    }

    var fraction_y =
        amount_y -
        floor(amount_y);

    if (
        !vertical_collision &&
        fraction_y > 0
    )
    {
        if (
            !death_part_solid_at(
                x,
                y +
                direction_y *
                fraction_y
            )
        )
        {
            y +=
                direction_y *
                fraction_y;
        }
        else
        {
            vertical_collision = true;
        }
    }


    // ------------------------------------------------
    // Ground or ceiling impact
    // ------------------------------------------------
    if (vertical_collision)
    {
        // Falling onto a surface.
        if (direction_y > 0)
        {
            var impact_speed =
                abs(vsp);

            bounce_count++;

            if (
                bounce_count >= maximum_bounces ||
                impact_speed <
                    minimum_bounce_speed
            )
            {
                vsp = 0;

                hsp *= 0.6;
                spin_speed *= 0.55;

                if (
                    abs(hsp) < 0.18 &&
                    abs(spin_speed) < 0.35
                )
                {
                    settled = true;
                }
            }
            else
            {
                vsp =
                    -impact_speed *
                    bounce_amount;

                hsp *= 0.82;
                spin_speed *= 0.85;
            }
        }
        // Hitting a ceiling.
        else
        {
            vsp =
                abs(vsp) *
                0.3;
        }
    }
}


// ====================================================
// ROTATION
// ====================================================

image_angle += spin_speed;


// ====================================================
// SETTLE WHEN RESTING ON GROUND
// ====================================================

if (
    death_part_solid_at(
        x,
        y + 1
    )
)
{
    if (
        abs(vsp) < 0.5 &&
        abs(hsp) < 0.18
    )
    {
        hsp *= 0.7;
        spin_speed *= 0.7;

        if (
            abs(hsp) < 0.05 &&
            abs(spin_speed) < 0.15
        )
        {
            settled = true;

            hsp = 0;
            vsp = 0;
            spin_speed = 0;
        }
    }
}