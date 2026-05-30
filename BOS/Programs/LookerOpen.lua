-- Looker (OPEN) MADE BY GOCHIPC
package.path = package.path .. ";/BOS/?.lua"
local gub = require("gub")
local currentDir = "/"
local function getFiles(path)
    local list = fs.list(path)
    local filtered = {}
    for _, file in ipairs(list) do
        if file ~= "startup" and file ~= "rom" then
            table.insert(filtered, file)
        end
    end
    return filtered
end
local function draw(files)
    term.clear()
    topBar()
    clearText()
    topButton(" X ", 1, "false")
    topButton(" Back ", 5, "false")
    topText("Looker", 12)
    term.setCursorPos(1,2)
    clearText()
    print("Dir: " .. currentDir)
    for i, file in ipairs(files) do
        term.setCursorPos(1, i + 3)
        if fs.isDir(fs.combine(currentDir, file)) then
            print("[DIR] " .. file)
        else
            print("      " .. file)
        end
    end
end
while true do
    local files = getFiles(currentDir)
    draw(files)
    local event, button, x, y = os.pullEvent()
    if event == "mouse_click" then
        if y == 1 and x >= 5 and x <= 10 then
            topButton(" Back ", 5, "true")
            sleep(0.1)
            topButton(" Back ", 5, "false")
            if currentDir ~= "/" then
                currentDir = fs.getDir(currentDir)
                if currentDir == "" then currentDir = "/" end
            end
        elseif y == 1 and x >= 1 and x <= 3 then
            topButton(" X ", 1, "true")
            sleep(0.1)
            return
        else
            local index = y - 3
            local selected = files[index]
            if selected then
                local path = fs.combine(currentDir, selected)
                if fs.isDir(path) then
                    currentDir = path
                else
                    term.setBackgroundColor(colors.black)
                    term.setTextColor(colors.white)
                    term.clear()
                    term.setCursorPos(1,1)
                    shell.run("BOS/Programs/EmuBrand.lua", path)
                    term.clear()
                end
            end
        end

    elseif event == "term_resize" then
        term.clear()
    end
end