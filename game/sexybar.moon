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

        .setColor .95, .95, .95

        if thing
          if thing.hover
            .setColor .95, .8, .95

        .rectangle "fill", x, y, @grid, @grid

        .setColor .5, .5, .5
        .rectangle "line", x, y, @grid, @grid

        if thing
          sprite = thing.sprite

          .setColor 1, 1, 1

          if thing.selected
            .setColor 1, 0, 1

          .draw sprite, x, y, 0, @grid / sprite\getWidth!, @grid / sprite\getHeight!
          
          thing.hover = false

      .pop!


  bar.add = (thing) =>
    @things[#@things] = thing

  bar.click = (mouse_x, mouse_y, button, is_touch) =>  
    unless is_touch
      if button == 1
      if mouse_y < @grid * @scale      
        thing = @things[math.floor mouse_x / (@grid * @scale)]

        if thing
          thing.selected = not thing.selected

          if thing.selected
            @current = thing
          else
            @current = nil
      else
        mouse_x = game.camera\left! + love.mouse.getX! / game.camera.sx
        mouse_y = game.camera\top!  + love.mouse.getY! / game.camera.sy

        game\spawn @current.make mouse_x - mouse_x % game.grid.block_scale, mouse_y - mouse_y % game.grid.block_scale

  bar

{
  :make
}