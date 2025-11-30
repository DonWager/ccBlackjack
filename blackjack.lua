-- Deck Stuff
INITDECK = {
    "AH", "AS", "AC", "AD",  -- Aces
    "2H", "2S", "2C", "2D",  -- Twos
    "3H", "3S", "3C", "3D",  -- Threes
    "4H", "4S", "4C", "4D",  -- Fours
    "5H", "5S", "5C", "5D",  -- Fives
    "6H", "6S", "6C", "6D",  -- Sixes
    "7H", "7S", "7C", "7D",  -- Sevens
    "8H", "8S", "8C", "8D",  -- Eights
    "9H", "9S", "9C", "9D",  -- Nines
    "10H", "10S", "10C", "10D", -- Tens
    "JH", "JS", "JC", "JD",  -- Jacks
    "QH", "QS", "QC", "QD",  -- Queens
    "KH", "KS", "KC", "KD"   -- Kings
}
local deck = {}

local function shuffle(t)
  local n = #t
  for i = n, 2, -1 do
    local j = math.random(i)
    t[i], t[j] = t[j], t[i]
  end
  return t
end

local function draw(t)
  local n = #t
  if n == 0 then return nil end
  local card = t[n]
  t[n] = nil
  local suit = string.sub(card, -1)
  card = string.sub(card, 1, -2)
  local value = 0
    if card == "J" or card == "Q" or card == "K" then
        value = 10
    elseif card == "A" then
        value = 0
    else
        value = tonumber(card)
    end
  return {suit,value}
end

local players = {}
local mon = peripheral.wrap("right") or error("Monitor not found on right")
print(mon.getSize()) --29 12
local native = term.native()
term.redirect(mon)
mon.setTextScale(1)
mon.clear()
math.randomseed(os.time()+math.floor(os.time()*1000))

-- Button Stuff
local btnHit = {x1=1,y1=9,x2=9,y2=12,label="HIT"}
local btnStand = {x1=11,y1=9,x2=19,y2=12,label="STAND"}
local btnDouble = {x1=21,y2=9,x2=29,y2=12,label="DOUBLE"}

-- Rendert Knopf auf Monitor
function drawButton(b, isPressed)
  local bg = isPressed and colors.gray or colors.lightGray
  paintutils.drawFilledBox(b.x1,b.y1,b.x2,b.y2,bg)
  mon.setTextColor(colors.black)
  local cx = math.floor((b.x1 + b.x2 - #b.label)/2) + 1
  local cy = math.floor((b.y1 + b.y2)/2)
  mon.setCursorPos(cx, cy)
  mon.write(b.label)
end

-- Checkt, ob der Knopfdruck innerhalb des Knopfes war
function inside(b,x,y) return x>=b.x1 and x<=b.x2 and y>=b.y1 and y<=b.y2 end

function initializeGame(connectedPlayers)
  deck = {table.unpack(INITDECK)}
  shuffle(deck)
end

-- Game state
initializeGame(1)
local playerTotal = 0
local dealerTotal = draw(deck)[2] + draw(deck)[2]
playerTotal = draw(deck)[2] + draw(deck)[2]

local function drawUI()
  mon.clear()
  drawButton(btnHit,false); drawButton(btnStand,false); drawButton(btnDouble,false)
end

drawUI()

-- Handle touch events
while true do
    local ev, side, x, y = os.pullEvent("monitor_touch")
    if inside(btnHit,x,y) then
        drawButton(btnHit, true); sleep(0.12); drawButton(btnHit,false)
        local v = draw(deck)[2]; playerTotal = playerTotal + v
        drawUI()
    elseif inside(btnStand,x,y) then
        drawButton(btnStand, true); sleep(0.12); drawButton(btnStand,false)
        drawUI()
    elseif inside(btnDouble,x,y) then
        drawButton(btnDouble, true); sleep(0.12; drawButton(btnDouble,false)
        local v = draw(deck)[2]; playerTotal = playerTotal + v
        drawUI()
    end
end

term.redirect(native)
