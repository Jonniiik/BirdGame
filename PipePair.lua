PipePair = Class{}
--расстояние между труб
local GAP_HEIGHT = 90
--VIRTUAL_WEIDH
function PipePair:init(y)
  self.x = VIRTUAL_WIDTH + 32
  self.y = y

  --инициализация двух труб которые находятся в паре
  self.pipes = {
    ['upper'] = Pipe('top', self.y),--верхняя труба
    ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT) --нижняя труба
  }

  --пара не готова к удалению с экрана
  self.remove = false

  --Считать или нет
  self.scored = false
end

function PipePair:update(dt)
  if self.x > -PIPE_WIDTH then
    self.x = self.x - PIPE_SPEED * dt
    self.pipes['lower'].x = self.x
    self.pipes['upper'].x = self.x
  else
    self.remove = true
  end
end

function PipePair:render()
  for k, pipe in pairs(self.pipes) do
    pipe:render()
  end
end
