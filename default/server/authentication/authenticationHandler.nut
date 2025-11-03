local redisClient = RedisClientProvider.getClient()

addEventHandler("onPacket", function(pid, packet) {


	local packetContent = PacketReader.readPacket(packet)
	// if the packet id doesn't match => stop code execution
	if (packetContent.packetId != PacketId.CEF) {
		return
	}
	local message = packetContent.message

	if (("messageContext" in message) && message.messageContext == "setVisual") {
		processSetVisual(packetContent.playerId, message);
		return
	} else if (("messageContext" in message) && message.messageContext == "switchToRegisterMode") {
		PacketWriter.sendServerCommandPacket(pid, "register")
	}
})

function handleLogin(playerId, username, passwordSha){

	local userData = PlayerRepository.getPlayerByName(redisClient, username)
	if(userData == null){
		PacketWriter.sendServerCommandPacket(playerId, "loginFailed")
	}else{

		if(userData.passwordSha == passwordSha){
			PacketWriter.sendServerCommandPacket(playerId, "loginSuccess")
		}else{
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