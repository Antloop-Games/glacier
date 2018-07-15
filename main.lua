lib = require("lib")
love.graphics.setDefaultFilter("nearest", "nearest")
love.graphics.setBackgroundColor(1, 1, 1)
lib.gamestate:set("game")
math.lerp = function(a, b, t)
  return a + (b - a) * t
end
math.sign = function(a)
  if a < 0 then
    return -1
  elseif a > 1 then
    return 1
  else
    return 0
  end
end
do
  local _with_0 = love
  _with_0.load = function()
    return lib.gamestate:load()
  end
  _with_0.update = function(dt)
    return lib.gamestate:update(dt)
  end
  _with_0.draw = function()
    return lib.gamestate:draw()
  end
  _with_0.keypressed = function(key)
    return lib.gamestate:press(key)
  end
  _with_0.keyreleased = function(key)
    return lib.gamestate:release(key)
  end
  return _with_0
end
