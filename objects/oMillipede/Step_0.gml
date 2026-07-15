/// oMillipede — Step

// ----------------------------------------------------
// Pause and death freeze
// ----------------------------------------------------
if (scr_game_frozen())
{
    exit;
}

if (!enabled)
{
    exit;
}

// ----------------------------------------------------
// Safety
// ----------------------------------------------------
move_direction =
    ((round(move_direction) mod 4) + 4) mod 4;

middle_count = max(1, round(middle_count));

// Recalculate in case middle_count was changed
body_length =
    left_w +
    (mid_w * middle_count) +
    right_w;

body_thickness =
    max(left_h, max(mid_h, right_h));

// ----------------------------------------------------
// Movement direction
//
// 0 = right
// 1 = down
// 2 = left
// 3 = up
// ----------------------------------------------------
var dir_x = 0;
var dir_y = 0;

switch (move_direction)
{
    case 0:
        dir_x = 1;
        dir_y = 0;
    break;

    case 1:
        dir_x = 0;
        dir_y = 1;
    break;

    case 2:
        dir_x = -1;
        dir_y = 0;
    break;

    case 3:
        dir_x = 0;
        dir_y = -1;
    break;
}

// ----------------------------------------------------
// Move
// ----------------------------------------------------
var movement = move_speed * patrol_sign;

x += dir_x * movement;
y += dir_y * movement;

travelled += abs(movement);

// Reverse after reaching patrol distance
if (patrol_distance > 0 && travelled >= patrol_distance)
{
    travelled = 0;
    patrol_sign *= -1;
}

// ----------------------------------------------------
// Advance composite animation
// ----------------------------------------------------
anim_position += anim_speed;

// ----------------------------------------------------
// Composite collision rectangle
// ----------------------------------------------------
var horizontal =
    move_direction == 0 ||
    move_direction == 2;

var collision_w;
var collision_h;

if (horizontal)
{
    collision_w =
        max(1, body_length - collision_inset_length * 2);

    collision_h =
        max(1, body_thickness - collision_inset_side * 2);
}
else
{
    collision_w =
        max(1, body_thickness - collision_inset_side * 2);

    collision_h =
        max(1, body_length - collision_inset_length * 2);
}

var col_left   = x - collision_w * 0.5;
var col_right  = x + collision_w * 0.5;
var col_top    = y - collision_h * 0.5;
var col_bottom = y + collision_h * 0.5;

// ----------------------------------------------------
// Kill player on contact
// ----------------------------------------------------
var p = instance_find(oPlayer, 0);

if (p != noone)
{
    if (
        !variable_instance_exists(p, "state") ||
        p.state != "dead"
    )
    {
        var hit =
            p.bbox_right  > col_left   &&
            p.bbox_left   < col_right  &&
            p.bbox_bottom > col_top    &&
            p.bbox_top    < col_bottom;

        if (hit)
        {
            with (p)
            {
                scr_player_died();
            }
        }
    }
}