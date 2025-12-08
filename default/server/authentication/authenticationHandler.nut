::PID_PLAYERNAME_MAP <- {};::PLAYERNAME_PID_MAP <- {};

local redisClient = RedisClientProvider.getClient()
const BACKGROUND_ARENA_CHAMPION = "Arena Champion"
const BACKGROUND_ARCANE_MAGE = "Arcane Mage"
const BACKGROUND_INFAMOUS_HUNTER = "Infamous Hunter"

addEventHandler("onPlayerDisconnect", function(pid, reason) {

	if ((pid in ::PID_PLAYERNAME_MAP)) {
		local playername = ::PID_PLAYERNAME_MAP[pid]
		delete::PLAYERNAME_PID_MAP[playername]
		delete::PID_PLAYERNAME_MAP[pid]
	}

})


addEventHandler("onPacket", function(pid, packet) {

	local packetContent = PacketReader.readPacket(packet)
	// if the packet id doesn't match => stop code execution
	if (packetContent.packetId != PacketId.CEF) {
		return
	}

	if (packetContent.playerId != pid) {
		return
	}

	local message = packetContent.message

	if (("messageContext" in message) && message.messageContext == "setCharacterCreationMode") {
		setPlayerVirtualWorld(packetContent.playerId, packetContent.playerId + 2)
		setPlayerVisual(packetContent.playerId, "Hum_Body_Naked0", 0, "Hum_Head_FatBald", 0)
	} else if (("messageContext" in message) && message.messageContext == "setVisual") {
		processSetVisual(packetContent.playerId, message);
	} else if (("messageContext" in message) && message.messageContext == "switchToRegisterMode") {
		PacketWriter.sendServerPostPacket(pid, "register", {})
	} else if (("messageContext" in message) && message.messageContext == "attemptLogin") {
		processLoginAttempt(pid, message);
	} else if (("messageContext" in message) && message.messageContext == "attemptRegistration") {
		processRegistrationAttempt(pid, message);
	}
})


function getPlayerStatsByBackground(background) {
	local stats = {}

	if (background == BACKGROUND_ARENA_CHAMPION) {
		stats.health <- 1100
		stats.mana <- 10
		stats.str <- 100
		stats.dex <- 10
		stats.oneHand <- 100
		stats.twoHand <- 100
		stats.bow <- 10
		stats.crossBow <- 10
		stats.circle <- 0
	} else if (background == BACKGROUND_ARCANE_MAGE) {
		stats.health <- 700
		stats.mana <- 200
		stats.str <- 30
		stats.dex <- 10
		stats.oneHand <- 30
		stats.twoHand <- 50
		stats.bow <- 10
		stats.crossBow <- 10
		stats.circle <- 6
	} else if (background == BACKGROUND_INFAMOUS_HUNTER) {
		stats.health <- 900
		stats.mana <- 10
		stats.str <- 50
		stats.dex <- 100
		stats.oneHand <- 50
		stats.twoHand <- 10
		stats.bow <- 100
		stats.crossBow <- 10
		stats.circle <- 0
	} else {
		stats.health <- 1100
		stats.mana <- 10
		stats.str <- 100
		stats.dex <- 10
		stats.oneHand <- 100
		stats.twoHand <- 100
		stats.bow <- 10
		stats.crossBow <- 10
		stats.circle <- 0
	}
	return stats
}

function getPlayerInventoryByBackground(background) {
	local inventory = {}

	if (background == BACKGROUND_ARENA_CHAMPION) {
		inventory.melee <- "ITMW_1H_FERROSSWORD_MIS"
		inventory.armor <- "ITAR_SLD_H"
		inventory.ranged <- null
		inventory.other <- {
			"ITPO_HEALTH_ADDON_04": 20,
			"ITPO_MANA_ADDON_04": 20
		}

	} else if (background == BACKGROUND_ARCANE_MAGE) {
		inventory.melee <- null
		inventory.armor <- "ITAR_KDW_L_ADDON"
		inventory.ranged <- null
		inventory.other <- {
			"ITPO_HEALTH_ADDON_04": 20,
			"ITPO_MANA_ADDON_04": 20
		}

	} else if (background == BACKGROUND_INFAMOUS_HUNTER) {
		inventory.melee <- "ITMW_1H_FERROSSWORD_MIS"
		inventory.armor <- "ITAR_LEATHER_L"
		inventory.ranged <- "ITRW_SLD_BOW"
		inventory.other <- {
			"ITPO_HEALTH_ADDON_04": 20,
			"ITPO_MANA_ADDON_04": 20
		}
	} else {
		inventory.melee <- "ITMW_1H_FERROSSWORD_MIS"
		inventory.armor <- "ITAR_SLD_H"
		inventory.ranged <- null
		inventory.other <- {
			"ITPO_HEALTH_ADDON_04": 20,
			"ITPO_MANA_ADDON_04": 20
		}
	}
	return inventory
}

