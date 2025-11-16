function AI_GetDistancePlayers(from, to) {
	local from_pos = getPlayerPosition(from)
	local to_pos = getPlayerPosition(to)

	return getDistance3d(from_pos.x, from_pos.y, from_pos.z, to_pos.x, to_pos.y, to_pos.z)
}

function AI_GetAngleToPlayer(from, to) {
	local from_pos = getPlayerPosition(from)
	local to_pos = getPlayerPosition(to)

	return getVectorAngle(from_pos.x, from_pos.z, to_pos.x, to_pos.z)
}

function AI_TurnToPlayer(from, to) {
	if(from == -1 || to == -1) {
		return
	}
	local from_pos = getPlayerPosition(from)
	local to_pos = getPlayerPosition(to)

	setPlayerAngle(from, getVectorAngle(from_pos.x, from_pos.z, to_pos.x, to_pos.z), true)
}


function AI_TurnToVec3(ai_id, to_pos) {
	local from_pos = getPlayerPosition(ai_id)
	setPlayerAngle(ai_id, getVectorAngle(from_pos.x, from_pos.z, to_pos.x, to_pos.z), true)
}

function AI_WaitForAction(npc_id, action_id) {
	return action_id != -1 && !isNpcActionFinished(npc_id, action_id)
}

function AI_Warn(npc_state, ts) {
	if (npc_state.warn_time == 0) {
		return false
	}

	if (npc_state.warn_start == 0) {
		npc_state.warn_start = ts
	}

	if ((ts - npc_state.warn_start) < npc_state.warn_time) {
		local distance = AI_GetDistancePlayers(npc_state.id, npc_state.enemy_id)
		if (distance > npc_state.target_distance) {
			npc_state.OnFocusChange(npc_state.enemy_id, -1)
			return
		}

		playAni(npc_state.id, "T_WARN")
		return true
	}

	return false
}

function AI_CollectNearestTarget(npc_state) {
	local streamed = getStreamedPlayersByPlayer(npc_state.id)
	local from_pos = getPlayerPosition(npc_state.id)

	local nearest_playerid = -1
	local nearest_distance = 999999

	foreach(pid in streamed) {
		if (isPlayerDead(pid)) {
			continue
		}

		local to_pos = getPlayerPosition(pid)
		local distance = getDistance3d(from_pos.x, from_pos.y, from_pos.z, to_pos.x, to_pos.y, to_pos.z)

		if (distance < nearest_distance && distance <= npc_state.target_distance) {
			nearest_playerid = pid
			nearest_distance = distance
		}
	}

	return nearest_playerid
}

function getUnitCircleAngle(x1, y1, x2, y2) {
	if (x1 == x2 && y1 == y2) {
		return 0
	}

	local x = x2 - x1
	local y = y2 - y1

	local angle = atan(abs(y) / abs(x)) * 180.0 / 3.14

	if (x < 0 && y > 0) {
		angle = 180 - angle
	} else if (x < 0 && y < 0) {
		angle = angle + 180
	} else if (x > 0 && y < 0) {
		angle = 360 - angle
	}

	return angle;
}


function alignToDirection(playerid, dir_x, dir_z) {
	local pos = getPlayerPosition(playerid);
	local angle = getUnitCircleAngle(pos.x, pos.z, pos.x + dir_x, pos.z + dir_z);
	setPlayerAngle(playerid, angle, true)
}

function refreshPosition(npc_state) {
	npc_state.flags.last_pos_update <- getTickCount()
	npc_state.flags.last_pos_x <- npc_state.flags.current_pos_x
	npc_state.flags.last_pos_y <- npc_state.flags.current_pos_y
	npc_state.flags.last_pos_z <- npc_state.flags.current_pos_z
}

