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


addEventHandler("onPacket", function(packet)
{
	// read unique packet id
	local packetId = packet.readUInt8()

	// if the packet id doesn't match => stop code execution
	if (packetId != PacketId.SERVER_COMMAND)
		return

	// read message
	local message = packet.readString()

	if(message == "setCharacterCreationMode"){
		setCharacterCreationMode()		
	}

})

function clientDebugPrint(message){
       Chat.print(0, 255, 0, message)
}


function sendToServerHandler(message){
	local packet = Packet()

	packet.writeUInt8(PacketId.CEF)
    local messageWithHeroId = JsonUtils.setInJson(message, "heroId", heroId)
	packet.writeString(messageWithHeroId)
	packet.send(RELIABLE)
}

function sendToClientHandler(message){

	local message = packet.readString()
	local to_container = JSON.parse_ansi(message)

	local command = to_container.command

	if(command != null && command == "switchToRegisterMode"){

	}

}