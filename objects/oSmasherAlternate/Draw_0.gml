/// oSmasherAlternate — Draw
var rod_start_y = base_y + top_h - head_overlap;
var rod_end_y =
    head_y;
var rod_height = max(0, round(rod_end_y - rod_start_y));
if (spr_hydraulic != -1 && rod_height > 0)
{
    draw_sprite_part_ext(spr_hydraulic, 0, 0, 0, hydraulic_w, 1, round(hydraulic_x), round(rod_start_y), 1, rod_height, c_white, 1);
}
if (spr_bottom != -1)
{
    draw_sprite(spr_bottom, 0, round(bottom_x + sprite_get_xoffset(spr_bottom)), round(head_y + sprite_get_yoffset(spr_bottom)));
}
if (spr_top != -1)
{
    draw_sprite(spr_top, 0, round(base_x + sprite_get_xoffset(spr_top)), round(base_y + sprite_get_yoffset(spr_top)));
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
