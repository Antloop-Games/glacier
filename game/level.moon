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



  level.load = (path) =>
    --Remove all tiles
    for x, _y in pairs(@map)
      for y, _ in pairs(_y)
        level\remove_tile_unchecked x, y

    game.objects = {}

    image = love.image.newImageData path

    for x = 1, image\getWidth!
      for y = 1, image\getHeight!
        rx, ry = x - 1, y - 1

        r, g, b = image\getPixel rx, ry

        for id, color in pairs level.registry
          if r == color[1] and g == color[2] and b == color[3]
            level\add_tile rx, ry, id

  level.add_tile = (x, y, id) => -- returns false if it's adding the same
    --TODO: Make the min and max be calculated in @export_map
    --      as adding a tile far away and then removing it
    --      results in an unnecessarily big map, and this could
    --      result in more bugs.
    @min_x = x if @min_x == nil or x < @min_x
    @max_x = x if @max_x == nil or x > @max_x

    @min_y = y if @min_y == nil or y < @min_y
    @max_y = y if @max_y == nil or y > @max_y

    unless @map[x]
      @map[x] = {}
    elseif @map[x][y]
      if id == @map[x][y].id or @map[x][y].id == "player"
        --Place a block ontop of the exact same block or the player spawn point
        --so we shouldn't do anything
        return false

    --create the tile in the game world
    tile = objects[id].make x * @size, y * @size
    game\spawn tile
    game.world\add tile, tile.x, tile.y, tile.w, tile.h

    @map[x][y] = { :id, ref: tile }

    true

  level.remove_tile = (x, y) =>
    --Can't be unless, checks if the block exists
    return if not @map[x] or not @map[x][y]
    -- we do in fact need player
    return if @map[x][y].id == "player"

    level\remove_tile_unchecked x, y

  level.remove_tile_unchecked = (x, y) =>
    ref = @map[x][y].ref
    --Make the object remove itself from bump
    ref\remove!

    --Remove from game.objects
    for i, v in ipairs game.objects
      if v == ref
        table.remove game.objects, i
        break

    --Remove from 2d array
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

    level_img\encode "png", path

  level

{
  :make
}
