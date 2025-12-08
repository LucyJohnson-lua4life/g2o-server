function retrieveItemInfo(item) {
	local info = {
		itemInstance = item.instance,
		itemValue = item.value
	}
	return info
}

addEventHandler("onDropItem", function(item) {
	local post = retrieveItemInfo(item)
	PacketWriter.sendClientPostPacket(heroId, "decrementInventory", post)
})

function sendItemPost(item, command) {
	local post = retrieveItemInfo(item)
	PacketWriter.sendClientPostPacket(heroId, command, post)
}

addEventHandler("onUnequip", function(item) {
	if (item.mainflag == 2) {
		sendItemPost(item, "unequipMelee")
	} else if (item.mainflag == 4) {
		sendItemPost(item, "unequipRanged")
	} else if (item.mainflag == 16) {
		sendItemPost(item, "unequipArmor")
	}
})

addEventHandler("onEquip", function(item) {
	if (item.mainflag == 2) {
		sendItemPost(item, "equipMelee")
	} else if (item.mainflag == 4) {
		sendItemPost(item, "equipRanged")
	} else if (item.mainflag == 16) {
		sendItemPost(item, "equipArmor")
	}
})

addEventHandler("onTakeItem", function(item, synchronized) {
	local post = retrieveItemInfo(item)
	PacketWriter.sendClientPostPacket(heroId, "incrementInventory" ,post)
})

addEventHandler("onPlayerUseItem", function(id, item, from, to) {

	Chat.print(0,255,0, "t1")
	if (to == 0) {
		Chat.print(0,255,0, "t2")
		local post = retrieveItemInfo(item)
		PacketWriter.sendClientPostPacket(heroId, "decrementInventory", post)
	}

})