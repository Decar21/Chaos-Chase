socket = require("socket")-- For socket.gettime()*1000

Menu = require("menu")


-- Use for collision checks, will enemyBulletPhysical set later
local closest


-- Damage multiplier for powerups
local damageMultiplier = 1


-- Used for reading User's touch input
local touches = love.touch.getTouches()

-- Variables for trophy popups
local trophyStart = socket.gettime()
local killCount = 0
local time = 0


-- Score
local score = 725
local topscore = 150
local topscore1 = 300
local topscore2 = 450
local topscore3 = 600
local topscore4 = 750

--[[ Create explosion animation ]]--
-- Explosions and quad for animation
local explosion = love.graphics.newImage("assets/explosionanim.png")

local exp = {}
quad = {}

quad[0] = love.graphics.newQuad(0,0,64,64,256,256)
quad[1] = love.graphics.newQuad(64,0,64,64,256,256)
quad[2] = love.graphics.newQuad(128,0,64,64,256,256)
quad[3] = love.graphics.newQuad(192,0,64,64,256,256)

quad[4] = love.graphics.newQuad(0,64,64,64,256,256)
quad[5] = love.graphics.newQuad(64,64,64,64,256,256)
quad[6] = love.graphics.newQuad(128,64,64,64,256,256)
quad[7] = love.graphics.newQuad(192,64,64,64,256,256)

quad[8] = love.graphics.newQuad(0,128,64,64,256,256)
quad[9] = love.graphics.newQuad(64,128,64,64,256,256)
quad[10] = love.graphics.newQuad(128,128,64,64,256,256)
quad[11] = love.graphics.newQuad(192,128,64,64,256,256)

quad[12] = love.graphics.newQuad(0,192,64,64,256,256)
quad[13] = love.graphics.newQuad(64,192,64,64,256,256)
quad[14] = love.graphics.newQuad(128,192,64,64,256,256)
quad[15] = love.graphics.newQuad(192,192,64,64,256,256)


local bsexp = {}
bsquad = {}

bsquad[0] = love.graphics.newQuad(0,0,64,64,256,256)
bsquad[1] = love.graphics.newQuad(64,0,64,64,256,256)
bsquad[2] = love.graphics.newQuad(128,0,64,64,256,256)
bsquad[3] = love.graphics.newQuad(192,0,64,64,256,256)

bsquad[4] = love.graphics.newQuad(0,64,64,64,256,256)
bsquad[5] = love.graphics.newQuad(64,64,64,64,256,256)
bsquad[6] = love.graphics.newQuad(128,64,64,64,256,256)
bsquad[7] = love.graphics.newQuad(192,64,64,64,256,256)

bsquad[8] = love.graphics.newQuad(0,128,64,64,256,256)
bsquad[9] = love.graphics.newQuad(64,128,64,64,256,256)
bsquad[10] = love.graphics.newQuad(128,128,64,64,256,256)
bsquad[11] = love.graphics.newQuad(192,128,64,64,256,256)

bsquad[12] = love.graphics.newQuad(0,192,64,64,256,256)
bsquad[13] = love.graphics.newQuad(64,192,64,64,256,256)
bsquad[14] = love.graphics.newQuad(128,192,64,64,256,256)
bsquad[15] = love.graphics.newQuad(192,192,64,64,256,256)


--[[ Load Essential Variables and Assets ]]--
function love.load()


  mainMenuSong = love.audio.newSource("assets/MainMenu.wav", "stream")

  lvl1Song = love.audio.newSource("assets/Level_1.wav", "stream")
  lvl2Song = love.audio.newSource("assets/Level_2.wav", "stream")
  lvl3Song = love.audio.newSource("assets/domy.wav", "stream")
  lvl4Song = love.audio.newSource("assets/Boss_2.wav" , "stream")
  bossSong = love.audio.newSource("assets/Boss_3.wav", "stream")

  mainMenuSong:setLooping(true)
  mainMenuSong:play()


  --[[ Set variables for visual scaling ]]--
  --define virtual viewport
  VIRTUAL_WIDTH = 1600
  VIRTUAL_HEIGHT = 900
   
  --calculate the amount of sx, and sy
  sx = VIRTUAL_WIDTH / love.graphics.getWidth()
  sy = VIRTUAL_HEIGHT / love.graphics.getHeight()


  --[[ Create variables for configuring touch controls ]]--
  touches = love.touch.getTouches()


  --[[ Set variables needed for essential aspects ]]--

  -- Level counter
  level = 1

  -- timer (possible use later)
  timer = 0

  love.window.setMode(love.graphics.getWidth(), love.graphics.getHeight(), {resizable=false, fullscreen=true})

  --[[ Load Assets ]]--
  background = love.graphics.newImage("assets/BackgroundSeamless.png")
  bglvl2 = love.graphics.newImage("assets/bglvl2.jpg")
  bglvl3 = love.graphics.newImage("assets/bglvl3.jpg")
  bglvl4 = love.graphics.newImage("assets/bglvl4.jpg")
  bglvl5 = love.graphics.newImage("assets/bglvl5.jpg")

  -- Pause Image
  pauseImage = love.graphics.newImage("assets/pause.png")

  -- Ships
  ShipImage1 = love.graphics.newImage("assets/PlayerRed_Frame_01_png_processed.png")

  -- Bullets
  minigunImage1 = love.graphics.newImage("assets/Minigun_Small_png_processed.png")
  laserImage = love.graphics.newImage("assets/Laser_Medium_png_processed.png")
  rocketImage = love.graphics.newImage("assets/Plasma_Large_png_processed.png")

  enemyBulletImage = love.graphics.newImage("assets/Plasma_Large_png_processed.png")
  bossBulletImage = love.graphics.newImage("assets/bossbullet.png")


  -- Items and item assets
  Items = {}
  damageItemImage = love.graphics.newImage("assets/Powerup_Ammo_png_processed.png")
  speedItemImage =  love.graphics.newImage("assets/Powerup_Energy_png_processed.png")
  healthItemImage = love.graphics.newImage("assets/Powerup_Health_png_processed.png")
  rocketItemImage = love.graphics.newImage("assets/Powerup_Rockets_png_processed.png")
  shieldItemImage = love.graphics.newImage("assets/Powerup_Shields_png_processed.png")
  itemShadowImage = love.graphics.newImage("assets/Powerup_Shadow_png_processed.png")

  -- Trophy Image
  TrophyImage = love.graphics.newImage("assets/Trophy_Plaque.png")


  -- Health and health assets
  hb = {}
  hb[0] = love.graphics.newImage("assets/hb_0.png")
  hb[1] = love.graphics.newImage("assets/hb_1.png")
  hb[2] = love.graphics.newImage("assets/hb_2.png")
  hb[3] = love.graphics.newImage("assets/hb_3.png")
  hb[4] = love.graphics.newImage("assets/hb_4.png")
  hb[5] = love.graphics.newImage("assets/hb_5.png")
  hb[6] = love.graphics.newImage("assets/hb_6.png")
  hb[7] = love.graphics.newImage("assets/hb_7.png")
  hb[8] = love.graphics.newImage("assets/hb_8.png")
  hb[9] = love.graphics.newImage("assets/hb_9.png")
  hb[10] = love.graphics.newImage("assets/hb_10.png")
  hb[11] = love.graphics.newImage("assets/hb_11.png")
  hb[12] = love.graphics.newImage("assets/hb_12.png")
  hb[13] = love.graphics.newImage("assets/hb_13.png")
  hb[14] = love.graphics.newImage("assets/hb_14.png")
  hb[15] = love.graphics.newImage("assets/hb_15.png")
  hb[16] = love.graphics.newImage("assets/hb_16.png")


  --[[ Set up the Player, Enemies, Bullets(player and enemy), and Items ]]--

  -- Player
  shipSpeed = 150
  shipSize = 64

  playerHealth = 100

  shipScale = {x = 1.5, y = 1.5}
  shipOffset = {x = ShipImage1:getWidth()/2, y = ShipImage1:getHeight()/2}

  -- Create structure for Player Ship
  math.randomseed(os.time())
  Ship = {
    position = {x = love.graphics.getWidth() / 2, y = love.graphics.getHeight() / 2},
    direction = 0
  }

  -- Enemies
  -- Will need base variables, scaling measures, and assets
  enemyTimer = 0
  initialEnemySpawn = 1.5
  initialEnemySpeed = 75

  enemySpawn = initialEnemySpawn
  EnemySpeed = initialEnemySpeed

  enemyScale = {x = 1.5, y = 1.5}
  enemyOffset = {}
  enemySize = {}

  Enemies = {}
  EnemyImage = {}
  EnemyImage[1] = love.graphics.newImage("assets/Blue_And_Green_Ship1.png")
  EnemyImage[2] = love.graphics.newImage("assets/Enemy01_Red_Frame_1_png_processed.png")
  EnemyImage[3] = love.graphics.newImage("assets/Enemy01_Teal_Frame_1_png_processed.png")
  EnemyImage[4] = love.graphics.newImage("assets/Enemy02Green_Frame_1_png_processed.png")
  EnemyImage[5] = love.graphics.newImage("assets/Enemy02Red_Frame_1_png_processed.png")
  EnemyImage[6] = love.graphics.newImage("assets/Enemy02_Teal_Frame_1_png_processed.png")
  EnemyImage[7] = love.graphics.newImage("assets/Enemy02Red_Frame_1_png_processed.png")
  EnemyImage[8] = love.graphics.newImage("assets/Enemy02_Teal_Frame_1_png_processed.png")
  EnemyImage[9] = love.graphics.newImage("assets/Blue_And_Green_MashUp1.png")
  EnemyImage[10] = love.graphics.newImage("assets/Enemy01_Green_Frame_1_png_processed.png")
  EnemyImage[11] = love.graphics.newImage("assets/Blue_And_Red_Ship1.png")
  EnemyImage[12] = love.graphics.newImage("assets/Green_And_Red_Ship1.png")
  EnemyImage[13] = love.graphics.newImage("assets/Green_And_Red_Ship2.png")
  EnemyImage[14] = love.graphics.newImage("assets/Purple_Ship1.png")
  

  for variable = 1, 14, 1 do
    enemyOffset[variable] = {x = EnemyImage[variable]:getWidth()/2, y = EnemyImage[variable]:getHeight()/2}
  end

  for variable = 1, 14, 1 do
    enemySize[variable] = EnemyImage[variable]:getHeight()
  end


  -- Boss
  -- Will need base variables, scaling measures, and assets
  bossTimer = 0
  initialBossSpawn = 1
  initialBossSpeed = 25

  bossSpawn = initialBossSpawn
  bossSpeed = initialBossSpeed

  bossScale = {x = 2.125, y = 2.125}
  bossOffset = {}
  bossSize = {}

  Bosses = {}
  BossImage = {}
  BossImage[1] = love.graphics.newImage("assets/boss1.png")

  for bvariable = 1, 1, 1 do
    bossOffset[bvariable] = {x = BossImage[bvariable]:getWidth()/2, y = BossImage[bvariable]:getHeight()/2}
  end

  for bvariable = 1, 1, 1 do
    bossSize[bvariable] = BossImage[bvariable]:getHeight()
  end


  -- On screen Buttons 
  buttons = { 
    fType = {love.graphics.getWidth() - 100, love.graphics.getHeight() - 100, 75, 75}
  }

  freq = 0.25

  fireButton = love.graphics.circle("fill", love.graphics.getWidth() - 75, love.graphics.getHeight() - 75, 50)
  fireButtonScale = {x = 1, y = 1}
  fireButtonSize = {}

