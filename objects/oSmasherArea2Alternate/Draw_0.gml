/// oSmasherArea2Alternate — Draw
var rod_start_y = base_y + top_h - head_overlap;
var rod_end_y = head_y + 8;
var rod_height = max(0, round(rod_end_y - rod_start_y));
if (spr_hydraulic != -1 && rod_height > 0)
{
    draw_sprite_part_ext(spr_hydraulic, 0, 0, 0, hydraulic_w, 1, round(hydraulic_x), round(rod_start_y), 1, rod_height, c_white, 1);
}
// MOVING HEAD: NORMAL OR FAST VISUAL SMEAR
var _head_visual = spr_bottom;
if (smash_blur_enabled && spr_bottom_fast != -1 && smash_state == "descending")
{
    var _total_travel = max(1, smash_distance + windup_distance);
    var _eased_progress = clamp((head_offset + windup_distance) / _total_travel, 0, 1);
    var _descent_progress = sqrt(_eased_progress);
    if (_descent_progress >= smash_blur_start && _descent_progress < smash_blur_end)
        _head_visual = spr_bottom_fast;
}
if (_head_visual != -1)
{
    var _visual_w = sprite_get_width(_head_visual);
    var _visual_h = sprite_get_height(_head_visual);
    var _visual_left = round(center_x - _visual_w * 0.5);
    var _visual_top = round(head_y + bottom_h - _visual_h);
    if (_head_visual == spr_bottom_fast)
    {
        var _housing_bottom = round(base_y + top_h);
        var _clip_top = max(0, _housing_bottom - _visual_top);
        var _visible_height = _visual_h - _clip_top;
        if (_visible_height > 0)
        {
            draw_sprite_part_ext(_head_visual, 0, 0, _clip_top, _visual_w, _visible_height,
                _visual_left, _visual_top + _clip_top, 1, 1, c_white, 1);
        }
    }
    else
    {
        draw_sprite(_head_visual, 0, _visual_left + sprite_get_xoffset(_head_visual),
            _visual_top + sprite_get_yoffset(_head_visual));
    }
}
if (spr_top != -1)
{
    draw_sprite(spr_top, 0, round(base_x + sprite_get_xoffset(spr_top)),
        round(base_y + sprite_get_yoffset(spr_top)));
}
// ONE-SHOT COMPRESSED-AIR FX (FOREGROUND)
if (air_top_frame >= 0 && spr_air_top != -1)
{
    var _top_fx_x = round(air_top_anchor_x - sprite_get_width(spr_air_top) * 0.5 + air_top_offset_x);
    var _top_fx_y = round(air_top_anchor_y + air_top_offset_y);
    draw_sprite(spr_air_top, floor(air_top_frame),
        _top_fx_x + sprite_get_xoffset(spr_air_top),
        _top_fx_y + sprite_get_yoffset(spr_air_top));
}
if (air_bottom_frame >= 0 && spr_air_bottom != -1)
{
    var _bottom_fx_x = round(air_bottom_anchor_x - sprite_get_width(spr_air_bottom) * 0.5 + air_bottom_offset_x);
    var _bottom_fx_y = round(air_bottom_anchor_y - sprite_get_height(spr_air_bottom) * 0.5 + air_bottom_offset_y);
    draw_sprite(spr_air_bottom, floor(air_bottom_frame),
        _bottom_fx_x + sprite_get_xoffset(spr_air_bottom),
        _bottom_fx_y + sprite_get_yoffset(spr_air_bottom));
}
if (debug_draw)
{
    draw_set_alpha(0.25);
    draw_set_color(c_red);
    draw_rectangle(bottom_x + crush_inset_x, head_y, bottom_x + bottom_w - crush_inset_x, head_y + bottom_h, false);
    draw_set_alpha(0.12);
    draw_set_color(c_yellow);
    draw_rectangle(bottom_x + crush_inset_x, min(head_previous_y, head_y), bottom_x + bottom_w - crush_inset_x, max(head_previous_y + bottom_h, head_y + bottom_h), false);
    draw_set_alpha(1);
    draw_set_color(c_aqua);
    draw_line(bottom_x, head_y + bottom_h, bottom_x + bottom_w, head_y + bottom_h);
    draw_set_color(c_white);
    draw_text(base_x + top_w + 8, base_y, "STATE: " + string(smash_state) + "\nOFFSET: " + string(head_offset) + "\nHEAD Y: " + string(head_y) + "\nMOVE Y: " + string(head_move_y) + "\nACTIVE: " + string(active) + "\nDESCENDING: " + string(descending));
}
draw_set_alpha(1);
draw_set_color(c_white);
