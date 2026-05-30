local gub = require("gub")
local function drawLogo()
    term.clear()
    topBar()
    drawCenteredImage("BOS/Icons/logo.nfp")
    topCenterText("Welcome")
    term.setBackgroundColor(colors.black)
end
drawLogo()
local timer = os.startTimer(1)
while true do
    local event, p1 = os.pullEvent()
    if event == "term_resize" then
        drawLogo()
    elseif event == "timer" and p1 == timer then
        break
    end
end
shell.run("BOS/Main.lua")