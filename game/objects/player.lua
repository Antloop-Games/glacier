local make
make = function(x, y)
  local player = {
    x = x,
    y = y,
    w = 20,
    h = 20,
    dx = 0,
    dy = 0,
    frcx = 7,
    frcy = 4,
    acc = 15,
    jump = 10.5,
    jumped = false,
    grounded = false,
    gravity = 45,
    gravity_og = 45,
    wall_x = 0,
    wall_fx = .7,
    wall_fy = .735,
    dir_x = 1,
    dash_timer = .25,
    dash_x = 0
  }
  player.update = function(self, dt)
    self.gravity = math.lerp(self.gravity, self.gravity_og, dt * 3)
    if self.wall_x ~= 0 then
      self.gravity = self.gravity_og
    end
    self.grounded = false
    self.wall_x = 0
    self.x, self.y, self.collisions = game.world:move(self, self.x + self.dx, self.y + self.dy)
    local _list_0 = self.collisions
    for _index_0 = 1, #_list_0 do
      local c = _list_0[_index_0]
      if c.other.trigger then
        c.other:trigger(self)
      end
      if c.normal.y ~= 0 then
        if c.normal.y == -1 then
          self.grounded = true
        end
        self.dy = 0
      end
      if c.normal.x ~= 0 then
        if not (self.grounded and self.wall_x ~= 0) then
          self.gravity = self.gravity / 1.25
          self.dx = self.dx - (c.normal.x * .5 * dt)
        end
        self.dx = 0
        self.wall_x = c.normal.x
      end
    end
    self.trigger_flag = false
    if self.jumped then
      self.gravity = self.gravity - (1.5 * dt)
    end
    self.dy = self.dy + (self.gravity * dt)
    do
      local _with_0 = love.keyboard
      if _with_0.isDown("d") then
        self.dx = self.dx + (self.acc * dt)
      end
      if _with_0.isDown("a") then
        self.dx = self.dx - (self.acc * dt)
      end
    end
    if self.grounded then
      self.dx = math.lerp(self.dx, 0, self.frcx * dt)
    else
      self.dx = math.lerp(self.dx, 0, self.frcy * dt)
    end
    self.dy = math.lerp(self.dy, 0, self.frcy * dt)
    self.jumped = self.dy < 0
    self:camera_follow(dt * 4)
    local a = math.sign(self.dx)
    if a ~= 0 then
      self.dir_x = -a
    end
    if self.dash_x ~= 0 then
      if self.dash_timer > 0 then
        self.dash_timer = self.dash_timer - dt
      elseif self.dash_timer < 0 then
        self.dash_x = 0
        self.dash_timer = .25
      end
    end
  end
  player.draw = function(self)
    local sprite = game.sprites.player
    local width = sprite:getWidth()
    do
      local _with_0 = love.graphics
      _with_0.setColor(1, 1, 1)
      _with_0.draw(sprite, self.x + width / 2, self.y, 0, self.dir_x, 1, width / 2)
      return _with_0
    end
  end
  player.press = function(self, key)
    if key == "space" then
      if self.grounded then
        self.dy = -self.jump
        self.jumped = true
      else
        if self.wall_x ~= 0 then
          self.dy = -self.jump * self.wall_fy
          self.dx = self.jump * self.wall_fx * self.wall_x
          self.jumped = true
          self.wall_x = 0
        end
      end
    end
    if key == "d" then
      if self.dash_x == 1 then
        self.dx = self.jump
        self.dash_x = 0
      else
        self.dash_x = 1
      end
    end
    if key == "a" then
      if self.dash_x == -1 then
        self.dx = -self.jump
        self.dash_x = 0
      else
        self.dash_x = -1
      end
    end
  end
  player.camera_follow = function(self, t)
    do
      local _with_0 = game.camera
      _with_0.x = math.lerp(_with_0.x, (self.x + self.dx * 20) * _with_0.sx, t)
      _with_0.y = math.lerp(_with_0.y, (self.y + self.dy * 2) * _with_0.sy, t)
      _with_0.r = math.lerp(_with_0.r, 0, t * .75)
      return _with_0
    end
  end
  player.release = function(self, key)
    if self.jumped then
      if key == "space" then
        self.dy = 0
      end
    end
  end
  game.world:add(player, player.x, player.y, player.w, player.h)
  return player
end
return {
  make = make
}
