/// oAchievementTrigger — Step

if (!enabled) exit;
if (triggered) exit;
if (achievement_id == "") exit;

if (scr_game_frozen()) exit;

if (variable_global_exists("game_phase")) {
    if (global.game_phase != "playing") exit;
}

var p = instance_find(oPlayer, 0);
if (p == noone) exit;

if (variable_instance_exists(p, "state")) {
    if (p.state == "dead") exit;
}

var hit =
    (p.bbox_right  > bbox_left) &&
    (p.bbox_left   < bbox_right) &&
    (p.bbox_bottom > bbox_top) &&
    (p.bbox_top    < bbox_bottom);

if (hit)
{
    triggered = true;

    scr_achievement_unlock(achievement_id);

    if (destroy_after_unlock) {
        instance_destroy();
    } else {
        enabled = false;
    }
}