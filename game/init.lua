game = {
  objects = { }
}
local camera = require("game/camera")
local bar = require("game/sexybar")
local level = require("game/level")
local sprites = {
  player = love.graphics.newImage("res/ninja.png")
}
game.spawn = function(self, object)
  self.objects[#self.objects + 1] = object
end
game.load = function(self)
  self.objects = { }
  self.camera = camera.make(0, 0, 3, 3, 0)
  self.world = lib.bump.newWorld()
  self.sprites = sprites
  self.bar = bar.make()
  self.bar:add({
    sprite = sprites.player
  })
  return level:load("res/levels/0.png", self)
end
game.update = function(self, dt)
  local _list_0 = self.objects
  for _index_0 = 1, #_list_0 do
    local object = _list_0[_index_0]
    if object.update then
      object:update(dt)
    end
  end
end
game.draw = function(self)
  self.camera:set()
  local _list_0 = self.objects
  for _index_0 = 1, #_list_0 do
    local object = _list_0[_index_0]
    if object.draw then
      object:draw()
    end
  end
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
return game
