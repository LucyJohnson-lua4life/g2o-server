class PacketWriter {

	static function sendCefPacket(playerId, message) {
		local packet = Packet()

		packet.writeUInt8(PacketId.CEF)
		packet.writeUInt16(playerId)
		packet.writeString(message)
		packet.send(RELIABLE_ORDERED)
	}

	static function sendClientPostPacket(playerId, post) {
		local packet = Packet()

		packet.writeUInt8(PacketId.CLIENT_POST)
		packet.writeUInt16(playerId)
		packet.writeString(JsonUtils.toJson(post))
		packet.send(RELIABLE_ORDERED)
	}

	static function sendServerCommandPacket(playerId, command) {
		local packet = Packet()
		packet.writeUInt8(PacketId.SERVER_COMMAND)
		packet.writeUInt16(playerId)
		packet.writeString(command)
		packet.send(playerId, RELIABLE_ORDERED)

	}

	static function sendServerPostPacket(playerId, post) {
		local packet = Packet()

		packet.writeUInt8(PacketId.SERVER_POST)
		packet.writeUInt16(playerId)
		packet.writeString(JsonUtils.toJson(post))
		packet.send(playerId, RELIABLE_ORDERED)
	}

	static function sendClientCommandPacket(playerId, command) {
		local packet = Packet()
		packet.writeUInt8(PacketId.CLIENT_COMMAND)
		packet.writeUInt16(playerId)
		packet.writeString(command)
		packet.send(RELIABLE_ORDERED)

	}

}