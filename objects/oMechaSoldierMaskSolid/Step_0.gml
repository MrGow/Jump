/// oMechaSoldierHitbox — Step

if (
    !instance_exists(owner)
    ||
    owner.dead
)
{
    instance_destroy();
    exit;
}


// Follow the soldier's LOGICAL position.
//
// Do not add draw_floor_inset here.
// That is visual-only.
x = owner.x;
y = owner.y;