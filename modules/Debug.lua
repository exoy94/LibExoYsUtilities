LibExoYsUtilities = LibExoYsUtilities or {}

local Lib = LibExoYsUtilities



--[[
* var (function or variable) to determine whether debug should be executed
* des (string) - designation of addon
]]

-- used in TributesEnhancement.lua

function Lib.Debug( var, des, text, delim)
  if type(var) == "function" then
    if not var() then
      return
    end
  elseif not var then
    return
  end
  local output = zo_strformat("[<<1>>-<<2>>-", Lib.GetTimeString(true), GetGameTimeMilliseconds() )
  output = zo_strformat("<<1>><<2>><<3>> ", Lib.ColorString(output, "8F8F8F"), Lib.ColorString(des,"00FF00"), Lib.ColorString("]","8F8F8F") )

  if Lib.IsTable( text ) then
   for k, v in ipairs(text) do
     output = string.format("%s%s", output, v)
     --output = zo_strformat("<<1>><<2>>", output, v)
     if delim[k] then
       output = string.format("%s%s", output, delim[k])
       --output = zo_strformat("<<1>><<2>>", output, delim[k] )
     end
   end
   d( output )
  else
   d( zo_strformat("<<1>><<2>>", output, text ) )
  end
end
