/// oGrabber — Step

// ====================================================
// FRAME MOVEMENT
// ====================================================

dx = 0;
dy = 0;


// ====================================================
// HOT-RELOAD SAFETY
// ====================================================

if (!variable_instance_exists(id, "route_id"))
{
    route_id = 0;
}

if (!variable_instance_exists(id, "move_speed"))
{
    move_speed = 2.0;
}

if (!variable_instance_exists(id, "close_animation_speed"))
{
    close_animation_speed = 0.25;
}

if (!variable_instance_exists(id, "open_animation_speed"))
{
    open_animation_speed = 0.25;
}

if (!variable_instance_exists(id, "destination"))
{
    destination = noone;
}

if (!variable_instance_exists(id, "grabbed_player"))
{
    grabbed_player = noone;
}

if (!variable_instance_exists(id, "grab_state"))
{
    grab_state = "idle";
}

if (!variable_instance_exists(id, "release_armed"))
{
    release_armed = false;
}

if (!variable_instance_exists(id, "claw_opening"))
{
    claw_opening = false;
}

if (!variable_instance_exists(id, "start_x"))
{
    start_x = x;
}

if (!variable_instance_exists(id, "start_y"))
{
    start_y = y;
}

if (!variable_instance_exists(id, "last_dx"))
{
    last_dx = 0;
}

if (!variable_instance_exists(id, "release_momentum"))
{
    release_momentum = 1.0;
}

if (!variable_instance_exists(id, "release_vsp"))
{
    release_vsp = 0;
}

if (!variable_instance_exists(id, "capture_half_width"))
{
    capture_half_width = 16;
}

if (!variable_instance_exists(id, "capture_top_offset"))
{
    capture_top_offset = 0;
}

if (!variable_instance_exists(id, "capture_bottom_offset"))
{
    capture_bottom_offset = 28;
}

if (!variable_instance_exists(id, "player_hold_top_offset"))
{
    player_hold_top_offset = 10;
}


// ====================================================
// PAUSE / MENU FREEZE
// ====================================================

var freeze_grabber = false;

if (variable_global_exists("game_phase"))
{
    freeze_grabber =
        global.game_phase == "paused" ||
        global.game_phase == "menu" ||
        global.game_phase == "death_menu" ||
        global.game_phase == "codec";
}

if (freeze_grabber)
{
    image_speed = 0;
    exit;
}


// ====================================================
// FIND MATCHING DESTINATION
// ====================================================

if (!instance_exists(destination))
{
    destination = noone;

    var destination_count =
        instance_number(oGrabberTarget);

    for (
        var destination_index = 0;
        destination_index < destination_count;
        destination_index++
    )
    {
        var candidate =
            instance_find(
                oGrabberTarget,
                destination_index
            );

        if (
            instance_exists(candidate) &&
            variable_instance_exists(
                candidate,
                "target_id"
            ) &&
            candidate.target_id == route_id
        )
        {
            destination = candidate;
            break;
        }
    }
}


// ====================================================
// FIND PLAYER
// ====================================================

var player = noone;

if (instance_exists(oPlayer))
{
    player =
        instance_find(
            oPlayer,
            0
        );
}


// ====================================================
// PLAYER DEATH RESET
// ====================================================

var player_dead = false;

if (
    instance_exists(player) &&
    variable_instance_exists(
        player,
        "state"
    )
)
{
    player_dead =
        player.state == "dead";
}

if (player_dead)
{
    if (instance_exists(grabbed_player))
    {
        if (
            variable_instance_exists(
                grabbed_player,
                "grabbed_by"
            )
        )
        {
            grabbed_player.grabbed_by =
                noone;
        }
    }

    grabbed_player = noone;

    release_armed = false;
    claw_opening = false;

    x = start_x;
    y = start_y;

    dx = 0;
    dy = 0;
    last_dx = 0;

    grab_state = "idle";

    image_speed = 0;

    image_index =
        max(
            0,
            image_number - 1
        );

    exit;
}


// ====================================================
// LOST PLAYER SAFETY
// ====================================================

if (
    grab_state == "closing" ||
    grab_state == "moving" ||
    grab_state == "parked"
)
{
    if (
        grabbed_player != noone &&
        !instance_exists(grabbed_player)
    )
    {
        grabbed_player = noone;
        release_armed = false;

        claw_opening = true;
        image_speed = 0;

        if (grab_state == "closing")
        {
            grab_state = "moving";
        }
    }
}


// ====================================================
// IDLE — WAIT OPEN FOR PLAYER
// ====================================================

