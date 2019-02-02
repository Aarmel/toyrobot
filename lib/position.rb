# Represents a point with x,y.
# Supports moving the point in a direction by calling the direction NORTH,SOUTH,EAST,WEST
#
class Position
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def NORTH
    @y += 1
  end

  def SOUTH
    @y -= 1
  end

  def EAST
    @x += 1
  end

  def WEST
    @x -= 1
  end
end
