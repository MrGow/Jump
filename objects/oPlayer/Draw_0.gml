/// oPlayer — Draw (pixel-snapped + bird drawn in front)  (FULL)

// How far DOWN to draw the sprite so feet feel "in" the oblique tiles.
// Tweak: 2–6 px usually.
if (!variable_instance_exists(id, "draw_floor_inset")) draw_floor_inset = 9;

var px = round(x);
var py = round(y) + draw_floor_inset;

// Draw player (visual-only offset)
draw_sprite_ext(
    sprite_index,
    image_index,
    px,
    py,
    image_xscale,
    image_yscale,
    image_angle,
    image_blend,
    image_alpha
);

// Draw bird in front (match the same visual offset if you want it to sit similarly)
if (variable_instance_exists(id, "bird") && instance_exists(bird)) {
    draw_sprite_ext(
        bird.sprite_index,
        bird.image_index,
        round(bird.x),
        round(bird.y) + draw_floor_inset,
        bird.image_xscale,
        bird.image_yscale,
        bird.image_angle,
        bird.image_blend,
        bird.image_alpha
    );
}