if (grab_state == "idle")
{
    image_speed = 0;

    image_index =
        max(
            0,
            image_number - 1
        );

    claw_opening = false;
    last_dx = 0;

    if (!instance_exists(player))
    {
        exit;
    }


    // ------------------------------------------------
    // CHECK WHETHER PLAYER CAN BE CAPTURED
    // ------------------------------------------------

    var can_capture = true;

    if (
        variable_instance_exists(
            player,
            "state"
        ) &&
        player.state == "dead"
    )
    {
        can_capture = false;
    }

    if (
        variable_instance_exists(
            player,
            "grabbed_by"
        ) &&
        instance_exists(player.grabbed_by)
    )
    {
        can_capture = false;
    }


    // ------------------------------------------------
    // CAPTURE RECTANGLE
    // ------------------------------------------------

    var captured_instance =
        collision_rectangle(
            x - capture_half_width,
            y + capture_top_offset,
            x + capture_half_width,
            y + capture_bottom_offset,
            oPlayer,
            false,
            true
        );

    var touching_capture_area =
        captured_instance == player;


    // ------------------------------------------------
    // CAPTURE PLAYER
    // ------------------------------------------------

    if (
        can_capture &&
        touching_capture_area
    )
    {
        grabbed_player = player;

        grabbed_player.grabbed_by =
            id;

        grabbed_player.hsp = 0;
        grabbed_player.vsp = 0;

        grabbed_player.standing_platform =
            noone;

        grabbed_player.standing_platform_xoff =
            0;

        grabbed_player.jump_charging =
            false;

        grabbed_player.jump_charge =
            0;

        grabbed_player.jump_charge_level =
            0;

        grabbed_player.charge_grace =
            0;

        grabbed_player.support_grace =
            0;

        grabbed_player.charge_start_lock =
            0;

        grabbed_player.edge_charge_fail =
            0;

        grabbed_player.bounce_pending =
            false;

        grabbed_player.bounce_timer =
            0;

        grabbed_player.coyote_timer =
            0;

        grabbed_player.state =
            "grabbed";


        // Begin on the fully open frame.
        image_index =
            max(
                0,
                image_number - 1
            );

        image_speed = 0;

        claw_opening = false;
        grab_state = "closing";

        // The player must release the jump used to reach
        // the claw before another jump can release them.
        release_armed = false;
    }

    exit;
}


// ====================================================
// HOLD PLAYER BENEATH CLAW
// ====================================================

if (instance_exists(grabbed_player))
{
    var desired_player_top =
        y + player_hold_top_offset;

    grabbed_player.x =
        x;

    // Origin-independent hanging position.
    grabbed_player.y +=
        desired_player_top -
        grabbed_player.bbox_top;

    grabbed_player.hsp = 0;
    grabbed_player.vsp = 0;

    grabbed_player.standing_platform =
        noone;

    grabbed_player.standing_platform_xoff =
        0;

    grabbed_player.jump_charging =
        false;

    grabbed_player.jump_charge =
        0;

    grabbed_player.jump_charge_level =
        0;

    grabbed_player.state =
        "grabbed";


    // ------------------------------------------------
    // JUMP HELD
    // ------------------------------------------------

    var jump_held = false;

    if (variable_global_exists("inp_jump_held"))
    {
        jump_held =
            global.inp_jump_held;
    }
    else
    {
        jump_held =
            keyboard_check(vk_space);
    }

    if (!jump_held)
    {
        release_armed = true;
    }


    // ------------------------------------------------
    // FRESH JUMP PRESS
    // ------------------------------------------------

    var jump_pressed = false;

    if (variable_global_exists("inp_jump_press"))
    {
        jump_pressed =
            global.inp_jump_press;
    }
    else
    {
        jump_pressed =
            keyboard_check_pressed(vk_space);
    }


    // ------------------------------------------------
    // RELEASE PLAYER
    // ------------------------------------------------

    if (
        release_armed &&
        jump_pressed
    )
    {
        var released_player =
            grabbed_player;

        grabbed_player = noone;
        release_armed = false;

        // Start playing the claw animation normally,
        // from its current frame towards fully open.
        claw_opening = true;
        image_speed = 0;

        // If the player releases before the claw has
        // completely closed, stop closing immediately
        // and allow the grabber to continue its route.
        if (grab_state == "closing")
        {
            grab_state = "moving";
        }

        released_player.grabbed_by =
            noone;

        released_player.hsp =
            last_dx *
            release_momentum;

        released_player.vsp =
            release_vsp;

        released_player.standing_platform =
            noone;

        released_player.standing_platform_xoff =
            0;

        released_player.jump_charging =
            false;

        released_player.jump_charge =
            0;

        released_player.jump_charge_level =
            0;

        released_player.charge_grace =
            0;

        released_player.support_grace =
            0;

        released_player.charge_start_lock =
            0;

        released_player.edge_charge_fail =
            0;

        released_player.bounce_pending =
            false;

        released_player.bounce_timer =
            0;

        released_player.state =
            "glide";

        // Prevent the release press from immediately
        // becoming a normal charged jump.
        released_player.prev_jump_h =
            true;
    }
}


