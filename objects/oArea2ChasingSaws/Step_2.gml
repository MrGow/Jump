/// oChasingSaws — End Step

if (!enabled) exit;

// Find chase controller
var ctrl = instance_find(oHorizontalChaseController, 0);

if (ctrl == noone) exit;

// ----------------------------------------------------
// Follow the chase camera
// ----------------------------------------------------
x = ctrl.cam_x + screen_offset_x;
y = ctrl.cam_y + screen_offset_y;

// ----------------------------------------------------
// Kill player on contact
// ----------------------------------------------------
var p = instance_place(x, y, oPlayer);

if (p != noone)
{
    if (variable_instance_exists(p, "state") && p.state != "dead")
    {
        with (p)
        {
            scr_player_died(undefined, false);
        }
    }
}