function loadPlayerData(playerId, username) {
	local playerData = PlayerRepository.getPlayerByName(redisClient, username)


	print("Loading data for player: " + username)

	local inventory = redisClient.hgetallFlat("inventory:" + username)

	local meleeName = redisClient.hget("equipped:" + username, "melee")
	local rangedName = redisClient.hget("equipped:" + username, "ranged")
	local armorName = redisClient.hget("equipped:" + username, "armor")


	setPlayerVisual(playerId, playerData.bodyModel, playerData.bodyTexture, playerData.headModel, playerData.headTexture)

	setPlayerMaxHealth(playerId, playerData.health)
	setPlayerHealth(playerId, playerData.health)
	setPlayerMana(playerId, playerData.mana)
	setPlayerMaxMana(playerId, playerData.mana)
	setPlayerStrength(playerId, playerData.str)
	setPlayerDexterity(playerId, playerData.dex)
	setPlayerSkillWeapon(playerId, 0, playerData.oneHand)
	setPlayerSkillWeapon(playerId, 1, playerData.twoHand)
	setPlayerSkillWeapon(playerId, 2, playerData.bow)
	setPlayerSkillWeapon(playerId, 3, playerData.crossBow)

	setPlayerTalent(playerId, TALENT_MAGE, playerData.circle)

	if(inventory != null) {
		foreach(itemInstance, amount in inventory) {
			print("itemInstance: " + itemInstance + " amount: " + amount)
			giveItem(playerId, itemInstance, amount.tointeger())
			print("Giving itemSST " + itemInstance + " x" + amount + " to " + username)
		}
	}else {
		print("No inventory found for player: " + username)
	}

	//only for debug
	giveItem(playerId, "ITMW_SCHWERT1",1)

	if (meleeName != ""){
        giveItem(playerId, meleeName, 1)
		equipItem(playerId, meleeName)
	}
	if (armorName != ""){
        giveItem(playerId, armorName, 1)
		equipItem(playerId, armorName)
	}
	if (rangedName != ""){
        giveItem(playerId, rangedName, 1)
		equipItem(playerId, rangedName)
	}

}

function registerPlayer(playerId, registrationPacket) {

	local stats = getPlayerStatsByBackground(registrationPacket.background)
	local inventory = getPlayerInventoryByBackground(registrationPacket.background)

	stats.name <- registrationPacket.username
	stats.passwordSha <- registrationPacket.passwordSha
	stats.bodyModel <- registrationPacket.bodyModel
	stats.bodyTexture <- registrationPacket.bodyTexture
	stats.headModel <- registrationPacket.headModel
	stats.headTexture <- registrationPacket.headTexture

	inventory.name <- registrationPacket.username

	PlayerRepository.setPlayer(redisClient, stats.name, stats)

	foreach(itemInstance, amount in inventory.other) {
		redisClient.hset("inventory:" + inventory.name, itemInstance, amount)
		print("Giving item " + itemInstance + " x" + amount + " to " + inventory.name)
	}
	redisClient.hset("equipped:" + inventory.name, "melee", inventory.melee)
	redisClient.hset("equipped:" + inventory.name, "ranged", inventory.ranged)
	redisClient.hset("equipped:" + inventory.name, "armor", inventory.armor)

	loadPlayerData(playerId, stats.name)
}

function processRegistrationAttempt(playerId, registrationPacket) {
	local username = registrationPacket.username
	local passwordSha = registrationPacket.passwordSha

	local userData = PlayerRepository.getPlayerByName(redisClient, username)
	if (userData == null) {
		registerPlayer(playerId, registrationPacket)
		setPlayerVirtualWorld(playerId, 0)
		PacketWriter.sendServerPostPacket(playerId, "registrationSuccess", {})
		::PID_PLAYERNAME_MAP[playerId] <- username
		::PLAYERNAME_PID_MAP[username] <- playerId
	} else {
		PacketWriter.sendServerPostPacket(playerId, "registrationUserExists", {})
	}
}

function processLoginAttempt(playerId, loginPacket) {
	local username = loginPacket.username
	local passwordSha = loginPacket.passwordSha

	handleLogin(playerId, username, passwordSha)
}

function handleLogin(playerId, username, passwordSha) {

	local userData = PlayerRepository.getPlayerByName(redisClient, username)
	if (userData == null) {
		PacketWriter.sendServerPostPacket(playerId, "loginFailed", {})
	} else {
		if (userData.passwordSha == passwordSha) {
			loadPlayerData(playerId, username)
			setPlayerVirtualWorld(playerId, 0)
			PacketWriter.sendServerPostPacket(playerId, "loginSuccess", {})
			::PID_PLAYERNAME_MAP[playerId] <- username
			::PLAYERNAME_PID_MAP[username] <- playerId
		} else {
			PacketWriter.sendServerPostPacket(playerId, "loginFailed", {})
		}
	}
}


function processSetVisual(playerId, visualPacket) {
	local bodyModel = visualPacket.bodyModel
	local bodyTxt = visualPacket.bodyTexture
	local headModel = visualPacket.headModel
	local headTxt = visualPacket.headTexture
	setPlayerVisual(playerId, bodyModel, bodyTxt, headModel, headTxt)
}