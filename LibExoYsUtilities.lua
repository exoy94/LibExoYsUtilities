LibExoYsUtilities = LibExoYsUtilities or {}
local Lib = LibExoYsUtilities

local EM = GetEventManager() 

Lib.name = "LibExoYsUtilities"
Lib.CM = ZO_CallbackObject:New()


--[[ ------------------------------- ]]
--[[ -- Initial Player Activation -- ]]
--[[ ------------------------------- ]]

local initialActivationDone = false

function Lib.RegisterInitialActivationCallback(callback)
    if initialActivationDone then return end
    if not Lib.IsFunc(callback) then return end
    Lib.CM:RegisterCallback('InitialPlayerActivation', callback)
end

function OnInitialActivation()
    if initialActivationDone then return end 
    Lib.CM:FireCallbacks('InitialPlayerActivation')
    initialActivationDone = true
    EM:UnregisterForEvent(Lib.name.."InitialActivation", EVENT_PLAYER_ACTIVATED)
    Lib.CM:UnregisterAllCallbacks('InitialPlayerActivation')
end


--[[ -------------------- ]]
--[[ -- Initialization -- ]]
--[[ -------------------- ]]

local function InitModule(module) 
    local func = Lib[module.."_InitFunc"] or nil 
    if Lib.IsFunc(func) then 
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