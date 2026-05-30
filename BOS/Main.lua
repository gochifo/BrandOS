local apis = require("gub")
local ter = "rom/programs/shell.lua"

local function draw()
  term.clear()
  term.setBackgroundColor(colors.black)
  topBar()
  topButton(" B ", 1, "false")
  topButton(" Program ", 5, "false")
  topButton(" Edit ", 15, "false")
  term.setCursorPos(1,2)
  clearText()
  BottomRightText("BETA!")
end
local function getEditFileName()
    if not fs.exists("untitled.lua") then
        return "untitled.lua"
    end
    local i = 2
    while true do
        local name = "untitled" .. i .. ".lua"
        if not fs.exists(name) then
            return name
        end
        i = i + 1
    end
end

draw()
while true do
  local event, button, x, y = os.pullEvent()
  if event == "term_resize" then
    draw()
  elseif event == "mouse_click" then
    if y == 1 and x >= 1 and x <= 3 then
        topButton(" B ", 1, "true")
        topList("  About  ", 1, 2)
        topList(" Restart ", 1, 3)
        topList(" Shutoff ", 1, 4)
        topList(" Console ", 1, 5)
        while true do
          local event, button, x, y = os.pullEvent()
          if event == "term_resize" then
           draw()
           break
          elseif event == "mouse_click" then
           if y == 1 and x >= 1 and x <= 3 then
            draw()
            break
           elseif y == 2 and x >= 1 and x <= 9 then
            shell.run("BOS/Programs/About.lua")
            draw()
            break
           elseif y == 3 and x >= 1 and x <= 9 then
            term.setBackgroundColor(colors.black)
            term.clear()
            topBar()
            topCenterText("Restart")
            drawCenteredImage("BOS/Icons/logo.nfp")
            sleep(1)
            os.reboot()
           elseif y == 4 and x >= 1 and x <= 9 then
            term.setBackgroundColor(colors.black)
            term.clear()
            topBar()
            topCenterText("Shutoff")
            drawCenteredImage("BOS/Icons/logo.nfp")
            sleep(1)
            os.shutdown()
           elseif y == 5 and x >= 1 and x <= 9 then
            shell.run("BOS/Programs/EmuBrand.lua", ter)
            draw()
            break
           end
          end
        end
   elseif y == 1 and x >= 5 and x <= 13 then
        topButton(" Program ", 5, "true")
        topList("   Run   ", 5, 2)
        while true do
            local event, button, x, y = os.pullEvent()
            if event == "term_resize" then
             draw()
             break
            elseif event == "mouse_click" then
             if y == 1 and x >= 5 and x <= 13 then
              draw()
              break
             elseif y == 2 and x >= 5 and x <= 13 then
              shell.run("BOS/Programs/LookerOpen.lua")
              draw()
              break
             end
            end
        end
   elseif y == 1 and x >= 15 and x <= 20 then
        topButton(" Edit ", 15, "true")
        topList("  New  ", 15, 2)
        topList(" Other ", 15, 3)
        while true do
            local event, button, x, y = os.pullEvent()
            if event == "term_resize" then
             draw()
             break
            elseif event == "mouse_click" then
             if y == 1 and x >= 15 and x <= 20 then
              draw()
              break
             elseif y == 2 and x >= 15 and x <= 20 then
              local fileName = getEditFileName()
              shell.run("BOS/Programs/TextBrand.lua", fileName)
              draw()
              break
             elseif y == 3 and x >= 15 and x <= 20 then
              shell.run("BOS/Programs/LookerEdit.lua")
              draw()
              break
             end
            end
        end
   end
  end
end