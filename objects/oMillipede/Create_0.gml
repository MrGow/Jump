/// oMillipede — Create

depth = -15000;

// Composite object: sprites are drawn manually.
sprite_index = -1;

enabled    = true;
debug_draw = false;


// ====================================================
// EDITOR VARIABLES
// ====================================================

if (!variable_instance_exists(id, "route_id"))
{
    route_id = 0;
}

// 0 = back-and-forth patrol
// 1 = closed loop
// 2 = one-way spawned stream
if (!variable_instance_exists(id, "route_mode"))
{
    route_mode = 0;
}

if (!variable_instance_exists(id, "middle_count"))
{
    middle_count = 2;
}

if (!variable_instance_exists(id, "move_speed"))
{
    move_speed = 0.65;
}

// Middle-to-middle centre distance.
if (!variable_instance_exists(id, "segment_spacing"))
{
    segment_spacing = 31;
}

// Head-to-middle centre distance.
if (!variable_instance_exists(id, "head_spacing"))
{
    head_spacing = 38;
}

if (!variable_instance_exists(id, "start_reversed"))
{
    start_reversed = false;
}

if (!variable_instance_exists(id, "endpoint_wait_frames"))
{
    endpoint_wait_frames = 0;
}

if (!variable_instance_exists(id, "reset_on_death"))
{
    reset_on_death = true;
}

// Small uniform visual offset away from the route.
// Usually 0 or 1.
if (!variable_instance_exists(id, "body_lift"))
{
    body_lift = 1;
}


// ====================================================
// VALUE SAFETY
// ====================================================

route_mode =
    clamp(
        round(route_mode),
        0,
        2
    );

middle_count =
    max(
        1,
        round(middle_count)
    );

move_speed =
    max(
        0,
        move_speed
    );

segment_spacing =
    max(
        1,
        segment_spacing
    );

head_spacing =
    max(
        1,
        head_spacing
    );

endpoint_wait_frames =
    max(
        0,
        round(endpoint_wait_frames)
    );


// ====================================================
// OWNERSHIP
// ====================================================

// noone = manually placed millipede
// otherwise contains its oMillipedeSpawner instance.
spawner_owner = noone;


// ====================================================
// SPRITES
// ====================================================

spr_head_left =
    asset_get_index("spriteMillipedeLeft");

spr_middle =
    asset_get_index("spriteMillipedeMiddle");

spr_head_right =
    asset_get_index("spriteMillipedeRight");


// ====================================================
// ANIMATION
// ====================================================

anim_position = 0;
anim_speed    = 0.35;


// ====================================================
// COLLISION
// ====================================================

collision_scale = 0.76;


// ====================================================
// ROUTE DATA
// ====================================================

route_ready = false;

route_nodes = [];

route_x = [];
route_y = [];

// Orientation of the route section starting at each node.
//
// 0 = floor
// 1 = right wall
// 2 = ceiling
// 3 = left wall
route_surface_rotation = [];

route_cumulative = [];

route_count  = 0;
route_length = 0;


// ====================================================
// MOVEMENT STATE
// ====================================================

// Exact route distance of the currently leading head.
lead_distance = 0;

// 1  = increasing node_order
// -1 = decreasing node_order
travel_direction = 1;

wait_timer      = 0;
reverse_pending = false;


// ====================================================
// PHYSICAL BODY DATA
// ====================================================

total_segments =
    max(
        3,
        middle_count + 2
    );

// Distance of every physical piece from the left head.
segment_chain_distance = [];

body_span = 0;

segment_x     = [];
segment_y     = [];
segment_angle = [];

placed_start_x = x;
placed_start_y = y;


// ====================================================
// BUILD PHYSICAL BODY SPACING
//
// Physical order:
//
// 0                    = left head
// 1..middle_count      = middles
// total_segments - 1   = right head
// ====================================================

build_segment_chain = function()
{
    middle_count =
        max(
            1,
            round(middle_count)
        );

    total_segments =
        middle_count + 2;

    segment_spacing =
        max(
            1,
            segment_spacing
        );

    head_spacing =
        max(
            1,
            head_spacing
        );

    segment_chain_distance =
        array_create(
            total_segments,
            0
        );

    var running_distance = 0;

    segment_chain_distance[0] = 0;

    for (
        var i = 1;
        i < total_segments;
        i++
    )
    {
        var gap;

        // Left head to first middle.
        if (i == 1)
        {
            gap = head_spacing;
        }
        // Last middle to right head.
        else if (i == total_segments - 1)
        {
            gap = head_spacing;
        }
        // Middle to middle.
        else
        {
            gap = segment_spacing;
        }

        running_distance += gap;

        segment_chain_distance[i] =
            running_distance;
    }

    body_span =
        running_distance;

    segment_x =
        array_create(
            total_segments,
            placed_start_x
        );

    segment_y =
        array_create(
            total_segments,
            placed_start_y
        );

    segment_angle =
        array_create(
            total_segments,
            0
        );
};


