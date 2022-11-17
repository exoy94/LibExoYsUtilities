LibExoYsUtilities = LibExoYsUtilities or {}
local Lib = LibExoYsUtilities


---------------------
-- AddIconToString --
---------------------

-- Utilities/MenuEntrties.lua

function Lib.AddIconToString(str, icon, size, inFront)
  if type(icon) == "number" then
    icon = GetAbilityIcon(icon)
  end
  local iconStr = zo_strformat("|t<<2>>:<<2>>:<<1>>|t", icon, size)
  if inFront then
    return zo_strformat("<<1>> <<2>>", iconStr, str)
  else
    return zo_strformat("<<1>> <<2>>", str, iconStr)
  end
end


-----------------
-- ColorString --
-----------------

-- Utilities/Debug.lua

-- Interface/Chat.lua

function Lib.ColorString(str, color)
  local colorString = ""
  if Lib.IsTable(color) then
    colorString = ZO_ColorDef.FloatsToHex( unpack(color) )
  else
    colorString = color
  end
  return string.format( "|c%s%s|r", colorString, str)
end


-----------------------------
-- GetFormattedAbilityName --
-----------------------------

function Lib.GetFormattedAbilityName( abilityId )
  return zo_strformat( SI_ABILITY_NAME, GetAbilityName(abilityId) )
end


------------------------
-- GetFormattedNumber --
------------------------

-- Utilities/DistanceCalculator.lua
-- Utilities/StringFormatter.lua

--[[ format (table)
        factor, (number)  -- multiply value with factor (default = 1)
        decimal (number)  -- number of decimal digits (default = 0)
        prefix (string)   -- string appended in front without space
        suffix (string)   -- string appended at end without space
]]

function Lib.GetFormattedNumber( value, format )
  format = format or {}
  format.factor = format.factor or 1
  local formatStr = zo_strformat("%s%.<<1>>f%s", format.decimal or 0)
  return string.format(formatStr, format.prefix or "", value*format.factor, format.suffix or "")
end


------------------------
-- GetCountdownString --
------------------------

-- TributesEnhancement.lua

-- TODO add string for end

function Lib.GetCountdownString( value, unit, decimal, notMilliseconds )
  local format = {
    suffix = unit and "s" or nil,
    factor = notMilliseconds and 1 or 1/1000
  }
  local seconds = value*format.factor
  if seconds < 10 and decimal then
    format.decimal = 1
  else
    format.decimal = 0
  end
  return Lib.GetFormattedNumber( value, format )
end


-------------------------
-- ComplementWithZeros --
-------------------------

-- Utilities/StringFormatter.lua

function Lib.ComplementWithZeros( value, digits )
  digits = digits or 0
  local formatStr = zo_strformat("%0<<1>>d", digits)
  return string.format(formatStr, value)
end


--------------------------
-- GetFormattedCurrency --
--------------------------

function Lib.GetFormattedCurrency( amount )
  local suffixList = {[3] = "k", [6] = "m"}
  local format = {}
  for i=3,6,3 do
    if amount >= 10^i then
      format.factor = 10^(-i)
      format.suffix = suffixList[i]
      format.decimal = math.floor(i/6)
    end
  end
  return Lib.GetFormattedNumber( amount, format )
end


-------------------
-- GetTimeString --
-------------------

function Lib.GetTimeString( hideSeconds )
  local timeString = GetTimeString()
  if not hideSeconds then
    return timeString
  else
    local hours, minutes, seconds = timeString:match("([^%:]+):([^%:]+):([^%:]+)")
    return zo_strformat("<<1>>:<<2>>", hours, minutes)
  end
end


---------------------
-- ConvertDuration --
---------------------

-- Utilities/StringFormatter.lua

--[[ output(table) =
      {unit}
      * amount for respective unit upto to limit
      raw = {unit}
      * total amount for respective unit without limit
]]


function Lib.ConvertDuration( duration, notMilliseconds )
  local factor = notMilliseconds and 1 or 1000
  local durationTable = { raw = {} }
  local limits = { 60, 60, 24, 7, 52 }
  local units = {"second", "minute", "hour", "day", "week" }

  durationTable.milliseconds = notMilliseconds and 0 or duration%1000
  durationTable.raw.milliseconds = duration

  for i, unit in ipairs( units ) do
    local limit = limits[i]
    local rawValue = math.floor( duration/factor )
    durationTable.raw[unit] = rawValue
    durationTable[unit] = rawValue >= limit and rawValue%limit or rawValue
    if unit == "week" then
      durationTable.year = math.floor( rawValue/limit )
    end
    factor = factor * limit
  end

  return durationTable
end


--[[ ---------------------------- ]]
--[[ -- Get Formatted Duration -- ]]
--[[ ---------------------------- ]]

-- Used by: 
-- TributesEnhancement.lua

-- mode: (option string):
--       + 'acronym'        --> 1y 2w 3d 4h 5m 6s
--       + 'word'           --> 1year 2weeks 3 days 1hour 2minutes
--       + 'compact'        --> 00:00:00

-- specification (option string for compact mode):
-- output only created for
--      + default           --> hours:minutes:seconds
--      + 'minute'          --> minutes:seconds
--      + 'second'          --> seconds


function Lib.GetFormattedDuration( duration, mode, specification )
  local function Pluralize(word)
    return word.."s"
  end
  local durationTable = Lib.IsTable(duration) and duration or Lib.ConvertDuration( duration )
  local units = {"year", "week", "day", "hour", "minute", "second"}
  local acros = {"y", "w", "d", "h", "m", "s"}
  local output = ""
  local createString = false

  local firstUnitForCompact = 4
  if mode == "compact" and specification then
    if specification == "minute" then
      firstUnitForCompact = 5
    elseif
      specification == "second" then
        firstUnitForCompact = 6
      end
  end

  for i, unit in ipairs( units ) do
    local value = durationTable[unit]
    if value ~= 0 then createString = true end

    if mode == "compact" and i>3 and i >= firstUnitForCompact then createString = true end

    if createString then
      if mode == "acronym" then
        output = zo_strformat("<<1>> <<2>><<3>>", output, value, acros[i]  )

      elseif mode == "word" then
        local word = value > 1 and Pluralize(unit) or unit
        output = zo_strformat("<<1>> <<2>> <<3>>", output, value, word)

      elseif mode == "compact" then
        local entry = Lib.ComplementWithZeros(value, 2)
        if output ~= "" then entry = ":"..entry end
        output = zo_strformat("<<1>><<2>>", output, entry)
      end
    end

  end
  return output
end
