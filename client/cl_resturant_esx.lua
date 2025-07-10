---@diagnostic disable: lowercase-global
ESX = exports['es_extended']:getSharedObject();
local onDuty = false

Citizen.CreateThread(function()
    for k, v in pairs(Businesses.Businesses) do
        local registers = v.registers
        local trays = v.trays
        local storage = v.storage
        local clockin = v.clockin
        local CookLoco = v.CookLoco
        local chairs = v.chairs

        if registers then
            for a, d in pairs(registers) do
                if d then
                    local length = 0.5
                    local width = 0.5
                    local height = 0.5

                    exports.ox_target:addBoxZone({
                        coords = vector3(d.coords.x, d.coords.y, d.coords.z - 0.2),
                        size = vec3(length, width, height),
                        rotation = d.coords.w,
                        debug = false,
                        options = {
                            {
                                name = "register-" .. k .. "-" .. a,
                                icon = "fas fa-credit-card",
                                label = "Facturer le client",
                                canInteract = function()
                                    local job = ESX.GetPlayerData().job
                                    return job and job.name == k and onDuty
                                end,
                                onSelect = function()
                                    TriggerEvent("v-businesses:ChargeCustomer", { registerJob = k })
                                end,
                                groups = k,
                            },
                            {
                                name = "register-" .. k .. "-" .. a,
                                icon = "fas fa-user-check",
                                label = "Show Menu",
                                canInteract = function()
                                    local job = ESX.GetPlayerData().job
                                    return job and job.name == k and onDuty
                                end,
                                onSelect = function()
                                    TriggerEvent("v-businesses:ShowMenu", { registerJob = k })
                                end,
                            },
                            {
                                name = "register-" .. k .. "-" .. a,
                                icon = "fas fa-user-check",
                                label = "Payer la facture (client)",
                                onSelect = function()
                                    TriggerEvent("v-businesses:Pay", { registerJob = k })
                                end,
                            }
                        },
                        distance = 2.0
                    })

                    if d.Prop then
                        local registerProp = CreateObject(GetHashKey("prop_till_01"), d.coords.x, d.coords.y,
                            d.coords.z,
                            false, false, false)
                        SetEntityHeading(registerProp, d.coords.w)
                        FreezeEntityPosition(registerProp, true)
                    end
                end
            end
        end

        if trays then
            for a, d in pairs(trays) do
                if d then
                    local length = 0.5
                    local width = 0.5
                    local height = 0.25

                    exports.ox_target:addBoxZone({
                        coords = vector3(d.coords.x, d.coords.y, d.coords.z - 0.62),
                        size = vec3(length, width, height),
                        rotation = d.coords.w,
                        debug = false,
                        options = {
                            {
                                name = "tray-" .. k .. "-" .. a,
                                icon = "fas fa-basket-shopping",
                                label = "Open Tray",
                                canInteract = function()
                                    local job = ESX.GetPlayerData().job
                                    return job and job.name == k and onDuty
                                end,
                                onSelect = function()
                                    -- Ensure parameters are passed as an object
                                    TriggerEvent("v-businesses:OpenTray", { trayId = a, trayJob = k })
                                end,
                            },
                        },
                        distance = 2.0
                    })
                end
            end
        end

        if storage then
            for a, d in ipairs(storage) do
                if d then
                    local height = d.height or 1.0

                    exports.ox_target:addBoxZone({
                        coords = vector3(d.coords.x, d.coords.y, d.coords.z - 0.62),
                        size = vec3(d.width or 1.5, d.length or 0.6, height),
                        rotation = d.coords.w,
                        debug = false,
                        options = {
                            {
                                name = "storage-" .. k .. "-" .. a,
                                icon = "fas fa-dolly",
                                label = d.targetLabel,
                                groups = k,
                                canInteract = function()
                                    local job = ESX.GetPlayerData().job
                                    return job and job.name == k and onDuty
                                end,
                                onSelect = function()
                                    TriggerEvent("v-businesses:OpenStorage", { storageJob = k, storageId = a })
                                end,
                            },
                        },
                        distance = 2.0
                    })
                end
            end
        end

        if CookLoco then
            for a, d in pairs(CookLoco) do
                if d then
                    local height = d.height or 0.35
                    local length = d.length or 1.5
                    local width = d.width or 0.6

                    exports.ox_target:addBoxZone({
                        coords = vector3(d.coords.x, d.coords.y, d.coords.z - 0.52),
                        size = vec3(length, width, height),
                        rotation = d.coords.w,
                        debug = false,
                        options = {
                            {
                                name = "CookLoco-" .. k .. "-" .. a,
                                icon = "fas fa-utensils",
                                label = d.targetLabel,
                                groups = k,
                                canInteract = function()
                                    local job = ESX.GetPlayerData().job
                                    return job and job.name == k and onDuty
                                end,
                                onSelect = function()
                                    TriggerEvent("v-businesses:PrepareFood", { job = k, index = a })
                                end,
                            },
                        },
                        distance = 2.0
                    })
                end
            end
        end

        if clockin then
            exports.ox_target:addBoxZone({
                coords = vector3(clockin.coords.x, clockin.coords.y, clockin.coords.z - 0.62),
                size = vec3(clockin.dimensions.length, clockin.dimensions.width, clockin.dimensions.height),
                rotation = clockin.coords.w,
                debug = false,
                options = {
                    {
                        name = "clockin-" .. k,
                        icon = "fas fa-clock",
                        label = "Clock In/Out",
                        groups = k,
                        onSelect = function()
                            TriggerEvent("v-businesses:ToggleClockIn", k)
                        end,
                    },
                },
                distance = 2.0
            })
        end

        if chairs then
            for a, chair in pairs(chairs) do
                if chair then
                    local size = 0.6
                    local height = 0.25
                    exports.ox_target:addBoxZone({
                        coords = vector3(chair.coords.x, chair.coords.y, chair.coords.z - 0.65),
                        size = vec3(size, size, height),
                        rotation = chair.coords.w,
                        debug = false,
                        options = {
                            {
                                name = "chair-" .. k .. "-" .. a,
                                icon = "fas fa-couch",
                                label = "Sit Chair",
                                onSelect = function()
                                    TriggerEvent("v-businesses:SitChair", {
                                        coords = chair.coords,
                                        chairJob = k
                                    })
                                end,
                            },
                        },
                        distance = 2.5
                    })
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    for businessName, business in pairs(Businesses.Businesses) do
        if business.blip then
            local blip = AddBlipForCoord(business.clockin.coords.x, business.clockin.coords.y, business.clockin.coords.z)
            SetBlipSprite(blip, business.blip.sprite)
            SetBlipScale(blip, business.blip.scale)
            SetBlipColour(blip, business.blip.color)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(business.jobDisplay)
            EndTextCommandSetBlipName(blip)
            SetBlipAsShortRange(blip, true)
        end
    end
end)

