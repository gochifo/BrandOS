-- EmuBrand MADE BY GOCHIPC
local tArgs = { ... }
local program = tArgs[1] or "shell"
package.path = package.path .. ";/BOS/?.lua"
local gub = require("gub")
local function getProgramName(path)
    if not path or path == "shell" then return "Terminal" end
    local name = fs.getName(path)
    return name:gsub("%.%w+$", "")
end
local programName = getProgramName(program)
local originalTerm = term.current()
local w, h = originalTerm.getSize()
local winY = 2
local win = window.create(originalTerm, 1, winY, w, h - (winY - 1), true)
local function drawTopBar()
    local previousTerm = term.redirect(originalTerm)
    topBar()
    topButton(" X ", 1, "false")
    topText(programName, 5)
    term.redirect(previousTerm)
end
local function createProgramCoroutine()
    return coroutine.create(function()
        term.redirect(win)
        if program == "shell" or fs.exists(program) then
            shell.run(program)
        else
            print("Program not found: " .. tostring(program))
            sleep(1)
        end
    end)
end
local co = createProgramCoroutine()
local function eventLoop()
    while true do
        drawTopBar()
        win.restoreCursor() 
        local event = { os.pullEventRaw() }
        local e = event[1]
        if e == "term_resize" then
            w, h = originalTerm.getSize()
            win.reposition(1, winY, w, h - (winY - 1))
            drawTopBar()
            if co and coroutine.status(co) ~= "dead" then
                coroutine.resume(co, table.unpack(event))
            end
        elseif e == "mouse_click" or e == "monitor_touch" or e == "mouse_drag" then
            local x, y = event[3], event[4]
            if y == 1 and x >= 1 and x <= 3 then
                local prev = term.redirect(originalTerm)
                topButton(" X ", 1, "true")
                term.redirect(prev)
                sleep(0.1)
                return
            end
            if y >= winY and co then
                event[4] = y - (winY - 1)
                if coroutine.status(co) ~= "dead" then
                    coroutine.resume(co, table.unpack(event))
                end
            end
        else
            if co then
                if coroutine.status(co) == "dead" then
                    co = nil
                else
                    local ok, err = coroutine.resume(co, table.unpack(event))
                    if not ok then
                        print("Program error:", err)
                        co = nil
                    end
                end
            end
        end
    end
end
originalTerm.setBackgroundColor(colors.black)
originalTerm.clear()
local status, err = pcall(eventLoop)
term.redirect(originalTerm)
term.setBackgroundColor(colors.black)
term.setCursorBlink(false)
term.clear()
term.setCursorPos(1, 1)
if not status and err ~= "Terminated" then
    print("Error: " .. err)
end