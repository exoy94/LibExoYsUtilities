LibExoYsUtilities = LibExoYsUtilities or {}
local Lib = LibExoYsUtilities

local EM = GetEventManager() 

Lib.name = "LibExoYsUtilities"


--------------------
-- Initialization --
--------------------

local function InitModule(module) 
    local func = Lib[module.."_InitFunc"] or nil 
    if type(func) == "function" then 
        func() 
    end
    func = nil 
end

local function Initialize()
    
    InitModule("CombatStateManager")

end
  
  
local function OnAddonLoaded(_, addonName)
    if addonName == Lib.name then
        EM:UnregisterForEvent(Lib.name, EVENT_ADD_ON_LOADED)
        Initialize()
    end
end
  
EM:RegisterForEvent(Lib.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)