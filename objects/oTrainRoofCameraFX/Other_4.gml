/// oTrainRoofCameraFX — Room Start

offset_x = 0;
offset_y = 0;

jolt_timer = 0;

jolt_current_x = 0;
jolt_current_y = 0;

micro_jitter_x = 0;
micro_jitter_y = 0;


next_jolt_timer =
    irandom_range(
        jolt_interval_min,
        jolt_interval_max
    );