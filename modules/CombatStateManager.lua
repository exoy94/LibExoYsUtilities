LibExoYsUtilities = LibExoYsUtilities or {}
local Lib = LibExoYsUtilities

local combatStartCallbackList = {}
local combatEndCallbackList = {}
local CombatState = {
  delay = 700,
  start = GetGameTimeMilliseconds(),
  duration = 0,
  inCombat = false,
}

-----------------------
-- Exposed Functions --
-----------------------

function Lib.RegisterCombatStartCallback(name, callback)
  combatStartCallbackList[name] = callback
end

function Lib.UnregisterCombatStartCallback(name)
  combatStartCallbackList[name] = nil
end

function Lib.RegisterCombatEndCallback(name, callback)
  combatEndCallbackList[name] = callback
end

function Lib.UnregisterCombatEndCallback(name)
  combatEndCallbackList[name] = nil
end

function Lib.GetCombatStartTime()
  return CombatState.inCombat and CombatState.start or 0
end

function Lib.GetLastCombatDuration()
  return CombatState.duration
end

function Lib.GetCurrentCombatDuration()
  return CombatState.inCombat and GetGameTimeMilliseconds() - CombatState.start or 0
end

function Lib.IsInCombat()
  return CombatState.inCombat
end

--------------------------
-- Combat State Manager --
--------------------------

local function OnPlayerCombatState(_, inCombat)

  local function ExecuteCallback(callback)
    if type(callback) == "function" then
      callback(inCombat)
    end
  end

  local function OnCombatStart()
    CombatState.inCombat = true
    CombatState.start = GetGameTimeMilliseconds()
    for _, callback in pairs( combatStartCallbackList ) do
      ExecuteCallback( callback )
    end
  end

  local function OnCombatEnd()
    CombatState.inCombat = false
    CombatState.duration = GetGameTimeMilliseconds() - CombatState.start
    for _, callback in pairs( combatEndCallbackList ) do
      ExecuteCallback( callback )
    end
  end

  if CombatState.callback then
    zo_removeCallLater(CombatState.callback)
    if inCombat then
      return
    end
  end
  if inCombat then
    OnCombatStart()
  else
    CombatState.callback = zo_callLater( function()
      CombatState.callback = nil
      OnCombatEnd()
    end, CombatState.delay)
  end

end

local function Initialize()
  Lib.EM:RegisterForEvent( Lib.name.."CombatState", EVENT_PLAYER_COMBAT_STATE, OnPlayerCombatState )
  if IsUnitInCombat("player") then OnPlayerCombatState(_, true) end
end

Lib.init_CombatStateManager = Initialize
