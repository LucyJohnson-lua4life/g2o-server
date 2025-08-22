local function onInit()
{
	print("Server initialized!")
}

addEventHandler("onInit", onInit)

// Spawning player (making player visible to other players)
addEventHandler("onPlayerJoin", spawnPlayer)
addEventHandler("onPlayerRespawn", spawnPlayer)