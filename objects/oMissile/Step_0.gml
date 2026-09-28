/// oMissile — Step

if (scr_game_frozen()) exit;

var previous_y = y;
vsp = -launch_speed;
y += vsp;

var half_width = sprite_get_width(sprite_index) * 0.35;
var half_height = sprite_get_height(sprite_index) * 0.35;

// Check the entire travelled path, not just the new position.
var ship = collision_rectangle(
    x - half_width,
    min(previous_y, y) - half_height,
    x + half_width,
    max(previous_y, y) + half_height,
    oGunShip, false, true
);

if (instance_exists(ship) &&
    instance_exists(ship.boss_controller) &&
    ship.state != "boss_crashing" &&
    ship.state != "boss_exposed" &&
    ship.state != "boss_retracting" &&
    ship.state != "boss_recovering")
{
    instance_create_depth(x, y, -1100, oMissileExplosion);
    ship.boss_on_missile_hit();
    instance_destroy();
    exit;
}

if (y < -destroy_margin) instance_destroy();
