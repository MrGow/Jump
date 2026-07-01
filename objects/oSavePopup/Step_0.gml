timer--;

dot_timer++;

if (dot_timer >= 10)
{
    dot_timer = 0;

    dot_state++;

    if (dot_state > 4)
        dot_state = 1;
}

// Fade during last half second
if (timer < room_speed * 0.5)
{
    alpha = timer / (room_speed * 0.5);
}

if (timer <= 0)
{
    instance_destroy();
}