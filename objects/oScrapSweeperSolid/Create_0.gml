/// oScrapSweeperSolid — Create


// ====================================================
// PARENT
// ====================================================

event_inherited();


// ====================================================
// OWNER
// ====================================================

owner_sweeper = noone;


// ====================================================
// GENERAL
// ====================================================

enabled = true;
active  = true;

visible = false;


// ====================================================
// COLLISION SIZE
//
// spriteScrapSweepSecondPoleMid is 16 x 48.
//
// The owner stretches this helper horizontally to cover
// the complete solid pole/body region.
// ====================================================

solid_width = 16;

image_xscale = 1;
image_yscale = 1;