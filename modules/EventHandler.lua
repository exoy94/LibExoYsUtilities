LibExoYsUtilities = LibExoYsUtilities or {}

local Lib = LibExoYsUtilities

local eventParameterList = {
  [EVENT_COMBAT_EVENT] = {
    ["event"] = 1,
    ["result"] = 2,
    ["isError"] = 3,
    ["abilityName"] = 4,
    ["abilityGraphic"] = 5,
    ["abilityActionSlotType"] = 6,
    ["sourceName"] = 7,
    ["sourceType"] = 8,
    ["targetName"] = 9,
    ["targetType"] = 10,
    ["hitValue"] = 11,
    ["powerType"] = 12,
    ["damageType"] = 13,
    ["log"] = 14,
    ["sourceUnitId"] = 15,
    ["targetUnitId"] = 16,
    ["abilityId"] = 17,
    ["overflow"] = 18,
 },
  [EVENT_EFFECT_CHANGED] = {
    ["event"] = 1,
    ["changeType"] = 2,
    ["effectSlot"] = 3,
    ["effectName"] = 4,
    ["unitTag"] = 5,
    ["beginTime"] = 6,
    ["endTime"] = 7,
    ["stackCount"] = 8,
    ["iconName"] = 9,
    ["buffType"] = 10,
    ["effectType"] = 11,
    ["abilityType"] = 12,
    ["statusEffectType"] = 13,
    ["unitName"] = 14,
    ["unitId"] = 15,
    ["abilityId"] = 16,
    ["sourceType"] = 17,
  },
}


function Lib.GetEventParameterTable(...)
  local params = {...}
  local t = {}
  t = ZO_ShallowTableCopy( eventParameterList[params[1]] )
  for k,v in pairs(t) do
    t[k] = params[v]
  end
  return t
end


function Lib.GetEventParameter(param, ...)
  local params = {...}
  local event = params[1]
  if not Lib.HasEventParameter( event, param ) then return end
  local paramNum = eventParameterList[event][param]
  return params[paramNum]
end


function Lib.HasEventParameter( event, parameter )
  return eventParameterList[event][parameter] ~= nil
end


function Lib.RegisterCustomEvent( eventData, callback )
  local function OnEvent(...)
    if eventData.dynamicFilter then
      for param, values in pairs( eventData.dynamicFilter ) do
        if not Lib.HasEventParameter( eventData.code, param ) then return end
        local meetRequirements = false
        for _, value in ipairs( values ) do
          if Lib.GetEventParameter(param, ...) == value then
            meetRequirements = true
            break
          end
        end
        if not meetRequirements then return end
      end
    end
    callback(...)
  end
  Lib.EM:RegisterForEvent(eventData.name, eventData.code, OnEvent)
  if eventData.staticFilter then
    for filter, value in pairs(eventData.staticFilter) do
      Lib.EM:AddFilterForEvent( eventData.name, eventData.code, filter, value)
    end
  end
end


function Lib.UnregisterCustomEvent( eventName, eventCode )
  Lib.EM:UnregisterForEvent( eventName, eventCode )
end
