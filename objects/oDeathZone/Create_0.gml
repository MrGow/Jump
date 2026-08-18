/// oDeathZone — Create

if (!variable_instance_exists(id, "zone_name"))
{
    zone_name = "";
}

if (!variable_instance_exists(id, "enabled"))
{
    enabled = true;
}

if (!variable_instance_exists(id, "debug_draw"))
{
    debug_draw = true;
}


// ====================================================
// OPTIONAL FOLLOW MODE
//
// Normal death zones ignore all of this.
//
// The Area 1 elevator controller can assign:
// follow_target = elevator platform
//
// The death zone then keeps its TOP edge a fixed
// distance underneath the target.
// ====================================================

follow_target = noone;

follow_active = false;

// Gap between target bottom and death-zone top.
if (!variable_instance_exists(id, "follow_gap_y"))
{
    follow_gap_y = 24;
}

// Usually we only need vertical following because the
// elevator death zone can span the whole shaft width.
if (!variable_instance_exists(id, "follow_x"))
{
    follow_x = false;
}

follow_offset_x = 0;


// ====================================================
// ORIGINAL POSITION
//
// Used when elevator resets.
// ====================================================

start_x = x;
start_y = y;


// ====================================================
// TILE SNAP
// ====================================================

if (!variable_instance_exists(id, "snap_to_tile"))
{
    snap_to_tile = true;
}

tile_w = 32;
tile_h = 32;


// ====================================================
// RECT
// ====================================================

left   = 0;
top    = 0;
right  = 0;
bottom = 0;


// ====================================================
// UPDATE RECT
// ====================================================

update_rect = function()
{
    var spr =
        sprite_index;

    var sw =
        (spr != -1)
        ? sprite_get_width(spr)
        : 32;

    var sh =
        (spr != -1)
        ? sprite_get_height(spr)
        : 32;

    var xo =
        (spr != -1)
        ? sprite_get_xoffset(spr)
        : 0;

    var yo =
        (spr != -1)
        ? sprite_get_yoffset(spr)
        : 0;

    var sx =
        image_xscale;

    var sy =
        image_yscale;


    var l =
        x -
        xo * sx;

    var t =
        y -
        yo * sy;

    var r =
        l +
        sw * sx;

    var b =
        t +
        sh * sy;


    left =
        round(
            min(l, r)
        );

    right =
        round(
            max(l, r)
        );

    top =
        round(
            min(t, b)
        );

    bottom =
        round(
            max(t, b)
        );
};


// ====================================================
// TILE SNAP
// ====================================================

snap_transform = function()
{
    var spr =
        sprite_index;

    var sw =
        (spr != -1)
        ? sprite_get_width(spr)
        : 32;

    var sh =
        (spr != -1)
        ? sprite_get_height(spr)
        : 32;

    var xo =
        (spr != -1)
        ? sprite_get_xoffset(spr)
        : 0;

    var yo =
        (spr != -1)
        ? sprite_get_yoffset(spr)
        : 0;


    update_rect();


    var gx =
        tile_w;

    var gy =
        tile_h;


    var cur_w =
        right -
        left;

    var cur_h =
        bottom -
        top;


    var snap_l =
        floor(
            left /
            gx
        ) *
        gx;

    var snap_t =
        floor(
            top /
            gy
        ) *
        gy;


    var snap_w =
        max(
            gx,
            round(
                cur_w /
                gx
            ) *
            gx
        );

    var snap_h =
        max(
            gy,
            round(
                cur_h /
                gy
            ) *
            gy
        );


    image_xscale =
        abs(
            snap_w /
            sw
        );

    image_yscale =
        abs(
            snap_h /
            sh
        );


    x =
        snap_l +
        xo *
        image_xscale;

    y =
        snap_t +
        yo *
        image_yscale;


    update_rect();
};


// ====================================================
// INITIAL RECT
// ====================================================

update_rect();