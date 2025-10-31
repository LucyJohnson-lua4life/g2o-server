addEventHandler("onPlayerMessage", function(pid, msg)
{
	print(getPlayerName(pid) + " said: " + msg)
	sendPlayerMessageToAll(pid, 255, 255, 255, msg)
})

addEventHandler("onPacket", function(pid, packet)
{
	print("onPacket received from pid: " + pid)
	// read unique packet id
	local packetId = packet.readUInt8()

	// if the packet id doesn't match => stop code execution
	if (packetId != PacketId.JSON)
		return

	// read message

	local message = packet.readString()

	local heroId = JsonUtils.getInJson(message, "heroId")
	print(heroId)
	local to_container = JSON.parse_ansi(message)

	if (("messageContext" in to_container) && to_container.messageContext == "setVisual") {
		processSetVisual(heroId, to_container);
		return
	}
})

function debugprint(message){
       print(message)
}

function jsontest(){
    local from_container = {a = 1.5, b = "hans", c = false, d = null, e = {f = [1, 2, [3, 4]]}}
    local json_string = JSON.dump_ansi(from_container, 2)

	print("json string: " + json_string);

	local to_container = JSON.parse_ansi(json_string)
	local age = to_container.a

	print("jsontest: " + age);
}


function processSetVisual(heroId, visualPacket){
	local id = heroId
    local bodyModel = "Hum_Body_Naked0"
    local bodyTxt = 0
    local headModel = "Hum_Head_FatBald"
	local headTxt = 0
    setPlayerVisual(id, bodyModel, bodyTxt, headModel, headTxt)
}