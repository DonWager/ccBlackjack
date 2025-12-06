-- Hoppelichter Bsp.: "Redstone" = {row="front",pos="3",dir="left",light=peripheral.wrap(minecraft:redstone_light_2)}
local seedIndex = require("seedIndex")
-- Init von allen Lampen
local frontRow = {
    peripheral.wrap("redstone_relay_0") -- Da das erst Relay nicht 1 sondern 0 ist, die 1 ist das erste der Rechten SeedLights, weil ich die erst Reihe für Reihe platziert habe
}
local leftRow = {}
local rightRow = {}
local backRow = {}

-- Fill frontRow with numbers 1-19
for i = 2, 19 do
    frontRow[i] = peripheral.wrap("redstone_relay_" .. i)
end

-- Fill rightRow with numbers 20-37
for i = 20, 37 do
    rightRow[i - 19] = peripheral.wrap("redstone_relay_" .. i)
end

-- Fill backRow with numbers 38-54
for i = 38, 54 do
    backRow[i - 37] = peripheral.wrap("redstone_relay_" .. i)
end

-- Fill leftRow with numbers 55-72
for i = 55, 72 do
    leftRow[i - 54] = peripheral.wrap("redstone_relay_" .. i)
end

-- Autocomplete Function
function autocomplete(input)
    local suggestions = {}
    for name, data in ipairs(seedIndex) do
        if string.sub(name, 1, string.len(input)) == input then
            table.insert(suggestions, name)
        end
    end
    return suggestions
end

function readAutocomplete()
    local input = ""
    while true do
        local event, key = os.pullEvent("char")
        term.clear()
        if key == "\n" then
            return input
        elseif key == "\27" then
            input = input:sub(1, -2) -- Handle backspace
        else
            input = input .. key
        end
        -- Get suggestions
        local suggestions = autocomplete(input)
        if #suggestions > 0 then
            for _, suggestion in ipairs(suggestions) do
                term.write(suggestion .. "\n")
            end
        end
    term.write(input) -- Reprint the prompt with current input
    end
end


function main()
    term.clear()
    while true do
        local query = readAutocomplete()
    end
end

main()
