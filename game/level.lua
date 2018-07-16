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
  map = { }
}
local objects = require("game/objects")
level.load = function(self, path, game)
  local image = love.image.newImageData(path)
  self.map = { }
  for x = 1, image:getWidth() do
    self.map[x] = { }
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
  game:spawn(a)
  if not (k == "player") then
    game.grid:add_tile(x / game.grid.tile_scale, y / game.grid.tile_scale, k, a)
  end
  game.world:add(a, a.x, a.y, a.w, a.h)
  return a
end
return level