// ====================================================
// SAMPLE THE EXACT AUTHORED ROUTE
//
// Returns:
//
// [0] X position
// [1] Y position
// [2] visual surface angle
//
// Every segment uses this same function. Therefore,
// every segment turns at exactly the same route point.
// ====================================================

sample_route = function(_distance)
{
    if (!route_ready || route_count < 2)
    {
        return [
            placed_start_x,
            placed_start_y,
            0
        ];
    }

    var d = _distance;

    // Closed loop wraps indefinitely.
    if (route_mode == 1)
    {
        d =
            (
                (d mod route_length) +
                route_length
            )
            mod route_length;
    }
    else
    {
        d =
            clamp(
                d,
                0,
                route_length
            );
    }

    var route_segment_count =
        route_mode == 1
        ? route_count
        : route_count - 1;

    for (
        var i = 0;
        i < route_segment_count;
        i++
    )
    {
        var next_index =
            (i + 1) mod route_count;

        var segment_start =
            route_cumulative[i];

        var segment_end =
            route_cumulative[i + 1];

        if (
            d <= segment_end ||
            i == route_segment_count - 1
        )
        {
            var start_x =
                route_x[i];

            var start_y =
                route_y[i];

            var end_x =
                route_x[next_index];

            var end_y =
                route_y[next_index];

            var segment_length =
                max(
                    0.0001,
                    segment_end -
                    segment_start
                );

            var amount =
                clamp(
                    (
                        d -
                        segment_start
                    ) /
                    segment_length,
                    0,
                    1
                );

            var sample_x =
                lerp(
                    start_x,
                    end_x,
                    amount
                );

            var sample_y =
                lerp(
                    start_y,
                    end_y,
                    amount
                );

            var surface =
                route_surface_rotation[i];

            surface =
                (
                    (round(surface) mod 4) +
                    4
                )
                mod 4;

            return [
                sample_x,
                sample_y,
                surface * 90
            ];
        }
    }

    var final_surface =
        route_surface_rotation[
            route_count - 1
        ];

    final_surface =
        (
            (round(final_surface) mod 4) +
            4
        )
        mod 4;

    return [
        route_x[route_count - 1],
        route_y[route_count - 1],
        final_surface * 90
    ];
};


// ====================================================
// UPDATE EVERY PHYSICAL PIECE
//
// No approximation or body-to-body following.
//
// Each piece occupies one exact distance on the same
// route, preserving spacing through corners.
// ====================================================

update_segments = function()
{
    if (!route_ready)
    {
        return;
    }

    var final_segment =
        total_segments - 1;

    for (
        var physical_index = 0;
        physical_index < total_segments;
        physical_index++
    )
    {
        var distance_on_route;

        if (travel_direction > 0)
        {
            // Right head is leading.
            //
            // Convert this physical piece's distance from
            // the left head into distance behind the
            // right head.
            var behind_right_head =
                body_span -
                segment_chain_distance[
                    physical_index
                ];

            distance_on_route =
                lead_distance -
                behind_right_head;
        }
        else
        {
            // Left head is leading.
            distance_on_route =
                lead_distance +
                segment_chain_distance[
                    physical_index
                ];
        }

        var route_sample =
            sample_route(
                distance_on_route
            );

        segment_x[physical_index] =
            route_sample[0];

        segment_y[physical_index] =
            route_sample[1];

        segment_angle[physical_index] =
            route_sample[2];
    }

    var leader_index =
        travel_direction > 0
        ? final_segment
        : 0;

    x =
        segment_x[
            leader_index
        ];

    y =
        segment_y[
            leader_index
        ];
};


// ====================================================
// BUILD ROUTE
// ====================================================

