/// oGhostBot — Step

// ====================================================
// LIGHT PULSE
// ====================================================

// Advance pulse timer
light_pulse_timer += 1;

// Keep timer within cycle
if (light_pulse_timer >= light_pulse_duration)
{
    light_pulse_timer = 0;
}

// Convert timer to angle
var pulse_angle =
    (light_pulse_timer / light_pulse_duration)
    * pi * 2;

// Smooth breathing motion
var pulse = sin(pulse_angle);

// Calculate visual radius
light_visual_radius =
    light_radius
    + pulse * light_pulse_amount;