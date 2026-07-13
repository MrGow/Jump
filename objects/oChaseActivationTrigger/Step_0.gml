/// oChaseActivationTrigger — Step

if (activated) exit;

var p = instance_place(x, y, oPlayer);

if (p != noone)
{
    var ctrl = instance_find(oHorizontalChaseController, 0);

    if (ctrl != noone)
    {
        ctrl.start_chase();
        activated = true;

        show_debug_message("CHASE ACTIVATED");
    }
}