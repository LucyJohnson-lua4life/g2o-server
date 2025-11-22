local redisClient = RedisClientProvider.getClient()

function incrementInventory(playerId, itemInstance) {

	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]
		local inventory = InventoryRepository.getInventoryByName(redisClient, playerName)

		if ((itemInstance in inventory.other)) {
			inventory.other[itemInstance] <- inventory.other[itemInstance] + 1
		} else {
			inventory.other[itemInstance] <- 1
		}
		InventoryRepository.setInventoryByName(redisClient, playerName, inventory)
	}
}

function decrementInventory(playerId, itemInstance) {

	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]
		local inventory = InventoryRepository.getInventoryByName(redisClient, playerName)


		if ((itemInstance in inventory.other)) {

			local amount = inventory.other[itemInstance]
			if (amount > 1) {

				inventory.other[itemInstance] <- inventory.other[itemInstance] - 1
			} else {
				delete inventory.other[itemInstance]
			}
		}

		InventoryRepository.setInventoryByName(redisClient, playerName, inventory)
	}
}

/*
inventory.meleeEquiped <- "ITMW_1H_FERROSSWORD_MIS"
		inventory.armorEquiped <- "ITAR_SLD_H"
		inventory.rangedEquiped
		*/
function handleEquipEvent(playerId, itemInstance, inventoryKey) {
	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]
		local inventory = InventoryRepository.getInventoryByName(redisClient, playerName)

		if((inventoryKey in inventory)){

			local oldItem = inventory[inventoryKey]

			if(oldItem != null && oldItem in inventory.other){
				inventory.other[oldItem] <- inventory.other[oldItem] + 1
			} else if(oldItem != null) {
				inventory.other[oldItem] <- 1
			}


			if((itemInstance in inventory.other)){
				local amount = inventory.other[itemInstance]
				if(amount > 1){
					inventory.other[itemInstance] <- inventory.other[itemInstance] -1
				}
				else{
					delete inventory.other[itemInstance]
				}
			}

			inventory[inventoryKey] <- itemInstance
		}
		InventoryRepository.setInventoryByName(redisClient, playerName, inventory)
	}
}


function handleUnequipEvent(playerId, itemInstance, inventoryKey) {
	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]
		local inventory = InventoryRepository.getInventoryByName(redisClient, playerName)

		if((inventoryKey in inventory)){

			local oldItem = inventory[inventoryKey]
			if(oldItem != itemInstance){
				return
			}

			if(itemInstance in inventory.other){
				inventory.other[itemInstance] <- inventory.other[itemInstance] + 1
			} else {
				inventory.other[itemInstance] <- 1
			}

			inventory[inventoryKey] <- null
		}
		InventoryRepository.setInventoryByName(redisClient, playerName, inventory)
	}
}

/*
function syncInventory(playerId, post) {

	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]
		local inventory = InventoryRepository.getInventoryByName(redisClient, playerName)

		if (("other" in post)) {
			inventory.other <- {}


			foreach(itemInstance, amount in post.other) {
				inventory.other[itemInstance] <- amount
			}

			print("HOOOOLLAAA: " + inventory.other)
		}

		print("hasmelee:" + getPlayerMeleeWeapon(playerId))
		if (("meleeEquiped" in post)) {

			inventory.meleeEquiped <- post.meleeEquiped
		}

		if (("armorEquiped" in post)) {
			inventory.armorEquiped <- post.armorEquiped
		}

		if (("rangedEquiped" in post)) {
			inventory.rangedEquiped <- post.rangedEquiped
		}
		InventoryRepository.setInventoryByName(redisClient, playerName, inventory)
	}
}
*/

addEventHandler("onPacket", function(pid, packet) {

	//local contentOnArrival = InventoryRepository.getInventoryByName(redisClient, playerName)
	local packetContent = PacketReader.readPacket(packet)
	// if the packet id doesn't match => stop code execution
	if (packetContent.packetId != PacketId.CLIENT_POST) {
		return
	}

	if (packetContent.playerId != pid) {
		return
	}

	local postCommand = packetContent.postCommand
	local post = packetContent.post


	if (postCommand == "incrementInventory") {
		incrementInventory(pid, post.itemInstance)
	} else if (postCommand == "decrementInventory") {
		decrementInventory(pid, post.itemInstance)
	}else if (postCommand == "equipMelee") {
		handleEquipEvent(pid, post.itemInstance, "melee")
	}else if (postCommand == "equipRanged") {
		handleEquipEvent(pid, post.itemInstance, "ranged")
	}else if (postCommand == "equipArmor") {
		handleEquipEvent(pid, post.itemInstance, "armor")
	}else if (postCommand == "unequipMelee") {
		handleUnequipEvent(pid, post.itemInstance, "melee")
	}
	else if (postCommand == "unequipRanged") {
		handleUnequipEvent(pid, post.itemInstance, "ranged")
	}
	else if (postCommand == "unequipArmor") {
		handleUnequipEvent(pid, post.itemInstance, "armor")
	}

})


/*
addEventHandler("onPacket", function(pid, packet) {

	print("check for client post")

	local packetContent = PacketReader.readPacket(packet)
	// if the packet id doesn't match => stop code execution
	if (packetContent.packetId != PacketId.CLIENT_POST) {
		return
	}

	if (packetContent.playerId != pid) {
		return
	}

	local post = packetContent.post

	print("got in here for inventory check")

	if (("command" in post) && post.command == "syncInventory") {
		print("melee: " + getPlayerMeleeWeapon(pid))
		syncInventory(pid, post)
	}

})
	*/

/*
addEventHandler("onPacket", function(pid, packet) {

	print("check for client post")

	local packetContent = PacketReader.readPacket(packet)
	// if the packet id doesn't match => stop code execution
	if (packetContent.packetId != PacketId.CLIENT_POST) {
		return
	}
	print("check PID!")
	if (packetContent.playerId != pid) {
		return
	}

	local post = packetContent.post

	print("got in here for inventory check")

	if (("command" in post) && post.command == "incrementInventory") {
		incrementInventory(pid, post.itemInstance)
	} else if (("command" in post) && post.command == "decrementInventory") {
		decrementInventory(pid, post.itemInstance)
	}

})
	*/