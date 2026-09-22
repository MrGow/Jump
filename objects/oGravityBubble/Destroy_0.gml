/// oGravityBubble — Destroy


if (instance_exists(captured_player))
{
    with (captured_player)
    {
        if (state == "gravity_bubble")
        {
            state = "glide";

            hsp = 0;
            vsp = 0;
        }
    }
}