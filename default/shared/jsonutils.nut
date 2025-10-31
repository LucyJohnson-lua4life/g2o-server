class JsonUtils {
	static function parse(jsonString) {
		return JSON.parse_ansi(message)
	}

	static function toJson(object) {
		return JSON.dump_ansi(from_container, 2)
	}

	static function setInJson(jsonString, key, value) {
		local object = JSON.parse_ansi(jsonString)
		object[key] <- value
		return JSON.dump_ansi(object, 2)
	}

	static function getInJson(jsonString, key) {
		local object = JSON.parse_ansi(jsonString)
		return object[key]
	}
}