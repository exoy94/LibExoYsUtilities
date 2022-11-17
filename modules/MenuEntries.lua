LibExoYsUtilities = LibExoYsUtilities or {}
local Lib = LibExoYsUtilities

--[[
data =
{
  ["addonName"] = *addonName*,
  ["esouiSuffix"] = *urlSuffix*,
}
]]
function Lib.GetGeneralSettingsName()
  return Lib.AddIconToString(EXOY_UTIL_GENERAL_SETTINGS, "esoui/art/icons/achievement_u30_mainquest_2.dds", 36, true)
end

function Lib.GetFeedbackSubmenu( data )
  local submenu = {
    type = "submenu",
    name = Lib.AddIconToString(EXOY_UTIL_FEEDBACK_SETTINGS, "esoui/art/icons/achievement_update11_dungeons_004.dds", 36, true),
    controls = {},
  }

  table.insert(submenu.controls,   {
        type = "description",
        --title = "My Title",	--(optional)
        title = nil,	--(optional)
        text = EXOY_UTIL_FEEDBACK_INGAME_MAIL_DESCRIPTION,
        width = "half",
    } )
  table.insert(submenu.controls,   {
        type = "button",
        name = EXOY_UTIL_FEEDBACK_INGAME_MAIL_BUTTON,
        tooltip = "",
        func = function()
              local server = GetWorldName()
              local function PrefillMail()
                ZO_MailSendToField:SetText("@Exoy94")
                ZO_MailSendSubjectField:SetText( data.addonName )
                ZO_MailSendBodyField:TakeFocus()
              end
              if GetWorldName() == "EU Megaserver" then
                SCENE_MANAGER:Show('mailSend')
                zo_callLater(PrefillMail, 250)
              else
                --ZO_Dialogs_ShowDialog(ERG.dialogs.warningIngameMailServer)
              end
        end,
        width = "half",
        warning = EXOY_UTIL_FEEDBACK_INGAME_MAIL_WARNING,
    } )

  table.insert(submenu.controls, { type = "divider" } )
  table.insert(submenu.controls,   {
        type = "description",
        --title = "My Title",	--(optional)
        title = nil,	--(optional)
        text = EXOY_UTIL_FEEDBACK_ESOUI_DESCRIPTION,
        width = "half",
    })
  table.insert(submenu.controls,   {
        type = "button",
        name = EXOY_UTIL_FEEDBACK_ESOUI_BUTTON,
        tooltip = "",
        func = function()
          RequestOpenUnsafeURL( "https://www.esoui.com/downloads/"..data.esouiSuffix )
        end,
        width = "half",
        warning = ERG_FEEDBACK_URL_WARNING,
    } )
  table.insert(submenu.controls, { type = "divider" } )
  table.insert(submenu.controls,   {
        type = "description",
        --title = "My Title",	--(optional)
        title = nil,	--(optional)
        text = ERG_FEEDBACK_PAYPAL_DESCRIPTION,
        width = "half",
    })
  table.insert(submenu.controls,   {
        type = "button",
        name = EXOY_UTIL_FEEDBACK_PAYPAL_BUTTON,
        tooltip = "",
        func = function()
          RequestOpenUnsafeURL( "https://www.paypal.com/paypalme/ExoYGaming" )
        end,
        width = "half",
        warning = EXOY_UTIL_FEEDBACK_URL_WARNING,
    })

  return submenu
end
