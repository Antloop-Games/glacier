-- x, y, scale x, scale y, rotation: returns camera
make = (x, y, sx, sy, r) ->
  cam = {
    :x,  :y
    :sx, :sy
    :r
  }


  cam.move = (dx, dy) =>
    @x += dx
    @y += dy

    cam


  cam.set = =>
    with love.graphics
      .push!
      .translate .getWidth! / 2 - @x, .getHeight! / 2 - @y
      .scale @sx, @sy
      .rotate @r

    cam


  cam.unset = =>
    love.graphics.pop!
    cam

  --The width of the camera in in-game distance
  cam.width = =>
    love.graphics.getWidth! / @sx

  --The heightt of the camera in in-game distance
  cam.height = =>
    love.graphics.getHeight! / @sy

  cam



{
  :make
}
