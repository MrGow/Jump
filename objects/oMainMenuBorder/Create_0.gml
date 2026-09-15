/// oMainMenuBorder — Create


// ====================================================
// DRAW ABOVE TERMINAL / MENU GUI
// ====================================================

depth = -1050;

visible = true;

persistent = false;


// ====================================================
// BORDER SPRITE
//
// The object itself intentionally has NO assigned sprite.
// We draw this manually in Draw GUI.
// ====================================================

border_sprite =
    asset_get_index(
        "spriteMainMenuBorder"
    );