end


-- Bullets
-- Will need base variables, types, and tables
local bulletTimer = 0

local bulletSize = 10
local bulletScale = 0.25
local bulletOffset = 24

local bulletSpeed = 450

local shots = 0

local fireType = "Minigun"
local fireRateMultiplier = 0.25
local fireRate = 0

local Bullets = {}
local bulletquad = {}
bulletquad[0] = love.graphics.newQuad(0,0,48,48,240,48)
bulletquad[1] = love.graphics.newQuad(48,0,48,48,240,48)
bulletquad[2] = love.graphics.newQuad(96,0,48,48,240,48)
bulletquad[3] = love.graphics.newQuad(144,0,48,48,240,48)
bulletquad[4] = love.graphics.newQuad(192,0,48,48,240,48)
bulletquad[5] = love.graphics.newQuad(240,0,48,48,240,48)

-- Funtion to keep track of players fireType, fireRate, and updating fireRate
function updateFireRate()
  if fireType == "Minigun" then
    baseFireRate = 0.5
  elseif fireType == "Laser" then
    baseFireRate = 1
    bulletSpeed = 550
  elseif fireType == "Rocket" then
    baseFireRate = 0.75
  end
  fireRate = baseFireRate * (1/(math.log10(fireRateMultiplier+1)*10))
end
updateFireRate()


-- Enemy Bullets
-- Will enemyBulletPhysical essentially the same as player bullets
local enemyBulletTimer = 0
local enemyBulletSpeed = 175

local enemyBulletSize = 8
local enemyBulletScale = 0.3
local enemyBulletOffset = 20

local enemyFireType = "EnemyGun"
local enemyFireRate = 0
local enemyFireRateMultiplier = 0.25

local EnemyBullets = {}
local enemybulletquad = {}
enemybulletquad[0] = love.graphics.newQuad(0,0,48,48,240,48)
enemybulletquad[1] = love.graphics.newQuad(48,0,48,48,240,48)
enemybulletquad[2] = love.graphics.newQuad(96,0,48,48,240,48)
enemybulletquad[3] = love.graphics.newQuad(144,0,48,48,240,48)
enemybulletquad[4] = love.graphics.newQuad(192,0,48,48,240,48)
enemybulletquad[5] = love.graphics.newQuad(240,0,48,48,240,48)

function updateEnemyFireRate()
  if enemyFireType == "EnemyGun" then
    enemyBaseFireRate = 0.5
  end
  enemyFireRate = enemyBaseFireRate * (1 / (math.log10(enemyFireRateMultiplier + 1) * 10))
end
updateEnemyFireRate()


-- Boss Bullets
-- Will be essentially the same as enemy bullets
local bossBulletTimer = 0
local bossBulletSpeed = 100

local bossBulletSize = 8
local bossBulletScale = 0.5
local bossBulletOffset = 20

local bossFireType = "BossGun"
local bossFireRate = 0
local bossFireRateMultiplier = 0.25

local BossBullets = {}
local bossbulletquad = {}
bossbulletquad[0] = love.graphics.newQuad(0,0,48,48,240,48)
bossbulletquad[1] = love.graphics.newQuad(48,0,48,48,240,48)
bossbulletquad[2] = love.graphics.newQuad(96,0,48,48,240,48)
bossbulletquad[3] = love.graphics.newQuad(144,0,48,48,240,48)
bossbulletquad[4] = love.graphics.newQuad(192,0,48,48,240,48)
bossbulletquad[5] = love.graphics.newQuad(240,0,48,48,240,48)
bossbulletquad[6] = love.graphics.newQuad(288,0,48,48,240,48)


