/// oAchievementTrigger — Create

if (!variable_instance_exists(id, "achievement_id")) achievement_id = "";
if (!variable_instance_exists(id, "enabled")) enabled = true;
if (!variable_instance_exists(id, "destroy_after_unlock")) destroy_after_unlock = true;
if (!variable_instance_exists(id, "debug_draw")) debug_draw = false;

visible = false;
triggered = false;