/// oScrapChief — Step
if (scr_game_frozen()) exit;
if (eye_flash_timer > 0) eye_flash_timer--;
if (!instance_exists(carriage) || !instance_exists(chain))
{
    active = false;
    visible = false;
    chain_attached = false;
    exit;
}
visible = carriage.visible;
active = visible;
if (!visible) exit;
if (spit_test_enabled && keyboard_check_pressed(ord("O"))) begin_spit_attack(0);
if (overheat_test_enabled && keyboard_check_pressed(ord("I")))
{
    if (overheat_vulnerable) begin_overheat_recovery(true);
    else begin_overheat();
}
switch (chief_state)
{
    case 0:
        advance_chief_animation(idle_animation_speed, true);
        if (carriage.entrance_complete) begin_intro_roar();
        break;
    case 1:
        advance_chief_animation(idle_animation_speed, true);
        if (intro_roar_timer > 0) intro_roar_timer--;
        if (intro_roar_timer <= 0) begin_roar_start();
        break;
    case 2:
        if (advance_chief_animation(roar_animation_speed, false)) begin_roar_loop();
        break;
    case 3:
        advance_chief_animation(roar_animation_speed, true);
        var _fx_advance = get_animation_advance(roar_fx_sprite, roar_fx_animation_speed);
        var _fx_count = max(1, sprite_get_number(roar_fx_sprite));
        roar_fx_frame += _fx_advance;
        roar_fx_frame = roar_fx_frame mod _fx_count;
        intro_roar_timer--;
        if (intro_roar_timer <= 0) begin_roar_end();
        break;
    case 4:
        if (advance_chief_animation(roar_animation_speed, false)) finish_intro_roar();
        break;
    case 5:
        advance_chief_animation(idle_animation_speed, true);
        if (!intro_roar_complete)
        {
            if (intro_roar_timer > 0) intro_roar_timer--;
            if (intro_roar_timer <= 0) intro_roar_complete = true;
        }
        break;
    case 6:
        var _spit_finished = advance_chief_animation(spit_animation_speed, false);
        var _release_frame = clamp(floor(spit_release_frame), 0, sprite_get_number(spriteScrapChiefSpit) - 1);
        if (spit_mode == 1)
        {
            if (barrage_timer > 0) barrage_timer--;
            if (animation_frame >= _release_frame && barrage_released < barrage_count && barrage_timer <= 0) release_barrage_piece();
            if (_spit_finished && barrage_released >= barrage_count) finish_spit_attack();
        }
        else
        {
            if (!spit_released && animation_frame >= _release_frame) release_spit_projectile();
            if (_spit_finished) finish_spit_attack();
        }
        break;
    case 7:
        var _overheat_finished = advance_chief_animation(overheat_animation_speed, false);
        if (_overheat_finished)
        {
            var _allow_drop = true;
            if (instance_exists(controller))
            {
                var _phase1 = controller.phase1_overheat_started && (controller.elevator_state == 3 || controller.elevator_state == 4);
                var _phase2 = controller.phase2_overheat_started && (controller.elevator_state == 5 || controller.elevator_state == 6);
                if (_phase1 || _phase2)
                {
                    _allow_drop = false;
                    if ((controller.elevator_state == 4 || controller.elevator_state == 6) && instance_exists(controller.platform))
                        _allow_drop = abs(controller.platform.dx) <= 0.001 && abs(controller.platform_move_x) <= 0.001;
                }
            }
            if (_allow_drop) begin_overheat_drop();
        }
        break;
    case 8:
        image_index = sprite_get_number(sprite_index) - 1;
        break;
    case 9:
        if (advance_chief_animation(overheat_animation_speed, false)) begin_overheat_vulnerability();
        break;
    case 10:
        advance_chief_animation(overheat_animation_speed, true);
        if (check_eye_hit()) break;
        if (overheat_timer > 0) overheat_timer--;
        if (overheat_timer <= 0) begin_overheat_recovery(false);
        break;
    case 11:
        if (advance_chief_animation(overheat_animation_speed, false)) begin_overheat_retraction();
        break;
    case 12:
        image_index = sprite_get_number(sprite_index) - 1;
        if (abs(chain.chain_length - overheat_original_length) <= 0.1 && !grounded) finish_overheat();
        break;
}
