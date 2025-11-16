class AISpellWisp extends AIBase {
    instance = "WISP"
    attack_distance = 300
    target_distance = 1200
    chase_distance = 1000
    warn_time = 3000

    function Setup() {
        setPlayerName(this.id, "Lux")
    }

    function Spawn() {
        setPlayerInstance(this.id, this.instance)
    }
}