/// oChipBankPopup — Create

visible = true;
depth = -100;

from_count = 0;
to_count   = 0;

display_count = from_count;

timer = 0;
timer_max = room_speed * 2.5;

count_delay = room_speed * 0.55;
count_done = false;

alpha = 0;
scale = 1.6;
number_pop_timer = 0;

// Temporary bank sound.
// Replace this later with your dedicated banking sound.
snd_chip_bank = asset_get_index("CollectableChipPickup");
chip_bank_gain = 1.0;