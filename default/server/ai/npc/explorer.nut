class AIExplorer extends AIDefensiveHumanoid {
    attack_distance = 200
    target_distance = 1000
    chase_distance = 500
    weapon_mode = WEAPONMODE_1HS

    function Setup() {
        setPlayerName(this.id, "Explorer")
    }

    function Spawn() {
        setPlayerInstance(this.id, this.instance)
    }
}
