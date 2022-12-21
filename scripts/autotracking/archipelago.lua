ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")

CUR_INDEX = -1
SLOT_DATA = nil
LOCAL_ITEMS = {}
GLOBAL_ITEMS = {}

function onClear(slot_data)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onClear, slot_data:\n%s", dump_table(slot_data)))
    end
    SLOT_DATA = slot_data
    CUR_INDEX = -1
    -- reset locations
    for _, v in pairs(LOCATION_MAPPING) do
        if v[1] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing location %s", v[1]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[1]:sub(1, 1) == "@" then
                    obj.AvailableChestCount = obj.ChestCount
                else
                    obj.Active = false
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    -- reset items
    for _, v in pairs(ITEM_MAPPING) do
        if v[1] and v[2] then
            if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: clearing item %s of type %s", v[1], v[2]))
            end
            local obj = Tracker:FindObjectForCode(v[1])
            if obj then
                if v[2] == "toggle" then
                    obj.Active = false
                elseif v[2] == "progressive" then
                    obj.CurrentStage = 0
                    obj.Active = false
                elseif v[2] == "consumable" then
                    obj.AcquiredCount = 0
                elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                    print(string.format("onClear: unknown item type %s for code %s", v[2], v[1]))
                end
            elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
                print(string.format("onClear: could not find object for code %s", v[1]))
            end
        end
    end
    
    LOCAL_ITEMS = {}
    GLOBAL_ITEMS = {}

    if SLOT_DATA == nil then
        return
    end

    if slot_data['second_fossil_check_condition'] then
        local obj = Tracker:FindObjectForCode("op_fos")
        if obj then
            obj.AcquiredCount = slot_data['second_fossil_check_condition']
        end
    end
    if slot_data['require_item_finder'] then
        local obj = Tracker:FindObjectForCode("op_if")
        if obj then
            obj.CurrentStage = slot_data['require_item_finder']
        end
    end
    if slot_data['randomize_hidden_items'] then
        local obj = Tracker:FindObjectForCode("op_hid")
        local stage = slot_data['randomize_hidden_items']
        if (stage >=2) then
            stage = 2
        end
        if obj then
            obj.CurrentStage = stage
        end
    end
    if slot_data['badges_needed_for_hm_moves'] then
        local obj = Tracker:FindObjectForCode("op_hm")
        local stage = slot_data['badges_needed_for_hm_moves']
        if (stage >= 2) then
            stage = 2
        end
        if obj then
            obj.CurrentStage = stage
        end
    end
    if slot_data['extra_key_items'] then
        local obj = Tracker:FindObjectForCode("op_exk")
        if obj then
            obj.CurrentStage = slot_data['extra_key_items']
        end
    end
    if slot_data['tea'] then
        local obj = Tracker:FindObjectForCode("op_tea")
        if obj then
            obj.CurrentStage = slot_data['tea']
        end
    end
    if slot_data['extra_strength_boulders'] then
        local obj = Tracker:FindObjectForCode("op_bldr")
        if obj then
            obj.CurrentStage = slot_data['extra_strength_boulders']
        end
    end
    if slot_data['old_man'] then
        local obj = Tracker:FindObjectForCode("op_man")
        local stage = slot_data['old_man']
        if (stage == 2) then
            stage = 0
        else
            stage = 1
        end
        if obj then
            obj.CurrentStage = stage
        end
    end
    if slot_data['free_fly_map'] then
        local obj = Tracker:FindObjectForCode("freefly")
        if obj then
            obj.CurrentStage = slot_data['free_fly_map']
        end
    end
    if slot_data['extra_badges'] then
        local hm
        local badge
        local obj
        local blist = {m=2,v=3,e=4,b=5,c=6,t=7,r=8,s=9}
        if slot_data['extra_badges']["Cut"] then
            badge = string.sub(slot_data['extra_badges']["Cut"],1,1)
            badge = string.lower(badge)
            obj = Tracker:FindObjectForCode("cutex")
            if obj then
                obj.CurrentStage = blist[badge]
            end
        else
            obj = Tracker:FindObjectForCode("cutex")
            if obj then
                obj.CurrentStage = 1
            end
        end
        if slot_data['extra_badges']["Fly"] then
            badge = string.sub(slot_data['extra_badges']["Fly"],1,1)
            badge = string.lower(badge)
            obj = Tracker:FindObjectForCode("flyex")
            if obj then
                obj.CurrentStage = blist[badge]
            end
        else
            obj = Tracker:FindObjectForCode("flyex")
            if obj then
                obj.CurrentStage = 1
            end
        end
        if slot_data['extra_badges']["Surf"] then
            badge = string.sub(slot_data['extra_badges']["Surf"],1,1)
            badge = string.lower(badge)
            obj = Tracker:FindObjectForCode("surfex")
            if obj then
                obj.CurrentStage = blist[badge]
            end
        else
            obj = Tracker:FindObjectForCode("surfex")
            if obj then
                obj.CurrentStage = 1
            end
        end
        if slot_data['extra_badges']["Strength"] then
            badge = string.sub(slot_data['extra_badges']["Strength"],1,1)
            badge = string.lower(badge)
            obj = Tracker:FindObjectForCode("strengthex")
            if obj then
                obj.CurrentStage = blist[badge]
            end
        else
            obj = Tracker:FindObjectForCode("strengthex")
            if obj then
                obj.CurrentStage = 1
            end
        end
        if slot_data['extra_badges']["Flash"] then
            badge = string.sub(slot_data['extra_badges']["Flash"],1,1)
            badge = string.lower(badge)
            obj = Tracker:FindObjectForCode("flashex")
            if obj then
                obj.CurrentStage = blist[badge]
            end
        else
            obj = Tracker:FindObjectForCode("flashex")
            if obj then
                obj.CurrentStage = 1
            end
        end
        if slot_data['oaks_aide_rt_2'] then
            obj = Tracker:FindObjectForCode("aide2")
            if obj then
                obj.AcquiredCount = slot_data['oaks_aide_rt_2']
            end
        end
        if slot_data['oaks_aide_rt_11'] then
            obj = Tracker:FindObjectForCode("aide11")
            if obj then
                obj.AcquiredCount = slot_data['oaks_aide_rt_11']
            end
        end
        if slot_data['oaks_aide_rt_15'] then
            obj = Tracker:FindObjectForCode("aide15")
            if obj then
                obj.AcquiredCount = slot_data['oaks_aide_rt_15']
            end
        end
        if slot_data['randomize_pokedex'] then
            obj = Tracker:FindObjectForCode("op_dex")
            if obj then
                obj.CurrentStage = slot_data['randomize_pokedex']
            end
        end
        if slot_data['trainersanity'] then
            obj = Tracker:FindObjectForCode("op_trn")
            if obj then
                obj.CurrentStage = slot_data['trainersanity']
            end
        end
    end
