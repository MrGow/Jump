/// oSpinner — Clean Up

for (var i = 0; i < array_length(platforms); i++)
{
    if (instance_exists(platforms[i])) {
        with (platforms[i]) instance_destroy();
    }
}