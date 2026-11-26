
/// oScrapChief — Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// ATTACHMENT SAFETY
// ====================================================

if (
    !instance_exists(carriage) ||
    !instance_exists(chain)
)
{
    active = false;
    visible = false;

    chain_attached = false;

    exit;
}


// ====================================================
// VISIBILITY
// ====================================================

visible = carriage.visible;

active = visible;

if (!visible)
{
    exit;
}


// ====================================================
// OPTIONAL MANUAL SPIT TEST
// ====================================================

if (
    spit_test_enabled &&
    keyboard_check_pressed(ord("O"))
)
{
    begin_spit_attack(0);
}


// ====================================================
// CHIEF STATE MACHINE
// ====================================================

switch (chief_state)
{
    // ============================================
    // STATE 0 — ENTRANCE IDLE
    // ============================================

    case 0:

        advance_chief_animation(
            idle_animation_speed,
            true
        );

        if (carriage.entrance_complete)
        {
            begin_intro_roar();
        }

        break;


    // ============================================
    // STATE 1 — INTRO ROAR ANTICIPATION
    // ============================================

    case 1:

        advance_chief_animation(
            idle_animation_speed,
            true
        );

        if (intro_roar_timer > 0)
        {
            intro_roar_timer--;
        }

        if (intro_roar_timer <= 0)
        {
            begin_roar_start();
        }

        break;


    // ============================================
    // STATE 2 — ROAR START
    // ============================================

    case 2:

        var _finished = advance_chief_animation(
            roar_animation_speed,
            false
        );

        if (_finished)
        {
            begin_roar_loop();
        }

        break;


    // ============================================
    // STATE 3 — ROAR LOOP
    // ============================================

    case 3:

        advance_chief_animation(
            roar_animation_speed,
            true
        );


        // ----------------------------------------
        // Advance separate roar FX animation
        // ----------------------------------------

        var _fx_advance = get_animation_advance(
            roar_fx_sprite,
            roar_fx_animation_speed
        );

        var _fx_count = max(
            1,
            sprite_get_number(roar_fx_sprite)
        );

        roar_fx_frame += _fx_advance;

        roar_fx_frame =
            roar_fx_frame mod _fx_count;


        // ----------------------------------------
        // Roar duration
        // ----------------------------------------

        intro_roar_timer--;

        if (intro_roar_timer <= 0)
        {
            begin_roar_end();
        }

        break;


    // ============================================
    // STATE 4 — ROAR END
    // ============================================

    case 4:

        var _finished = advance_chief_animation(
            roar_animation_speed,
            false
        );

        if (_finished)
        {
            finish_intro_roar();
        }

        break;


    // ============================================
    // STATE 5 — COMBAT IDLE
    // ============================================

    case 5:

        advance_chief_animation(
            idle_animation_speed,
            true
        );


        // ----------------------------------------
        // Post-roar recovery
        // ----------------------------------------

        if (!intro_roar_complete)
        {
            if (intro_roar_timer > 0)
            {
                intro_roar_timer--;
            }

            if (intro_roar_timer <= 0)
            {
                intro_roar_complete = true;
            }
        }

        break;


    // ============================================
    // STATE 6 — SPITTING
    // ============================================

    case 6:

        // ----------------------------------------
        // Advance spit animation
        // ----------------------------------------

        var _spit_finished =
            advance_chief_animation(
                spit_animation_speed,
                false
            );


        // ----------------------------------------
        // Projectile release frame
        //
        // Clamp to the available animation frames.
        // ----------------------------------------

        var _release_frame = clamp(
            floor(spit_release_frame),

            0,

            sprite_get_number(
                spriteScrapChiefSpit
            ) - 1
        );


        // ----------------------------------------
        // Release exactly one projectile
        // ----------------------------------------

        if (
            !spit_released &&
            animation_frame >= _release_frame
        )
        {
            release_spit_projectile();
        }


        // ----------------------------------------
        // Return to combat idle
        // ----------------------------------------

        if (_spit_finished)
        {
            finish_spit_attack();
        }

        break;
}
