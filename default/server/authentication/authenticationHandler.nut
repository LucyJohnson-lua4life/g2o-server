::PID_PLAYERNAME_MAP <- {};::PLAYERNAME_PID_MAP <- {};

local redisClient = RedisClientProvider.getClient()
const BACKGROUND_ARENA_CHAMPION = "Arena Champion"
const BACKGROUND_ARCANE_MAGE = "Arcane Mage"
const BACKGROUND_INFAMOUS_HUNTER = "Infamous Hunter"

addEventHandler("onPlayerDisconnect", function(pid, reason) {

	if ((pid in ::PID_PLAYERNAME_MAP)) {
		local playername = ::PID_PLAYERNAME_MAP[pid]
		print("about to playername: " + playername)
		delete::PLAYERNAME_PID_MAP[playername]
	}
	print("about to pid: " + pid)
	delete::PID_PLAYERNAME_MAP[pid]

})


addEventHandler("onPacket", function(pid, packet) {

	print("got in here")

	local packetContent = PacketReader.readPacket(packet)
	// if the packet id doesn't match => stop code execution
	if (packetContent.packetId != PacketId.CEF) {
		print("no cef received")
		return
	}

	if (packetContent.playerId != pid) {
		print("playerid didnt match")
		return
	}

	local message = packetContent.message

	print("got in here")

	if (("messageContext" in message) && message.messageContext == "setCharacterCreationMode") {
		print("Setting character creation mode for playerId: " + packetContent.playerId)
		setPlayerVirtualWorld(packetContent.playerId, packetContent.playerId + 2)
		setPlayerVisual(packetContent.playerId, "Hum_Body_Naked0", 0, "Hum_Head_FatBald", 0)
	} else if (("messageContext" in message) && message.messageContext == "setVisual") {
		processSetVisual(packetContent.playerId, message);
	} else if (("messageContext" in message) && message.messageContext == "switchToRegisterMode") {
		PacketWriter.sendServerCommandPacket(pid, "register")
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
	print("Loading player data for username: " + username + " into playerId: " + playerId)
	local playerData = PlayerRepository.getPlayerByName(redisClient, username)
	local inventoryData = InventoryRepository.getInventoryByName(redisClient, username)

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

	foreach(itemInstance, amount in inventoryData.other) {
		giveItem(playerId, itemInstance, amount)
	}

	//only for debug
	giveItem(playerId, "ITMW_SCHWERT1",1)

	if (inventoryData.melee != null){
        giveItem(playerId, inventoryData.melee, 1)
		equipItem(playerId, inventoryData.melee)
	}
	if (inventoryData.armor != null){
        giveItem(playerId, inventoryData.armor, 1)
		equipItem(playerId, inventoryData.armor)
	}
	if (inventoryData.ranged != null){
        giveItem(playerId, inventoryData.ranged, 1)
		equipItem(playerId, inventoryData.ranged)
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

	print("Registering player: " + stats.name)
	PlayerRepository.setPlayer(redisClient, stats.name, stats)
	InventoryRepository.setInventoryByName(redisClient, stats.name, inventory)
	loadPlayerData(playerId, stats.name)
}

function processRegistrationAttempt(playerId, registrationPacket) {
	local username = registrationPacket.username
	local passwordSha = registrationPacket.passwordSha

	print("Processing registration attempt for username: " + username)
	local userData = PlayerRepository.getPlayerByName(redisClient, username)
	if (userData == null) {
		registerPlayer(playerId, registrationPacket)
		setPlayerVirtualWorld(playerId, 0)
		PacketWriter.sendServerCommandPacket(playerId, "registrationSuccess")
		::PID_PLAYERNAME_MAP[playerId] <- username
		::PLAYERNAME_PID_MAP[username] <- playerId
		print("login playername: " + username + " with pid: " + playerId)
	} else {
		PacketWriter.sendServerCommandPacket(playerId, "registrationUserExists")
	}
}

function processLoginAttempt(playerId, loginPacket) {
	local username = loginPacket.username
	local passwordSha = loginPacket.passwordSha

	handleLogin(playerId, username, passwordSha)
}

function handleLogin(playerId, username, passwordSha) {

	local userData = PlayerRepository.getPlayerByName(redisClient, username)
	print("User data loaded for username: " + username + " is null: " + (userData == null))
	if (userData == null) {
		PacketWriter.sendServerCommandPacket(playerId, "loginFailed")
	} else {

		print("Comparing passwordSha: " + passwordSha + " with stored passwordSha: " + userData.passwordSha)
		if (userData.passwordSha == passwordSha) {
			loadPlayerData(playerId, username)
			setPlayerVirtualWorld(playerId, 0)
			PacketWriter.sendServerCommandPacket(playerId, "loginSuccess")
			print("login playername: " + username + " with pid: " + playerId)
			::PID_PLAYERNAME_MAP[playerId] <- username
			::PLAYERNAME_PID_MAP[username] <- playerId
		} else {
			PacketWriter.sendServerCommandPacket(playerId, "loginFailed")
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