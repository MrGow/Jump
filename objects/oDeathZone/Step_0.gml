/// oDeathZone — Step

if (!enabled)
{
    exit;
}

if (
    variable_instance_exists(id, "update_rect") &&
    is_callable(update_rect)
)
{
    update_rect();
}