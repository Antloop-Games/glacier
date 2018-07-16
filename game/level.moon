make = ->
  level = {
    size: 20 -- size of grid squares
    registry: {
      "block":  { 0, 0, 0 }
      "player": { 1, 1, 0 }
    }
    map: {}

    min_x: nil
    max_x: nil

    min_y: nil
    max_y: nil
  }



  objects = require "game/objects"



  level.load = (path, game) =>
    image = love.image.newImageData path

    map = {}

    for x = 1, image\getWidth!
      map[x] = {}

      for y = 1, image\getHeight!
        rx, ry = x - 1, y - 1

        r, g, b = image\getPixel rx, ry

        for k, v in pairs level.registry
          if r == v[1] and g == v[2] and b == v[3]
            level.spawn k, level.size * rx, level.size * ry, game


  level.spawn = (k, x, y, game) ->
    a = objects[k].make x, y

    if k == "player"
      game\spawn {
        draw: =>
          with love.graphics
            .setColor 1, 1, 1, .5
            .draw game.sprites.player, x, y
      }

    game\spawn a

    level\add_tile x / game.grid.tile_scale, y / game.grid.tile_scale, k, a

    game.world\add a, a.x, a.y, a.w, a.h

    a

  level.add_tile = (x, y, id, ref) => -- returns false if it's adding the same
    @min_x = x if @min_x == nil or x < @min_x
    @max_x = x if @max_x == nil or x > @max_x

    @min_y = y if @min_y == nil or y < @min_y
    @max_y = y if @max_y == nil or y > @max_y

    unless @map[x]
      @map[x] = {}
    elseif @map[x][y]
      if id == @map[x][y].id
        return false
      else
        return false if @map[x][y].id == "player"
        @remove_tile ref

    @map[x][y] = { :id, :ref }

    true

  level.remove_tile = (x, y) =>
    ref = @map[x][y].ref

    return if @map[x][y].id == "player" -- we do in fact need player

    ref\remove!

    for i, v in ipairs game.objects
      if v == ref
        table.remove game.objects, i
        break

    @map[x][y] = nil

  level.export_map = (path) =>
    width  = @max_x - @min_x + 1
    height = @max_y - @min_y + 1

    level_img = love.image.newImageData width, height

    for x = 0, @max_x
      continue unless @map[x]

      for y = 0, @max_y
        continue unless @map[x][y]

        color = game.level.registry[@map[x][y].id]

        new_x = x - @min_x
        new_y = y - @min_y

        level_img\setPixel new_x, new_y, color[1], color[2], color[3]

    unless love.filesystem.getInfo "maps"
      love.filesystem.createDirectory "maps"

    level_img\encode "png", "maps/#{path}.png"

  level

{
  :make
}
