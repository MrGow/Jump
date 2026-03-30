/// oDeathZone — Room Start

if (!variable_instance_exists(id, "snap_to_tile")) snap_to_tile = true;

if (snap_to_tile) {
    snap_transform();
} else {
    update_rect();
}
