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
	local to_container = JSON.parse_ansi(message)
	// print message in server console
	print(to_container.a)
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