function moveByGoto(npc_state, target_waypoint) {
	local flags = npc_state.flags

	if (!("last_pos_update" in flags) || flags.last_pos_update == null || flags.last_pos_update == 0) {
		local current_pos = getPlayerPosition(npc_state.id)
		flags.current_pos_x <- current_pos.x
		flags.current_pos_y <- current_pos.y
		flags.current_pos_z <- current_pos.z
		refreshPosition(npc_state)
	} else if (flags.last_pos_update + 500 < getTickCount()) {
		local current_pos = getPlayerPosition(npc_state.id)
		local distance_moved = getDistance3d(flags.current_pos_x, flags.current_pos_y, flags.current_pos_z, flags.last_pos_x, flags.last_pos_y, flags.last_pos_z)
		if (flags.current_pos_x != current_pos.x || flags.current_pos_y != current_pos.y || flags.current_pos_z != current_pos.z) {
			flags.current_pos_x <- current_pos.x
			flags.current_pos_y <- current_pos.y
			flags.current_pos_z <- current_pos.z
		} else if (distance_moved < 2) {

			local time_diff = getTickCount() - flags.last_pos_update
			local speed = (5 * 100) * (time_diff / 1000.0); // meter per seconds!
			local distance = getDistance3d(flags.current_pos_x, flags.current_pos_y, flags.current_pos_z, target_waypoint.x, target_waypoint.y, target_waypoint.z)
			if (speed > distance) {
				flags.current_pos_x = target_waypoint.x
				flags.current_pos_y = target_waypoint.y
				flags.current_pos_z = target_waypoint.z

				setPlayerPosition(npc_state.id, target_waypoint.x, target_waypoint.y, target_waypoint.z);
			} else {
				local dir_x = target_waypoint.x - flags.current_pos_x
				local dir_y = target_waypoint.y - flags.current_pos_y
				local dir_z = target_waypoint.z - flags.current_pos_z

				local dir_norm = sqrt(dir_x * dir_x + dir_y * dir_y + dir_z * dir_z);
				dir_x = dir_x / dir_norm
				dir_y = dir_y / dir_norm
				dir_z = dir_z / dir_norm

				flags.current_pos_x = flags.current_pos_x + (dir_x * speed)
				flags.current_pos_y = flags.current_pos_y + (dir_y * speed)
				flags.current_pos_z = flags.current_pos_z + (dir_z * speed)

				setPlayerPosition(npc_state.id, target_waypoint.x, target_waypoint.y, target_waypoint.z);

			}

		}
		refreshPosition(npc_state)
	}

	// TOOD: implement
}

function AI_Goto(npc_state, target_position_name) {
	local flags = npc_state.flags
	local world = npc_state.spawn.world

	if (!("goto_is_active" in flags)) {
		local pos = getPlayerPosition(npc_state.id)
		local nearest_wp = getNearestWaypoint(world, 0, 0, 0)
		local wp = getWaypoint(world, target_position_name)
		local way = Way(world, nearest_wp.name, target_position_name)


		flags.goto_way <- way
		flags.goto_route_index <- 0
		flags.goto_is_active <- true
		flags.goto_target_position <- wp
		flags.goto_target_name <- target_position_name
	}

	//print("survived till here: " + flags.goto_route_index)
	//print("waypoints: " + flags.goto_way.getWaypoints())
	//print(flags.goto_way.getWaypoints()[flags.goto_route_index])
	local current_pos = getPlayerPosition(npc_state.id)
	local next_target = getWaypoint(world, flags.goto_way.getWaypoints()[flags.goto_route_index])
	moveByGoto(npc_state, next_target)
	local distance_to_target = getDistance3d(current_pos.x, current_pos.y, current_pos.z, next_target.x, next_target.y, next_target.z)
	//print("distance: " + distance_to_target)
	if (distance_to_target > 100) {
		local walk_animation_name = "S_FISTWALKL"
		//	print("survived till here2")
		AI_TurnToVec3(npc_state.id, next_target)
		playAni(npc_state.id, walk_animation_name)
	} else if (flags.goto_route_index < flags.goto_way.getCountWaypoints() - 1) {
		flags.goto_route_index = flags.goto_route_index + 1
	} else {
		alignToDirection(npc_state.id, flags.goto_target_position.x, flags.goto_target_position.z)
		// do i even need alignToDirection here or is TurnToVec3 enough?
		//AI_TurnToVec3(npc_state.id, next_target)
		delete flags.goto_way
		delete flags.goto_route_index
		delete flags.goto_is_active
		delete flags.goto_target_position
		delete flags.goto_target_name
	}




}