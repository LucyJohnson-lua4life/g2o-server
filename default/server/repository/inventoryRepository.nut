//TODO: refactor inventory repository api
class InventoryRepository {

	static function setItemByName(client, name, item, amount) {
		return client.hset("inventory:" + name, item, amount)
	}

	static function getItemAmountByName(client, name, item) {
		return client.hget("inventory:" + name, item)
	}

	static function getAllItemsByName(client, name) {
		return client.hgetallFlat("inventory:" + name)
	}
	static function deleteItemByName(client, name, item) {
		return client.hdel("inventory:" + name, item)
	}

	static function setEquippedByName(client, name, equipmentType, item) {
		return client.hset("equipped:" + name, equipmentType, item)
	}

	static function getEquippedByType(client, name, equipmentType) {
		return client.hget("equipped:" + name, equipmentType)
	}

	static function deleteEquippedByType(client, name, equipmentType) {
		return client.hdel("equipped:" + name, equipmentType)
	}
}