if Businesses.OriginalESX then
    RegisterNetEvent('v-businesses:ChargeCustomer', function(info)
        local player, distance = lib.getClosestPlayer()
        if player and distance < 3.0 then
            local input = lib.inputDialog("Facturer un client", {
                { type = "input", label = "Montant", placeholder = "ex: 250",      icon = "euro-sign" },
                { type = "input", label = "Raison",  placeholder = "ex: Boissons", icon = "pen" }
            })

            if input and tonumber(input[1]) then
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), info.registerJob, info.registerJob,
                    tonumber(input[1]), input[2])
            end
        else
            lib.notify({ title = 'Aucun joueur proche', type = 'error' })
        end
    end)
else
    RegisterNetEvent('v-businesses:ChargeCustomer', function(info)
        TriggerEvent(Businesses.ResturantBillingEvent)
    end)
end

RegisterNetEvent('v-businesses:Pay', function(info)
    if Businesses.OriginalESX then
        lib.notify({ title = 'okokBilling n\'est pas actif', type = 'error' })
    else
        TriggerEvent(Businesses.CustomerBillingEvent)
    end
end)


RegisterNetEvent('v-businesses:OpenTray')
AddEventHandler('v-businesses:OpenTray', function(info)
    -- Debugging: Print the type and contents of `info`
    print("Type of info: ", type(info))
    print("Contents of info: ", json.encode(info)) -- Requires a JSON library or similar for pretty-printing

    if type(info) == 'table' and info.trayJob and info.trayId then
        local jobName = info.trayJob
        local trayId = info.trayId
        local stashName = "order-tray-" .. jobName .. "-" .. trayId
        exports["ox_inventory"]:openInventory('stash', stashName)
    else
        print("Error: Invalid data received for OpenTray event.")
    end
end)

