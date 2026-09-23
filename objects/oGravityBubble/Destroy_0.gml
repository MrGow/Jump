/// oGravityBubble — Destroy


if (instance_exists(captured_player))
{
    with (captured_player)
    {
        if (state == "gravity_bubble")
        {
            state =
                "glide";

            hsp = 0;
            vsp = 0;
        }

        gravity_bubble_pressure_scale =
            1.0;

        gravity_bubble_scale_recover =
            true;

        gravity_bubble_scale_recover_delay =
            0;

        gravity_bubble_scale_recover_lerp =
            0.20;
    }
}