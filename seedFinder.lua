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
    if input == nil or input == "" then return {} end
    local suggestions = {}
    for name, data in pairs(seedIndex) do
        if string.sub(name, 1, string.len(input)) == input then
            table.insert(suggestions, name)
        end
    end
    return suggestions
end

function readAutocomplete()
    local input = ""
    local selectedSuggetion = 0
    while true do
        term.clear()
        term.setCursorPos(1,1)
        term.print("Search for Essence:")
        term.write("> " .. input)

        local suggestions = autocomplete(input)
        if #suggestions > 0 then
            print("")
            for i = 1, math.min(17, #suggestions) do
                if i == selectedSuggestion then
                    term.setBackgroundColor(colors.white)
                    term.setTextColor(colors.black)
                    print(suggestions[i]) 
                    term.setBackgroundColor(colors.black)
                    term.setTextColor(colors.white)
                else
                    print(suggestion[i])
                end
            end
        end
            
        term.setCursorPos(3 + string.len(input), 1)
        term.setCursorBlink(true)
        local event, a = os.pullEvent()
        if event == "char" then
            selectedSuggestion = 0
            input = input .. a
        elseif event == "key" then
            if a == keys.backspace then
                if #input > 0 then input = string.sub(input, 1, -2) end
            elseif a == keys.enter then
                return input
            elseif a == keys.down then
                selectedSuggestion = math.min(selectedSuggestion + 1, #suggestions, 17)
            elseif a == keys.up then
                selectedSuggestion = math.max(selectedSuggestion - 1, 0)
            end
        end
    end
end


function main()
    term.clear()
    while true do
        local query = readAutocomplete()
        print("You entered: " .. query)
        os.sleep(10)
    end
end

main()