build_route = function()
{
    route_ready = false;

    route_nodes = [];

    route_x = [];
    route_y = [];

    route_surface_rotation = [];

    route_cumulative = [];

    route_count  = 0;
    route_length = 0;


    // ------------------------------------------------
    // Find matching route nodes
    // ------------------------------------------------
    var node_total =
        instance_number(
            oMillipedeRouteNode
        );

    for (
        var i = 0;
        i < node_total;
        i++
    )
    {
        var node =
            instance_find(
                oMillipedeRouteNode,
                i
            );

        if (node == noone)
        {
            continue;
        }

        if (node.route_id != route_id)
        {
            continue;
        }

        array_push(
            route_nodes,
            node
        );
    }

    route_count =
        array_length(
            route_nodes
        );

    if (route_count < 2)
    {
        show_debug_message(
            "MILLIPEDE ROUTE ERROR: route_id " +
            string(route_id) +
            " requires at least two nodes."
        );

        return false;
    }


    // ------------------------------------------------
    // Sort nodes by node_order
    // ------------------------------------------------
    for (
        var a = 0;
        a < route_count - 1;
        a++
    )
    {
        var smallest = a;

        for (
            var b = a + 1;
            b < route_count;
            b++
        )
        {
            if (
                route_nodes[b].node_order <
                route_nodes[smallest].node_order
            )
            {
                smallest = b;
            }
        }

        if (smallest != a)
        {
            var temporary =
                route_nodes[a];

            route_nodes[a] =
                route_nodes[smallest];

            route_nodes[smallest] =
                temporary;
        }
    }


    // ------------------------------------------------
    // Cache node positions and surface orientations
    // ------------------------------------------------
    for (
        var c = 0;
        c < route_count;
        c++
    )
    {
        var cached_node =
            route_nodes[c];

        array_push(
            route_x,
            cached_node.x
        );

        array_push(
            route_y,
            cached_node.y
        );

        var node_surface = 0;

        if (
            variable_instance_exists(
                cached_node,
                "surface_rotation"
            )
        )
        {
            node_surface =
                cached_node.surface_rotation;
        }

        node_surface =
            (
                (round(node_surface) mod 4) +
                4
            )
            mod 4;

        array_push(
            route_surface_rotation,
            node_surface
        );
    }


    // ------------------------------------------------
    // Build body spacing
    // ------------------------------------------------
    build_segment_chain();


    // ------------------------------------------------
    // Build cumulative route lengths
    // ------------------------------------------------
    route_cumulative = [0];

    route_length = 0;

    for (
        var s = 0;
        s < route_count - 1;
        s++
    )
    {
        route_length +=
            point_distance(
                route_x[s],
                route_y[s],
                route_x[s + 1],
                route_y[s + 1]
            );

        array_push(
            route_cumulative,
            route_length
        );
    }


    // Closed loop: final node back to node zero.
    if (route_mode == 1)
    {
        route_length +=
            point_distance(
                route_x[route_count - 1],
                route_y[route_count - 1],
                route_x[0],
                route_y[0]
            );

        array_push(
            route_cumulative,
            route_length
        );
    }


    // ------------------------------------------------
    // Validate
    // ------------------------------------------------
    if (route_length <= 0)
    {
        show_debug_message(
            "MILLIPEDE ROUTE ERROR: route_id " +
            string(route_id) +
            " has zero length."
        );

        return false;
    }

    if (
        route_mode != 1 &&
        route_length < body_span
    )
    {
        show_debug_message(
            "MILLIPEDE ROUTE WARNING: route_id " +
            string(route_id) +
            " is shorter than the complete body."
        );
    }


    // ------------------------------------------------
    // Initial direction
    // ------------------------------------------------
    travel_direction =
        start_reversed
        ? -1
        : 1;

    // Stream mode always moves forwards.
    if (route_mode == 2)
    {
        travel_direction = 1;
    }


    // ------------------------------------------------
    // Initial leading-head position
    // ------------------------------------------------
    if (route_mode == 1)
    {
        lead_distance =
            start_reversed
            ? 0
            : body_span;
    }
    else if (travel_direction > 0)
    {
        // Right head leads.
        lead_distance =
            min(
                route_length,
                body_span
            );
    }
    else
    {
        // Left head leads.
        lead_distance =
            max(
                0,
                route_length -
                body_span
            );
    }

    wait_timer      = 0;
    reverse_pending = false;

    route_ready = true;

    update_segments();

    return true;
};


// ====================================================
// REVERSE BACK-AND-FORTH PATROL
//
// The creature does not rotate as one rigid sprite.
// The previously trailing physical head becomes leader.
// ====================================================

reverse_patrol = function()
{
    if (travel_direction > 0)
    {
        // It reached the final route endpoint.
        //
        // The left head is currently body_span behind
        // the right head and becomes the new leader.
        travel_direction = -1;

        lead_distance =
            max(
                0,
                route_length -
                body_span
            );
    }
    else
    {
        // It reached the first route endpoint.
        //
        // The right head becomes the new leader.
        travel_direction = 1;

        lead_distance =
            min(
                route_length,
                body_span
            );
    }

    wait_timer      = 0;
    reverse_pending = false;

    update_segments();
};


// ====================================================
// RESET MILLIPEDE
// ====================================================

reset_millipede = function()
{
    if (!reset_on_death)
    {
        return;
    }

    anim_position = 0;

    route_ready = false;

    build_route();
};