# RoboAreaInteface to ensure position_in_bounds? is implemented
#
class RoboAreaInterface
  def position_in_bounds?(_position)
    raise 'position_in_bounds? Must be implented!'
  end
end
