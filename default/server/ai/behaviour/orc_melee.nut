local function get_wm_name(wm) {
	switch (wm) {
		case WEAPONMODE_FIST:
			return "FIST"
		case WEAPONMODE_1HS:
			return "1H"
		case WEAPONMODE_2HS:
			return "2H"
		case WEAPONMODE_BOW:
			return "BOW"
		case WEAPONMODE_CBOW:
			return "CBOW"
		case WEAPONMODE_MAG:
			return "MAG"
	}

	return ""
}

class AIOrcMelee extends AIAgressive {
	attack_wait_time = 4000
	last_attack_time = 0
	max_distance = 3000
	target_distance = 1000


	function AttackMove(ts) {
		local queued_actions_count = getNpcActionsCount(this.id)

		if (this.weapon_mode >= WEAPONMODE_1HS && this.weapon_mode <= WEAPONMODE_2HS) {
			npcAttackMelee(this.id, this.enemy_id, ATTACK_LEFT, -1, true)
			npcAttackMelee(this.id, this.enemy_id, ATTACK_RIGHT, -1, true)
			npcAttackMelee(this.id, this.enemy_id, ATTACK_LEFT, -1, true)

		} else if (queued_actions_count < 1) {
			npcAttackMelee(this.id, this.enemy_id, 0, -1, true)
		}
	}

	function ParadeMove(wm_name) {

		playAni(this.id, "T_" + wm_name + "PARADEJUMPB");
		AI_TurnToPlayer(this.id, this.enemy_id)


		this.wait_until = getTickCount() + 500
	}

	function EnsureWeapon() {

		if (getPlayerWeaponMode(this.id) == WEAPONMODE_NONE) {
			print("weapon still not drawn")
			if (this.weapon_mode == WEAPONMODE_MAG) {
				readySpell(this.id, 0, 0)
			} else {
				drawWeapon(this.id, this.weapon_mode)
			}

			this.wait_until = getTickCount() + 1500
			return false
		}

		return true
	}

	function RemoveWeapon() {
		local weapon_mode = getPlayerWeaponMode(this.id)
		if (weapon_mode != WEAPONMODE_NONE) {
			removeWeapon(this.id)
		}
	}

	function StartHitCombo(wm_name, ts) {
		if (this.weapon_mode <= WEAPONMODE_2HS) {

			if (ts - this.last_attack_time > this.attack_wait_time) {
				this.AttackMove(ts)
				this.last_attack_time = ts
				this.wait_until = ts + 1500

			} else {
				this.ParadeMove(wm_name)
			}
		} else {
			this.AttackMove(ts)
		}
	}

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
		this.wait_until = -1
		if (!this.EnsureWeapon()) {
			return
		}
		local distance = AI_GetDistancePlayers(this.id, this.enemy_id)
		local wm_name = get_wm_name(this.weapon_mode)
		local queued_actions_count = getNpcActionsCount(this.id)
		if (distance > this.attack_distance) {
			if (!AI_Warn(this, ts) && queued_actions_count < 1) {
				// Warn finished, run to enemy
				AI_TurnToPlayer(this.id, this.enemy_id)
				playAni(this.id, "S_" + wm_name + "RUNL")
			}
		} else if(distance < this.attack_distance * 0.2){
			clearNpcActions(this.id)
			playAni(this.id, "T_" + wm_name + "PARADEJUMPB");
		}
		else {
			AI_TurnToPlayer(this.id, this.enemy_id)
			this.StartHitCombo(wm_name, ts)
		}
	}

	function OnFocusChange(from, to) {
		if (to == -1) {
			playAni(this.id, "S_RUN")

			this.RemoveWeapon()
			this.Reset()
		}
	}

	function OnHitReceived(kid, desc) {
		if (this.enemy_id == -1) {
			this.enemy_id = kid
			this.warn_start = 1
			return
		}

		local change_action = rand() % 100
		if (change_action > 70) {
			this.ParadeMove(get_wm_name(this.weapon_mode))
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
}