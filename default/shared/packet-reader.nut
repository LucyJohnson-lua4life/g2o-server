class PacketReader {

	function readCef(packetId, packet) {
		local playerId = packet.readUInt16()
		local message = packet.readString()
		local to_container = JSON.parse_ansi(message)

		return {
			packetId = packetId,
			playerId = playerId,
			message = to_container
		}
	}

	function readServerCommand(packetId, packet) {
		local playerId = packet.readUInt16()
		local command = packet.readString()

		return {
			packetId = packetId,
			playerId = playerId,
			command = command
		}
	}

	static function readPacket(packet) {
		local packetId = packet.readUInt8()

		// if the packet id doesn't match => stop code execution
		if (packetId == PacketId.CEF) {
			return readCef(packetId, packet)
		} else if (packetId == PacketId.SERVER_COMMAND) {
			return readServerCommand(packetId, packet)
		}
	}
}