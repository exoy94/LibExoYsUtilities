LibExoYsUtilities = LibExoYsUtilities or {}
local Lib = LibExoYsUtilities

function Lib.IsTable( t )
  return type(t) == "table"
end

function Lib.IsFunc( f )
  return type(f) == "function"
end

function Lib.IsString( s ) 
  return type(s) == "string"
end

function Lib.IsNum( n ) 
  return type(n) == "number"
end