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