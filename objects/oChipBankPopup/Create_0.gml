/// oChipBankPopup — Create

from_count = 0;
to_count   = 0;

timer = 0;
timer_max = room_speed * 3.4;

count_delay = room_speed * 0.25;
count_done = false;

display_count = from_count;

alpha = 0;
scale = 1;

// Optional sound later
snd_chip_bank = asset_get_index("ChipBank1");
chip_bank_gain = 1.0;