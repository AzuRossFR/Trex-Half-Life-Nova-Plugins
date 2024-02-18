
local PLUGIN = PLUGIN

PLUGIN.name = "ChatClass"
PLUGIN.author = "AzuRoss"
PLUGIN.description = "Rajoute des couleurs aux class."

function PLUGIN:InitializedChatClasses()
    -- Cache the default chat class table.
    local icChatTable = ix.chat.classes.ic

    -- Override the OnChatAdd method.
    icChatTable.OnChatAdd = function(this, speaker, text, anonymous, info)
        local color = this.color
        local name = anonymous and
            L"quelqu'un" or hook.Run("GetCharacterName", speaker, chatType) or
            (IsValid(speaker) and speaker:Name() or "Console")
        -- Get the speaker's character, faction table, and faction color.
        local character = speaker:GetCharacter()
        local factionTable = ix.faction.Get(character:GetFaction())
        local factionColor = factionTable.GetColor and factionTable:GetColor() or factionTable.color or color or color_white

        if (this.GetColor) then
            color = this:GetColor(speaker, text, info)
        end

        -- We position the speaker's name after the faction color and before the text color to only change the name of the speaker.
        -- The text color will be the default color for this chat type.
        chat.AddText(factionColor, ix.util.GetMaterial("trexhln/chat/message_icon.png"), name, color, " dit : \"" .. text .. "\"")
    end

    -- Re-register the edited chat class by passing the cached table (with our edits).
    ix.chat.Register("ic", icChatTable)
end