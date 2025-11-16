local browser = Browser(0, 0, 8192, 8192, "cef://index.html");


function setCharacterCreationMode() {
	Camera.movementEnabled = false;
	Camera.modeChangeEnabled = false;

	local playerPos = getPlayerPosition(heroId);
	local playerAngle = getPlayerAngle(heroId);

	local distance = 250; // Distance in front of player
	local rad = playerAngle * PI / 180;

	local offsetX = distance * sin(rad);
	local offsetZ = distance * cos(rad);
	local offsetY = 50; // Slightly above player for better view

	Camera.setPosition(playerPos.x + offsetX, playerPos.y + offsetY, playerPos.z + offsetZ);
	Camera.setRotation(0, playerAngle + 180, 0); // Look at player from front
	setFreeze(true)
	browser.visible = true
	setCursorVisible(true)
}


addEventHandler("onPacket", function(packet) {
	// read unique packet id
	local packetContent = PacketReader.readPacket(packet)

	// if the packet id doesn't match => stop code execution
	if (packetContent.packetId != PacketId.SERVER_COMMAND) {
		return
	}
	if (packetContent.playerId != heroId) {
		return
	}


	// read message
	local command = packetContent.command
	// IMPORTANT: SET character creation Mode only for the heroId that is determined by the server!!!!

	Chat.print(0, 255, 0, "Received server command: " + command + " for playerId: " + packetContent.playerId)

	if (command == "setCharacterCreationMode") {
		setCharacterCreationMode()
		local message = JsonUtils.toJson({
			messageContext = "setCharacterCreationMode"
		})
		Chat.print(0, 255, 0, message)
		PacketWriter.sendCefPacket(heroId, message)
	} else if (command == "loginSuccess") {
		Camera.movementEnabled = true;
		Camera.modeChangeEnabled = true;
		setFreeze(false)
		browser.call("runLoginSuccess")
	} else if (command == "loginFailed") {
		browser.call("runLoginFailed")
	} else if (command == "registrationUserExists") {
		browser.call("runRegistrationUserExists")
	} else if (command == "registrationSuccess") {
		Camera.movementEnabled = true;
		Camera.modeChangeEnabled = true;
		setFreeze(false)
		browser.call("runRegistrationSuccess")


	}

})

function attackWithFireball(attackerId){
Chat.print(0, 255, 0, "startFireBall")
	attackPlayerWithEffect(attackerId, 32, DAMAGE_FIRE, 1, true, 1, "spellFX_InstantFireball")
}

function testAttack(attackerId){
  setTimer(attackWithFireball, 1500, 5,attackerId)

}

//TODO: please remove
addEventHandler("onPacket", function(packet) {
	// read unique packet id
	Chat.print(0, 255, 0, "Received server command!!!")
	local packetContent = PacketReader.readPacket(packet)
Chat.print(0, 255, 0, "allguchi")
	// if the packet id doesn't match => stop code execution
	if (packetContent.packetId != PacketId.SERVER_POST) {
		return
	}
	if (packetContent.playerId != heroId) {
		return
	}
Chat.print(0, 255, 0, "gotin here")

	// read message
	local post = packetContent.post
	// IMPORTANT: SET character creation Mode only for the heroId that is determined by the server!!!!

	//Chat.print(0, 255, 0, "Received server command: " + post + " for playerId: " + packetContent.playerId)

	if (post.command == "wispAttack") {
		testAttack(post.wispId1)
		testAttack(post.wispId2)
	}

})

function clientDebugPrint(message) {
	Chat.print(0, 255, 0, message)
}


function sendToServerHandler(message) {
	PacketWriter.sendCefPacket(heroId, message)
}


function cefLog(message) {
	Chat.print(0, 255, 0, "" + message)
}

function sendToClientHandler(message) {

	local message = packet.readString()
	local to_container = JSON.parse_ansi(message)

	local command = to_container.command

	if (command != null && command == "switchToRegisterMode") {

	}

}