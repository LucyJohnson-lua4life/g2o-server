// function openClassSelect() {
// 	 print("Opening class selection menu...")
// 	 Camera.movementEnabled = false;
// 	 Camera.modeChangeEnabled = false;
// 	Camera.setRotation(0, 0, 0)
// 	local playerPos = getPlayerPosition(heroId);
// 	Camera.setPosition(playerPos.x, playerPos.y, playerPos.z - 200);
// 	local playerAngle = getPlayerAngle(heroId)

// 	Camera.setRotation(0, playerAngle + 180, 0);
// 	//Camera.setPosition(0, 0, 100)
// }

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
}

function closeClassSelect() {
    Camera.movementEnabled = true;
    Camera.modeChangeEnabled = true;
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
			print("helo")
			break

	}


})