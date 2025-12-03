/// @func scr_upgrade_cost(_index)
/// @desc Returns the scrap cost for upgrading the upgrade at this index.

function scr_upgrade_cost(_index)
{
    var _u = global.upgrades[_index];
    // Simple formula: cost scales with current level
    return _u.base_cost * (_u.level + 1);
}
