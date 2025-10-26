// try changing some of the values
// saving this file will cause it to be hot reloaded
local texture = Texture(2048, 2048, 4096, 4096, "MENU_INGAME.TGA")
local Label = Label(0, 0, "Title text")

local function onReload()
{
	// set Label font
	Label.font = "FONT_OLD_20_WHITE.TGA"

	// center Label
	local texturePosition = texture.getPosition()
	local textureSize = texture.getSize()

	Label.setPosition(texturePosition.x + (textureSize.width - Label.width) / 2, texturePosition.y + 400)

	// show UI elements
	texture.visible = true
	Label.visible = true
}

// register reload callback that will be called:
// - when scripts get initialized for the first time
// - when you introduce changes to this file and save it in your editor
setReloadCallback(onReload)