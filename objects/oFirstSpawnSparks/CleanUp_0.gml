/// oFirstSpawnSparks — Clean Up

// ====================================================
// STOP SPARK AUDIO
// ====================================================

if (spark_sound_voice != -1)
{
    audio_stop_sound(spark_sound_voice);
    spark_sound_voice = -1;
}