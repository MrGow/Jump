/// oMechaSoldier — Draw End


// ====================================================
// MUZZLE FLASH
//
// Draw separately after the normal soldier draw so
// the flash always appears cleanly over the weapon.
// ====================================================

if (
    !dead
    &&
    muzzle_flash_active
    &&
    spr_muzzle != -1
)
{
    // ------------------------------------------------
    // SAME RECOIL POSITION AS SOLDIER DRAW
    // ------------------------------------------------

    var _draw_x =
        x -
        facing *
        recoil_amount;


    var _draw_y =
        y +
        draw_floor_inset;


    // ------------------------------------------------
    // BARREL TIP
    // ------------------------------------------------

    var _muzzle =
        soldier_get_muzzle(
            locked_aim_frame,
            _draw_x,
            _draw_y
        );


    var _mx =
        _muzzle[0];


    var _my =
        _muzzle[1];


    // ------------------------------------------------
    // SMALL FORWARD OFFSET
    //
    // Keeps the flash centred just beyond the barrel
    // rather than buried inside the rifle.
// ------------------------------------------------

    _mx +=
        lengthdir_x(
            muzzle_flash_forward,
            locked_shot_angle
        );


    _my +=
        lengthdir_y(
            muzzle_flash_forward,
            locked_shot_angle
        );


    draw_sprite_ext(
    spr_muzzle,
    floor(
        muzzle_flash_frame
    ),
    _mx,
    _my,
    -1,
    1,
    locked_shot_angle - 180,
    c_white,
    1
);
}