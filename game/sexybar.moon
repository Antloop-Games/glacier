make = ->
  bar = {
    x: 0, y: 0

    grid: 20 -- for grid
    scale: 3 -- for how big things are, bar's its own camera

    things: {}
  }

  bar.update = (dt) =>
    

  bar.draw = =>
    with love.graphics
      .push!

      width = .getWidth! / @scale

      .scale @scale, @scale
      .setColor .95, .95, .95, .5
      .rectangle "fill", @x, @y, width, @grid

      for i = 0, width / @grid
        x = @x + i * @grid
        y = 0

        .setColor .8, .8, .8, .5
        .rectangle "line", x, y, @grid, @grid

        thing = @things[i]

        if thing
          sprite = thing.sprite

          .setColor 1, 1, 1, .75
          .draw sprite, x, y, 0, @grid / sprite\getWidth!, @grid / sprite\getHeight!
    
      .pop!


  bar.add = (thing) =>
    @things[#@things] = thing

  bar

{
  :make
}