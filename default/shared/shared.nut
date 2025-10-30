class CustomPacketMessage extends BPacketMessage {
	pid = -1
	face_id = -1
    body_id = null

    constructor(pid, face_id, body_id) {
        this.pid = pid
		this.face_id = face_id
		this.body_id = body_id
    }
}