RegisterNetEvent('v-businesses:OpenStorage')
AddEventHandler('v-businesses:OpenStorage', function(info)
    -- Print type and contents of `info` to diagnose the issue
    print("Type of info: ", type(info))
    print("Contents of info: ", json.encode(info)) -- Use a JSON library or similar for pretty-printing

    if type(info) == 'table' and info.storageJob and info.storageId then
        local jobName = info.storageJob
        local storageId = info.storageId
        local stashName = "storage-" .. jobName .. "-" .. storageId
        exports["ox_inventory"]:openInventory('stash', stashName)
    else
        print("Error: Invalid data received for OpenStorage event.")
    end
end)

RegisterNetEvent('v-businesses:ToggleClockIn', function(info)
    lib.registerContext({
        id = 'openclothingbusinesses',
        title = Config.Clothing.Title,
        onExit = function()
        end,
        options = {
            {
                event = "v-businesses:businessesdefaultskin",
                icon = Config.Clothing.OwnIcon,
                description = Config.Clothing.OwnDescription,
                title = Config.Clothing.OwnLabel,
            },
            {
                event = "v-businesses:businesseschangeclothes",
                title = Config.Clothing.EmployerLabel,
                icon = Config.Clothing.EmployerIcon,
                description = Config.Clothing.EmployerDescription,
            },
        },
    })
    lib.showContext('openclothingbusinesses')
end)
function cleanPlayer(playerPed)
    SetPedArmour(playerPed, 0)
    ClearPedBloodDamage(playerPed)
    ResetPedVisibleDamage(playerPed)
    ClearPedLastWeaponDamage(playerPed)
    ResetPedMovementClipset(playerPed, 0)
end

function setUniform(uniform, playerPed)
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject

        if skin.sex == 0 then
            uniformObject = Config.Uniforms[uniform].male
        else
            uniformObject = Config.Uniforms[uniform].female
        end

        if uniformObject then
            TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        else
            lib.notify({ title = 'Aucune tenue trouvée', type = 'error' })
        end
    end)
end

RegisterNetEvent('v-businesses:businessesdefaultskin')
AddEventHandler('v-businesses:businessesdefaultskin', function()
    if lib.progressCircle({
            duration = 3000,
            label = 'Vous remettez votre tenue',
            position = 'bottom',
            disable = {
                move = true,
                car = true,
                mouse = false,
                combat = true,
            },
            anim = {
                dict = 'clothingshirt',
                clip = 'try_shirt_positive_d'
            },
        }) then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
        onDuty = false
    end
end)

RegisterNetEvent('v-businesses:businesseschangeclothes')
AddEventHandler('v-businesses:businesseschangeclothes', function()
    local playerPed = PlayerPedId()
    if lib.progressCircle({
            duration = 3000,
            label = 'Vous mettez votre tenue',
            position = 'bottom',
            disable = {
                move = true,
                car = true,
                mouse = false,
                combat = true,
            },
            anim = {
                dict = 'clothingshirt',
                clip = 'try_shirt_positive_d'
            },
        }) then
        setUniform('employer', playerPed)
        onDuty = true
    end
end)

