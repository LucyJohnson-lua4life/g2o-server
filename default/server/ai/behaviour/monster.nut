class AIMonster extends AIAgressive {

	attack_wait_time = 3000
	last_attack_time = 0
	max_distance = 3000
    target_distance = 1000

	function AttackRoutine(ts) {
		if(isPlayerConnected(this.enemy_id) == false) {
			this.enemy_id = -1
			return
		}
		AI_TurnToPlayer(this.id, this.enemy_id)
		if ((this.wait_until - ts) > 0 || AI_WaitForAction(this.id, this.wait_for_action_id)) {
			return
		}

		this.wait_for_action_id = -1

		local distance = AI_GetDistancePlayers(this.id, this.enemy_id)
		if (distance > this.attack_distance) {
			if (!AI_Warn(this, ts)) {
				// Warn finished, run to enemy
				AI_TurnToPlayer(this.id, this.enemy_id)
				playAni(this.id, "S_FISTRUNL")
			}
		} else if (ts - this.last_attack_time > this.attack_wait_time) {
			npcAttackMelee(this.id, this.enemy_id, ATTACK_FORWARD, 1, true)
			this.wait_for_action_id = getNpcLastActionId(this.id)
			this.last_attack_time = ts
			this.wait_until = ts + 1000 // Minimal attack time
		} else {
			this.ParadeMove()
			this.wait_until = ts + 1000 // Minimal attack time
		}
	}

	function OnFocusChange(from, to) {
		if (to == -1) {
			this.Reset()
		}
	}


	function ParadeMove() {
		local action = rand() % 5
		if (action < 3) {

			playAni(this.id, "T_FISTPARADEJUMPB");
		} else if (action < 4) {
			playAni(this.id, "T_FISTRUNSTRAFER");
		} else {
			action = 2
			playAni(this.id, "T_FISTRUNSTRAFEL");
		}
		this.wait_until = getTickCount() + 500
	}

	function OnHitReceived(kid, desc) {
		base.OnHitReceived(kid, desc)
		if (this.enemy_id == -1) {
			this.enemy_id = kid
			return
		}

		local change_action = rand() % 100
		if (change_action > 60) {
			this.ParadeMove()
			this.wait_for_action_id = getNpcLastActionId(this.id)
		}

		// Change target if killer is closer
		if (this.enemy_id != kid) {
			local enemy_distance = AI_GetDistancePlayers(this.id, this.enemy_id)
			local killer_distance = AI_GetDistancePlayers(this.id, kid)

			if (killer_distance < enemy_distance) {
				this.enemy_id = kid
			}
		}
	}

	function DailyRoutine(ts) {
		// Triggered when NPC has no enemy
		local queued_actions_count = getNpcActionsCount(this.id)
		if (queued_actions_count < 1) {
			playAni(this.id, "S_EAT");
		}
	}
}