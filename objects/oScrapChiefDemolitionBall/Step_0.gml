/// oScrapChiefDemolitionBall — Step
if (scr_game_frozen()) exit;
if (!variable_instance_exists(id, "phase2_drag")) phase2_drag = false;
if (!instance_exists(controller)) controller = instance_find(oScrapChiefController, 0);
if (instance_exists(controller)) active = controller.boss_active && !controller.sequence_complete;
else active = false;
chain_attached = instance_exists(chain) && instance_exists(carriage);
if (!chain_attached)
{
    visible = false;
    dangerous = false;
    grounded = false;
    slam_state = 0;
    slam_timer = 0;
    slam_complete = true;
    phase2_drag = false;
}
var frame_count = sprite_get_number(sprite_index);
var playback_speed = sprite_get_speed(sprite_index);
if (sprite_get_speed_type(sprite_index) == spritespeed_framespersecond) playback_speed /= room_speed;
animation_frame += playback_speed;
animation_frame = animation_frame mod max(1, frame_count);
image_index = floor(animation_frame);
if (!active || !visible || !chain_attached) { dangerous = false; exit; }
if (slam_test_enabled && keyboard_check_pressed(ord("P"))) begin_slam();
switch (slam_state)
{
    case 0:
        phase2_drag = false;
        break;
    case 1:
        slam_timer--;
        if (slam_timer <= 0)
        {
            if (!begin_slam_descent()) begin_slam_retraction();
        }
        break;
    case 2:
        slam_timer--;
        if (slam_timer <= 0) { phase2_drag = false; begin_slam_retraction(); }
        break;
    case 3:
        if (!phase2_drag)
        {
            slam_timer--;
            if (slam_timer <= 0) begin_slam_retraction();
        }
        break;
    case 4:
        phase2_drag = false;
        if (abs(chain.chain_length - slam_original_length) <= 0.1 && !grounded) finish_slam();
        break;
}
