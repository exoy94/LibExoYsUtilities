LibExoYsUtilities = LibExoYsUtilities or {}

local Lib = LibExoYsUtilities

--[[ ---------------- ]]
--[[ -- Chat Debug -- ]]
--[[ ---------------- ]]

-- used in 
--    + TributesEnhancement.lua

-- params
--    + trigger (func or bool)    --> determines whether chat debug is printed
--    + des     (string)          --> designation of addon
--    + text    (string or table) --> 
--    + delim   (table)           --> defines delimiter if 'text' is table 


function Lib.DebugMsg( trigger, des, text, delim)
  -- early outs
  if Lib.IsFunc(trigger) then 
    if not trigger() then
      return
    end
  elseif not trigger then
    return
  end

  local output = zo_strformat("[<<1>>-<<2>>-", Lib.GetTimeString(true), GetGameTimeMilliseconds() )
  output = zo_strformat("<<1>><<2>><<3>> ", Lib.ColorString(output, "8F8F8F"), Lib.ColorString(des,"00FF00"), Lib.ColorString("]","8F8F8F") )

  if Lib.IsTable( text ) then
   for k, v in ipairs(text) do
     output = string.format("%s%s", output, v)
     if delim[k] then
       output = string.format("%s%s", output, delim[k])
     end
   end
   d( output )
  else
   d( zo_strformat("<<1>><<2>>", output, text ) )
  end
end
