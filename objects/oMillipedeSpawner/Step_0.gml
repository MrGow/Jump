/// oMillipedeSpawner — Step

if (scr_game_frozen())
{
    exit;
}

if (!enabled)
{
    exit;
}

if (spawn_timer > 0)
{
    spawn_timer--;
    exit;
}

if (count_owned_millipedes() >= max_active)
{
    // Check again shortly rather than resetting the
    // entire full spawn interval.
    spawn_timer = 10;
    exit;
}

// ----------------------------------------------------
// Create one-way stream millipede
// ----------------------------------------------------
var layer_name =
    layer_exists("Instances")
    ? "Instances"
    : layer_get_name(layer_get_id_at_depth(0));

var m =
    instance_create_layer(
        x,
        y,
        layer_name,
        oMillipede
    );

if (m != noone)
{
    m.route_id   = route_id;
    m.route_mode = 2;

    m.middle_count =
        middle_count;

    m.move_speed =
        move_speed;

    m.segment_spacing =
        segment_spacing;

    m.first_middle_flipped =
        first_middle_flipped;

    m.start_reversed = false;

    m.reset_on_death = false;

    m.spawner_owner = id;

    // Force route to rebuild using the spawner's values.
    m.route_ready = false;
}

spawn_timer =
    max(1, spawn_interval);