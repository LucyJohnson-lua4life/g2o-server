class PlayerRepository {

	static function setPlayer(client, name, playerData) {
		local json = JSON.dump_ansi(playerData, 2)
		client.set("player:" + name, json)
	}

	static function getPlayerByName(client, name) {
		local playerDataJson = client.get("player:" + name)
		if (playerDataJson == "") {
			return null
		}
		return JSON.parse_ansi(playerDataJson)
	}

	static function getPlayerJson(client, name) {
		local playerDataJson = client.get("player:" + name)
		if (playerDataJson == "") {
			return null
		}
		return playerDataJson
	}

}