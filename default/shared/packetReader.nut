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

	function readClientPost(packetId, packet) {
		local playerId = packet.readUInt16()
		local post = packet.readString()

		return {
			packetId = packetId,
			playerId = playerId,
			post = JsonUtils.parse(post)
		}
	}
	function readServerPost(packetId, packet) {
		local playerId = packet.readUInt16()
		local post = packet.readString()

		return {
			packetId = packetId,
			playerId = playerId,
			post = JsonUtils.parse(post)
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

	function readClientCommand(packetId, packet) {
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
		} else if (packetId == PacketId.CLIENT_POST) {
			return readClientPost(packetId, packet)
		}else if (packetId == PacketId.CLIENT_COMMAND) {
			return readClientCommand(packetId, packet)
	    }
		else if (packetId == PacketId.SERVER_POST) {
			return readServerPost(packetId, packet)
	    }
	}
}