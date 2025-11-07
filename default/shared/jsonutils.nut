class JsonUtils {
	static function parse(jsonString) {
		return JSON.parse_ansi(jsonString)
	}

	static function toJson(object) {
		return JSON.dump_ansi(object, 2)
	}

	static function setInJson(jsonString, key, value) {
		local object = JSON.parse_ansi(jsonString)
		object[key] <- value
		return JSON.dump_ansi(object, 2)
	}

	static function getInJson(jsonString, key) {
		local object = JSON.parse_ansi(jsonString)
		if(!(key in object))
			return null
		return object[key]
	}
}