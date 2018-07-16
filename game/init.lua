game = {
  objects = { },
  camera = nil,
  level = nil,
  world = nil,
  grid = nil,
  bar = nil,
  sprites = nil
}
local camera = require("game/camera")
local bar = require("game/sexybar")
local level = require("game/level")
local grid = require("game/grid")
local sprites = {
  player = love.graphics.newImage("res/ninja.png")
}
game.spawn = function(self, object)
  self.objects[#self.objects + 1] = object
end
game.load = function(self)
  self.objects = { }
  self.camera = camera.make(0, 0, 3, 3, 0)
  self.level = level.make()
  self.world = lib.bump.newWorld()
  self.grid = grid.make()
  self.sprites = sprites
  self.bar = bar.make()
  self.bar:add({
    sprite = sprites.player,
    make = (require("game/objects"))["block"].make,
    name = "block"
  })
  self.bar:add({
    sprite = sprites.player,
    make = (require("game/objects"))["block"].make,
    name = "block"
  })
  self.bar:add({
    sprite = sprites.player,
    make = (require("game/objects"))["block"].make,
    name = "block"
  })
  self.bar:add({
    sprite = sprites.player,
    make = (require("game/objects"))["block"].make,
    name = "block"
  })
  self.bar:add({
    sprite = sprites.player,
    make = (require("game/objects"))["block"].make,
    name = "block"
  })
  self.bar:add({
    sprite = sprites.player,
    make = (require("game/objects"))["block"].make,
    name = "block"
  })
  return self.level:load("res/levels/0.png", self)
end
game.update = function(self, dt)
  if not (self.bar.exporting) then
    local _list_0 = self.objects
    for _index_0 = 1, #_list_0 do
      local object = _list_0[_index_0]
      if object.update then
        object:update(dt)
      end
    end
  end
  return self.bar:update(dt)
end
game.draw = function(self)
  self.camera:set()
  self.grid:draw()
  local _list_0 = self.objects
  for _index_0 = 1, #_list_0 do
    local object = _list_0[_index_0]
    if object.draw then
      object:draw()
    end
  end
  self.grid:draw_highlight()
  self.camera:unset()
  return self.bar:draw()
end
game.press = function(self, key)
  local _list_0 = self.objects
  for _index_0 = 1, #_list_0 do
    local object = _list_0[_index_0]
    if object.press then
      object:press(key)
    end
  end
  return self.bar:press(key)
end
game.release = function(self, key)
  local _list_0 = self.objects
  for _index_0 = 1, #_list_0 do
    local object = _list_0[_index_0]
    if object.release then
      object:release(key)
    end
  end
end
game.click = function(self, x, y, button, is_touch)
  return self.bar:click(x, y, button, is_touch)
end
game.textinput = function(self, t)
  return self.bar:textinput(t)
end
return game
