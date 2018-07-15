make = (x, y) ->
  block = {
    :x, :y

    w: 20
    h: 20
  }

  block.draw = =>
    with love.graphics
      .setColor 0, 0, 0
      .rectangle "fill", @x, @y, @w, @h

  game.world\add block, block.x, block.y, block.w, block.h

  block



{
  :make
}