// ====================================================
// OPENING ANIMATION
//
// The normal sprite direction is closed to open.
// This runs while the grabber continues moving.
// ====================================================

if (claw_opening)
{
    image_speed = 0;

    image_index =
        min(
            image_number - 1,
            image_index +
            open_animation_speed
        );

    if (image_index >= image_number - 1)
    {
        image_index =
            image_number - 1;

        image_speed = 0;
        claw_opening = false;
    }
}


// ====================================================
// CLOSING ANIMATION
//
// Advance backwards manually so frame 0 cannot wrap
// back to the final open frame.
// ====================================================

if (grab_state == "closing")
{
    image_speed = 0;
    claw_opening = false;

    image_index =
        max(
            0,
            image_index -
            close_animation_speed
        );

    if (image_index <= 0)
    {
        image_index = 0;
        image_speed = 0;

        grab_state = "moving";
    }

    exit;
}


// ====================================================
// MOVE HORIZONTALLY TO DESTINATION
// ====================================================

if (grab_state == "moving")
{
    image_speed = 0;


    // ------------------------------------------------
    // ANIMATION STATE
    // ------------------------------------------------

    if (instance_exists(grabbed_player))
    {
        // Remain closed while holding the player.
        image_index = 0;
        claw_opening = false;
    }
    else if (!claw_opening)
    {
        // Released and opening animation completed.
        image_index =
            image_number - 1;
    }


    // ------------------------------------------------
    // DESTINATION SAFETY
    // ------------------------------------------------

    if (!instance_exists(destination))
    {
        dx = 0;
        dy = 0;
        last_dx = 0;

        exit;
    }


    // ------------------------------------------------
    // HORIZONTAL MOVEMENT
    // ------------------------------------------------

    var old_x =
        x;

    var remaining_x =
        destination.x - x;

    if (abs(remaining_x) <= move_speed)
    {
        x =
            destination.x;
    }
    else
    {
        x +=
            sign(remaining_x) *
            move_speed;
    }

    // Horizontal routes do not use the target's Y.
    y = start_y;

    dx =
        x - old_x;

    dy = 0;

    last_dx =
        dx;


    // ------------------------------------------------
    // REPOSITION HELD PLAYER AFTER MOVEMENT
    // ------------------------------------------------

    if (instance_exists(grabbed_player))
    {
        var moved_player_top =
            y + player_hold_top_offset;

        grabbed_player.x =
            x;

        grabbed_player.y +=
            moved_player_top -
            grabbed_player.bbox_top;

        grabbed_player.hsp = 0;
        grabbed_player.vsp = 0;
        grabbed_player.state = "grabbed";
    }


    // ------------------------------------------------
    // DESTINATION REACHED
    // ------------------------------------------------

    if (abs(x - destination.x) <= 0.01)
    {
        x =
            destination.x;

        grab_state =
            "parked";
    }

    exit;
}


// ====================================================
// PARKED AT END OF RAIL
// ====================================================

if (grab_state == "parked")
{
    image_speed = 0;

    dx = 0;
    dy = 0;
    last_dx = 0;


    // ------------------------------------------------
    // ANIMATION STATE
    // ------------------------------------------------

    if (instance_exists(grabbed_player))
    {
        image_index = 0;
        claw_opening = false;
    }
    else if (!claw_opening)
    {
        image_index =
            image_number - 1;
    }


    // ------------------------------------------------
    // KEEP HOLDING PLAYER
    // ------------------------------------------------

    if (instance_exists(grabbed_player))
    {
        var parked_player_top =
            y + player_hold_top_offset;

        grabbed_player.x =
            x;

        grabbed_player.y +=
            parked_player_top -
            grabbed_player.bbox_top;

        grabbed_player.hsp = 0;
        grabbed_player.vsp = 0;
        grabbed_player.state = "grabbed";
    }
}