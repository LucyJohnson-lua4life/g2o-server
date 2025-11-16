local class_selection_mode_data = {}

function incrementWithOverflow(value, increment, max) {
	value += increment
	if (value >= max) {
		value = 0
	} else if (value < 0) {
		value = max - 1
	}
	return value
}

function decrementWithOverflow(value, decrement, max) {
	value -= decrement
	if (value < 0) {
		value = max - 1
	} else if (value >= max) {
		value = 0
	}
	return value
}


MyLabel <- {}
function openClassSelect() {
    print("Opening class selection menu...");
    Camera.movementEnabled = false;
    Camera.modeChangeEnabled = false;

    local playerPos = getPlayerPosition(heroId);
    local playerAngle = getPlayerAngle(heroId);

    local distance = 250; // Distance in front of player
    local rad = playerAngle * PI / 180;

    // X/Z plane offset, Y is height
    local offsetX = distance * sin(rad);
    local offsetZ = distance * cos(rad);
    local offsetY = 50; // Slightly above player for better view

    Camera.setPosition(playerPos.x + offsetX, playerPos.y + offsetY, playerPos.z + offsetZ);
    Camera.setRotation(0, playerAngle + 180, 0); // Look at player from front
	setFreeze(true)
	//MyLabel <- Label(anx(100), any(100), "TTTTTTTTTTTTTTTTTESSSSSSST")
	//MyLabel.visible = true

	//Chat.print(0, 255, 0, "test" + MyLabel.widthPx + " " + MyLabel.heightPx + " " + MyLabel.visible)
	//local myLabel = Label(200, 500, "Test Label")


}

function closeClassSelect() {
    Camera.movementEnabled = true;
    Camera.modeChangeEnabled = true;
	setFreeze(false)
}


function attackWithFireball(focus){
Chat.print(0, 255, 0, "startFireBall")
	attackPlayerWithEffect(heroId, 32, DAMAGE_FIRE, 1, true, 1, "spellFX_InstantFireball")
}

function testAttack(){
  local focus = getFocusNpc()
  Chat.print(0, 255, 0, "focus: " + focus)
  setTimer(attackWithFireball, 2000, 5, focus)

}

function getPosition(){
	local p = getPlayerPosition(heroId)
	local angle = getPlayerAngle(heroId)
	Chat.print(0, 255, 0, "pos: " + p.x + "," + p.y + "," + p.z + " angle: " + angle)
}

addEventHandler("onKeyDown", function(key)
{
	// switch (key)
	// {
	// 	case KEY_UP:
	// 		if (!isKeyToggled(key))
	// 			return

	// 		if (!chatInputIsOpen())
	// 			NetStats.setVisible(!NetStats.visible)
	// 		break
	// }
})

addEventHandler("onCommand", function(cmd, param) {
	switch (cmd) {
		case "class":
			openClassSelect()
			break
		case "offclass":
			closeClassSelect()
			break
		case "elo":
			testAttack()
			break
		case "pos":
			getPosition()
			break
	}


})