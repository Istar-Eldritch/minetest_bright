
bright = {}

-- Load other files
dofile(minetest.get_modpath("bright").."/minetest_helpers.lua")


-- In order to add light we have to trick the client into generating a source of light, we do this by
-- creating a block source of light that is transparent to the user.
minetest.register_node("bright:light", {
  drawtype = "airlike",
  paramtype = "light",
  walkable = false,
  pointable = false,
  digable = false,
  is_ground_content = true,
  light_propagates = true,
  light_source = 13,
})

function add_light(position)
  local existing_node = minetest.get_node(position);
  if existing_node.name == "air" then
    minetest.env:add_node(position, {
      type = "node",
      name="bright:light",
    })
  end
end

function remove_light(position)
  local node = minetest.get_node(position)
  if node.name == "bright:light" then
    minetest.remove_node(position);
  end
end

-- In each game tick we need to:
-- Find wich players have a source of light in their hands
--  For those players, generate a light source close to them.
-- Remove all previous light sources generated if any.
minetest.register_globalstep(function(dtime)
  for index, player in pairs(minetest.get_connected_players()) do
    if minetest.is_player(player) then

      local pos = player:get_pos()
      pos.y = pos.y + 1
      local new_light_pos = nil
      if player:get_wielded_item():get_name() == "default:torch" then
        new_light_pos = pos
        add_light(new_light_pos)
      end

      -- Remove the lights around the player with the exception of the recently added one.
      -- FIXME: In multiplayer this may cause problems as it may remove the light 
      -- from other players. One potential solution is to keep the state of the active lights somewhere.
      for_each_position_in_range(pos, 2, function(position)
        if not is_same_position(new_light_pos, position) then
          remove_light(position);
        end
      end)
    end
  end
end)
