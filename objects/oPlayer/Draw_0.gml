/// oPlayer — Draw (pixel-snapped + bird drawn in front)

var px = round(x);
var py = round(y);

// Draw player
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

// Draw bird in front
if (variable_instance_exists(id, "bird") && instance_exists(bird)) {
    draw_sprite_ext(
        bird.sprite_index,
        bird.image_index,
        round(bird.x),
        round(bird.y),
        bird.image_xscale,
        bird.image_yscale,
        bird.image_angle,
        bird.image_blend,
        bird.image_alpha
    );
}

