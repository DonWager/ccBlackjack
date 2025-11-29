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
  local v = t[n]
  t[n] = nil
  return v
end

local players = {}
local mon = peripheral.wrap("right") or error("Monitor not found on left")
local native = term.native()
term.redirect(mon)
mon.setTextScale(1)
mon.clear()
math.randomseed(os.time()+math.floor(os.time()*1000))
local btnHit = {x1=2,y1=8,x2=12,y2=10,label="HIT"}
local btnStand = {x1=14,y1=8,x2=24,y2=10,label="STAND"}

-- Rendet Knopf auf Monitor
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
function inside(button,x,y) return x>=b.x1 and x<=b.x2 and y>=b.y1 and y<=b.y2 end

function initializeGame(connectedPlayers)
  deck = INITDECK
  shuffle(deck)
end

-- Game state
local playerTotal = 0
local dealerTotal = draw() + draw()
playerTotal = draw() + draw()

local function drawUI()
  mon.clear()
  mon.setCursorPos(2,2); mon.setTextColor(colors.white); mon.write("Dealer: "..dealerTotal)
  mon.setCursorPos(2,4); mon.setTextColor(colors.white); mon.write("Player: "..playerTotal)
  drawButton(btnHit,false); drawButton(btnStand,false)
end

drawUI()

-- Handle touch events
while true do
  local ev, side, x, y = os.pullEvent("monitor_touch")
  if inside(btnHit,x,y) then
    drawButton(btnHit, true); sleep(0.12); drawButton(btnHit,false)
    local v = draw(); playerTotal = playerTotal + v
    drawUI()
    if playerTotal > 21 then
      mon.setCursorPos(2,6); mon.setTextColor(colors.red); mon.write("BUST! You lose.")
      break
    end
  elseif inside(btnStand,x,y) then
    drawButton(btnStand, true); sleep(0.12); drawButton(btnStand,false)
    -- simple dealer behavior: draw until 17
    while dealerTotal < 17 do
      dealerTotal = dealerTotal + draw()
    end
    drawUI()
    if dealerTotal > 21 or playerTotal > dealerTotal then
      mon.setCursorPos(2,6); mon.setTextColor(colors.green); mon.write("You win!")
    elseif playerTotal == dealerTotal then
      mon.setCursorPos(2,6); mon.setTextColor(colors.yellow); mon.write("Push.")
    else
      mon.setCursorPos(2,6); mon.setTextColor(colors.red); mon.write("You lose.")
    end
    break
  end
end

term.redirect(native)