RegisterNetEvent('v-businesses:PrepareFood')
AddEventHandler('v-businesses:PrepareFood', function(info)
    -- Check if `info` is a table and contains the expected fields
    if type(info) == 'table' and info.job and info.index then
        local job = info.job
        local index = info.index
        local CookLoco = Businesses.Businesses[job].CookLoco[index]

        if not CookLoco then
            lib.notify({
                title = 'Invalid Preparation Table',
                type = 'error'
            })
            return
        end

        local options = {}

        for _, item in pairs(CookLoco.items) do
            local hasItems = true
            local requirements = "Requirements:\n"

            if item.requiredItems then
                for _, req in pairs(item.requiredItems) do
                    local itemInfo = (ESX.Items or {})[req.item]
                    local itemDisplayName = itemInfo and itemInfo.label or req.item
                    requirements = requirements .. req.amount .. "x " .. itemDisplayName .. "\n"
                    if exports.ox_inventory:GetItemCount(req.item) < req.amount then
                        hasItems = false
                    end
                end
            else
                requirements = "Requirements: None"
            end

            local iteminfo = exports.ox_inventory:Items(item.item)
            local itemName = iteminfo and iteminfo.label or item.item
            local itemID = iteminfo and iteminfo.name or item.item

            table.insert(options, {
                title = itemName,
                description = requirements,
                image = 'nui://ox_inventory/web/images/' .. itemID .. '.png',
                disabled = not hasItems,
                event = "btrp-business:inputAmount",
                args = { iteminfo = item, index = index }
            })
        end

        lib.registerContext({
            id = 'food_preparation_menu',
            title = 'Prepare Food',
            options = options,
            onExit = function()
                ClearPedTasks(PlayerPedId())
            end
        })

        lib.showContext('food_preparation_menu')
    else
        print("Error: Invalid data received for PrepareFood event.")
        print("Received info:", type(info), json.encode(info))
    end
end)

RegisterNetEvent('btrp-business:inputAmount', function(info)
    local iteminfo = info.iteminfo
    local input = lib.inputDialog('Cooking', {
        { type = 'number', label = 'Food Quantity', description = 'How many would you like to make?', min = 1, max = 10, icon = 'hashtag' }
    })

    local quantity = tonumber(input[1])

    if not quantity then
        ClearPedTasks(PlayerPedId())
        lib.notify({
            title = 'Invalid Input',
            type = 'error'
        })
        return
    end

    local hasAllRequiredItems = true
    local requirements = "Requirements: "

    if iteminfo.requiredItems then
        for _, req in pairs(iteminfo.requiredItems) do
            local totalRequired = req.amount * quantity
            local itemDisplayName = exports.ox_inventory:Items(req.item).label or req.item
            requirements = requirements .. totalRequired .. "x " .. itemDisplayName .. " "

            if exports.ox_inventory:GetItemCount(req.item) < totalRequired then
                hasAllRequiredItems = false
            end
        end
    end

    if not hasAllRequiredItems then
        lib.notify({
            title = 'Insufficient Items',
            description = 'You do not have enough items. Required: ' .. requirements,
            type = 'error'
        })
        return
    end

    TriggerEvent('v-businesses:CompletePreparingFood', { iteminfo = iteminfo, index = info.index, quantity = quantity })
end)

RegisterNetEvent('v-businesses:CompletePreparingFood', function(info)
    local iteminfo = info.iteminfo
    local index = info.index
    local quantity = info.quantity

    for i = 1, quantity do
        if lib.progressCircle({
                duration = iteminfo.time,
                label = iteminfo.progressLabel,
                position = 'bottom',
                disable = {
                    move = true,
                    car = true,
                    mouse = false,
                    combat = true
                },
                anim = {
                    dict = 'mini@drinking',
                    clip = 'shots_barman_b'
                }
            }) then
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('v-businesses:GiveItem', { iteminfo = iteminfo, quantity = 1 })
            Citizen.Wait(1000)
        end
    end

    TriggerEvent('v-businesses:PrepareFood', { index = index })
end)

