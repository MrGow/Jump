/// oDeathZone — Room Start

if (!variable_instance_exists(id, "snap_to_tile"))
{
    snap_to_tile = true;
}

if (
    snap_to_tile &&
    variable_instance_exists(id, "snap_transform") &&
    is_callable(snap_transform)
)
{
    snap_transform();
}
else if (
    variable_instance_exists(id, "update_rect") &&
    is_callable(update_rect)
)
{
    update_rect();
}