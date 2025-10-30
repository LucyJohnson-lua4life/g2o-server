local function join_handler(pid) {
    sendMessageToAll(0, 255, 0, getPlayerName(pid) + " connected with the server.")

	ClassFighter(pid)
	spawnPlayer(pid)
	setPlayerPosition(pid, 0, 0, 0)
}

addEventHandler("onPlayerJoin", join_handler)

local function respawn_handler(pid) {
    if (isNpc(pid))
        return

    sendMessageToAll(255, 150, 0, getPlayerName(pid) + " has respawned.")

	ClassFighter(pid)
	spawnPlayer(pid)
}

addEventHandler("onPlayerRespawn", respawn_handler)

local function init_handler() {
	randomseed(getTickCount())

	//AI_SpawnNPC(AIYoungWolf.Create(), 200, 200, -1500, 0.00, "NEWWORLD\\NEWWORLD.ZEN")
	//AI_SpawnNPC(AIYoungWolf.Create(), 300, 200, -1500, 0.00, "NEWWORLD\\NEWWORLD.ZEN")
	//AI_SpawnNPC(AIYoungWolf.Create(), 400, 200, -1500, 0.00, "NEWWORLD\\NEWWORLD.ZEN")
	//AI_SpawnNPC(AIHumanBanditRanged.Create("BDT_10307_ADDON_RANGERBANDIT_M"), 200, 200, -1500, 0.00, "NEWWORLD\\NEWWORLD.ZEN")
    //AI_SpawnNPC(AIHumanBanditMelee.Create("BDT_10309_ADDON_RANGERBANDIT_L"), 300, 200, -1500, 0.00, "NEWWORLD\\NEWWORLD.ZEN")
    //AI_SpawnNPC(AIHumanBanditMelee.Create("BDT_10308_ADDON_RANGERBANDIT_L"), 400, 200, -1500, 0.00, "NEWWORLD\\NEWWORLD.ZEN")
    //AI_SpawnNPC(AIHumanBanditRanged.Create("BDT_10311_ADDON_RANGERBANDIT_M"), 500, 200, -1500, 0.00, "NEWWORLD\\NEWWORLD.ZEN")
    //AI_SpawnNPC(AIHumanBanditRanged.Create("BDT_10310_ADDON_RANGERBANDIT_M"), 600, 200, -1500, 0.00, "NEWWORLD\\NEWWORLD.ZEN")
    //AI_SpawnNPC(AIHumanBanditMelee.Create("BDT_10313_ADDON_RANGERBANDIT_L"), 700, 200, -1500, 0.00, "NEWWORLD\\NEWWORLD.ZEN")
    //AI_SpawnNPC(AIHumanBanditMelee.Create("BDT_10312_ADDON_RANGERBANDIT_L"), 800, 200, -1500, 0.00, "NEWWORLD\\NEWWORLD.ZEN")
    //AI_SpawnNPC(AIHumanBanditRanged.Create("BDT_10314_ADDON_RANGERBANDIT_M"), 900, 200, -1500, 0.00, "NEWWORLD\\NEWWORLD.ZEN")
	//AI_SpawnNPC(AIHumanBanditMelee.Create("BDT_1022_LEUCHTTURMBANDIT"),  200, 200, -1500, 0.00, "NEWWORLD\\NEWWORLD.ZEN")

	local redisTest = RedisClient()
	redisTest.set("name", "Hans");


	local name = redisTest.get("name");
	print("name: " + name);

    local from_container = {a = 1.5, b = "hans", c = false, d = null, e = {f = [1, 2, [3, 4]]}}
    local json_string = JSON.dump_ansi(from_container, 2)

	print("json string: " + json_string);

	local to_container = JSON.parse_ansi(json_string)
	local age = to_container.a

	print("jsontest: " + age);
}

addEventHandler("onInit", init_handler)