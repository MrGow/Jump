/// oCodecTrigger — Step


// ====================================================
// ALREADY USED
// ====================================================

if (
    activated &&
    one_shot
)
{
    exit;
}


// ====================================================
// ONLY TRIGGER DURING GAMEPLAY
// ====================================================

if (
    variable_global_exists("game_phase") &&
    global.game_phase != "playing"
)
{
    exit;
}


// ====================================================
// DON'T START ANOTHER CODEC
// ====================================================

if (instance_exists(oCodec))
{
    exit;
}


// ====================================================
// PLAYER
// ====================================================

var p =
    instance_find(
        oPlayer,
        0
    );


if (p == noone)
{
    exit;
}


if (
    variable_instance_exists(
        p,
        "state"
    ) &&
    p.state == "dead"
)
{
    exit;
}


// ====================================================
// RECTANGLE OVERLAP
//
// Uses actual scaled bbox.
//
// This means you can freely resize the trigger sprite
// in the room editor.
// ====================================================

var overlap =
    p.bbox_right  > bbox_left  &&
    p.bbox_left   < bbox_right &&
    p.bbox_bottom > bbox_top   &&
    p.bbox_top    < bbox_bottom;


if (!overlap)
{
    exit;
}


// ====================================================
// ACTIVATE
// ====================================================

activated = true;


// Stop current movement immediately.
if (
    variable_instance_exists(
        p,
        "hsp"
    )
)
{
    p.hsp = 0;
}


if (
    variable_instance_exists(
        p,
        "vsp"
    )
)
{
    p.vsp = 0;
}


// ====================================================
// CREATE CODEC
//
// codec_id is supplied BEFORE oCodec Create runs.
// ====================================================

var layer_name =
    layer_exists("GUI")
    ? "GUI"
    : "Instances";


instance_create_layer(
    0,
    0,
    layer_name,
    oCodec,
    {
        codec_id : codec_id
    }
);