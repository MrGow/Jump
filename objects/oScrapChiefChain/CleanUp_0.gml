/// oScrapChiefChain — Clean Up

if (instance_exists(payload))
{
    if (payload.chain == id)
    {
        payload.chain = noone;

        payload.carriage = noone;

        payload.chain_attached = false;

        payload.visible = false;
    }
}

if (instance_exists(carriage))
{
    if (carriage.chain == id)
    {
        carriage.chain = noone;
    }
}