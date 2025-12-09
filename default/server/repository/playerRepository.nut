//TODO: replace player repository with hash maps for better performance
class PlayerRepository {

	static function setPlayer(client, name, playerData) {

		client.hset("player:" + name, "health", playerData.health)
		client.hset("player:" + name, "mana", playerData.mana)
		client.hset("player:" + name, "str", playerData.str)
		client.hset("player:" + name, "dex", playerData.dex)
		client.hset("player:" + name, "oneHand", playerData.oneHand)
		client.hset("player:" + name, "twoHand", playerData.twoHand)
		client.hset("player:" + name, "bow", playerData.bow)
		client.hset("player:" + name, "crossBow", playerData.crossBow)
		client.hset("player:" + name, "circle", playerData.circle)
		client.hset("player:" + name, "name", playerData.name)
		client.hset("player:" + name, "passwordSha", playerData.passwordSha)
		client.hset("player:" + name, "bodyModel", playerData.bodyModel)
		client.hset("player:" + name, "bodyTexture", playerData.bodyTexture)
		client.hset("player:" + name, "headModel", playerData.headModel)
		client.hset("player:" + name, "headTexture", playerData.headTexture)

	}

	static function getPlayerByName(client, name) {
		local stats = {}


        if (client.hget("player:" + name, "name") == ""){
			return null;
		}

		stats.health <- client.hget("player:" + name, "health").tointeger()
		stats.mana <- client.hget("player:" + name, "mana").tointeger()
		stats.str <- client.hget("player:" + name, "str").tointeger()
		stats.dex <- client.hget("player:" + name, "dex").tointeger()
		stats.oneHand <- client.hget("player:" + name, "oneHand").tointeger()
		stats.twoHand <- client.hget("player:" + name, "twoHand").tointeger()
		stats.bow <- client.hget("player:" + name, "bow").tointeger()
		stats.crossBow <- client.hget("player:" + name, "crossBow").tointeger()
		stats.circle <- client.hget("player:" + name, "circle").tointeger()
		stats.name <- client.hget("player:" + name, "name")
		stats.passwordSha <- client.hget("player:" + name, "passwordSha")
		stats.bodyModel <- client.hget("player:" + name, "bodyModel")
		stats.bodyTexture <- client.hget("player:" + name, "bodyTexture").tointeger()
		stats.headModel <- client.hget("player:" + name, "headModel")
		stats.headTexture <- client.hget("player:" + name, "headTexture").tointeger()

		return stats
	}



}