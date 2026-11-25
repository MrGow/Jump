/// oScrapChiefBossStartTrigger — Step

// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// ALREADY ACTIVATED
// ====================================================

if (activated)
{
    exit;
}


// ====================================================
// FIND CONTROLLER
// ====================================================

if (!instance_exists(controller))
{
    controller = instance_find(
        oScrapChiefController,
        0
    );
}

if (!instance_exists(controller))
{
    exit;
}


// ====================================================
// ELEVATOR SAFETY
// ====================================================

if (
    !controller.sequence_active ||
    controller.sequence_complete
)
{
    exit;
}


// ====================================================
// FIND PLAYER
// ====================================================

var p = instance_find(
    oPlayer,
    0
);

if (p == noone)
{
    exit;
}


// ====================================================
// TRIGGER RECTANGLE
// ====================================================

var left = x;
var top = y;

var right = x + trigger_width;
var bottom = y + trigger_height;


// ====================================================
// PLAYER OVERLAP
// ====================================================

if (
    p.bbox_right >= left &&
    p.bbox_left <= right &&
    p.bbox_bottom >= top &&
    p.bbox_top <= bottom
)
{
    activated = true;

    controller.boss_active = true;

    show_debug_message(
        "SCRAP CHIEF: BOSS ACTIVATED"
    );
}