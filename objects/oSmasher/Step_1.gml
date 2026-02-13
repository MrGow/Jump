/// oSmasher — Begin Step (FULL)
if (!enabled) exit;

// Lock position (visual anim provides motion)
x = base_x;
y = base_y;

// Decide active window *before* player collisions run in Step
if (use_active_frames) {
    var fr = floor(image_index);
    active = (fr >= active_from && fr <= active_to);
} else {
    active = true;
}

// Swap collision mask by frame EARLY
// Up frames -> body-only (lets player pass underneath)
// Down frames -> full (blocks plate area)
mask_index = active ? mask_full : mask_body;
