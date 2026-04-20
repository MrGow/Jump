/// oPauseMenu — Create

depth = -100000;
persistent = false;
visible = true;

menu_items = [
    "Resume",
    "Settings",
    "Controls",
    "Quit to Menu",
    "Quit to Desktop"
];

selected_index = 0;

global.game_phase = "paused";