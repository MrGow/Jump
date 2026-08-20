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
                "Huh.",
                "You're still operational?",
                "Could've sworn you were on today's decommissioning pile.",
                "That crusher usually doesn't miss.",
                "Well... don't get too excited.",
                "If they wanted you scrapped, they'll notice eventually.",
                "I'd keep my head down if I were you."
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
                "You're still going?",
                "I'll give you this, little guy...",
                "You've got persistence.",
                "Not much sense, apparently, but persistence.",
                "You know nobody gets out of here, right?",
                "Still...",
                "I'll be impressed if you make it another hundred metres."
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