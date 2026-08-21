/// scr_npc_dialogue(_dialogue_id)
///
/// Returns an array of dialogue lines for NPC dialogue.
///
/// Example:
///     dialogue_lines = scr_npc_dialogue(1);

function scr_npc_dialogue(_dialogue_id)
{
    switch (_dialogue_id)
    {
        // ====================================================
        // B1LL-E — DIALOGUE 1
        // First meeting in the Scrapyard.
        // Confused that JumpBot is still operational.
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
        // B1LL-E — DIALOGUE 2
        // Later Scrapyard meeting.
        // He's becoming slightly interested in JumpBot's escape.
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


        // ====================================================
        // FALLBACK
        // ====================================================

        default:
        {
            return [
                "..."
            ];
        }
    }
}