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
	if (packetContent.packetId != PacketId.SERVER_COMMAND)
		return

	// read message
	local command = packetContent.command
	// IMPORTANT: SET character creation Mode only for the heroId that is determined by the server!!!!

	Chat.print(0, 255, 0, "Received server command: " + command + " for playerId: " + packetContent.playerId)

	if (command == "setCharacterCreationMode" && heroId == packetContent.playerId) {
		setCharacterCreationMode()
	} else if (command == "loginSuccess" && heroId == packetContent.playerId) {
		browser.call("runLoginSuccess")
	} else if (command == "loginFailed" && heroId == packetContent.playerId) {
		browser.call("runLoginFailed")
	}

})

function clientDebugPrint(message) {
	Chat.print(0, 255, 0, message)
}


function sendToServerHandler(message) {
	PacketWriter.sendCefPacket(heroId, message)
}

function sendToClientHandler(message) {

	local message = packet.readString()
	local to_container = JSON.parse_ansi(message)

	local command = to_container.command

	if (command != null && command == "switchToRegisterMode") {

	}

}