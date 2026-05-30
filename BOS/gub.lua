-- This is an Apis about gui and other
-- COPYRIGHT 2026
-- Made by GochiPC DEVELOPMENT
local version = "1.1"
local gub = {}

function gubVer()
    return version
end

function topBar()
    term.setCursorPos(1,1)
    term.setBackgroundColor(colors.white)
    term.clearLine()
end

function topButton(text, x, on)
    if on == "false" then
      term.setCursorPos(x,1)
      term.setTextColor(colors.black)
      term.setBackgroundColor(colors.lightGray)
      term.setCursorPos(x,1)
      print(text)
      term.setBackgroundColor(colors.black)
    elseif on == "true" then
      term.setCursorPos(x,1)
      term.setTextColor(colors.black)
      term.setBackgroundColor(colors.gray)
      term.setCursorPos(x,1)
      print(text)
      term.setBackgroundColor(colors.black)
    elseif on == "dis" then
      term.setCursorPos(x,1)
      term.setTextColor(colors.white)
      term.setBackgroundColor(colors.lightGray)
      term.setCursorPos(x,1)
      print(text)
      term.setBackgroundColor(colors.black)
    else
      term.setCursorPos(x,1)
      term.setBackgroundColor(colors.red)
      print("ERROR")
    end
end

function topList(text, x, y)
    term.setCursorPos(x,y)
    term.setTextColor(colors.black)
    term.setBackgroundColor(colors.gray)
    term.setCursorPos(x,y)
    print(text)
    term.setBackgroundColor(colors.black)
end

function topText(text, x)
    term.setCursorPos(x,1)
    term.setTextColor(colors.black)
    term.setBackgroundColor(colors.white)
    term.setCursorPos(x,1)
    print(text)
    term.setBackgroundColor(colors.black)
end

function clearText()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
end

function BottomRightText(text)
    local w, h = term.getSize()
    term.setCursorPos(w - #text + 1, h)
    term.write(text)
end

function topCenterText(text)
  local w, _ = term.getSize()
  local x = math.floor((w - #text) / 2) + 1
  term.setTextColor(colors.black)
  term.setBackgroundColor(colors.white)
  term.setCursorPos(x, 1)
  term.write(text)
end

function drawCenteredImage(path)
  local img = paintutils.loadImage(path)
  local w, h = term.getSize()
  local iw, ih = #img[1], #img
  local x = math.floor((w - iw)/2) + 1
  local y = math.floor((h - ih)/2) + 1
  paintutils.drawImage(img, x, y)
end

return gub