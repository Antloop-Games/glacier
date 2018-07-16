make = ->
  grid = {
    tile_scale: 20,
    map: {},

    min_x: nil
    max_x: nil

    min_y: nil
    max_y: nil
  }

  grid.draw = =>
    with game.camera
      love.graphics.setLineWidth(1 / .sx)
      love.graphics.setColor(0, 0, 0)

      --Vertical lines
      offset = \left! % grid.tile_scale

      for i = 0, \width! / grid.tile_scale do
        --Top point
        --Each line is slitghly more to the right than previous one
        x1, y1 = \left! - offset + i * grid.tile_scale, \top!
        --Bottom point
        x2, y2 = x1, \bot!
        --Line from top to bottom
        love.graphics.line x1, y1, x2, y2

      --Horizontal lines
      offset = \top! % grid.tile_scale

      for i = 0, \height! / grid.tile_scale do
        --Left point     each line is slitghly lower than the previous one
        x1, y1 = \left!, \top! - offset + i * grid.tile_scale
        --Right point
        x2, y2 = \right!, y1
        --Draw line from left to right
        love.graphics.line x1, y1, x2, y2

  grid.draw_highlight = =>
    if game.bar.current
      with love.graphics
        .setColor 1, 1, 1

        mouse_x = game.camera\left! + love.mouse.getX! / game.camera.sx
        mouse_y = game.camera\top!  + love.mouse.getY! / game.camera.sy

        .draw game.bar.current.sprite, mouse_x - mouse_x % @tile_scale, mouse_y - mouse_y % @tile_scale

  grid.add_tile = (x, y, id, ref) => -- returns false if it's adding the same
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

  grid.remove_tile = (x, y) =>
    ref = @map[x][y].ref

    return if @map[x][y].id == "player" -- we do in fact need player

    ref\remove!

    for i, v in ipairs game.objects
      if v == ref
        table.remove game.objects, i
        break

    @map[x][y] = nil

  grid.export_map = (path) =>
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


  grid

{
  :make
}
