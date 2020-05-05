PlayState = Class{__includes = BaseState} --включает в себя все из BaseState(Осторожнее нижнее подчеркивание должно быть двойным __)

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.score = 0

    self.lastY = - PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
    --Изначально spawnTimer = 0, в данном случае мы прибовляем значение dt
    self.timer = self.timer + dt

    if self.timer > 2 then
      --Модифицируем lastY
      local y = math.max(-PIPE_HEIGHT + 10, -- расстояние до первой трубы
      math.min(self.lastY + math.random(-20, 20),-- расстояние между труб примерно в середине, если мы начнем увеличивать расстояние, то трубы начнут двигаться низу
      VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))-- расстояние между труб примерно в середине, если мы начнем увеличивать расстояние, то трубы начнут двигаться вверх
      self.lastY = y
      --В данном случае мы добавляем пару труб через insert(когда мы создаем инсерт мы кладем Y в PipePair)
      table.insert(self.pipePairs, PipePair(y))
      --Обнуляем timer
      self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do
        --расчет счета
        if not pair.scored then
           if pair.x + PIPE_WIDTH < self.bird.x then
               self.score = self.score + 1
               pair.scored = true
               sounds['score']:play()
           end
       end
        -- Обновляем позицию трубы
        pair:update(dt)
    end
        --удаляем не нужные трубы
    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end
    --Правила движения Птицы, делаем гравитацию которая опускает Птицу вниз, и прыжак который поднимает Птицу
    self.bird:update(dt)
    --Проверка на столкновение птицы и труб
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()
                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end
    --Проверка на косание земли. Если птичка коснется земли игра остановится
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
      sounds['explosion']:play()
      sounds['hurt']:play()
        gStateMachine:change('score', {
            score = self.score
        })
    end
end

function PlayState:render()
  --Отрисовываем всех двойных труб
  for k, pair in pairs(self.pipePairs) do
      pair:render()
  end
  --выводим счет на экран
  love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

  self.bird:render()
end
