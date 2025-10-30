
local browser = Browser(0, 0, 8192, 8192, "cef://index.html")
browser.visible = true
setCursorVisible(true)


function debugprint(message){
       print(message)
       Chat.print(0, 255, 0, "test")
}




addEventHandler("onPlayerMessage", function(pid, r, g, b, message)
{
    local name = getPlayerName(pid)
    local color = getPlayerColor(pid)

    print("CHAT MESSAGE from " + name + ": " + message)
    browser.call("appendChatLine", name, color, message)
})