function updateBossFireRate()
  if bossFireType == "BossGun" then
    bossBaseFireRate = 0.5
  end
  bossFireRate = bossBaseFireRate * (1 / (math.log10(bossFireRateMultiplier + 1) * 10))
end
updateBossFireRate()


-- Screens for pausing, loading, and highscore
local pauseScreen = false

local loadScreen = true

local scoreScreen = false

local gameScreen = true


--[[ Run the game and update game aspects ]]--
--[[ 
    - Will need to update Items
    - Will need to update Player Bullets and Enemy Bullets
    - Will need to update Player Movement
    - Will need to Enemy Movement and Spawns
    - Will need to check all collisions
    - Will need to update levels
 ]]-- 
function love.update(dt)

  -- Run the funtion if the game is not paused
  if gameScreen == true then


    enemyTimer = enemyTimer + dt
    bossTimer = bossTimer + dt
    bulletTimer = bulletTimer + dt
    enemyBulletTimer = enemyBulletTimer + dt
    bossBulletTimer = bossBulletTimer + dt

    if pauseScreen == true or loadScreen == true or scoreScreen == true then
      mainMenuSong:setLooping(true)
      mainMenuSong:play()
      love.audio.pause(lvl1Song)
      love.audio.pause(lvl2Song)
      love.audio.pause(lvl3Song)
      love.audio.pause(lvl4Song)
      love.audio.pause(bossSong)
    end

    if level == 1 then
      lvl2Song:stop()
      lvl3Song:stop()
      lvl4Song:stop()
      bossSong:stop()
      love.audio.pause(mainMenuSong)
      lvl1Song:setLooping(true)
      lvl1Song:play()
      lvl1Song:setVolume(0.2)

      if pauseScreen == true or loadScreen == true or scoreScreen == true then
        mainMenuSong:setLooping(true)
        mainMenuSong:play()
        love.audio.pause(lvl1Song)
        love.audio.pause(lvl2Song)
        love.audio.pause(lvl3Song)
        love.audio.pause(lvl4Song)
        love.audio.pause(bossSong)
      end 
    end

    if level == 5 or score > 750 then
      love.audio.pause(mainMenuSong)
      lvl1Song:stop()
      bossSong:setLooping(true)
      bossSong:play()
      bossSong:setVolume(0.5)

      if pauseScreen == true or loadScreen == true or scoreScreen == true then
        mainMenuSong:setLooping(true)
        mainMenuSong:play()
        love.audio.pause(lvl1Song)
        love.audio.pause(lvl2Song)
        love.audio.pause(lvl3Song)
        love.audio.pause(lvl4Song)
        love.audio.pause(bossSong)
      end
    end


    -- PLAYER -- 
    -- Make the Player's model follow the User's screen touch
    local touchX, touchY = love.graphics.getWidth(), love.graphics.getHeight()
    for _, id in ipairs(touches) do
      touchX, touchY = love.touch.getPosition(id)
    end

    -- Update the Player's position to where the User is touching
    distance = ((touchX - Ship.position.x)^2 + (touchY - Ship.position.y)^2)^0.5

    -- If the User holds the Mouse 1 Button, update Player's position. Do not let them go off screen --
    -- id, love.graphics.getWidth(), love.graphics.getHeight(), 0, 0, 1
    if love.mouse.isDown(1) and distance > 2 then
      touchX, touchY = love.mouse.getPosition()

      Ship.direction = math.atan2(touchX - Ship.position.x, Ship.position.y - touchY)-math.pi/2

      -- Update the Player's position to where the User is touching
      distance = ((touchX - Ship.position.x)^2 + (touchY - Ship.position.y)^2)^0.5

      Ship.position.x = Ship.position.x + (math.cos(Ship.direction)* dt * shipSpeed)
      if Ship.position.x < 0 then
        Ship.position.x = 0

      elseif Ship.position.x > love.graphics.getWidth() then
        Ship.position.x = love.graphics.getWidth()
      end

      Ship.position.y = Ship.position.y + (math.sin(Ship.direction)* dt * shipSpeed)
      if Ship.position.y < 0 then
        Ship.position.y = 0

      elseif Ship.position.y > love.graphics.getHeight() then
        Ship.position.y = love.graphics.getHeight()
      end

      c = 0
      
      -- change fire types
      if touchX > love.graphics.getWidth() - 300 and touchY > love.graphics.getHeight() - 150 then 
        fireType = "Laser"
        updateFireRate()
      end

      if touchX > love.graphics.getWidth() - 300 and touchX > love.graphics.getWidth() - 150 and touchY > love.graphics.getHeight() - 150 then 
        fireType = "Minigun"
        updateFireRate()
      end

      -- Pausing the game
      if touchX > love.graphics.getWidth() - 100 and touchY < 100 then
        pauseScreen = true
      end

      -- Unpause
      if touchX < love.graphics.getWidth() - 300 and touchX < love.graphics.getWidth() - 100 and touchY < love.graphics.getHeight() then
        pauseScreen = false
      end

      -- Pausing the game
      if touchX < 100 and touchY < 100 and pauseScreen ~= true then
        loadScreen = true
      end

      -- Main Menu WIP
      if loadScreen then
        if touchY < love.graphics.getHeight()/1.5 then
          loadScreen = false
        end


        if touchY < 500 and touchY < 250 then
          scoreScreen = true
        end

        if touchX < 100 and touchY < love.graphics.getHeight()-100 and scoreScreen == true then
          scoreScreen = false
          loadScreen = true
        end
      end
      


      -- Create Player Bullets when Mouse 2 is clicked
      -- if love.mouse.isDown(2) or love.keyboard.isDown("space") then
      if bulletTimer > fireRate then
        bulletTimer = 0
        shots = shots + 1

        -- Create a Bullet Structure
        local Bullet = {
          position = {x = Ship.position.x, y = Ship.position.y},
          direction = Ship.direction,
          Type = fireType
        }
        table.insert(Bullets, Bullet)
        sound = love.audio.newSource("assets/Bullet3.wav", "static")
        sound:play()
        sound:setVolume(0.3)
      end

      -- Create Enemy Bullets, they will spawn from random enemies and have random fire rates
      for enemyEntity,enemyPhysical in pairs(Enemies) do
        if enemyBulletTimer > enemyFireRate then
          enemyBulletTimer = math.random(0.01, 2)

          -- Create EnemtBully structure
          local EnemyBullet = {
            position = {x = enemyPhysical.position.x, y = enemyPhysical.position.y},
            direction = enemyPhysical.direction,
            Type = enemyFireType
          }
          table.insert(EnemyBullets, EnemyBullet)
        end
      end

      -- Create Boss Bullets, they will spawn from random enemies and have random fire rates
      for bossEntity, bossPhysical in pairs(Bosses) do
        if bossBulletTimer > bossFireRate then
          bossBulletTimer = math.random(0.1, 3)

          -- Create EnemtBully structure
          local bossBullet = {
            position = {x = bossPhysical.position.x, y = bossPhysical.position.y},
            direction = bossPhysical.direction,
            Type = bossFireType
          }
          table.insert(BossBullets, bossBullet)
        end
      end
    end


    -- ENEMIES -- 
    -- Update Enemies Positions and check collisions with Player, Enemies will track onto the Player --
    for enemyEntity, enemyPhysical in pairs(Enemies) do
      if enemyPhysical.health < 1 then
        explosionAnimation(enemyEntity, enemyPhysical)
      end

      -- Change sprite size with hitboxes WIP -- 
      local tempWidth = EnemyImage[enemyPhysical.sprite]:getWidth()
      enemyPhysical.position.x = enemyPhysical.position.x + (math.cos(enemyPhysical.direction)* dt * EnemySpeed / (tempWidth*1.5)*32)
      enemyPhysical.position.y = enemyPhysical.position.y + (math.sin(enemyPhysical.direction)* dt * EnemySpeed / (tempWidth*1.5)*32)
      enemyPhysical.direction = math.atan2(enemyPhysical.position.x - Ship.position.x, Ship.position.y - enemyPhysical.position.y) + math.pi/2

      -- Collision detection with Player
      distance = ((enemyPhysical.position.x - Ship.position.x)^2 + (enemyPhysical.position.y - Ship.position.y)^2)^0.5
    
      if distance < closest.distance and enemyPhysical.position.x < love.graphics.getWidth() and enemyPhysical.position.x > 0 and enemyPhysical.position.y < love.graphics.getHeight() and enemyPhysical.position.y > 0 then
        closest.distance = distance
        closest.x = enemyPhysical.position.x
        closest.y = enemyPhysical.position.y
      end
      
      -- If the Enemy and Player collide, hurt both Enemy and Player
      if distance < (enemySize[enemyPhysical.sprite]/2 + shipSize/2) * enemyScale.x then 
        playerHealth = playerHealth - 1
        enemyPhysical.health = enemyPhysical.health - 1

        if enemyPhysical.health < 0 then
          enemyPhysical.health = 0
        end

        -- Reset game if player dies
        if playerHealth <= 0 then
          fireRateMultiplier = 0.25
          updateFireRate()
          updateEnemyFireRate()
          Enemies = {}
          Bullets = {}
          EnemyBullets = {} 
          Items = {}
          exp = {}
          Ship.position.x = love.graphics.getWidth() / 2
          Ship.position.y = love.graphics.getHeight() / 2
          enemySpawn = initialEnemySpawn
          EnemySpeed = initialEnemySpeed

          if score > topscore then
            topscore1 = topscore
            topscore2 = topscore1
            topscore3 = topscore2
            topscore4 = topscore3
            topscore = score
          elseif score > topscore1 then
            topscore2 = topscore1
            topscore3 = topscore2
            topscore4 = topscore3
            topscore1 = score
          elseif score > topscore2 then
            topscore3 = topscore2
            topscore4 = topscore3
            topscore2 = score
          elseif score > topscore3 then
            topscore4 = topscore3
            topscore3 = score
          elseif score > topscore4 then
            topscore4 = score
          end

          score = 0
          fireType = "Minigun"
          
          level = 1
          playerHealth = 100
          shipSpeed = 150
          damageMultiplier = 1
        end
      end
    end


    if score > 750 then
      -- BOSSES -- 
      -- Update Bosses Positions and check collisions with Player, Boss will track onto the Player --
      if bossTimer > bossSpawn then
        bossTimer = 0
        bossSpawn = 0
      end

      for bossEntity, bossPhysical in pairs(Bosses) do
        if bossPhysical.health < 1 then
          bossExplosionAnimation(bossEntity, bossPhysical)
        end

        -- Change sprite size with hitboxes WIP -- 
        local tempWidth = BossImage[bossPhysical.sprite]:getWidth()
        bossPhysical.position.x = bossPhysical.position.x + (math.cos(bossPhysical.direction)* dt * bossSpeed / (tempWidth*1.5)*32)
        bossPhysical.position.y = bossPhysical.position.y + (math.sin(bossPhysical.direction)* dt * bossSpeed / (tempWidth*1.5)*32)
        bossPhysical.direction = math.atan2(bossPhysical.position.x - Ship.position.x, Ship.position.y - bossPhysical.position.y) + math.pi/2

        -- Collision detection with Player
        distance = ((bossPhysical.position.x - Ship.position.x)^2 + (bossPhysical.position.y - Ship.position.y)^2)^0.5
      
        if distance < closest.distance and bossPhysical.position.x < love.graphics.getWidth() and bossPhysical.position.x > 0 and bossPhysical.position.y < love.graphics.getHeight() and bossPhysical.position.y > 0 then
          closest.distance = distance
          closest.x = bossPhysical.position.x
          closest.y = bossPhysical.position.y
        end

        if bossPhysical.position.y > love.graphics.getHeight() / 2 - 50 then
          bossSpeed = 0
        end
        
        -- If the Enemy and Player collide, hurt both Enemy and Player
        if distance < (bossSize[bossPhysical.sprite]/2 + shipSize/2) * bossScale.x then 
          playerHealth = playerHealth - 1
          bossPhysical.health = bossPhysical.health - 1

          if bossPhysical.health < 0 then
            bossPhysical.health = 0
          end

          -- Reset game if player dies
          if playerHealth <= 0 then
            fireRateMultiplier = 0.25
            updateFireRate()
            updateEnemyFireRate()
            Enemies = {}
            Bullets = {}
            Bosses = {}
            EnemyBullets = {} 
            Items = {}
            exp = {}
            Ship.position.x = love.graphics.getWidth() / 2
            Ship.position.y = love.graphics.getHeight() / 2
            enemySpawn = initialEnemySpawn
            EnemySpeed = initialEnemySpeed

            if score > topscore then
              topscore1 = topscore
              topscore2 = topscore1
              topscore3 = topscore2
              topscore4 = topscore3
              topscore = score
            elseif score > topscore1 then
              topscore2 = topscore1
              topscore3 = topscore2
              topscore4 = topscore3
              topscore1 = score
            elseif score > topscore2 then
              topscore3 = topscore2
              topscore4 = topscore3
              topscore2 = score
            elseif score > topscore3 then
              topscore4 = topscore3
              topscore3 = score
            elseif score > topscore4 then
              topscore4 = score
            end

            score = 0
            fireType = "Minigun"
            
            playerHealth = 100
            shipSpeed = 150
            damageMultiplier = 1
            level = 1
          end
        end
      end
    end


    -- PLAYER BULLETS --
    -- Update Player Bullet position for each Bullet Type
    for bEntity, bPhysical in pairs(Bullets) do
      if bPhysical.Type == "Minigun" then
        bPhysical.position.x = bPhysical.position.x + (math.cos(bPhysical.direction)* dt * bulletSpeed)
        bPhysical.position.y = bPhysical.position.y + (math.sin(bPhysical.direction)* dt * bulletSpeed)
      end

      if bPhysical.Type == "Laser" then
        bPhysical.position.x = bPhysical.position.x + (math.cos(bPhysical.direction)* dt * bulletSpeed)
        bPhysical.position.y = bPhysical.position.y + (math.sin(bPhysical.direction)* dt * bulletSpeed)
      end

      -- Check Player Bullet collision with Enemies
      for enemyEntity, enemyPhysical in pairs(Enemies) do
        distance = ((enemyPhysical.position.x - bPhysical.position.x)^2 + (enemyPhysical.position.y - bPhysical.position.y)^2)^0.5

        -- If the distance of the Player Bullet connects with the Enemy Sprite, deal damage to Enemy bases on fireType
        if distance < (enemySize[enemyPhysical.sprite]/2 + bulletSize/2) * enemyScale.x then
          if bPhysical.Type == "Minigun" then
            enemyPhysical.health = enemyPhysical.health - 3 * damageMultiplier
          elseif bPhysical.type == "Laser" then
            enemyPhysical.health = enemyPhysical.health - 7 * damageMultiplier
          else
            enemyPhysical.health = enemyPhysical.health - 15 * damageMultiplier
          end

          -- Update enemy health
          if enemyPhysical.health < 0 then
            enemyPhysical.health = 0
            killCount = killCount + 1
          end

          -- Remove bullets from screen and update enemy spawns
          table.remove(Bullets, bEntity)
          score = score + 1
          enemySpawn = enemySpawn - 0.0001
          EnemySpeed = EnemySpeed + 0.001
        end
      end

      -- Check Player Bullet collision with bosses
      for bossEntity, bossPhysical in pairs(Bosses) do
        distance = ((bossPhysical.position.x - bPhysical.position.x)^2 + (bossPhysical.position.y - bPhysical.position.y)^2)^0.5

        -- If the distance of the Player Bullet connects with the Enemy Sprite, deal damage to Enemy bases on fireType
        if distance < (bossSize[bossPhysical.sprite]/2 + bulletSize/2) * bossScale.x then
          if bPhysical.Type == "Minigun" then
            bossPhysical.health = bossPhysical.health - 3 * damageMultiplier
          elseif bPhysical.type == "Laser" then
            bossPhysical.health = bossPhysical.health - 7 * damageMultiplier
          else
            bossPhysical.health = bossPhysical.health - 15 * damageMultiplier
          end

          -- Update enemy health
          if bossPhysical.health < 0 then
            bossPhysical.health = 0
          end

          -- Remove bullets from screen and update enemy spawns
          table.remove(Bullets, bEntity)
          score = score + 1
        end
      end

      -- Check if the Player Bullets go off screen and if they do remove them from the Bullet Table
      if bPhysical.position.x < 0 or bPhysical.position.x > love.graphics.getWidth() or bPhysical.position.y < 0 or bPhysical.position.y > love.graphics.getHeight() then
        table.remove(Bullets, bEntity)
      end
    end

    -- ENEMY BULLETS -- 
    -- Update Enemy Bullet position
    for enemyBulletEntity, enemyBulletPhysical in pairs(EnemyBullets) do
      if enemyBulletPhysical.Type == "EnemyGun" then
        enemyBulletPhysical.position.x = enemyBulletPhysical.position.x + (math.cos(enemyBulletPhysical.direction) * dt * enemyBulletSpeed)
        enemyBulletPhysical.position.y = enemyBulletPhysical.position.y + (math.sin(enemyBulletPhysical.direction) * dt * enemyBulletSpeed)
      end

      -- Check Enemy Bullet collision with Player
      edistance = ((enemyBulletPhysical.position.x - Ship.position.x)^2 + (Ship.position.y - enemyBulletPhysical.position.y)^2)^0.5
      if edistance < (shipSize/2 + enemyBulletSize/2) * shipScale.x then
        if enemyBulletPhysical.Type == "EnemyGun" then
          playerHealth = playerHealth - 1
        end
        
        -- Update Player's health
        if playerHealth < 0 then
          playerHealth = 0
        end

        -- Remove Enemy Bullets from the table
        table.remove(EnemyBullets, enemyBulletEntity)
      end
      
      -- Reset game if Player dies
      if playerHealth <= 0 then
        fireRateMultiplier = 0.25
        updateFireRate()
        updateEnemyFireRate()
        Enemies = {}
        Bullets = {}
        EnemyBullets = {} 
        Items = {}
        exp = {}
        Ship.position.x = love.graphics.getWidth() / 2
        Ship.position.y = love.graphics.getHeight() / 2
        enemySpawn = initialEnemySpawn
        EnemySpeed = initialEnemySpeed

      if score > topscore then
        topscore1 = topscore
        topscore2 = topscore1
        topscore3 = topscore2
        topscore4 = topscore3
        topscore = score
      elseif score > topscore1 then
        topscore2 = topscore1
        topscore3 = topscore2
        topscore4 = topscore3
        topscore1 = score
      elseif score > topscore2 then
        topscore3 = topscore2
        topscore4 = topscore3
        topscore2 = score
      elseif score > topscore3 then
        topscore4 = topscore3
        topscore3 = score
      elseif score > topscore4 then
        topscore4 = score
      end

        score = 0
        fireType = "Minigun"
        
        level = 1
        playerHealth = 100
        shipSpeed = 150
        damageMultiplier = 1
      end

      -- Check if the Enemy Bullets go off screen and if they do remove them from the Bullet Table
      if enemyBulletPhysical.position.x < 0 or enemyBulletPhysical.position.x > love.graphics.getWidth() or enemyBulletPhysical.position.y < 0 or enemyBulletPhysical.position.y > love.graphics.getHeight() then
        table.remove(EnemyBullets, enemyBulletEntity)
      end

    end

    -- BOSS BULLETS -- 
    -- Update Enemy Bullet position
    for bossBulletEntity, bossBulletPhysical in pairs(BossBullets) do
      if bossBulletPhysical.Type == "BossGun" then
        bossBulletPhysical.position.x = bossBulletPhysical.position.x + (math.cos(bossBulletPhysical.direction) * dt * bossBulletSpeed)
        bossBulletPhysical.position.y = bossBulletPhysical.position.y + (math.sin(bossBulletPhysical.direction) * dt * bossBulletSpeed)
      end

      -- Check Enemy Bullet collision with Player
      bdistance = ((bossBulletPhysical.position.x - Ship.position.x)^2 + (Ship.position.y - bossBulletPhysical.position.y)^2)^0.5
      if bdistance < (shipSize/2 + bossBulletSize/2) * shipScale.x then
        if bossBulletPhysical.Type == "BossGun" then
          playerHealth = playerHealth - 2
        end
        
        -- Update Player's health
        if playerHealth < 0 then
          playerHealth = 0
        end

        -- Remove Enemy Bullets from the table
        table.remove(BossBullets, bossBulletEntity)
      end
      
      -- Reset game if Player dies
      if playerHealth <= 0 then
        fireRateMultiplier = 0.25
        updateFireRate()
        updateEnemyFireRate()
        Enemies = {}
        Bullets = {}
        EnemyBullets = {} 
        Items = {}
        exp = {}
        Ship.position.x = love.graphics.getWidth() / 2
        Ship.position.y = love.graphics.getHeight() / 2
        enemySpawn = initialEnemySpawn
        EnemySpeed = initialEnemySpeed

      if score > topscore then
        topscore1 = topscore
        topscore2 = topscore1
        topscore3 = topscore2
        topscore4 = topscore3
        topscore = score
      elseif score > topscore1 then
        topscore2 = topscore1
        topscore3 = topscore2
        topscore4 = topscore3
        topscore1 = score
      elseif score > topscore2 then
        topscore3 = topscore2
        topscore4 = topscore3
        topscore2 = score
      elseif score > topscore3 then
        topscore4 = topscore3
        topscore3 = score
      elseif score > topscore4 then
        topscore4 = score
      end

        score = 0
        fireType = "Minigun"
        
        level = 1
        playerHealth = 100
        shipSpeed = 150
        damageMultiplier = 1
      end

      -- Check if the Boss Bullets go off screen and if they do remove them from the Bullet Table
      if bossBulletPhysical.position.x < 0 or bossBulletPhysical.position.x > love.graphics.getWidth() or bossBulletPhysical.position.y < 0 or bossBulletPhysical.position.y > love.graphics.getHeight() then
        table.remove(BossBullets, bossBulletEntity)
      end
    end


    -- ITEMS -- 
    -- Check for Player collision with Items and update properly
    for itemEntity, itemPhysical in pairs(Items) do
      distance = ((itemPhysical.x - Ship.position.x)^2 + (itemPhysical.y - Ship.position.y)^2)^0.5

      if distance < (shipSize / 2 + bulletSize / 2) * enemyScale.x then
        if itemPhysical.type == "Health" then
          playerHealth = playerHealth + round((100 - playerHealth) / 2)
        elseif itemPhysical.type == "Speed" then
          shipSpeed = shipSpeed + 2 * (150 / shipSpeed)
        elseif itemPhysical.type == "Damage" then
          damageMultiplier = damageMultiplier + (1 / damageMultiplier) * (1 / damageMultiplier)

        -- Update Player's fireRate and 
        else
          fireRateMultiplier = fireRateMultiplier + 0.25
          updateFireRate()
        end
        -- Remove items from game once they are "picked up"
        table.remove(Items, itemEntity)
      end
    end

    
    -- LEVELS --
    -- Create a system to update Levels, each proceeding level becomes more difficult but player gets a small buff after each level is beaten --
    -- Basically the same as when the Player dies but tweaked to not completely reset game --

    -- Level 2
    if score == 75 then

      fireRateMultiplier = fireRateMultiplier + 0.075
      updateFireRate()
      updateEnemyFireRate()
      Enemies = {}
      Bullets = {}
      EnemyBullets = {} 
      --Items = {}
      exp = {}
      Ship.position.x = love.graphics.getWidth() / 2
      Ship.position.y = love.graphics.getHeight() / 2
      enemySpawn = initialEnemySpawn - 0.15
      EnemySpeed = initialEnemySpeed + 10

      if score > topscore then
        topscore1 = topscore
        topscore2 = topscore1
        topscore3 = topscore2
        topscore4 = topscore3
        topscore = score
      elseif score > topscore1 then
        topscore2 = topscore1
        topscore3 = topscore2
        topscore4 = topscore3
        topscore1 = score
      elseif score > topscore2 then
        topscore3 = topscore2
        topscore4 = topscore3
        topscore2 = score
      elseif score > topscore3 then
        topscore4 = topscore3
        topscore3 = score
      elseif score > topscore4 then
        topscore4 = score
      end

      score = 76
      fireType = "Minigun"
      
      playerHealth = 100
      shipSpeed = 200
      damageMultiplier = damageMultiplier + 0.25

      level = level + 1
    end

    -- Level 3
    if score == 200 then
      fireRateMultiplier = fireRateMultiplier + 0.075
      updateFireRate()
      updateEnemyFireRate()
      Enemies = {}
      Bullets = {}
      EnemyBullets = {} 
     --Items = {}
      exp = {}
      Ship.position.x = love.graphics.getWidth() / 2
      Ship.position.y = love.graphics.getHeight() / 2
      enemySpawn = initialEnemySpawn - 0.25
      EnemySpeed = initialEnemySpeed + 15

      if score > topscore then
        topscore1 = topscore
        topscore2 = topscore1
        topscore3 = topscore2
        topscore4 = topscore3
        topscore = score
      elseif score > topscore1 then
        topscore2 = topscore1
        topscore3 = topscore2
        topscore4 = topscore3
        topscore1 = score
      elseif score > topscore2 then
        topscore3 = topscore2
        topscore4 = topscore3
        topscore2 = score
      elseif score > topscore3 then
        topscore4 = topscore3
        topscore3 = score
      elseif score > topscore4 then
        topscore4 = score
      end

      score = 201
      fireType = "Minigun"
      
      playerHealth = 100
      shipSpeed = 225
      damageMultiplier = damageMultiplier + 0.25

      level = level + 1
    end

    -- Level 4
    if score == 500 then
      fireRateMultiplier = fireRateMultiplier + 0.075
      updateFireRate()
      updateEnemyFireRate()
      Enemies = {}
      Bullets = {}
      EnemyBullets = {} 
     --Items = {}
      exp = {}
      Ship.position.x = love.graphics.getWidth() / 2
      Ship.position.y = love.graphics.getHeight() / 2
      enemySpawn = initialEnemySpawn - 0.30
      EnemySpeed = initialEnemySpeed + 20

      if score > topscore then
        topscore1 = topscore
        topscore2 = topscore1
        topscore3 = topscore2
        topscore4 = topscore3
        topscore = score
      elseif score > topscore1 then
        topscore2 = topscore1
        topscore3 = topscore2
        topscore4 = topscore3
        topscore1 = score
      elseif score > topscore2 then
        topscore3 = topscore2
        topscore4 = topscore3
        topscore2 = score
      elseif score > topscore3 then
        topscore4 = topscore3
        topscore3 = score
      elseif score > topscore4 then
        topscore4 = score
      end

      score = 501
      fireType = "Minigun"
      
      playerHealth = 100
      shipSpeed = 225
      damageMultiplier = damageMultiplier + 0.25

      level = level + 1
    end
    

    -- Boss
    if score == 750 then
      fireRateMultiplier = fireRateMultiplier + 0.075
      updateFireRate()
      updateEnemyFireRate()
      updateBossFireRate()
      Enemies = {}
      Bullets = {}
      Bosses = {}
      EnemyBullets = {} 
      --Items = {}
      exp = {}
      Ship.position.x = love.graphics.getWidth() / 2
      Ship.position.y = love.graphics.getHeight() / 2
      enemySpawn = 0
      EnemySpeed = 0
      initialEnemySpawn = 0
      initialEnemySpeed = 0
      bossSpawn = 1
      bossSpeed = initialBossSpeed


      if score > topscore then
        topscore1 = topscore
        topscore2 = topscore1
        topscore3 = topscore2
        topscore4 = topscore3
        topscore = score
      elseif score > topscore1 then
        topscore2 = topscore1
        topscore3 = topscore2
        topscore4 = topscore3
        topscore1 = score
      elseif score > topscore2 then
        topscore3 = topscore2
        topscore4 = topscore3
        topscore2 = score
      elseif score > topscore3 then
        topscore4 = topscore3
        topscore3 = score
      elseif score > topscore4 then
        topscore4 = score
      end

      score = 751
      fireType = "Minigun"
      
      playerHealth = 100
      shipSpeed = 225
      damageMultiplier = damageMultiplier + 0.25

      level = level + 1
      
    end


    -- Collision check variables
    closest = {
      distance = 1000,
      x=0,
      y=0
    }


    -- ENEMY SPAWNS --
    -- Create Enemy Spawns based on sprite type
    if enemyTimer > enemySpawn then

      enemyTimer = 0
      spriteSelector = 1

      local baseMultiplier = 100

      local progress = math.log(score);

      if math.random(1,4) == 1 and score > 36 then
        spriteSelector = 2
      end

      if math.random(1,9) == 1 and score > 76 then
        spriteSelector = 3
      end

      if math.random(1,9) == 1 and score > 76 then
        spriteSelector = 9
      end

      if math.random(1,16) == 1 and score > 125 then
        spriteSelector = 4
      end

      if math.random(1,16) == 1 and score > 125 then
        spriteSelector = 10
      end

      if math.random(1,25) == 1 and score > 251 then
        spriteSelector = 5
      end

      if math.random(1,25) == 1 and score > 251 then
        spriteSelector = 11
      end

      if math.random(1,36) == 1 and score > 325 then
        spriteSelector = 6
      end

      if math.random(1,36) == 1 and score > 325 then
        spriteSelector = 12
      end

      if math.random(1,49) == 1 and score > 400 then
        spriteSelector = 7
      end

      if math.random(1,49) == 1 and score > 400 then
        spriteSelector = 13
      end

      if math.random(1,64) == 1 and score > 501 then
        spriteSelector = 8
      end

      if math.random(1,64) == 1 and score > 501 then
        spriteSelector = 14
      end
    
      if spriteSelector > 14 then
        spriteSelector = 15
      end

      if spriteSelector < 1 then
        spriteSelector = 1
      end

      -- Create Structure to hold variables for Enemies
      local Enemy = {
        position = {x = math.random(0,1)*(love.graphics.getWidth()+300)-100, y = math.random(0,(love.graphics.getHeight()+300))-100},
        direction = 0,
        sprite = spriteSelector,
        health = spriteSelector^2.5 * 10,
        maxhealth = spriteSelector^2.5 * 10,
        Type = enemyFireType
      }
      -- Insert Enemies into their Table
      table.insert(Enemies,Enemy)

    end

    if score > 750 then
      -- BOSS SPAWNS --
      -- Create Enemy Spawns based on sprite type
      if bossTimer > bossSpawn then

        bossTimer = 0
        bossSelector = 1

        local baseMultiplier = 100

        local progress = math.log(score);

        
        -- Create Structure to hold variables for Bosses
        local Boss = {
          position = {x = love.graphics.getWidth() / 2, y = -50},
          direction = 0,
          sprite = bossSelector,
          health = 1000,
          maxhealth = 1000,
          Type = bossFireType
        }
        -- Insert Bosses into their Table
        table.insert(Bosses, Boss)
      end
    end

  end
