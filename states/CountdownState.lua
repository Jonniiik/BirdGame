CountdownState = Class{__includes = BaseState} --включает в себя все из BaseState(Осторожнее нижнее подчеркивание должно быть двойным __)

COUNTDOWN_TIME = 0.75

function CountdownState:init()
  self.count = 3 -- максимальное число таймера 3..2..1..0
  self.timer = 0 -- таймер
end

function CountdownState:update(dt)
  self.timer = self.timer + dt

  if self.timer > COUNTDOWN_TIME then
    self.timer = self.timer % COUNTDOWN_TIME
    self.count = self.count - 1

    if self.count == 0 then
      gStateMachine:change('play')
    end
  end
end

function CountdownState:render()
  love.graphics.setFont(hugeFont)
  love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end
