local make
make = function()
  local level = {
    size = 20,
    registry = {
      ["block"] = {
        0,
        0,
        0
      },
      ["player"] = {
        1,
        1,
        0
      }
    },
    map = { },
    min_x = nil,
    max_x = nil,
    min_y = nil,
    max_y = nil
  }
  local objects = require("game/objects")
  level.load = function(self, path, game)
    local image = love.image.newImageData(path)
    local map = { }
    for x = 1, image:getWidth() do
      map[x] = { }
      for y = 1, image:getHeight() do
        local rx, ry = x - 1, y - 1
        local r, g, b = image:getPixel(rx, ry)
        for k, v in pairs(level.registry) do
          if r == v[1] and g == v[2] and b == v[3] then
            level.spawn(k, level.size * rx, level.size * ry, game)
          end
        end
      end
    end
  end
  level.spawn = function(k, x, y, game)
    local a = objects[k].make(x, y)
    if k == "player" then
      game:spawn({
        draw = function(self)
          do
            local _with_0 = love.graphics
            _with_0.setColor(1, 1, 1, .5)
            _with_0.draw(game.sprites.player, x, y)
            return _with_0
          end
        end
      })
    end
    game:spawn(a)
    level:add_tile(x / game.grid.tile_scale, y / game.grid.tile_scale, k, a)
    game.world:add(a, a.x, a.y, a.w, a.h)
    return a
  end
  level.add_tile = function(self, x, y, id, ref)
    if self.min_x == nil or x < self.min_x then
      self.min_x = x
    end
    if self.max_x == nil or x > self.max_x then
      self.max_x = x
    end
    if self.min_y == nil or y < self.min_y then
      self.min_y = y
    end
    if self.max_y == nil or y > self.max_y then
      self.max_y = y
    end
    if not (self.map[x]) then
      self.map[x] = { }
    elseif self.map[x][y] then
      if id == self.map[x][y].id then
        return false
      else
        if self.map[x][y].id == "player" then
          return false
        end
        self:remove_tile(ref)
      end
    end
    self.map[x][y] = {
      id = id,
      ref = ref
    }
    return true
  end
  level.remove_tile = function(self, x, y)
    local ref = self.map[x][y].ref
    if self.map[x][y].id == "player" then
      return 
    end
    ref:remove()
    for i, v in ipairs(game.objects) do
      if v == ref then
        table.remove(game.objects, i)
        break
      end
    end
    self.map[x][y] = nil
  end
  level.export_map = function(self, path)
    local width = self.max_x - self.min_x + 1
    local height = self.max_y - self.min_y + 1
    local level_img = love.image.newImageData(width, height)
    for x = 0, self.max_x do
      local _continue_0 = false
      repeat
        if not (self.map[x]) then
          _continue_0 = true
          break
        end
        for y = 0, self.max_y do
          local _continue_1 = false
          repeat
            if not (self.map[x][y]) then
              _continue_1 = true
              break
            end
            local color = game.level.registry[self.map[x][y].id]
            local new_x = x - self.min_x
            local new_y = y - self.min_y
            level_img:setPixel(new_x, new_y, color[1], color[2], color[3])
            _continue_1 = true
          until true
          if not _continue_1 then
            break
          end
        end
        _continue_0 = true
      until true
      if not _continue_0 then
        break
      end
    end
    if not (love.filesystem.getInfo("maps")) then
      love.filesystem.createDirectory("maps")
    end
    return level_img:encode("png", "maps/" .. tostring(path) .. ".png")
  end
  return level
end
return {
  make = make
}
