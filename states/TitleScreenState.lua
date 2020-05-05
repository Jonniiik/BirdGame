TitleScreenState = Class{__includes = BaseState} --Включает в себя все что есть в BaseState(Осторожнее нижнее подчеркивание должно быть двойным __)

function TitleScreenState:update(dt)
  --если нажато на Enter или статус return статус у игры "play"
  if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
      gStateMachine:change('countdown')
  end
end

function TitleScreenState:render()
    --Выводим Название игры
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Bird', 0, 64, VIRTUAL_WIDTH, 'center')
    --Просим игрока нажать на Enter
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end
