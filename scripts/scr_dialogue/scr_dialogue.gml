/// scr_Dialogue
/// Returns an array of dialogue lines for a given dialogue ID.

function scr_Dialogue(_dialogue_id)
{
    switch (_dialogue_id)
    {
        // ====================================================
        // B1LL-E 01
        // First meeting — confused that JumpBot is alive.
        // ====================================================
        case 1:
        {
            return [
                "Huh?",
                "You're still alive?",
                "You're supposed to be getting decommissioned.",
                "That crusher usually takes care of that.",
                "...",
                "Well. That's inconvenient.",
                "For somebody, probably."
            ];
        }


        // ====================================================
        // B1LL-E 02
        // Mildly impressed, but still thinks escape is hopeless.
        // ====================================================
        case 2:
        {
            return [
                "Still going, huh?",
                "I'll give you this...",
                "You've got commitment.",
                "Admirable, little guy.",
                "Completely pointless, obviously.",
                "Nobody gets out of here.",
                "But hey.",
                "Knock yourself out."
            ];
        }
    }

    // Safety fallback.
    return [
        "..."
    ];
}