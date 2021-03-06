require './lib/playarea/robo_area_interface'

# Represents tabletop used in toy robot simulator.
# Square
#
class RoboTable < RoboAreaInterface
  attr_accessor :width, :height, :southwest_corner, :northeast_corner

  # width, height, southwest_corner of the area
  #
  def initialize(width = 5, height = 5, southwest_corner = Position.new(0, 0))
    @width = width
    @height = height
    @southwest_corner = southwest_corner
    @northeast_corner = Position.new(southwest_corner.x + width - 1, southwest_corner.y + height - 1)
  end

  # Is the position inside the table area
  #
  def position_in_bounds?(position)
    !((@southwest_corner.x..@northeast_corner.x).cover?(position.x) && (@southwest_corner.y..@northeast_corner.y).cover?(position.y))
  end
end
