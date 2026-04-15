/// oMovingPlatform — Room Start

marker_found = false;

with (oMovingPlatformMarker)
{
    if (move_id == other.move_id)
    {
        other.target_x = x;
        other.target_y = y;
        other.marker_found = true;
    }
}

if (!marker_found) {
    target_x = start_x;
    target_y = start_y;
}