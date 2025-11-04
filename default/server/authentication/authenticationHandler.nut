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
	else if (("messageContext" in message) && message.messageContext == "attemptLogin") {
		processLoginAttempt(packetContent.playerId, message);
	}
})


function processLoginAttempt(playerId, loginPacket) {
	local username = loginPacket.username
	local passwordSha = loginPacket.passwordSha

	handleLogin(playerId, username, passwordSha)
}

function handleLogin(playerId, username, passwordSha){

	local userData = PlayerRepository.getPlayerByName(redisClient, username)
	if(userData == null){
		PacketWriter.sendServerCommandPacket(playerId, "loginFailed")
		print("Login failed: User not found - " + username)
	}else{

		if(userData.passwordSha == passwordSha){
			PacketWriter.sendServerCommandPacket(playerId, "loginSuccess")
			print("Login success for user: " + username)
		}else{
			PacketWriter.sendServerCommandPacket(playerId, "loginFailed")
			print("Login failed: Incorrect password for user - " + username)
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