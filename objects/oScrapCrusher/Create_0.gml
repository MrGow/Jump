/// oScrapCrusher — Create (FULL)
event_inherited();

if (!variable_instance_exists(id,"enabled")) enabled = true;
if (!variable_instance_exists(id,"active"))  active  = true;

// --- Crusher loop SFX ---
snd_crusher_loop = asset_get_index("ScrapCrusherLoopSound1");
crusher_loop_instance = noone;
crusher_loop_started  = false;

crusher_loop_gain_max = 0.14;
crusher_loop_inner_dist = 55;
crusher_loop_outer_dist = 180;
crusher_loop_pitch = 1.0;

// --- Kill tuning ---
if (!variable_instance_exists(id,"kill_band_h"))           kill_band_h = 6;
if (!variable_instance_exists(id,"kill_depth_px"))         kill_depth_px = 2;
if (!variable_instance_exists(id,"kill_inset_x"))          kill_inset_x = 12;
if (!variable_instance_exists(id,"kill_headroom_px"))      kill_headroom_px = 2;
if (!variable_instance_exists(id,"sink_px"))               sink_px = 6;
if (!variable_instance_exists(id,"kill_only_when_falling")) kill_only_when_falling = false;

if (!variable_instance_exists(id,"debug_draw")) debug_draw = false;

// Optional animated active frames
if (!variable_instance_exists(id,"use_active_frames")) use_active_frames = false;
if (!variable_instance_exists(id,"active_from")) active_from = 0;
if (!variable_instance_exists(id,"active_to"))   active_to   = 999999;

// IMPORTANT: freeze the kill surface/extents so bbox changes per frame don't break detection
kill_surface_y = bbox_top;
kill_left      = bbox_left;
kill_right     = bbox_right;