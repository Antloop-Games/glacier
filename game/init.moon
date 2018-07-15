export game = {
  objects: {} -- game objects of the world
}



camera = require "game/camera"
bar    = require "game/sexybar"
level  = require "game/level"
grid   = require "game/grid"


sprites = {
  player: love.graphics.newImage "res/ninja.png"
}



game.spawn = (object) =>
  @objects[#@objects + 1] = object


game.load = =>
  @objects = {}

  @camera  = camera.make 0, 0, 3, 3, 0
  @world   = lib.bump.newWorld!
  @grid    = grid.make!

  @sprites = sprites

  @bar     = bar.make!

  @bar\add({ sprite: sprites.player })

  level\load "res/levels/0.png", @


game.update = (dt) =>
  for object in *@objects
    object\update dt if object.update


game.draw = =>
  @camera\set!

  @grid.draw!

  for object in *@objects
    object\draw! if object.draw

  @camera\unset!

  @bar\draw!


game.press = (key) =>
  for object in *@objects
    object\press key if object.press


game.release = (key) =>
  for object in *@objects
    object\release key if object.release



game
