local browser = GetBrowser();

addEventHandler("onTakeFocus", function(type, id, name) {
	if (type == VOB_NPC) {
		browser.call("displayTalkButton")
	}

})

addEventHandler("onLostFocus", function(type, id, name) {
	if (type == VOB_NPC) {
		browser.call("hideTalkButton")

	}

})