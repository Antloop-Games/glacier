local path = "lib/"
local gamestate = require(path .. "gamestate")
local bump = require(path .. "bump")
return {
  gamestate = gamestate,
  bump = bump
}
