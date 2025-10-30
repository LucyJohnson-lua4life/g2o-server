addEventHandler("onPlayerMessage", function(pid, msg)
{
	print(getPlayerName(pid) + " said: " + msg)
	sendPlayerMessageToAll(pid, 255, 255, 255, msg)
})

function debugprint(message){
       print(message)
}