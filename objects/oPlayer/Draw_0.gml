/// oPlayer - Draw (oblique visual offset + perched bird glued to player)

if (!variable_instance_exists(id, "draw_floor_inset")) draw_floor_inset = 9;

var px = round(x);
var py = round(y) + draw_floor_inset;

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

    // If the bird belongs to this player, draw it RELATIVE to the player's draw position
    if (variable_instance_exists(bird, "owner") && bird.owner == id) {

        // Keep the bird's relative offset to the player,
        // but base it off the PLAYER'S drawn position, not bird world position
        var rel_x = bird.x - x;
        var rel_y = bird.y - y;

        var bird_draw_x = round(px + rel_x);
        var bird_draw_y = round(py + rel_y);

        draw_sprite_ext(
            bird.sprite_index,
            bird.image_index,
            bird_draw_x,
            bird_draw_y,
            bird.image_xscale,
            bird.image_yscale,
            bird.image_angle,
            bird.image_blend,
            bird.image_alpha
        );
    }
    else
    {
        // Fallback for non-owned / free bird
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
}