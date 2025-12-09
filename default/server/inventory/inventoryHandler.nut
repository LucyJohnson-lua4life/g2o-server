local redisClient = RedisClientProvider.getClient()

function incrementInventory(playerId, itemInstance) {

	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]

		local amount = InventoryRepository.getItemAmountByName(redisClient, playerName, itemInstance)
		amount = amount == "" ? 0 : amount.tointeger()

		if (amount != 0) {
			InventoryRepository.setItemByName(redisClient, playerName, itemInstance, amount + 1)
		} else {
			InventoryRepository.setItemByName(redisClient, playerName, itemInstance, 1)
		}


	}
}

function decrementInventory(playerId, itemInstance) {

	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]

		local amount = InventoryRepository.getItemAmountByName(redisClient, playerName, itemInstance)
		amount = amount == "" ? 0 : amount.tointeger()

		if (amount > 1) {
			InventoryRepository.setItemByName(redisClient, playerName, itemInstance, amount - 1)
		} else {
			InventoryRepository.deleteItemByName(redisClient, playerName, itemInstance)
		}

	}
}

function handleEquipEvent(playerId, itemInstance, equipmentType) {
	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]

		local amount = InventoryRepository.getItemAmountByName(redisClient, playerName, itemInstance)
		amount = amount == "" ? 0 : amount.tointeger()
		local oldItem = InventoryRepository.getEquippedByType(redisClient, playerName, equipmentType)
		local oldItemAmount = InventoryRepository.getItemAmountByName(redisClient, playerName, oldItem)
		oldItemAmount = oldItemAmount == "" ? 0 : oldItemAmount

		if (oldItemAmount != 0) {
			InventoryRepository.setItemByName(redisClient, playerName, oldItem, oldItemAmount + 1)
		} else if (oldItemAmount == 0) {
			InventoryRepository.setItemByName(redisClient, playerName, oldItem, 1)
		}

		if (amount > 1) {
			InventoryRepository.setItemByName(redisClient, playerName, itemInstance, amount - 1)
		} else {
			InventoryRepository.deleteItemByName(redisClient, playerName, itemInstance)
		}

		InventoryRepository.setEquippedByName(redisClient, playerName, equipmentType, itemInstance)
	}
}


function handleUnequipEvent(playerId, itemInstance, equipmentType) {
	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]

		local amount = InventoryRepository.getItemAmountByName(redisClient, playerName, itemInstance)
		amount = amount == "" ? 0 : amount.tointeger()
		local oldItem = InventoryRepository.getEquippedByType(redisClient, playerName, equipmentType)
		local oldItemAmount = InventoryRepository.getItemAmountByName(redisClient, playerName, oldItem)
		oldItemAmount = oldItemAmount == "" ? 0 : oldItemAmount


		if (oldItem != itemInstance) {
			return
		} else {
			InventoryRepository.deleteEquippedByType(redisClient, playerName, equipmentType)
		}

		if (amount != 0) {
			InventoryRepository.setItemByName(redisClient, playerName, itemInstance, amount + 1)
		} else {
			InventoryRepository.setItemByName(redisClient, playerName, itemInstance, 1)
		}
	}
}

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
	} else if (postCommand == "equipMelee") {
		handleEquipEvent(pid, post.itemInstance, "melee")
	} else if (postCommand == "equipRanged") {
		handleEquipEvent(pid, post.itemInstance, "ranged")
	} else if (postCommand == "equipArmor") {
		handleEquipEvent(pid, post.itemInstance, "armor")
	} else if (postCommand == "unequipMelee") {
		handleUnequipEvent(pid, post.itemInstance, "melee")
	} else if (postCommand == "unequipRanged") {
		handleUnequipEvent(pid, post.itemInstance, "ranged")
	} else if (postCommand == "unequipArmor") {
		handleUnequipEvent(pid, post.itemInstance, "armor")
	}

})