/// oArea2ChasingSawsHorizontal — End Step

if (!enabled) exit;

var ctrl = instance_find(oVerticalChaseController, 0);

if (ctrl == noone) exit;
if (!ctrl.chase_active) exit;

// ----------------------------------------------------
// Follow the top of the moving camera
// ----------------------------------------------------
x = ctrl.cam_x + screen_offset_x;
y = ctrl.cam_y + screen_offset_y;

// ----------------------------------------------------
// Kill player on contact
// ----------------------------------------------------
var p = instance_place(x, y, oPlayer);

if (p != noone)
{
    if (variable_instance_exists(p, "state") &&
        p.state != "dead")
    {
        with (p)
        {
            scr_player_died();
        }
    }
}