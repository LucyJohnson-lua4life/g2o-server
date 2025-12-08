local redisClient = RedisClientProvider.getClient()

function incrementInventory(playerId, itemInstance) {

	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]

		local amount = redisClient.hget("inventory:" + playerName, itemInstance)
		amount = amount == "" ? 0 : amount.tointeger()

		if (amount != 0) {
			redisClient.hset("inventory:" + playerName, itemInstance, amount + 1)
		} else {
			redisClient.hset("inventory:" + playerName, itemInstance, 1)
		}


	}
}

function decrementInventory(playerId, itemInstance) {

	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]

		local amount = redisClient.hget("inventory:" + playerName, itemInstance)
		amount = amount == "" ? 0 : amount.tointeger()

		if (amount > 1) {
			redisClient.hset("inventory:" + playerName, itemInstance, amount - 1)
		} else {
			redisClient.hdel("inventory:" + playerName, itemInstance)
		}

	}
}

function handleEquipEvent(playerId, itemInstance, equipmentType) {
	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]

		local amount = redisClient.hget("inventory:" + playerName, itemInstance)
		amount = amount == "" ? 0 : amount.tointeger()
		local oldItem = redisClient.hget("equipped:" + playerName, equipmentType)
		local oldItemAmount = redisClient.hget("inventory:" + playerName, oldItem)
		oldItemAmount = oldItemAmount == "" ? 0 : oldItemAmount

		if (oldItemAmount != 0) {
			redisClient.hset("inventory:" + playerName, oldItem, oldItemAmount + 1)
		} else if (oldItemAmount == 0) {
			redisClient.hset("inventory:" + playerName, oldItem, 1)
		}

		if (amount > 1) {
			redisClient.hset("inventory:" + playerName, itemInstance, amount - 1)
		} else {
			redisClient.hdel("inventory:" + playerName, itemInstance)
		}

		redisClient.hset("equipped:" + playerName, equipmentType, itemInstance)
	}
}


function handleUnequipEvent(playerId, itemInstance, equipmentType) {
	if ((playerId in ::PID_PLAYERNAME_MAP)) {
		local playerName = ::PID_PLAYERNAME_MAP[playerId]


		local amount = redisClient.hget("inventory:" + playerName, itemInstance)
		amount = amount == "" ? 0 : amount.tointeger()
		local oldItem = redisClient.hget("equipped:" + playerName, equipmentType)
		local oldItemAmount = redisClient.hget("inventory:" + playerName, oldItem)
		oldItemAmount = oldItemAmount == "" ? 0 : oldItemAmount


		if (oldItem != itemInstance) {
			return
		}else {
			redisClient.hdel("equipped:" + playerName, equipmentType)
		}

		if (amount != 0) {
			redisClient.hset("inventory:" + playerName, itemInstance, amount + 1)
		} else {
			redisClient.hset("inventory:" + playerName, itemInstance, 1)
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