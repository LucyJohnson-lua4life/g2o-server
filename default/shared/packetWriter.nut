class PacketWriter {

	static function sendCefPacket(playerId, message) {
		local packet = Packet()

		packet.writeUInt8(PacketId.CEF)
		packet.writeUInt16(playerId)
		packet.writeString(message)
		packet.send(RELIABLE_ORDERED)
	}

	static function sendClientPostPacket(playerId, postCommand, post) {
		local packet = Packet()

		packet.writeUInt8(PacketId.CLIENT_POST)
		packet.writeUInt16(playerId)
		packet.writeString(postCommand)
		packet.writeString(JsonUtils.toJson(post))
		packet.send(RELIABLE_ORDERED)
	}

	static function sendServerPostPacket(playerId, postCommand, post) {
		local packet = Packet()

		packet.writeUInt8(PacketId.SERVER_POST)
		packet.writeUInt16(playerId)
		packet.writeString(postCommand)
		packet.writeString(JsonUtils.toJson(post))
		packet.send(playerId, RELIABLE_ORDERED)
	}


}