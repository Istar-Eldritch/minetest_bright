function for_each_position_in_range(center, range, callback)
  local min_x = center.x - range;
  local max_x = center.x + range;
  local min_y = center.y - range;
  local max_y = center.y + range;
  local min_z = center.z - range;
  local max_z = center.z + range;


  for x = min_x, max_x, 1
  do
    for y = min_y, max_y, 1
    do
      for z = min_z, max_z, 1
      do
        local position = {x = x, y = y, z = z}
        callback(position)
      end
    end
  end
end

function is_same_position(pos1, pos2)
  return pos1 ~= nil and
         pos2 ~= nil and
         pos1.x == pos2.x and
         pos1.y == pos2.y and
         pos1.z == pos2.z
end

