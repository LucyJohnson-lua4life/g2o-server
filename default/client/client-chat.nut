
local browser = Browser(0, 0, 8192, 8192, "cef://index.html")
browser.visible = true
setCursorVisible(true)


function debugprint(message){
       print(message)
       Chat.print(0, 255, 0, "test")
}


function messagePassTest(message){
    //local from_container = {a = 1.5, b = "hans", c = false, d = null, e = {f = [1, 2, [3, 4]]}}
    //local json_string = JSON.dump_ansi(from_container, 2)

	local packet = Packet()
    Chat.print(0, 255, 0, PacketId.JSON)
    Chat.print(0, 255, 0, message)
	
	packet.writeUInt8(PacketId.JSON)	
	packet.writeString(message)
	packet.send(RELIABLE)    
}



addEventHandler("onPlayerMessage", function(pid, r, g, b, message)
{
    local name = getPlayerName(pid)
    local color = getPlayerColor(pid)

    print("CHAT MESSAGE from " + name + ": " + message)
    browser.call("appendChatLine", name, color, message)
})