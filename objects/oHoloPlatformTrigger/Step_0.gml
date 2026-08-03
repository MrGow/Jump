/// oHoloPlatformTrigger — Step

if (!enabled)
{
    exit;
}

if (one_use && used)
{
    exit;
}

if (
    variable_global_exists("game_phase") &&
    global.game_phase != "playing"
)
{
    exit;
}

var p =
    instance_find(
        oPlayer,
        0
    );

if (p == noone)
{
    exit;
}

if (
    variable_instance_exists(p, "state") &&
    p.state == "dead"
)
{
    exit;
}

var overlap =
    p.bbox_right  > bbox_left &&
    p.bbox_left   < bbox_right &&
    p.bbox_bottom > bbox_top &&
    p.bbox_top    < bbox_bottom;

if (!overlap)
{
    exit;
}

var controller_object =
    asset_get_index(
        "oHoloPlatformController"
    );

if (controller_object == -1)
{
    exit;
}

var controller =
    instance_find(
        controller_object,
        0
    );

if (
    controller != noone &&
    variable_instance_exists(
        controller,
        "start_holo_sequence"
    ) &&
    is_callable(
        controller.start_holo_sequence
    )
)
{
    controller.start_holo_sequence();

    used = true;
}