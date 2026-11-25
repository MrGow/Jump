/// oScrapChiefChain — Create

// ====================================================
// REFERENCES
// ====================================================

carriage = noone;
payload = noone;

initialized = false;


// ====================================================
// DRAWING
// ====================================================

depth = -125;

visible = true;

chain_sprite = spriteScrapChiefTilingChain;

chain_sprite_width =
    sprite_get_width(chain_sprite);

chain_sprite_height =
    sprite_get_height(chain_sprite);


// ====================================================
// CHAIN CONFIGURATION
// ====================================================

chain_length = 100;
target_length = 100;

minimum_length = 8;
maximum_length = 280;

retract_speed = 2;
extend_speed = 3;


// ====================================================
// PHYSICS CONFIGURATION
// ====================================================

segment_count = 12;

constraint_iterations = 16;

chain_gravity = 0.30;

chain_damping = 0.985;

payload_gravity = 0.35;

payload_mass = 8;


// ====================================================
// CHAIN POINTS
// ====================================================

point_x = [];
point_y = [];

previous_x = [];
previous_y = [];


// ====================================================
// DEBUG
// ====================================================

debug_draw = false;


// ====================================================
// INITIALIZE CHAIN
// ====================================================

initialize_chain = function(
    _carriage,
    _payload,
    _length
)
{
    carriage = _carriage;
    payload = _payload;

    chain_length = clamp(
        _length,
        minimum_length,
        maximum_length
    );

    target_length = chain_length;

    var anchor_x = carriage.attachment_x;
    var anchor_y = carriage.attachment_y;

    var segment_length =
        chain_length / segment_count;


    // --------------------------------------------
    // Build straight hanging chain
    // --------------------------------------------

    for (var i = 0; i <= segment_count; i++)
    {
        point_x[i] = anchor_x;

        point_y[i] =
            anchor_y + segment_length * i;

        previous_x[i] = point_x[i];
        previous_y[i] = point_y[i];
    }


    // --------------------------------------------
    // Attach payload
    // --------------------------------------------

    payload.carriage = carriage;
    payload.chain = id;

    payload.chain_attached = true;

    payload_gravity = payload.ball_gravity;
    payload_mass = payload.ball_mass;

    payload.x =
        point_x[segment_count] -
        payload.ball_attach_offset_x;

    payload.y =
        point_y[segment_count] -
        payload.ball_attach_offset_y;

    payload.prev_x = payload.x;
    payload.prev_y = payload.y;

    payload.dx = 0;
    payload.dy = 0;

    payload.update_attachment();

    payload.visible = carriage.visible;

    initialized = true;
};


// ====================================================
// SET TARGET LENGTH
// ====================================================

set_chain_length = function(_length)
{
    target_length = clamp(
        _length,
        minimum_length,
        maximum_length
    );
};


// ====================================================
// RETRACT CHAIN
// ====================================================

retract_chain = function(_amount)
{
    set_chain_length(
        target_length - abs(_amount)
    );
};


// ====================================================
// EXTEND CHAIN
// ====================================================

extend_chain = function(_amount)
{
    set_chain_length(
        target_length + abs(_amount)
    );
};