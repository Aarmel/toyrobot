# As class_eval is used to make any class that includes the state_machine will have the 
# Direction State machine included as if it was inline
# 
# class MyClass
#   include DirectionStateMachineclass
# end
#
# m = MyClass.new
# m.NORTH
# 
module DirectionStateMachine
  def self.included(base)
    base.class_eval do
      state_machine :direction, :initial => :none do

        event :NORTH do
          transition all => :NORTH
        end

        event :SOUTH do
          transition all => :SOUTH
        end

        event :EAST do
          transition all => :EAST
        end

        event :WEST do
          transition all => :WEST
        end

        event :LEFT do
          transition NORTH: :WEST, WEST: :SOUTH, SOUTH: :EAST, EAST: :NORTH
        end

        event :RIGHT do
          transition NORTH: :EAST, EAST: :SOUTH, SOUTH: :WEST, WEST: :NORTH
        end

        state :none do
        end

        state :NORTH do
        end

        state :EAST do
        end

        state :SOUTH do
        end

        state :WEST do
        end
      end
    end
  end
end