-- About MADE BY GOCHIPC
package.path = package.path .. ";/BOS/?.lua"
local gub = require("gub")
local function draw()
  if fs.exists("BOS/version.txt") then
    local file = fs.open("BOS/version.txt", "r")
    ver = file.readAll()
    file.close()
  end
  term.clear()
  topBar()
  topButton(" X ", 1, "false")
  topText("About", 5)
  clearText()
  term.setCursorPos(1,2)
  print("- Version")
  print("BrandOS", ver)
  print("Gub " .. gubVer())
  print(os.version())
  print(" ")
  print("- About")
  print("BRANDOS. COPYRIGHT 2026. MADE BY GOCHIPC ALL RIGHTS RESERVED")
end
draw()
while true do
  local event, button, x, y = os.pullEvent()
  if event == "term_resize" then
    draw()
  elseif event == "mouse_click" then
    if y == 1 and x >= 1 and x <= 3 then
      topButton(" X ", 1, "true")
      sleep(0.1)
      return
    end
  end
end