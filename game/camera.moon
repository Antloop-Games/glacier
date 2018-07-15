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

  --The height of the camera in in-game distance
  cam.height = =>
    love.graphics.getHeight! / @sy

  --Position of the left border of the camera in the gameworld
  cam.left = =>
    @x / @sx - @width!/2

  --Position of the right border of the camera in the gameworld
  cam.right = =>
    @x / @sx + @width!/2

  cam.top = =>
    @y / @sy - @height!/2

  cam.bot = =>
    @y / @sy + @height!/2


  cam
{
  :make
}
