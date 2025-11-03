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

function jsontest() {
	local from_container = {
		a = 1.5,
		b = "hans",
		c = false,
		d = null,
		e = {
			f = [1, 2, [3, 4]]
		}
	}
	local json_string = JSON.dump_ansi(from_container, 2)



	local message = JSON.parse_ansi(json_string)
	local age = message.a

	print("jsontest: " + age);
}


function processSetVisual(playerId, visualPacket) {
	local bodyModel = visualPacket.bodyModel
	local bodyTxt = visualPacket.bodyTexture
	local headModel = visualPacket.headModel
	local headTxt = visualPacket.headTexture
	setPlayerVisual(playerId, bodyModel, bodyTxt, headModel, headTxt)
}