/// oTeleporterText — Step

if (
    owner_teleporter == noone
    ||
    !instance_exists(owner_teleporter)
)
{
    instance_destroy();
    exit;
}


// Follow owner position.
//
// The text calculations themselves still use the
// teleporter's x/y, but keeping this here also makes
// debugging sensible.
x = owner_teleporter.x;
y = owner_teleporter.y;