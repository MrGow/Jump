/// oMainMenu — Create

depth = -100000;
visible = true;

logo_sprite = asset_get_index("spriteJumpBotLogo");
logo_scale  = 0.18;

menu_items = [
    "New Game",
    "Continue",
    "Settings",
    "Quit Game"
];

selected_index = 0;

// Change this to your current first gameplay room
start_room = Scrapyard1;