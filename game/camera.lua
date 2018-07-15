local make
make = function(x, y, sx, sy, r)
  local cam = {
    x = x,
    y = y,
    sx = sx,
    sy = sy,
    r = r
  }
  cam.move = function(self, dx, dy)
    self.x = self.x + dx
    self.y = self.y + dy
    return cam
  end
  cam.set = function(self)
    do
      local _with_0 = love.graphics
      _with_0.push()
      _with_0.translate(_with_0.getWidth() / 2 - self.x, _with_0.getHeight() / 2 - self.y)
      _with_0.scale(self.sx, self.sy)
      _with_0.rotate(self.r)
    end
    return cam
  end
  cam.unset = function(self)
    love.graphics.pop()
    return cam
  end
  cam.width = function(self)
    return love.graphics.getWidth() / self.sx
  end
  cam.height = function(self)
    return love.graphics.getHeight() / self.sy
  end
  return cam
end
return {
  make = make
}
