LibExoYsUtilities = LibExoYsUtilities or {}
local Lib = LibExoYsUtilities

local EM = GetEventManager() 

Lib.name = "LibExoYsUtilities"

-------------------------------
-- Player Initial Activation --
-------------------------------
-- executes callbacks for the first "PLAYER_ACTIVATED" event after an reloadui/login
-- exposed function to allow for other modules/addons to register callbacks
-- unregister function would be kinda pointless

local initialActivationCallbackList = {}

-- exposed function
function Lib.RegisterInitialActivationCallback(callback)
    table.insert(initialActivationCallbackList, callback)
end

function OnInitialActivation()
    for _, callback in ipairs( initialActivationCallbackList ) do
        if type(callback) = "function" then 
            callback()
        end
    end
    EM:UnregisterForEvent(Lib.name.."InitialActivation", EVENT_PLAYER_ACTIVATED)
end

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
    
    EM:RegisterForEvent(Lib.name.."InitialActivation", EVENT_PLAYER_ACTIVATED, OnInitialActivation)

    InitModule("CombatStateManager")

end


local function OnAddonLoaded(_, addonName)
    if addonName == Lib.name then
        EM:UnregisterForEvent(Lib.name, EVENT_ADD_ON_LOADED)
        Initialize()
    end
end
  
EM:RegisterForEvent(Lib.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)