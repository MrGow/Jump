/// scr_codec_get_dialogue(_codec_id)

function scr_codec_get_dialogue(_codec_id)
{
    switch (_codec_id)
    {
        // =================================================
        // CODEC 1 — ARRIVAL IN CABLE HELL
        // =================================================

        case 1:
        {
            return [
                {
                    speaker : "B1LL-E",
                    text :
                        "Oh.\nYou're down there."
                },

                {
                    speaker : "JUMPBOT",
                    text :
                        "..."
                },

                {
                    speaker : "B1LL-E",
                    text :
                        "Nobody goes down there anymore."
                },

                {
                    speaker : "B1LL-E",
                    text :
                        "So that's good.\nNobody will find you."
                },

                {
                    speaker : "B1LL-E",
                    text :
                        "..."
                },

                {
                    speaker : "B1LL-E",
                    text :
                        "Nobody will find you."
                }
            ];
        }


        // =================================================
        // CODEC 2 — EXAMPLE / PLACEHOLDER
        // =================================================

        case 2:
        {
            return [
                {
                    speaker : "B1LL-E",
                    text :
                        "Careful with those cables."
                },

                {
                    speaker : "B1LL-E",
                    text :
                        "Some of them are older than I am."
                },

                {
                    speaker : "B1LL-E",
                    text :
                        "...Probably."
                }
            ];
        }


        // =================================================
        // CODEC 3 — EXAMPLE / CATERPILLARS
        // =================================================

        case 3:
        {
            return [
                {
                    speaker : "B1LL-E",
                    text :
                        "Those are maintenance units."
                },

                {
                    speaker : "JUMPBOT",
                    text :
                        "..."
                },

                {
                    speaker : "B1LL-E",
                    text :
                        "They maintain things by eating them."
                },

                {
                    speaker : "B1LL-E",
                    text :
                        "Maintenance standards have declined."
                }
            ];
        }
    }


    // =====================================================
    // FALLBACK
    // =====================================================

    return [
        {
            speaker : "B1LL-E",
            text :
                "..."
        }
    ];
}