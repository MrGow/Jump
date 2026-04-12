/// oMovingPlatform — Room Start
/// Find the marker with matching move_id

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

// If no marker found, platform just stays where placed
if (!marker_found) {
    target_x = start_x;
    target_y = start_y;
}