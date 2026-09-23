/// oScrapSweeper — Create


// ====================================================
// GENERAL
// ====================================================

depth = -900;

visible = true;


// ====================================================
// EDITOR VARIABLES
// ====================================================

if (!variable_instance_exists(id, "facing"))
{
    facing = 1;
}

if (!variable_instance_exists(id, "second_pole_repeats"))
{
    second_pole_repeats = 4;
}

if (!variable_instance_exists(id, "enabled"))
{
    enabled = true;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = false;
}


// ====================================================
// NORMALIZE
// ====================================================

facing =
    (facing < 0)
    ? -1
    : 1;

second_pole_repeats =
    max(
        0,
        round(
            second_pole_repeats
        )
    );


// ====================================================
// ART DIMENSIONS
// ====================================================

base_back_width =
    sprite_get_width(
        spriteScrapSweepBaseBack
    );

base_front_width =
    sprite_get_width(
        spriteScrapSweepBaseFront
    );

first_base_width =
    sprite_get_width(
        spriteScrapSweepFirstPoleBase
    );

first_mid_width =
    sprite_get_width(
        spriteScrapSweepFirstPoleMid
    );

first_end_width =
    sprite_get_width(
        spriteScrapSweepFirstPoleEnd
    );

second_mid_width =
    sprite_get_width(
        spriteScrapSweepSecondPoleMid
    );

spike_width =
    sprite_get_width(
        spriteScrapSweepSpikes
    );

pole_height =
    sprite_get_height(
        spriteScrapSweepSecondPoleMid
    );

spike_height =
    sprite_get_height(
        spriteScrapSweepSpikes
    );


// ====================================================
// ASSEMBLY
//
// x/y = centre of wall mounting.
//
// VISUAL ORDER:
//
// BaseBack
// FirstPoleBase
// FirstPoleMid
// FirstPoleEnd
// SecondPoleMid x N
// Spikes
// BaseFront overlay
//
// BaseBack and BaseFront occupy the SAME position.
//
// BaseBack is drawn behind the pole.
// BaseFront is drawn over the pole.
//
// This makes the pole appear mounted inside the base.
// ====================================================


// ====================================================
// WALL MOUNT
// ====================================================

offset_base_back = 0;
offset_base_front = 0;


// ====================================================
// FIRST POLE BASE
//
// Begins inside the wall mounting.
// ====================================================

offset_first_base =
    first_base_width * 0.5;


// ====================================================
// FIRST / THICK POLE
// ====================================================

offset_first_mid =
    offset_first_base
    +
    first_base_width * 0.5
    +
    first_mid_width * 0.5;


// ====================================================
// CENTRAL COLLAR
// ====================================================

offset_first_end =
    offset_first_mid
    +
    first_mid_width * 0.5
    +
    first_end_width * 0.5;


// ====================================================
// SECOND / THIN POLE
//
// This begins immediately after FirstPoleEnd.
// ====================================================

offset_second_start =
    offset_first_end
    +
    first_end_width * 0.5;


// ====================================================
// SPIKES
//
// Spikes attach DIRECTLY to the end of the repeatable
// second pole.
//
// There is no reused FirstPoleBase at this end.
// ====================================================

offset_spikes =
    offset_second_start
    +
    (
        second_pole_repeats *
        second_mid_width
    )
    +
    spike_width * 0.5;


// ====================================================
// PHYSICAL BODY
//
// Everything from the wall mounting to the end of the
// second pole is solid but harmless.
//
// The spike assembly is handled separately as lethal.
// ====================================================

body_start_offset =
    -base_back_width * 0.5;

body_end_offset =
    offset_second_start
    +
    (
        second_pole_repeats *
        second_mid_width
    );

body_solid_width =
    body_end_offset -
    body_start_offset;

body_solid_centre_offset =
    (
        body_start_offset +
        body_end_offset
    )
    * 0.5;

body_solid_centre_x =
    x +
    facing *
    body_solid_centre_offset;


// ====================================================
// SPIKE HITBOX
// ====================================================

spike_hitbox_inset_x = 4;
spike_hitbox_inset_y = 4;


// ====================================================
// CREATE SOLID BODY
// ====================================================

solid_inst =
    instance_create_layer(
        body_solid_centre_x,
        y,
        "Instances",
        oScrapSweeperSolid
    );

if (instance_exists(solid_inst))
{
    solid_inst.owner_sweeper =
        id;

    solid_inst.solid_width =
        body_solid_width;

    solid_inst.image_xscale =
        body_solid_width / 16;

    solid_inst.image_yscale =
        1;

    solid_inst.visible =
        false;
}


// ====================================================
// CRUSH STATE
// ====================================================

crush_tolerance = 2;