RegisterNetEvent('v-businesses:SitChair')
AddEventHandler('v-businesses:SitChair', function(info)
    local ped = PlayerPedId()
    local coords = info.coords

    if not coords or not coords.x or not coords.y or not coords.z then
        lib.notify({
            title = 'Invalid chair coordinates.',
            type = 'error'
        })
        return
    end

    local adjustedCoords = vector3(coords.x, coords.y, coords.z - 0.5)

    if #(GetEntityCoords(ped) - adjustedCoords) > 2.0 then
        lib.notify({
            title = 'You are too far from the chair.',
            type = 'error'
        })
        return
    end

    -- Remplacement QBCore.GetPlayersFromCoords
    local playersNearby = {}
    for _, playerId in ipairs(GetActivePlayers()) do
        local playerPed = GetPlayerPed(playerId)
        if playerPed and #(GetEntityCoords(playerPed) - adjustedCoords) <= 0.5 then
            table.insert(playersNearby, playerId)
        end
    end

    for _, player in ipairs(playersNearby) do
        if player ~= PlayerId() and IsPedSittingInAnyVehicle(GetPlayerPed(player)) then
            lib.notify({
                title = 'This seat is taken.',
                type = 'error'
            })
            return
        end
    end

    local business = info.chairJob
    local chairFacing = 0.0

    if Businesses.Businesses[business] and Businesses.Businesses[business].chairs then
        for _, chair in ipairs(Businesses.Businesses[business].chairs) do
            local chairCoords = vector3(chair.coords.x, chair.coords.y, chair.coords.z)
            local distance = #(adjustedCoords - chairCoords)
            if distance < 1.0 then
                chairFacing = chair.coords.w
                break
            end
        end
    end

    TaskGoStraightToCoord(ped, adjustedCoords.x, adjustedCoords.y, adjustedCoords.z, 1.0, 2000, chairFacing, 0.1)
    Wait(1200)
    TaskStartScenarioAtPosition(ped, "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER", adjustedCoords.x, adjustedCoords.y,
        adjustedCoords.z, chairFacing, 0, true, true)

    lib.notify({
        title = 'You sat down on the chair.',
        type = 'success'
    })
end)


RegisterNetEvent('v-businesses:ShowMenu')
AddEventHandler('v-businesses:ShowMenu', function(info)
    -- Handle missing info scenario
    if not info then
        print("No info provided")
        return
    end

    -- Default values to avoid nil indexing
    local businessName = info.registerJob or info.storageJob or info.trayJob or info.CookLocoJob
    local business = Businesses.Businesses[businessName]

    if not business then
        print("Business not found")
        return
    end

    local imageUrl = business.menu

    -- Debugging info
    print("Image URL: " .. (imageUrl or "No URL"))

    lib.alertDialog({
        header = business.jobDisplay .. ' Menu' or "Business Image",
        content = '![Photo ID Image](' .. imageUrl .. ')\n\nUse this image?',
        centered = true,
        cancel = true,
        size = 'xl',
        labels = {
            confirm = 'OK'
        }
    })
end)

-- Seller - auto goes to warehouse stock

Citizen.CreateThread(function()
    if SellerBlip then
        RemoveBlip(SellerBlip)
    end

    SellerBlip = AddBlipForCoord(Config.SellerBlip.coords.x, Config.SellerBlip.coords.y, Config.SellerBlip.coords.z)
    SetBlipSprite(SellerBlip, Config.SellerBlip.blipSprite)
    SetBlipDisplay(SellerBlip, 4)
    SetBlipScale(SellerBlip, Config.SellerBlip.blipScale)
    SetBlipColour(SellerBlip, Config.SellerBlip.blipColor)
    SetBlipAsShortRange(SellerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.SellerBlip.label)
    EndTextCommandSetBlipName(SellerBlip)
end)

