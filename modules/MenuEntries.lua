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
  return Lib.AddIconToString(LIB_EXOY_GENERAL_SETTINGS, "esoui/art/icons/achievement_u30_mainquest_2.dds", 36, "front")
end

function Lib.GetFeedbackSubmenu( data )
  local submenu = {
    type = "submenu",
    name = Lib.AddIconToString(LIB_EXOY_FEEDBACK_SETTINGS, "esoui/art/icons/achievement_update11_dungeons_004.dds", 36, "front"),
    controls = {},
  }

  table.insert(submenu.controls,   {
        type = "description",
        --title = "My Title",	--(optional)
        title = nil,	--(optional)
        text = LIB_EXOY_FEEDBACK_INGAME_MAIL_DESCRIPTION,
        width = "half",
    } )
  table.insert(submenu.controls,   {
        type = "button",
        name = LIB_EXOY_FEEDBACK_INGAME_MAIL_BUTTON,
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
        warning = LIB_EXOY_FEEDBACK_INGAME_MAIL_WARNING,
    } )

  table.insert(submenu.controls, { type = "divider" } )
  table.insert(submenu.controls,   {
        type = "description",
        --title = "My Title",	--(optional)
        title = nil,	--(optional)
        text = LIB_EXOY_FEEDBACK_ESOUI_DESCRIPTION,
        width = "half",
    })
  table.insert(submenu.controls,   {
        type = "button",
        name = LIB_EXOY_FEEDBACK_ESOUI_BUTTON,
        tooltip = "",
        func = function()
          RequestOpenUnsafeURL( "https://www.esoui.com/downloads/"..data.esouiSuffix )
        end,
        width = "half",
        warning = LIB_EXOY_FEEDBACK_URL_WARNING,
    } )
  table.insert(submenu.controls, { type = "divider" } )
  table.insert(submenu.controls,   {
        type = "description",
        --title = "My Title",	--(optional)
        title = nil,	--(optional)
        text = LIB_EXOY_FEEDBACK_PAYPAL_DESCRIPTION,
        width = "half",
    })
  table.insert(submenu.controls,   {
        type = "button",
        name = LIB_EXOY_FEEDBACK_PAYPAL_BUTTON,
        tooltip = "",
        func = function()
          RequestOpenUnsafeURL( "https://www.paypal.com/paypalme/ExoYGaming" )
        end,
        width = "half",
        warning = LIB_EXOY_FEEDBACK_URL_WARNING,
    })

  return submenu
end
