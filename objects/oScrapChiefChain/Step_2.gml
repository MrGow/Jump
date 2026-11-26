
/// oScrapChiefChain — End Step

// ====================================================
// SAFETY
// ====================================================

if (!initialized)
{
    exit;
}

if (
    !instance_exists(carriage) ||
    !instance_exists(payload)
)
{
    instance_destroy();
    exit;
}


// ====================================================
// VISIBILITY
// ====================================================

payload.visible = carriage.visible;

if (!carriage.visible)
{
    exit;
}


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    payload.dx = 0;
    payload.dy = 0;

    exit;
}


// ====================================================
// UPDATE CHAIN LENGTH
// ====================================================

if (chain_length < target_length)
{
    chain_length = min(
        target_length,
        chain_length + extend_speed
    );
}
else if (chain_length > target_length)
{
    chain_length = max(
        target_length,
        chain_length - retract_speed
    );
}

var segment_length =
    chain_length / segment_count;


// ====================================================
// UPPER ANCHOR
// ====================================================

var anchor_x = carriage.attachment_x;
var anchor_y = carriage.attachment_y;

point_x[0] = anchor_x;
point_y[0] = anchor_y;

previous_x[0] = anchor_x;
previous_y[0] = anchor_y;


// ====================================================
// DEMOLITION BALL FLOOR CONFIGURATION
// ====================================================

var is_demolition_ball =
    payload.object_index ==
    oScrapChiefDemolitionBall;

var floor_enabled = false;

var floor_left = 0;
var floor_right = 0;
var floor_attachment_y = 0;

var floor_move_x = 0;

var was_grounded = false;
var floor_contact = false;

var ball_left_offset = 0;
var ball_right_offset = 0;


if (is_demolition_ball)
{
    was_grounded = payload.grounded;

    ball_left_offset =
        -payload.ball_attach_offset_x;

    ball_right_offset =
        payload.ball_width -
        payload.ball_attach_offset_x;

    if (instance_exists(carriage.controller))
    {
        var ctrl = carriage.controller;

        if (instance_exists(ctrl.platform))
        {
            var p = ctrl.platform;

            floor_enabled = p.enabled;

            floor_left =
                p.bbox_left +
                p.surface_inset_left;

            floor_right =
                p.bbox_right -
                p.surface_inset_right;

            floor_attachment_y =
                p.surface_y
                - payload.ball_height
                + payload.ball_attach_offset_y;

            floor_move_x = p.dx;
        }
    }
}


// ====================================================
// VERLET INTEGRATION
// ====================================================

for (var i = 1; i <= segment_count; i++)
{
    var vx =
        (point_x[i] - previous_x[i]) *
        chain_damping;

    var vy =
        (point_y[i] - previous_y[i]) *
        chain_damping;


    // --------------------------------------------
    // Ground friction relative to moving elevator
    // --------------------------------------------

    if (
        is_demolition_ball &&
        floor_enabled &&
        was_grounded &&
        i == segment_count
    )
    {
        vx =
            floor_move_x +
            (vx - floor_move_x) *
            payload.ground_friction;

        vy = min(vy, 0);
    }


    previous_x[i] = point_x[i];
    previous_y[i] = point_y[i];

    var gravity_amount = chain_gravity;

    if (i == segment_count)
    {
        gravity_amount = payload_gravity;
    }

    point_x[i] += vx;

    point_y[i] +=
        vy + gravity_amount;
}


// ====================================================
// DISTANCE CONSTRAINTS
// ====================================================

for (
    var iteration = 0;
    iteration < constraint_iterations;
    iteration++
)
{
    // Keep the upper anchor fixed.

    point_x[0] = anchor_x;
    point_y[0] = anchor_y;


    for (var i = 0; i < segment_count; i++)
    {
        var next = i + 1;

        var diff_x =
            point_x[next] - point_x[i];

        var diff_y =
            point_y[next] - point_y[i];

        var distance = sqrt(
            diff_x * diff_x +
            diff_y * diff_y
        );

        if (distance <= 0.0001)
        {
            continue;
        }

        var correction =
            (distance - segment_length) /
            distance;


        // ----------------------------------------
        // Inverse mass weighting
        // ----------------------------------------

        var weight_a = 1;
        var weight_b = 1;

        if (i == 0)
        {
            weight_a = 0;
        }

        if (next == segment_count)
        {
            weight_b =
                1 / max(0.01, payload_mass);
        }

        var total_weight =
            weight_a + weight_b;


        // ----------------------------------------
        // Apply corrections
        // ----------------------------------------

        point_x[i] +=
            diff_x *
            correction *
            (weight_a / total_weight);

        point_y[i] +=
            diff_y *
            correction *
            (weight_a / total_weight);

        point_x[next] -=
            diff_x *
            correction *
            (weight_b / total_weight);

        point_y[next] -=
            diff_y *
            correction *
            (weight_b / total_weight);
    }


    // --------------------------------------------
    // DEMOLITION BALL FLOOR CONSTRAINT
    //
    // Apply during every physics iteration.
    // --------------------------------------------

    if (floor_enabled)
    {
        var end_x =
            point_x[segment_count];

        var end_y =
            point_y[segment_count];

        var ball_left =
            end_x + ball_left_offset;

        var ball_right =
            end_x + ball_right_offset;

        var overlaps_floor =
            ball_right >= floor_left &&
            ball_left <= floor_right;

        if (
            overlaps_floor &&
            end_y > floor_attachment_y
        )
        {
            point_y[segment_count] =
                floor_attachment_y;
        }
    }
}


// ====================================================
// FINAL FLOOR CONTACT
// ====================================================

if (floor_enabled)
{
    var end_x =
        point_x[segment_count];

    var end_y =
        point_y[segment_count];

    var ball_left =
        end_x + ball_left_offset;

    var ball_right =
        end_x + ball_right_offset;

    var overlaps_floor =
        ball_right >= floor_left &&
        ball_left <= floor_right;

    floor_contact =
        overlaps_floor &&
        end_y >= floor_attachment_y - 0.1;

    if (floor_contact)
    {
        point_y[segment_count] =
            floor_attachment_y;

        // Remove downward Verlet velocity.

        previous_y[segment_count] =
            point_y[segment_count];
    }
}


// ====================================================
// UPDATE PAYLOAD POSITION
// ====================================================

payload.prev_x = payload.x;
payload.prev_y = payload.y;

payload.x =
    point_x[segment_count] -
    payload.ball_attach_offset_x;

payload.y =
    point_y[segment_count] -
    payload.ball_attach_offset_y;


// ====================================================
// MOVEMENT DELTAS
// ====================================================

payload.dx =
    payload.x - payload.prev_x;

payload.dy =
    payload.y - payload.prev_y;

payload.velocity_x = payload.dx;
payload.velocity_y = payload.dy;


// ====================================================
// UPDATE ATTACHMENT
// ====================================================

payload.update_attachment();


// ====================================================
// DEMOLITION BALL GROUND STATE
// ====================================================

if (is_demolition_ball)
{
    payload.grounded = floor_contact;

    if (
        floor_contact &&
        payload.slam_state == 2
    )
    {
        payload.slam_impact();
    }
}
