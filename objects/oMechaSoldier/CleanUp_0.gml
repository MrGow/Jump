/// oMechaSoldier — Clean Up

if (instance_exists(hitbox))
{
    instance_destroy(
        hitbox
    );

    hitbox = noone;
}