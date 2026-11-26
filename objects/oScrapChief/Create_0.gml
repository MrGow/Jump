/// oScrapChief — Create

// ====================================================
// CONFIGURATION SAFETY
//
// Only supply defaults if the variables do not exist.
// Never overwrite Variable Definitions.
// ====================================================

if (!variable_instance_exists(id, "chief_id"))
{
    chief_id = 2;
}

if (!variable_instance_exists(id, "chief_mass"))
{
    chief_mass = 16;
}

if (!variable_instance_exists(id, "chief_gravity"))
{
    chief_gravity = 0.35;
}

if (!variable_instance_exists(id, "connector_offset_x"))
{
    connector_offset_x = 0;
}

if (!variable_instance_exists(id, "connector_offset_y"))
{
    connector_offset_y = 0;
}

if (!variable_instance_exists(id, "connector_overlap"))
{
    connector_overlap = 4;
}

if (!variable_instance_exists(id, "idle_animation_speed"))
{
    idle_animation_speed = 1;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// INTRO ROAR CONFIGURATION
// ====================================================

if (!variable_instance_exists(id, "intro_roar_delay"))
{
    intro_roar_delay = 0.5;
}

if (!variable_instance_exists(id, "intro_roar_duration"))
{
    intro_roar_duration = 2.0;
}

if (!variable_instance_exists(id, "roar_animation_speed"))
{
    roar_animation_speed = 1;
}

if (!variable_instance_exists(id, "roar_fx_animation_speed"))
{
    roar_fx_animation_speed = 1;
}

if (!variable_instance_exists(id, "roar_fx_offset_x"))
{
    roar_fx_offset_x = 0;
}

if (!variable_instance_exists(id, "roar_fx_offset_y"))
{
    roar_fx_offset_y = 0;
}

if (!variable_instance_exists(id, "intro_recovery_seconds"))
{
    intro_recovery_seconds = 0.5;
}


// ====================================================
// SPRITE
// ====================================================

sprite_index = spriteScrapChiefIdle;

image_index = 0;
image_speed = 0;

image_xscale = 1;
image_yscale = 1;

image_angle = 0;
image_alpha = 1;
image_blend = c_white;

depth = -110;

visible = false;


// ====================================================
// REFERENCES
// ====================================================

controller = noone;

carriage = noone;
chain = noone;


// ====================================================
// ORIGINAL POSITION
// ====================================================

start_x = x;
start_y = y;

prev_x = x;
prev_y = y;


// ====================================================
// DIMENSIONS
// ====================================================

chief_width = sprite_get_width(
    spriteScrapChiefIdle
);

chief_height = sprite_get_height(
    spriteScrapChiefIdle
);

connector_sprite = spriteScrapChiefConnector;

connector_width = sprite_get_width(
    connector_sprite
);

connector_height = sprite_get_height(
    connector_sprite
);


// ====================================================
// CONNECTOR POSITION
//
// Relative to Chief's top-left origin.
// ====================================================

connector_local_x =
    chief_width * 0.5
    - connector_width * 0.5
    + connector_offset_x;

connector_local_y =
    -connector_height
    + connector_overlap
    + connector_offset_y;


// ====================================================
// SHARED CHAIN PAYLOAD INTERFACE
//
// These names match the existing demolition ball
// interface so the chain requires no changes.
// ====================================================

ball_mass = chief_mass;
ball_gravity = chief_gravity;

ball_attach_offset_x =
    connector_local_x
    + connector_width * 0.5;

ball_attach_offset_y =
    connector_local_y;


// ====================================================
// ATTACHMENT POSITIONS
// ====================================================

ball_attach_x = x + ball_attach_offset_x;
ball_attach_y = y + ball_attach_offset_y;

chain_attach_x = ball_attach_x;
chain_attach_y = ball_attach_y;


// ====================================================
// MOVEMENT
// ====================================================

velocity_x = 0;
velocity_y = 0;

dx = 0;
dy = 0;


// ====================================================
// STATE
// ====================================================

active = false;

dangerous = false;

chain_attached = false;


// ====================================================
// ANIMATION
// ====================================================

animation_frame = 0;


// ====================================================
// CHIEF STATE MACHINE
//
// 0 = Entrance idle
// 1 = Intro roar anticipation
// 2 = Roar start
// 3 = Roar loop
// 4 = Roar end
// 5 = Combat idle
// ====================================================

chief_state = 0;


// ====================================================
// INTRO ROAR STATE
// ====================================================

intro_roar_started = false;
intro_roar_complete = false;

intro_roar_timer = 0;


// ====================================================
// ROAR FX
// ====================================================

roar_fx_sprite = spriteScrapChiefRoarFX;

roar_fx_active = false;

roar_fx_frame = 0;


// ====================================================
// GET ANIMATION ADVANCE
//
// Convert the sprite's configured animation speed
// into frames per game step.
// ====================================================

get_animation_advance = function(_sprite, _multiplier)
{
    var _speed = sprite_get_speed(_sprite);

    var _speed_type = sprite_get_speed_type(
        _sprite
    );

    if (_speed_type == spritespeed_framespersecond)
    {
        _speed /= max(1, room_speed);
    }

    return max(0, _speed * _multiplier);
};


// ====================================================
// SET CHIEF ANIMATION
// ====================================================

set_chief_animation = function(_sprite)
{
    sprite_index = _sprite;

    animation_frame = 0;

    image_index = 0;
    image_speed = 0;
};


// ====================================================
// ADVANCE CHIEF ANIMATION
//
// Returns true when a non-looping animation finishes.
// ====================================================

advance_chief_animation = function(
    _multiplier,
    _loop
)
{
    var _frame_count = max(
        1,
        sprite_get_number(sprite_index)
    );

    var _advance = get_animation_advance(
        sprite_index,
        _multiplier
    );

    animation_frame += _advance;

    if (_loop)
    {
        animation_frame =
            animation_frame mod _frame_count;

        image_index = floor(animation_frame);

        return false;
    }

    if (animation_frame >= _frame_count)
    {
        animation_frame = _frame_count - 1;

        image_index = _frame_count - 1;

        return true;
    }

    image_index = floor(animation_frame);

    return false;
};


// ====================================================
// BEGIN INTRO ROAR
// ====================================================

begin_intro_roar = function()
{
    if (intro_roar_started)
    {
        return;
    }

    intro_roar_started = true;
    intro_roar_complete = false;

    intro_roar_timer = max(
        0,
        round(intro_roar_delay * room_speed)
    );

    chief_state = 1;
};


// ====================================================
// BEGIN ROAR START
// ====================================================

begin_roar_start = function()
{
    chief_state = 2;

    roar_fx_active = false;
    roar_fx_frame = 0;

    set_chief_animation(
        spriteScrapChiefRoarStart
    );
};


// ====================================================
// BEGIN ROAR LOOP
// ====================================================

begin_roar_loop = function()
{
    chief_state = 3;

    intro_roar_timer = max(
        1,
        round(intro_roar_duration * room_speed)
    );

    roar_fx_active = true;
    roar_fx_frame = 0;

    set_chief_animation(
        spriteScrapChiefRoarLoop
    );
};


// ====================================================
// BEGIN ROAR END
// ====================================================

begin_roar_end = function()
{
    chief_state = 4;

    roar_fx_active = false;
    roar_fx_frame = 0;

    set_chief_animation(
        spriteScrapChiefRoarEnd
    );
};



// ====================================================
// FINISH INTRO ROAR
//
// Return to idle immediately, but delay permission
// for the controller to begin the first attack.
// ====================================================

finish_intro_roar = function()
{
    chief_state = 5;

    intro_roar_complete = false;

    intro_roar_timer = max(
        0,
        round(
            intro_recovery_seconds *
            room_speed
        )
    );

    roar_fx_active = false;
    roar_fx_frame = 0;

    set_chief_animation(
        spriteScrapChiefIdle
    );

    if (intro_roar_timer <= 0)
    {
        intro_roar_complete = true;
    }
};



// ====================================================
// UPDATE ATTACHMENT
// ====================================================

update_attachment = function()
{
    ball_attach_x =
        x + ball_attach_offset_x;

    ball_attach_y =
        y + ball_attach_offset_y;

    chain_attach_x = ball_attach_x;
    chain_attach_y = ball_attach_y;
};


// ====================================================
// RESET CHIEF
// ====================================================

reset_chief = function()
{
    x = start_x;
    y = start_y;

    prev_x = x;
    prev_y = y;

    velocity_x = 0;
    velocity_y = 0;

    dx = 0;
    dy = 0;

    active = false;
    dangerous = false;

    visible = false;

    carriage = noone;
    chain = noone;

    chain_attached = false;


    // --------------------------------------------
    // Reset state machine
    // --------------------------------------------

    chief_state = 0;

    intro_roar_started = false;
    intro_roar_complete = false;

    intro_roar_timer = 0;


    // --------------------------------------------
    // Reset roar FX
    // --------------------------------------------

    roar_fx_active = false;
    roar_fx_frame = 0;


    // --------------------------------------------
    // Reset animation
    // --------------------------------------------

    sprite_index = spriteScrapChiefIdle;

    animation_frame = 0;

    image_index = 0;
    image_speed = 0;

    update_attachment();
};


// ====================================================
// HEAD ANIMATION ALIGNMENT
//
// Compensate for vertical movement within each
// animation's transparent sprite canvas.
//
// These offsets are purely visual and do not
// affect the chain or payload physics.
// ====================================================

if (!variable_instance_exists(id, "head_alignment_strength"))
{
    head_alignment_strength = 1.0;
}


// ====================================================
// FRAME-SPECIFIC OFFSETS
// ====================================================

// Idle — 8 frames.

head_offset_idle = [
    0,
    2,
    5,
    6,
    8,
    5,
    3,
    1
];


// Roar Start — 9 frames.

head_offset_roar_start = [
    0,
    1,
    2,
    3,
    5,
    7,
    14,
    17,
    20
];


// Roar Loop — 6 frames.

head_offset_roar_loop = [
    20,
    19,
    20,
    19,
    19,
    20
];


// Roar End — 9 frames.

// Roar End — 9 frames.

head_offset_roar_end = [
    20,
    17,
    14,
    7,
    5,
    3,
    2,
    1,
    0
];


// ====================================================
// GET HEAD ALIGNMENT OFFSET
// ====================================================

get_head_alignment_y = function()
{
    var _offsets = [];

    switch (sprite_index)
    {
        case spriteScrapChiefIdle:

            _offsets = head_offset_idle;

            break;


        case spriteScrapChiefRoarStart:

            _offsets = head_offset_roar_start;

            break;


        case spriteScrapChiefRoarLoop:

            _offsets = head_offset_roar_loop;

            break;


        case spriteScrapChiefRoarEnd:

            _offsets = head_offset_roar_end;

            break;


        default:

            return 0;
    }


    var _frame = clamp(
        floor(image_index),
        0,
        array_length(_offsets) - 1
    );

    return
        _offsets[_frame] *
        head_alignment_strength;
};


// ====================================================
// SPIT ATTACK CONFIGURATION
// ====================================================

if (!variable_instance_exists(id, "spit_animation_speed"))
{
    spit_animation_speed = 1.0;
}

if (!variable_instance_exists(id, "spit_release_frame"))
{
    spit_release_frame = 8;
}

if (!variable_instance_exists(id, "spit_mouth_offset_x"))
{
    spit_mouth_offset_x = 192;
}

if (!variable_instance_exists(id, "spit_mouth_offset_y"))
{
    spit_mouth_offset_y = 210;
}

if (!variable_instance_exists(id, "spit_arc_height"))
{
    spit_arc_height = 24;
}

if (!variable_instance_exists(id, "spit_flight_seconds"))
{
    spit_flight_seconds = 1.1;
}

if (!variable_instance_exists(id, "spit_rotation_speed"))
{
    spit_rotation_speed = 4;
}

if (!variable_instance_exists(id, "spit_test_enabled"))
{
    spit_test_enabled = false;
}


// ====================================================
// SPIT ATTACK STATE
// ====================================================

spit_active = false;
spit_complete = true;

spit_released = false;

spit_mode = 0;


// ====================================================
// BEGIN SPIT ATTACK
//
// Mode 0 = Aim at player.
//
// Additional targeting modes can be added later.
// ====================================================

begin_spit_attack = function(_mode)
{
    if (
        !active ||
        !visible ||
        !chain_attached
    )
    {
        return false;
    }

    if (
        chief_state != 5 ||
        !intro_roar_complete ||
        spit_active
    )
    {
        return false;
    }

    if (!instance_exists(controller))
    {
        controller = instance_find(
            oScrapChiefController,
            0
        );
    }

    if (!instance_exists(controller))
    {
        return false;
    }

    if (!instance_exists(controller.platform))
    {
        return false;
    }


    // --------------------------------------------
    // Initialize attack
    // --------------------------------------------

    spit_mode = _mode;

    spit_active = true;
    spit_complete = false;
    spit_released = false;

    chief_state = 6;

    set_chief_animation(
        spriteScrapChiefSpit
    );

    return true;
};


// ====================================================
// RELEASE SPIT PROJECTILE
// ====================================================

release_spit_projectile = function()
{
    if (spit_released)
    {
        return;
    }

    spit_released = true;

    if (!instance_exists(controller))
    {
        return;
    }

    if (!instance_exists(controller.platform))
    {
        return;
    }

    var p = instance_find(
        oPlayer,
        0
    );

    if (p == noone)
    {
        return;
    }

    var elevator = controller.platform;


    // --------------------------------------------
    // Mouth position
    //
    // Relative to Chief's current drawing origin.
    // --------------------------------------------

    // --------------------------------------------
	// Mouth position
	//
	// Account for the head's visual alignment.
	// --------------------------------------------

	var spawn_x =
		round(x) +
		spit_mouth_offset_x;

	var spawn_y =
		round(y + get_head_alignment_y()) +
		spit_mouth_offset_y;


    // --------------------------------------------
    // Target position
    // --------------------------------------------

    var target_x =
        (p.bbox_left + p.bbox_right) * 0.5;

    var target_y =
        (p.bbox_top + p.bbox_bottom) * 0.5;


    // --------------------------------------------
    // Keep target within elevator boundaries.
    // --------------------------------------------

    target_x = clamp(
        target_x,

        elevator.bbox_left +
        elevator.surface_inset_left,

        elevator.bbox_right -
        elevator.surface_inset_right
    );


    // --------------------------------------------
    // Create projectile
    // --------------------------------------------

    var scrap = instance_create_depth(
        spawn_x,
        spawn_y,
        -115,
        oScrapChiefSpitProjectile
    );

    scrap.initialize_aimed_spit(
        controller,
        target_x,
        target_y,
        spit_flight_seconds,
        spit_arc_height,
        spit_rotation_speed
    );
};


// ====================================================
// FINISH SPIT ATTACK
// ====================================================

finish_spit_attack = function()
{
    spit_active = false;
    spit_complete = true;

    chief_state = 5;

    set_chief_animation(
        spriteScrapChiefIdle
    );
};

