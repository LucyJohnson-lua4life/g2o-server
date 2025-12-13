class AIBase {
    id = -1
    spawn = null
    instance = null

    // AI vars
    wait_until = 0
    wait_for_action_id = -1
    // set to null at class level to avoid creating a shared table
    // that would be shared across instances
    flags = null

    constructor(npc_id) {
        this.id = npc_id
        // ensure each instance gets its own flags table
        this.flags = {}
    }

    function Reset() {
        this.wait_until = 0
        this.wait_for_action_id = -1
        this.flags = {}
    }

    function Create(instance = null) {
        instance = instance || this.instance

        local npc_id = createNpc("NPC", instance)
        if (npc_id == -1) {
            return null
        }

        local state = this(npc_id)
        state.instance = instance
        state.Setup()
        setPlayerRespawnTime(npc_id, 10000)

        return state
    }

    function Update(ts) {
        // Triggered every AI update tick
        if (isPlayerDead(this.id)) {
			return false
		}

		if (("goto_is_active" in this.flags && this.flags.goto_is_active)) {
			if (AI_Goto(this, this.flags.goto_target_name)) {
                return false
			}

		}

		if (("goto_coordinate_is_active" in this.flags && this.flags.goto_coordinate_is_active)) {
			if (AI_Goto_Coordinate(this, this.flags.goto_coordinate_target)) {
				return false
			}
		}
        return true

    }

    function Setup() {
        // Triggered only once while creating NPC
    }

    function Spawn() {
        // Triggered after NPC respawn
    }

    function OnHitReceived(kid, desc) {
        this.Reset()
        // Triggered when NPC receives damage
    }
}