Citizen.CreateThread(function()
    local pedModel = GetHashKey(Config.PedModel)
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do
        Wait(500)
    end

    local ped = CreatePed(4, pedModel, Config.Location.coords.x, Config.Location.coords.y, Config.Location.coords.z,
        Config.Location.heading, false, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
    SetModelAsNoLongerNeeded(pedModel)
    exports.ox_target:addBoxZone({
        coords = Config.Location.coords,
        size = vec3(2.0, 2.0, 1.0),
        rotation = Config.Location.heading,
        debug = false,
        options = {
            {
                name = 'fruit_sell_ped',
                icon = "fas fa-shopping-basket",
                label = "Sell Items",
                onSelect = function()
                    TriggerEvent("farming:openFruitMenu")
                end
            },
        },
        distance = 2.0
    })
end)

RegisterNetEvent('farming:openFruitMenu')
AddEventHandler('farming:openFruitMenu', function()
    local fruits = {}

    -- Function to filter fruits based on search query
    local function filterFruits(query)
        local filteredFruits = {}
        for fruit, info in pairs(Config.ItemsFarming) do
            if info.label and string.find(string.lower(info.label), string.lower(query)) then
                local menuItem = {
                    title = info.label,
                    description = 'Sell some ' .. info.label .. "'s",
                    icon = 'fas fa-hand',
                    onSelect = function()
                        TriggerEvent('farming:selectFruit', { fruit = fruit })
                    end
                }
                table.insert(filteredFruits, menuItem)
            end
        end
        return filteredFruits
    end

    -- Function to create the menu with the option to search
    local function createMenu(searchQuery)
        local options = {}

        -- Add the search button at the top
        table.insert(options, {
            title = 'Search',
            description = 'Search for an item to sell',
            icon = 'fas fa-search',
            onSelect = function()
                -- Show the input dialog for search
                local input = lib.inputDialog('Search Items', {
                    { type = 'input', label = 'Enter Item name' }
                })

                -- If input is not canceled, filter and re-open the menu
                if input and input[1] then
                    createMenu(input[1])
                end
            end
        })

        -- Add the fruits based on the current search query
        local filteredFruits = filterFruits(searchQuery or '')
        for _, menuItem in ipairs(filteredFruits) do
            table.insert(options, menuItem)
        end

        -- Register and show the menu
        lib.registerContext({
            id = 'farming_fruit_menu_ox',
            title = 'Fruit Salesman',
            options = options
        })

        lib.showContext('farming_fruit_menu_ox')
    end

    -- Create and show the menu initially without any search query
    createMenu()
end)

RegisterNetEvent('farming:selectFruit')
AddEventHandler('farming:selectFruit', function(data)
    local fruit = data.fruit

    -- Use ox_lib input dialog for both cases
    local dialog = lib.inputDialog("Sell " .. Config.ItemsFarming[fruit].label, {
        {
            type = "number",
            label = "Amount to sell",
            default = "1",
        }
    }, { allowCancel = true })

    if dialog then
        local amount = tonumber(dialog[1])

        if amount and amount >= 1 then
            -- Use ox_lib progress circle for the selling animation
            lib.progressCircle({
                duration = Config.SellProgress,
                label = 'Selling ' .. fruit,
                canCancel = false,
                position = 'bottom',
                disable = {
                    car = true,
                    move = true,
                    combat = true,
                    sprint = true,
                },
                anim = {
                    dict = Config.SellingAnimDict,
                    clip = Config.SellingAnimName
                },
            })
            TriggerServerEvent('farming:sellFruit', fruit, amount)
        else
            -- Use ox_lib notification for invalid amount
            lib.notify({
                title = 'Invalid Amount',
                description = 'Please enter a valid number greater than or equal to 1',
                type = 'error'
            })
        end
    else
        -- Use ox_lib notification for sale cancellation
        lib.notify({
            title = 'Sale canceled',
            description = 'Please enter a valid amount to sell',
            type = 'error'
        })
    end
end)

---- BOSS MENU -----
---
RegisterNetEvent('esx:openBossMenuOx')
AddEventHandler('esx:openBossMenuOx', function(job)
    local options = {
        {
            title = "Menu Gestion Société",
            onSelect = function()
                TriggerEvent('esx_society:openBossMenu', job, nil, { wash = false })
            end
        },
        {
            title = "Coffre entreprise",
            onSelect = function()
                TriggerServerEvent('esx:openSocietyStash', job)
            end
        }
    }

    lib.registerContext({
        id = 'boss_menu_' .. job,
        title = 'Menu Patron - ' .. job,
        options = options
    })

    lib.showContext('boss_menu_' .. job)
end)

CreateThread(function()
    for k, v in pairs(Businesses.Businesses) do
        local bossModel = v.bossModel
        local bossCoords = v.bossCoords

        lib.requestModel(bossModel)

        local ped = CreatePed(0, bossModel, bossCoords.x, bossCoords.y, bossCoords.z - 1.0, bossCoords.w or 0.0, false,
            true)
        SetEntityAsMissionEntity(ped, true, true)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetPedFleeAttributes(ped, 0, 0)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetModelAsNoLongerNeeded(bossModel)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = 'open_boss_menu_' .. k,
                label = 'Menu Patron',
                icon = 'fas fa-briefcase',
                canInteract = function(entity, distance, coords, name)
                    local playerJob = ESX.GetPlayerData().job
                    return playerJob and playerJob.name == k and playerJob.grade_name == 'boss'
                end,
                onSelect = function()
                    TriggerEvent('esx:openBossMenuOx', k)
                end
            }
        })
    end
end)
