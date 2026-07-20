/// oBirdCompanion — Draw


// ====================================================
// LIVING BIRD
//
// The player's Draw event handles the living bird so it
// appears in the correct foreground position.
// ====================================================

if (
    !variable_instance_exists(id, "bird_state") ||
    bird_state == "alive"
)
{
    exit;
}


// ====================================================
// DEAD BIRD
//
// The player's Draw event exits completely while dead,
// so the bird must draw its own feather animation.
// ====================================================

if (sprite_index != -1)
{
    draw_self();
}