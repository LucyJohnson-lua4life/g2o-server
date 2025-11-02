addEventHandler("onPacket", function(pid, packet)
{

	// read unique packet id
	local packetId = packet.readUInt8()
	// if the packet id doesn't match => stop code execution
	if (packetId != PacketId.CEF){
		return
	}

	local message = packet.readString()
	local to_container = JSON.parse_ansi(message)

	if (("messageContext" in to_container) && to_container.messageContext == "setVisual") {
		processSetVisual(to_container);
		return
	} else if (("messageContext" in to_container) && to_container.messageContext == "switchToRegisterMode") {
			// create instance of Packet class
	local packet = Packet()


	packet.writeUInt8(PacketId.SERVER_COMMAND)

	// write example string
	packet.writeString("register")

	// send packet to the player that joined the server
	// RELIABLE constant passed as argument to the method call..
	// makes sure that packet will get eventually to the client,
	// and the order in which the packet will be received in onPacket event isn't guaranteed.
	packet.send(pid, RELIABLE)
		processSetVisual(to_container);
		return
	}
})

function jsontest(){
    local from_container = {a = 1.5, b = "hans", c = false, d = null, e = {f = [1, 2, [3, 4]]}}
    local json_string = JSON.dump_ansi(from_container, 2)



	local to_container = JSON.parse_ansi(json_string)
	local age = to_container.a

	print("jsontest: " + age);
}


function processSetVisual(visualPacket){
	local id = visualPacket.heroId
    local bodyModel = visualPacket.bodyModel
    local bodyTxt = visualPacket.bodyTexture
    local headModel = visualPacket.headModel
	local headTxt = visualPacket.headTexture
    setPlayerVisual(id, bodyModel, bodyTxt, headModel, headTxt)
}