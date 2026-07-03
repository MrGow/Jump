/// oCreditsController — Step

timer++;

var total_card_time = fade_in_frames + hold_frames + fade_out_frames;

if (timer >= total_card_time)
{
    timer = 0;
    credit_index++;

    if (credit_index >= array_length(credits))
    {
        global.game_phase = "main_menu";
        room_goto(MainMenuBackground);
    }
}