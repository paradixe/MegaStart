	function initPlayer(player)
    if player.character == nil then return end
    if global.donePlayers == nil then
        global.donePlayers = {}
    end
    if global.donePlayers[player.index] then return end
    global.donePlayers[player.index] = true

    player.get_inventory(defines.inventory.character_main).clear()
    player.get_inventory(defines.inventory.character_armor).clear()
    player.get_inventory(defines.inventory.character_guns).clear()
    player.get_inventory(defines.inventory.character_ammo).clear()

    -- Self item list
    local items = {
        -- basics
        {"coal", 200},
		{"iron-plate", 200},
		{"copper-plate", 200},
		{"iron-gear-wheel", 200},
		{"electronic-circuit", 200},
		-- belts
		{"fast-transport-belt", 1800},
		{"fast-underground-belt", 100},
		{"fast-splitter", 50},
		-- anti-biter
		{"grenade", 100},
		-- pipes
		{"pipe-to-ground", 100},
		{"pipe", 100},
		-- other logistic
		{"fast-inserter", 100},
		{"long-handed-inserter", 100},
		{"inserter", 100},
		{"steel-chest", 50},
		{"wooden-chest", 50},
		{"construction-robot", 50},
		-- buildings
		{"steel-furnace", 100},
		{"assembling-machine-2", 100},
		{"assembling-machine-1", 20},
		{"electric-mining-drill", 200},
		-- transportation
		{"carmk3", 1},
		{"repair-pack", 50},
		-- electricity
		{"big-electric-pole", 100},
		{"medium-electric-pole", 100},
		{"small-electric-pole", 50},
		{"boiler", 10},
		{"steam-engine", 20},
		{"offshore-pump", 5},
	}
    for _, item in pairs(items) do
        player.insert{name = item[1], count = item[2]}
    end

    -- Power armor mk2 loadout
    local armorInventory = player.get_inventory(defines.inventory.character_armor)
    armorInventory.insert("power-armor-mk2")
    local armorGrid = armorInventory.find_item_stack("power-armor-mk2").grid

    local equipment = {
				"fusion-reactor-equipment",
				"fusion-reactor-equipment",
				"fusion-reactor-equipment",
				"fusion-reactor-equipment",
				"exoskeleton-equipment",
				"battery-mk2-equipment",
				"battery-mk2-equipment",
				"battery-mk2-equipment",
				"belt-immunity-equipment",
				"night-vision-equipment",
				"personal-roboport-mk2-equipment",
    }
    for _, equip in pairs(equipment) do
        armorGrid.put{name = equip}
    end

	-- Specific inventories for different spidertrons
		-- Construction Spidertron
		local constructionInventory = {
				-- belts
				{"fast-transport-belt", 3200},
				{"fast-underground-belt", 200},
				{"fast-splitter", 200},
				-- pipes
				{"pipe-to-ground", 400},
				{"pipe", 400},
				-- other logistic
				{"fast-inserter", 400},
				{"long-handed-inserter", 200},
				{"steel-chest", 100},
				{"construction-robot", 100},
				-- buildings
				{"steel-furnace", 400},
				{"assembling-machine-2", 100},
				{"electric-mining-drill", 600},
				-- electricity
				{"repair-pack", 100},
				{"spidertron-remote", 1},
				{"big-electric-pole", 600},
				{"medium-electric-pole", 200},
				{"small-electric-pole", 100},
				{"boiler", 20},
				{"steam-engine", 40},
				{"offshore-pump", 10},
		}
		-- Military Spidertron
		local militaryInventory = {
				{"explosive-rocket", 23000},
				{"repair-pack", 500},
				{"construction-robot", 100},
				{"spidertron-remote", 1},
		}
		-- Allrounder Spidertron
		local allRounderInventory = {
				-- belts
				{"fast-transport-belt", 1800},
				{"fast-underground-belt", 200},
				{"fast-splitter", 100},
				-- pipes
				{"pipe-to-ground", 100},
				{"pipe", 100},
				-- other logistic
				{"fast-inserter", 100},
				{"long-handed-inserter", 100},
				{"steel-chest", 100},
				{"construction-robot", 100},
				-- buildings
				{"steel-furnace", 100},
				{"assembling-machine-2", 100},
				{"electric-mining-drill", 100},
				-- electricity
				{"repair-pack", 100},
				{"spidertron-remote", 1},
				{"big-electric-pole", 200},
				{"medium-electric-pole", 100},
				{"small-electric-pole", 50},
				{"explosive-rocket", 12000},
				{"boiler", 20},
				{"steam-engine", 40},
				{"offshore-pump", 10},
		}

		-- Function to add items to a spidertron
		local function addItemsToSpidertron(spidertron, inventoryItems)
			for _, item in pairs(inventoryItems) do
				spidertron.insert{name = item[1], count = item[2]}
			end
		end

		-- Create Spidertrons with specific roles
		local function createSpidertrons(player)
		-- Number of Spidertrons
			local spidertronTypes = {
				{inventory = constructionInventory, quantity = 1},
				{inventory = militaryInventory, quantity = 2},
				{inventory = allRounderInventory, quantity = 1},
			}

    for _, spidertronType in pairs(spidertronTypes) do
        for i = 1, spidertronType.quantity do
            local position = player.surface.find_non_colliding_position("spidertronmk3", player.position, 10, 1)
            if position then
                local spidertron = player.surface.create_entity{name="spidertronmk3", position=position, force=player.force}
                if spidertron and spidertron.valid then
                    log("Spidertronmk3 created at position: " .. serpent.line(position))
                    -- Check if the spidertron has a grid and add equipment
                    if spidertron.grid then
					-- Spidertron Equipment, Shared between all Spidertrons
                        local spidertronEquipment = {
                            {"fusion-reactor-equipment", 8},
                            {"personal-roboport-mk2-equipment", 6},
                            {"exoskeleton-equipment", 10},
                            {"battery-mk2-equipment", 14},
                            {"energy-shield-mk2-equipment", 4},
                            {"personal-laser-defense-equipment", 6},
                        }
						for _, equip in pairs(spidertronEquipment) do
							for i = 1, equip[2] do
								spidertron.grid.put{name = equip[1]}
							end
						end
                        addItemsToSpidertron(spidertron, spidertronType.inventory)
                    else
                        log("Failed to create Spidertronmk3")
                    end
                else
                    log("No valid position found to create Spidertronmk3")
                end
            end
        end
    end
end

-- Self Ammo
player.get_inventory(defines.inventory.character_guns).insert{name = "submachine-gun", count = 5}
	player.get_inventory(defines.inventory.character_ammo).insert{name = "uranium-rounds-magazine", count = 400}
    -- Create Spidertrons
    createSpidertrons(player)
end

function onPlayerJoined(event)
	local player = game.players[event.player_index]
	initPlayer(player)
end



script.on_event({defines.events.on_player_joined_game, defines.events.on_player_created}, onPlayerJoined)

-- Skip Crashsite and Intro
function onModInit()
	if remote.interfaces["freeplay"] then
		remote.call("freeplay", "set_disable_crashsite", true)
		remote.call("freeplay", "set_skip_intro", true)
	end
end

script.on_init(onModInit)


