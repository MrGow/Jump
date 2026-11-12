/// oSmasherArea2AlternateThin — Clean Up
// Remove collision components when their controlling smasher is destroyed.
if (instance_exists(collision_body))
{
    with (collision_body) instance_destroy();
}
if (instance_exists(collision_hydraulic))
{
    with (collision_hydraulic) instance_destroy();
}
if (instance_exists(collision_head))
{
    with (collision_head) instance_destroy();
}
