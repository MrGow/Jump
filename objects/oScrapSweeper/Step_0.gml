/// oScrapSweeper — Step


// ====================================================
// KEEP SOLID HELPER ALIVE
// ====================================================

if (!instance_exists(solid_inst))
{
    solid_inst =
        instance_create_layer(
            body_solid_centre_x,
            y,
            "Instances",
            oScrapSweeperSolid
        );

    if (instance_exists(solid_inst))
    {
        solid_inst.owner_sweeper =
            id;

        solid_inst.visible =
            false;
    }
}


// ====================================================
// UPDATE SOLID
// ====================================================

body_solid_centre_x =
    x +
    facing *
    body_solid_centre_offset;

if (instance_exists(solid_inst))
{
    solid_inst.x =
        body_solid_centre_x;

    solid_inst.y =
        y;

    solid_inst.enabled =
        enabled;

    solid_inst.active =
        enabled;

    solid_inst.solid_width =
        body_solid_width;

    solid_inst.image_xscale =
        body_solid_width / 16;
}


// ====================================================
// DISABLED
// ====================================================

if (!enabled)
{
    exit;
}


// ====================================================
// FREEZE
// ====================================================

if (scr_game_frozen())
{
    exit;
}


// ====================================================
// PLAYER
// ====================================================

var _player =
    instance_find(
        oPlayer,
        0
    );

if (!instance_exists(_player))
{
    exit;
}

if (
    variable_instance_exists(
        _player,
        "state"
    )
    &&
    _player.state == "dead"
)
{
    exit;
}


// ====================================================
// SPIKE POSITION
// ====================================================

var _spike_cx =
    x +
    facing *
    offset_spikes;

var _spike_half_w =
    spike_width * 0.5;

var _spike_half_h =
    spike_height * 0.5;


// ====================================================
// LETHAL SPIKE RECTANGLE
//
// Trimmed slightly so transparent edge pixels don't
// kill the player.
// ====================================================

var _spike_left =
    _spike_cx -
    _spike_half_w +
    spike_hitbox_inset_x;

var _spike_right =
    _spike_cx +
    _spike_half_w -
    spike_hitbox_inset_x;

var _spike_top =
    y -
    _spike_half_h +
    spike_hitbox_inset_y;

var _spike_bottom =
    y +
    _spike_half_h -
    spike_hitbox_inset_y;


// ====================================================
// SPIKE KILL
// ====================================================

var _hit_spikes =
    _player.bbox_right >
        _spike_left
    &&
    _player.bbox_left <
        _spike_right
    &&
    _player.bbox_bottom >
        _spike_top
    &&
    _player.bbox_top <
        _spike_bottom;

if (_hit_spikes)
{
    with (_player)
    {
        scr_player_died();
    }

    exit;
}


// ====================================================
// ELEVATOR CRUSH
//
// Normal contact with the pole/body is harmless.
//
// Crushing only occurs when:
//
// 1. Player horizontally overlaps the sweeper body.
// 2. Player is immediately below its underside.
// 3. The Area 1 elevator is actively pushing upward.
// 4. The player is supported by / riding the elevator.
//
// This means jumping into the underside normally just
// bonks the player's head. It does NOT kill.
// ====================================================

var _elevator =
    instance_find(
        oArea1ElevatorPlatform,
        0
    );

if (!instance_exists(_elevator))
{
    exit;
}


// ====================================================
// IS ELEVATOR MOVING UP?
// ====================================================

var _elevator_moving_up =
    false;

var _elevator_controller =
    instance_find(
        oArea1ElevatorController,
        0
    );

if (instance_exists(_elevator_controller))
{
    if (
        variable_instance_exists(
            _elevator_controller,
            "platform_move_y"
        )
    )
    {
        _elevator_moving_up =
            _elevator_controller.platform_move_y
            < 0;
    }
}

if (!_elevator_moving_up)
{
    exit;
}


// ====================================================
// BODY RECTANGLE
// ====================================================

var _body_left;
var _body_right;

if (facing > 0)
{
    _body_left =
        x +
        body_start_offset;

    _body_right =
        x +
        body_end_offset;
}
else
{
    _body_left =
        x -
        body_end_offset;

    _body_right =
        x -
        body_start_offset;
}

var _body_top =
    y -
    pole_height * 0.5;

var _body_bottom =
    y +
    pole_height * 0.5;


// ====================================================
// PLAYER HORIZONTAL OVERLAP
// ====================================================

var _horizontal_overlap =
    _player.bbox_right >
        _body_left
    &&
    _player.bbox_left <
        _body_right;

if (!_horizontal_overlap)
{
    exit;
}


// ====================================================
// PLAYER AGAINST UNDERSIDE
// ====================================================

var _head_gap =
    _body_bottom -
    _player.bbox_top;

var _against_underside =
    _player.bbox_top <=
        _body_bottom +
        crush_tolerance
    &&
    _player.bbox_bottom >
        _body_bottom;

if (!_against_underside)
{
    exit;
}


// ====================================================
// PLAYER SUPPORTED BY ELEVATOR
//
// We deliberately check the actual elevator platform,
// not merely vsp == 0. This prevents ordinary ceiling
// contact elsewhere from becoming lethal.
// ====================================================

var _supported_by_elevator =
    false;


// ----------------------------------------------------
// Existing standing-platform reference
// ----------------------------------------------------

if (
    variable_instance_exists(
        _player,
        "standing_platform"
    )
    &&
    instance_exists(
        _player.standing_platform
    )
)
{
    if (
        _player.standing_platform ==
        _elevator
    )
    {
        _supported_by_elevator =
            true;
    }
}


// ----------------------------------------------------
// Physical feet check as additional safety.
//
// This also catches the instant where the elevator
// pushes into the player before standing_platform has
// necessarily updated.
// ----------------------------------------------------

if (!_supported_by_elevator)
{
    var _feet_gap =
        _elevator.bbox_top -
        _player.bbox_bottom;

    var _player_over_elevator =
        _player.bbox_right >
            _elevator.bbox_left
        &&
        _player.bbox_left <
            _elevator.bbox_right;

    if (
        _player_over_elevator
        &&
        abs(_feet_gap) <= 3
    )
    {
        _supported_by_elevator =
            true;
    }
}


if (!_supported_by_elevator)
{
    exit;
}


// ====================================================
// CRUSH KILL
//
// Elevator is pushing upward, feet are supported by it,
// and the sweeper prevents further upward movement.
// ====================================================

with (_player)
{
    scr_player_died();
}