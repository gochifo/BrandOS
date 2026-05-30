-- TextBrand MADE BY GOCHIPC
local tArgs = { ... }
package.path = package.path .. ";/BOS/?.lua"
local gub = require("gub")
local fileName = tArgs[1]
local displayName = fileName:gsub("%.%w+$", "")
local w, h = term.getSize()
local text = {""}
local cx, cy = 1, 1
local programMenu = false
local scroll = 0
local function safeLine(i)
    if not text[i] then text[i] = "" end
end
if fs.exists(fileName) then
    local f = fs.open(fileName, "r")
    text = {}
    while true do
        local line = f.readLine()
        if not line then break end
        table.insert(text, line)
    end
    f.close()
    if #text == 0 then text = {""} end
else
    text = {""}
end
local function saveFile()
    local f = fs.open(fileName, "w")
    for _, line in ipairs(text) do
        f.writeLine(line)
    end
    f.close()
end
local function updateScroll()
    local maxVisible = h - 1
    if cy < scroll + 1 then
        scroll = cy - 1
    elseif cy > scroll + maxVisible then
        scroll = cy - maxVisible
    end
    if scroll < 0 then scroll = 0 end
end
local function drawTopBar()
    topBar()
    topButton(" X ", 1, "false")
    topButton(" Program ", 5, "false")
    topText(displayName, 15)
end
local function drawMenu()
    if not programMenu then return end
    topButton(" Program ", 5, "true")
    topList("  Save   ", 5, 2)
end
local function drawText()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    for i = 1, h - 1 do
        local lineIndex = i + scroll
        term.setCursorPos(1, i+1)
        term.clearLine()
        if text[lineIndex] then
            term.write(text[lineIndex])
        end
    end
end
local function drawCursor()
    if programMenu then
        term.setCursorBlink(false)
        return
    end
    local screenY = cy - scroll + 1
    if screenY >= 2 and screenY <= h then
        term.setCursorPos(cx, screenY)
        term.setCursorBlink(true)
    else
        term.setCursorBlink(false)
    end
end
local function render()
    drawTopBar()
    drawText()
    drawMenu()
    drawCursor()
end
local function insertChar(char)
    safeLine(cy)
    local line = text[cy]
    text[cy] = line:sub(1, cx-1) .. char .. line:sub(cx)
    cx = cx + 1
end
local function backspace()
    safeLine(cy)
    if cx > 1 then
        local line = text[cy]
        text[cy] = line:sub(1, cx-2) .. line:sub(cx)
        cx = cx - 1
    elseif cy > 1 then
        cx = #text[cy-1] + 1
        text[cy-1] = text[cy-1] .. text[cy]
        table.remove(text, cy)
        cy = cy - 1
    end
    updateScroll()
end
local function newLine()
    safeLine(cy)
    local line = text[cy]
    local newLineText = line:sub(cx)
    text[cy] = line:sub(1, cx-1)
    table.insert(text, cy + 1, newLineText)
    cy = cy + 1
    cx = 1
    updateScroll()
end
while true do
    render()
    local e, p1, p2, p3 = os.pullEvent()
    if e == "char" and not programMenu then
        insertChar(p1) 
    elseif e == "term_resize" then
        w, h = term.getSize()
        programMenu = false
        updateScroll()
    elseif e == "key" and not programMenu then
        if p1 == keys.backspace then
            backspace()
        elseif p1 == keys.enter then
            newLine()
        elseif p1 == keys.left then
            if cx > 1 then cx = cx - 1 end
        elseif p1 == keys.right then
            if cx <= #text[cy] then cx = cx + 1 end
        elseif p1 == keys.up then
            if cy > 1 then cy = cy - 1 end
            updateScroll()
        elseif p1 == keys.down then
            if cy < #text then cy = cy + 1 end
            updateScroll()
        end
    elseif e == "mouse_click" then
        local btn, x, y = p1, p2, p3
        if y == 1 and x >= 1 and x <= 3 then
            topButton(" X ", 1, "true")
            sleep(0.1)
            term.setCursorBlink(false)
            return
        end
        if y == 1 and x >= 5 and x <= 13 then
            programMenu = not programMenu
        elseif programMenu then
            if x >= 5 and x <= 13 and y == 2 then
                saveFile()
                programMenu = false
            else
                programMenu = false
            end
        elseif y > 1 then
            cy = y - 1 + scroll
            if cy < 1 then cy = 1 end
            if cy > #text then cy = #text end
            cx = math.min(x, #text[cy] + 1)
            updateScroll()
        end
    end
end
