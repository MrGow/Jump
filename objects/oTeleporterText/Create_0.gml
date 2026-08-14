/// oTeleporterText — Create

owner_teleporter = noone;


// ====================================================
// DRAW IN FRONT OF PLAYER
//
// oPlayer uses:
//     depth = -1000;
//
// Lower depth = farther forward in GameMaker.
// ====================================================

depth = -1001;


// ====================================================
// VISUAL
// ====================================================

visible = true;

// No actual sprite.
// Draw event handles the text.
sprite_index = -1;