end


--[[ Draw all objects to the screen ]]--
-- Bullets will be drawn before Player Ship and Enemies so Bullets spawn under the image 
function love.draw()

  -- If the Game is Paused, display the exit text
  if pauseScreen then
    love.graphics.draw(background, 0, 0, 0, 3, 3)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Game Paused. Tap to Continue', love.graphics.getWidth()/2-75, love.graphics.getHeight()/2, 0, 3, 3)
    love.graphics.circle("fill", 55, 75, 30)

  -- If the Game is in the load menu, display the menu text
  elseif loadScreen then
    love.graphics.draw(background, 0, 0, 0, 3, 3)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('Welcome to C H A O S C H A S E', love.graphics.getWidth()/2-200, 50, 0, 4, 4)
    love.graphics.print('H I S C O R E', love.graphics.getWidth()/2-100, love.graphics.getHeight()/2-300, 0, 3, 3)
    love.graphics.print('P L A Y', love.graphics.getWidth()/2-80, love.graphics.getHeight()/2 - 100, 0, 3, 3)

  -- If the Game is in the score menu, display the high scores (we can make these more uniform with values later)
  elseif scoreScreen then
    love.graphics.draw(background, 0, 0, 0, 3, 3)
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print('H   I   S   C   O   R   E   S', 750, 400, 0, 2.75, 2.75)
    love.graphics.print('1st   ' .. topscore .. '   ', 750, 475, 0, 2.75, 2.75)
    love.graphics.print('2nd   ' .. topscore1 .. '   ', 750, 550, 0, 2.75, 2.75)
    love.graphics.print('3rd   ' .. topscore2 .. '   ', 750, 625, 0, 2.75, 2.75)
    love.graphics.print('4th   ' .. topscore3 .. '   ', 750, 700, 0, 2.75, 2.75)
    love.graphics.print('5th   ' .. topscore4 .. '   ', 750, 775, 0, 2.75, 2.75)
    love.graphics.print('Press h to return', 900, 950, 0, 3, 3)

  -- Run the objects to be drawn --
  else
    if level == 1 then
      love.graphics.draw(background, 0, 0, 0, 3, 3)
    end
    if level == 2 then
      love.graphics.draw(bglvl2, 0, 0, 0, 3, 3)
    end
    if level == 3 then
      love.graphics.draw(bglvl3, 0, 0, 0, 3, 3)
    end
    if level == 4 then
      love.graphics.draw(bglvl4, 0, 0, 0, 3, 3)
    end
    if level == 5 or score > 750 then
      love.graphics.draw(bglvl5, 0, 0, 0, 3, 3)
    end


    love.graphics.circle("fill", love.graphics.getWidth() - 55, love.graphics.getHeight() - 75, 45)
    love.graphics.circle("fill", love.graphics.getWidth() - 150, love.graphics.getHeight() - 75, 45)
    love.graphics.circle("fill", love.graphics.getWidth() - 55, 75, 40)
    love.graphics.circle("fill", 55, 75, 40)

    love.graphics.draw(minigunImage1, love.graphics.getWidth() - 70, love.graphics.getHeight() - 78, 0, 1.75, 1.75)
    love.graphics.draw(laserImage, love.graphics.getWidth() - 165, love.graphics.getHeight() - 78, 0, 1.5, 1.5)

    love.graphics.draw(pauseImage, love.graphics.getWidth() - 55, 75)

    -- Draw explosions
    for i,v in pairs(exp) do
      current = round ((socket.gettime() - v.time) * 10 )
      if current > 15 then
        current = 15
        table.remove(exp, i)
      end
      love.graphics.draw(explosion, quad[current], v.x, v.y, 0, v.sprite*1, v.sprite*1, 32, 32)
    end

        -- Draw explosions
    for i,v in pairs(bsexp) do
      current = round ((socket.gettime() - v.time) * 10 )
      if current > 15 then
        current = 15
        table.remove(bsexp, i)
      end
      love.graphics.draw(explosion, quad[current], v.x, v.y, 0, v.sprite*5, v.sprite*5, 32, 32)
    end


    -- Draw Player Bullets
    for i,v in pairs(Bullets) do
      current = (round(socket.gettime() * 10) + i) % 5 
      if v.Type == "Minigun" then
        currentimage = minigunImage1
      elseif v.Type == "Laser" then
        currentimage = laserImage
      end
      love.graphics.draw(currentimage, bulletquad[current], v.position .x, v.position.y, v.direction, bulletScale, bulletScale, bulletOffset, bulletOffset)
    end


    -- Draw Player
    love.graphics.draw(ShipImage1, Ship.position.x, Ship.position.y, Ship.direction, shipScale.x, shipScale.y, shipOffset.x, shipOffset.y)


    -- Draw Enemy Bullets
    for ie,ve in pairs(EnemyBullets) do
      currentBullet = (round(socket.gettime() * 10) + ie) % 5 
      if ve.Type == "EnemyGun" then
        enemyCurrentBullet = enemyBulletImage
      end
      love.graphics.draw(enemyCurrentBullet, enemybulletquad[currentBullet], ve.position.x, ve.position.y, ve.direction, enemyBulletScale, enemyBulletScale, enemyBulletOffset, enemyBulletOffset)
    end

    -- Draw Boss Bullets
    for ie,ve in pairs(BossBullets) do
      currentBullet = (round(socket.gettime() * 10) + ie) % 5 
      if ve.Type == "BossGun" then
        bossCurrentBullet = bossBulletImage
      end
      love.graphics.draw(bossCurrentBullet, bossbulletquad[currentBullet], ve.position.x, ve.position.y, ve.direction, bossBulletScale, bossBulletScale, bossBulletOffset, bossBulletOffset)
    end


    -- Draw Enemies
    for i,v in pairs(Enemies) do
      local currenthealth = round(v.health / v.maxhealth * 16,0)
      --enemyOffset[v.sprite].x
      love.graphics.draw(EnemyImage[v.sprite], v.position.x, v.position.y, v.direction, enemyScale.x, enemyScale.y, enemyOffset[v.sprite].x, enemyOffset[v.sprite].y)
    end

    -- Draw Bosses
    for ib,vb in pairs(Bosses) do
      local currenthealth = round(vb.health / vb.maxhealth * 16,0)
      love.graphics.draw(BossImage[vb.sprite], vb.position.x, vb.position.y, vb.direction, bossScale.x, bossScale.y, bossOffset[vb.sprite].x, bossOffset[vb.sprite].y)

      if vb.health < 0 then
        love.graphics.print('Contragulations, you beat the game!', love.graphics.getWidth()/2, love.graphics.getHeight()/2)
      end
    end


    -- Draw Items
    for itemEntity, itemPhysical in pairs(Items) do
      if itemPhysical.type == "Health" then
        love.graphics.draw(healthItemImage, itemPhysical.x, itemPhysical.y, itemPhysical.d, 2, 2, 24, 24)
      elseif itemPhysical.type == "Speed" then
        love.graphics.draw(speedItemImage, itemPhysical.x, itemPhysical.y, itemPhysical.d, 2, 2, 24, 24)
      elseif itemPhysical.type == "Damage" then
        love.graphics.draw(damageItemImage, itemPhysical.x, itemPhysical.y,  itemPhysical.d, 2, 2, 24, 24)
      end
    end

    
    -- Draw Overlay
    local currenthealth = round(playerHealth / 100 * 16, 0)
    --love.graphics.print('Health:'..playerHealth.."/100", 20, 860)
    love.graphics.print('Score: '..score, love.graphics.getWidth()/2-75, 20, 0, 2, 2)
    love.graphics.draw(hb[currenthealth], 10, love.graphics.getHeight() - 75)

    love.graphics.print('Level:'..level, love.graphics.getWidth()/2+60, 20, 0, 2, 2)
    --love.graphics.print('Damage:'..damageMultiplier, 175, 20)

    -- Draw Trophies
    if killCount == 5 then
      love.graphics.draw(TrophyImage, love.graphics.getWidth()/2, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
      love.graphics.print('Trophy:'..killCount, love.graphics.getWidth()/2 + 68, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
    end

    if killCount == 15 then
      love.graphics.draw(TrophyImage, love.graphics.getWidth()/2, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
      love.graphics.print('Trophy:'..killCount, love.graphics.getWidth()/2 + 68, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
    end

    if killCount == 30 then
      love.graphics.draw(TrophyImage, love.graphics.getWidth()/2, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
      love.graphics.print('Trophy:'..killCount, love.graphics.getWidth()/2 + 68, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
    end

    if killCount == 50 then
      love.graphics.draw(TrophyImage, love.graphics.getWidth()/2, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
      love.graphics.print('Trophy:'..killCount, love.graphics.getWidth()/2 + 68, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
    end

    if killCount == 75 then
      love.graphics.draw(TrophyImage, love.graphics.getWidth()/2, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
      love.graphics.print('Trophy:'..killCount, love.graphics.getWidth()/2 + 68, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
    end

    if killCount == 100 then
      love.graphics.draw(TrophyImage, love.graphics.getWidth()/2, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
      love.graphics.print('Trophy:'..killCount, love.graphics.getWidth()/2 + 68, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
    end

    if killCount == 200 then
      love.graphics.draw(TrophyImage, love.graphics.getWidth()/2, love.graphics.getHeight() - 50, 0 , 1.5, 1.5)
      love.graphics.print('Trophy:'..killCount, love.graphics.getWidth()/2 + 68, love.graphics.getHeight() - 50, 0, 1.5, 1.5)
    end


    local t = love.touch.getTouches()
    local x, y = -1000, -1000
    for i, v in ipairs(t) do
       x, y = love.touch.getPosition(v)
       love.graphics.circle("fill", x, y, i*25)
    end

  end
end


--[[ Check Key Presses ]]--
function love.keypressed(key)
  if key == "escape" then
    pauseScreen = not pauseScreen
  
  elseif key == "g" then
  loadScreen = false
  
  elseif key == "n" then
    pauseScreen = false

  elseif key == "w" then
    Ship.position.y = Ship.position.y - 50

  elseif key == "s" then
    Ship.position.y = Ship.position.y + 50

  elseif key == "d" then
    Ship.position.x = Ship.position.x + 50

  elseif key == "a" then
    Ship.position.x = Ship.position.x - 50

  elseif key == "1" then
    fireType = "Minigun"
    updateFireRate()

  elseif key == "2" then
    fireType = "Laser"
    updateFireRate()

  elseif key == "f11" then
    love.window.setFullscreen(not love.window.getFullscreen(),"exclusive")

  elseif key == "y" then

    if pauseScreen then
      love.event.quit()
    end

  elseif key == "h" then
  
    if loadScreen then
      loadScreen = false
      scoreScreen = true

    elseif scoreScreen then
      scoreScreen = false
      loadScreen = true
    end
  end

end


--[[ Fucntion to round numbers ]]--
function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

--[[ Function to run explosions based on Enemy Size and spawn Items ]]--
function explosionAnimation(enemyEntity, enemyPhysical)

  -- Structure for explosions
  local explode = {
    x = enemyPhysical.position.x,
    y = enemyPhysical.position.y,
    sprite = enemyPhysical.sprite,
    time = socket.gettime()
  }
  table.insert(exp, explode)

  if enemyPhysical.position.x < 12 then
    enemyPhysical.position.x = 12
  end

  if enemyPhysical.position.x > love.graphics.getWidth() - 12 then
    enemyPhysical.position.x = love.graphics.getWidth() - 12
  end

  if enemyPhysical.position.y < 12 then
    enemyPhysical.position.y = 12
  end

  if enemyPhysical.position.y > love.graphics.getHeight() - 12 then
    enemyPhysical.position.y = love.graphics.getHeight() - 12
  end

  -- Start Spawning Items randomly after Explosions
  if math.random(1,10) == 1 then
    local Item = {
      type = "Rate",
      x = enemyPhysical.position.x,
      y = enemyPhysical.position.y,
      d = enemyPhysical.direction
    }

    table.insert(Items,Item)

  elseif math.random(1,10) == 1 then
    local Item = {
      type = "Damage",
      x = enemyPhysical.position.x,
      y = enemyPhysical.position.y,
      d = enemyPhysical.direction
    }

    table.insert(Items,Item)

  elseif math.random(1,10) == 1 then
    local Item = {
      type = "Speed",
      x = enemyPhysical.position.x,
      y = enemyPhysical.position.y,
      d = enemyPhysical.direction
    }

    table.insert(Items,Item)

  elseif math.random(1,10) == 1 then
    local Item = {
      type = "Health",
      x = enemyPhysical.position.x,
      y = enemyPhysical.position.y,
      d = enemyPhysical.direction
    }

    table.insert(Items,Item)

  elseif math.random(1,10) == 1 then
    local Item = {
      type = "Rocket",
      x = enemyPhysical.position.x,
      y = enemyPhysical.position.y,
      d = enemyPhysical.direction
    }

    table.insert(Items,Item)
  end
  
  table.remove(Enemies,enemyEntity)
end


--[[ Function to run explosions based on Enemy Size and spawn Items ]]--
function bossExplosionAnimation(bossEntity, bossPhysical)

  -- Structure for explosions
  local explode = {
    x = bossPhysical.position.x,
    y = bossPhysical.position.y,
    sprite = bossPhysical.sprite,
    time = socket.gettime()
  }
  table.insert(bsexp, explode)

  if bossPhysical.position.x < 12 then
    bossPhysical.position.x = 12
  end

  if bossPhysical.position.x > love.graphics.getWidth() - 12 then
    bossPhysical.position.x = love.graphics.getWidth() - 12
  end

  if bossPhysical.position.y < 12 then
    bossPhysical.position.y = 12
  end

  if bossPhysical.position.y > love.graphics.getHeight() - 12 then
    bossPhysical.position.y = love.graphics.getHeight() - 12
  end
  
  table.remove(Bosses, bossEntity)
end