LibExoYsUtilities = LibExoYsUtilities or {}
local Lib = LibExoYsUtilities

local fontData = {
    [1] = {
      path = "EsoUI/Common/Fonts/Univers57.otf",
      name = "Univers57",
    },
    [2] = {
      path = "EsoUI/Common/Fonts/Univers67.otf",
      name = "Univers67",
    },
    [3] = {
      path = "EsoUI/Common/Fonts/ProseAntiquePSMT.otf",
      name = "ProseAntique",
    },
    [4] = {
      path = "EsoUI/Common/Fonts/Handwritten_Bold.otf",
      name = "Handwritten",
    },
    [5] = {
      path = "EsoUI/Common/Fonts/TrajanPro-Regular.otf",
      name = "StoneTablet",
    },
    [6] = {
      path = "EsoUI/Common/Fonts/FTN87.otf",
      name = "FuturaBold",
    }
}


local function GetOutline( fontNo )
  return fontData[fontNo].outline or "soft-shadow-thick"
end


local function GetFontNumber( fontName )
  for fontNo, fontInfo in ipairs( fontData ) do
      if fontName == fontInfo.name then
        return fontNo
      end
  end
  return 2
end


-----------------------
-- Exposed Functions --
-----------------------

-- TributesEnhancementMenu.lua

function Lib.GetFontList( )
  local fontList = {}
  for fontNo, fontInfo in ipairs( fontData ) do
    table.insert(fontList, fontInfo.name)
  end
  return fontList
end


-- TributesEnhancementGui.lua

function Lib.GetFont( size, fontName )
  size = size or 18
  local fontNo = fontName and GetFontNumber( fontName ) or GetFontNumber( "Univers67" )
  return string.format( "%s|%d|%s", fontData[fontNo].path , size , GetOutline(fontNo) )
end

----------------------------------
-- How to create font selection --
----------------------------------
--[[

*MenuEntry =
{
  type = "dropdown",
  choices = Lib.GetFontList()
  getFunc = function() return store.font end,
  setFunc = function(selection)
    store.font = selection
    Gui:SetFont( Lib.GetFont(store.size, store.font) )
  end,
}

]]