end

-- called when an item gets collected
function onItem(index, item_id, item_name, player_number)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onItem: %s, %s, %s, %s, %s", index, item_id, item_name, player_number, CUR_INDEX))
    end
    if index <= CUR_INDEX then
        return
    end
    local is_local = player_number == Archipelago.PlayerNumber
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: could not find item mapping for id %s", item_id))
        end
        return
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: code: %s, type %s", v[1], v[2]))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[2] == "toggle" then
            obj.Active = true
        elseif v[2] == "progressive" then
            if obj.Active then
                obj.CurrentStage = obj.CurrentStage + 1
            else
                obj.Active = true
            end
        elseif v[2] == "consumable" then
            obj.AcquiredCount = obj.AcquiredCount + obj.Increment
        elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("onItem: unknown item type %s for code %s", v[2], v[1]))
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
    -- track local items via snes interface
    if is_local then
        if LOCAL_ITEMS[v[1]] then
            LOCAL_ITEMS[v[1]] = LOCAL_ITEMS[v[1]] + 1
        else
            LOCAL_ITEMS[v[1]] = 1
        end
    else
        if GLOBAL_ITEMS[v[1]] then
            GLOBAL_ITEMS[v[1]] = GLOBAL_ITEMS[v[1]] + 1
        else
            GLOBAL_ITEMS[v[1]] = 1
        end
    end
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("local items: %s", dump_table(LOCAL_ITEMS)))
        print(string.format("global items: %s", dump_table(GLOBAL_ITEMS)))
    end
    if PopVersion < "0.20.1" or AutoTracker:GetConnectionState("SNES") == 3 then
        -- add snes interface functions here for local item tracking
    end
end

--called when a location gets cleared
function onLocation(location_id, location_name)
    if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("called onLocation: %s, %s", location_id, location_name))
    end
    local v = LOCATION_MAPPING[location_id]
    if not v and AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    if not v[1] then
        return
    end
    local obj = Tracker:FindObjectForCode(v[1])
    if obj then
        if v[1]:sub(1, 1) == "@" then
            obj.AvailableChestCount = obj.AvailableChestCount - 1
        else
            obj.Active = true
        end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
        print(string.format("onLocation: could not find object for code %s", v[1]))
    end
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)