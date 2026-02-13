/// oScrapCrusher — Create (FULL)
event_inherited();

if (!variable_instance_exists(id,"enabled")) enabled = true;
if (!variable_instance_exists(id,"active"))  active  = true;

// --- Kill tuning (defaults; can override per instance in editor) ---
if (!variable_instance_exists(id,"kill_band_h"))           kill_band_h = 6;   // vertical band thickness
if (!variable_instance_exists(id,"kill_depth_px"))         kill_depth_px = 2; // must be THIS deep into band to kill
if (!variable_instance_exists(id,"kill_inset_x"))          kill_inset_x = 12; // shrink kill width to match oblique top
if (!variable_instance_exists(id,"kill_headroom_px"))      kill_headroom_px = 2; // only used with 'crossed' (safe)
if (!variable_instance_exists(id,"sink_px"))               sink_px     = 6;  // how deep feet lock into teeth
if (!variable_instance_exists(id,"kill_only_when_falling")) kill_only_when_falling = false;

if (!variable_instance_exists(id,"debug_draw")) debug_draw = false;

// Optional animated “active frames”
if (!variable_instance_exists(id,"use_active_frames")) use_active_frames = false;
if (!variable_instance_exists(id,"active_from")) active_from = 0;
if (!variable_instance_exists(id,"active_to"))   active_to   = 999999;

// IMPORTANT: freeze the kill surface/extents so bbox changes per frame don't break detection
kill_surface_y = bbox_top;
kill_left      = bbox_left;
kill_right     = bbox_right;
