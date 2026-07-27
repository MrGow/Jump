/// oSwivelGun — Begin Step

if (!enabled) exit;

// ----------------------------------------------------
// Always enforce the dedicated fixed housing mask.
//
// The visible gun rotates in Draw only, so this
// collision mask never rotates with the barrel.
// ----------------------------------------------------
if (
    swivel_solid_mask != -1 &&
    mask_index != swivel_solid_mask
)
{
    mask_index =
        swivel_solid_mask;
}