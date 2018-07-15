local make
make = function(x, y)
  local block = {
    x = x,
    y = y,
    w = 20,
    h = 20
  }
  block.draw = function(self)
    do
      local _with_0 = love.graphics
      _with_0.setColor(0, 0, 0)
      _with_0.rectangle("fill", self.x, self.y, self.w, self.h)
      return _with_0
    end
  end
  game.world:add(block, block.x, block.y, block.w, block.h)
  return block
end
return {
  make = make
}
