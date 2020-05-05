push = require 'push'

Class = require 'class'
--Класс Птица
require 'Bird'
--Класс Труба
require 'Pipe'
--Класс Пара Труб(Две трубы сверху и снизу вместе)
require 'PipePair'
--Разделяем состояние игры на разные классы
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountdownState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 514

-- Флаг во время которого у нас происходит движение
local scrolling = true



function love.load()
  love.graphics.setDefaultFilter('nearest','nearest')

  love.window.setTitle('Bird')

  --Инициализируем шрифты
  smallFont = love.graphics.newFont('font.ttf', 8)
  mediumFont = love.graphics.newFont('flappy.ttf', 14)
  flappyFont = love.graphics.newFont('flappy.ttf', 28)
  hugeFont = love.graphics.newFont('flappy.ttf', 56)
  love.graphics.setFont(flappyFont)

  --инициализация музыки
  sounds = {
      ['jump'] = love.audio.newSource('sounds/jump.wav', 'static'),
      ['explosion'] = love.audio.newSource('sounds/explosion.wav', 'static'),
      ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
      ['score'] = love.audio.newSource('sounds/score.wav', 'static'),

      -- https://freesound.org/people/xsgianni/sounds/388079/
      ['music'] = love.audio.newSource('sounds/marios_way.mp3', 'static')
  }

  -- выключение музыки
    sounds['music']:setLooping(true)
    sounds['music']:play()

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })
--инициализируем состояния приложения
gStateMachine = StateMachine {
    ['title'] = function() return TitleScreenState() end,
    ['countdown'] = function() return CountdownState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end
}
gStateMachine:change('title')
--Создаем пустую таблицу значений нажатых клавишь
love.keyboard.keysPressed = {}

end


function love.resize(w, h)
  push:resize(w,h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end
--Функция которая говорит, была нажата клавиша или нет
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    --Движение заднего плана
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    --Движение Земли
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    --Обновляем Статус
    gStateMachine:update(dt)

    --обнуляем таблицу значений нажатых клавишь
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(background, -backgroundScroll, 0)
    gStateMachine:render()
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end
