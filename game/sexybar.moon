make = ->
  bar = {
    x: 0, y: 0

    grid: 20 -- for grid
    scale: 3 -- for how big things are, bar's its own camera

    things: {}

    current: nil
  }

  bar.update = (dt) =>
    mouse_x = love.mouse.getX!
    mouse_y = love.mouse.getY!

    if mouse_y < @grid * @scale
      thing = @things[math.floor mouse_x / (@grid * @scale)]

      if thing
        thing.hover = true

  bar.draw = =>
    with love.graphics
      .push!

      width = .getWidth! / @scale

      .scale @scale, @scale

      for i = 0, width / @grid
        x = @x + i * @grid
        y = 0

        thing = @things[i]

        .setColor .95, .95, .95, .5

        if thing
          if thing.hover
            .setColor .95, .8, .95, .5

        .rectangle "fill", x, y, @grid, @grid

        .setColor .8, .8, .8, .5
        .rectangle "line", x, y, @grid, @grid

        if thing
          sprite = thing.sprite

          .setColor 1, 1, 1, .75

          if thing.selected
            .setColor 1, 0, 1, .75

          .draw sprite, x, y, 0, @grid / sprite\getWidth!, @grid / sprite\getHeight!
          
          thing.hover = false
    
      if @current
        mouse_x = love.mouse.getX!
        mouse_y = love.mouse.getY!

        .draw @current.sprite, math.floor mouse_x / (@grid * @scale), @mouse_y

      .pop!


  bar.add = (thing) =>
    @things[#@things] = thing

  bar.click = (button, mouse_x, mouse_y, is_touch) =>
    unless is_touch
      if mouse_y < @grid * @scale
        thing = @things[math.floor mouse_x / (@grid * @scale)]

        if thing
          thing.selected = not thing.selected

          if thing.selected
            @current = thing
          else
            @current = nil

  bar

{
  :make
}