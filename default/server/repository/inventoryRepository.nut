class InventoryRepository {

	static function setInventoryByName(client, name, inventoryData) {
		local json = JSON.dump_ansi(inventoryData, 2)
		client.set("inventory:" + name, json)
	}

	static function getInventoryByName(client, name) {
		local playerDataJson = client.get("inventory:" + name)
		if (playerDataJson == "") {
			return null
		}
		return JSON.parse_ansi(playerDataJson)
	}

	static function getInventoryJson(client, name) {
		local playerDataJson = client.get("inventory:" + name)
		if (playerDataJson == "") {
			return null
		}
		return playerDataJson
	}

}