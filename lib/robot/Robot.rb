require 'state_machine'
require './lib/statemachine/direction_state_machine.rb'
require './lib/position.rb'
require './lib/playarea/robo_table.rb'

# Robot
#
# Includes DirectionStateMachine to implement direction state
#
class Robot
  include DirectionStateMachine

  # :position - Current position of robot, Position Object - x,y
  # :playarea - Area the robot can move within, Object that implmenets roboArea
  #
  attr_accessor :position, :playarea

  # Robot's state machine and events
  #
  state_machine :state, initial: :limbo do
    after_transition on: :PLACE, do: :placing
    after_transition on: :MOVE, do: :moving
    after_transition on: :REPORT, do: :communicate

    event :PLACE do
      transition limbo: :placed, placed: same
    end

    event :MOVE do
      transition placed: :moving, unless: :going_to_die?
    end

    event :REPORT do
      transition placed: same
    end

    event :finished_moving do
      transition moving: :placed
    end

    state :placed do
    end

    state :moving do
    end

    state :limbo do
    end
  end

  # Initialize robot state and playarea
  #
  # Params:
  # +playarea+:: area the robot can move in, default to a standard RoboTable, must implement position_in_bounds?
  #
  def initialize(playarea = RoboTable.new)
    @playarea = playarea
    super() # NOTE: This *must* be called, otherwise states won't get initialized
  end

  # Dertimines if the command_string is a valid command and executes
  #
  # Valid Commands
  #  * PLACE X,Y,F  (where x and y are integers and F is a "direction")
  #  * MOVE
  #  * LEFT
  #  * RIGHT
  #  * REPORT
  #
  def process_command(command_string)
    match = /^MOVE$|^LEFT$|^RIGHT$|^REPORT$|^(PLACE)\s(\d)+,(\d)+,([A-Z]+)$/.match(command_string)

    begin
      if match[1] == 'PLACE'
        send(match[1], Position.new(match[2].to_i, match[3].to_i), match[4])
      elsif respond_to?(match[0])
        send(match[0])
      end
    rescue StandardError
      # catch anything that doesnt "match" e.g. invalid commands and IGNORE!
      puts 'Invalid command, ignoring'
    end
  end

  # Override place "event" to check position before transition
  # before_transition in state_machine is only for when the transition "is" going to happen
  #
  # Sequence is executed as follows:
  #   event --> before_transition --> transition --> after_transition
  #
  # super to continue the state machine flow unless we are outside the playarea or the direction is valid
  #
  def PLACE(position, direction)
    super unless fall_into_the_abyss?(position) || !respond_to?(direction)
  end

  private

  # Grabbing the paramaters from the "transition" call
  # First parameter : Position Object
  # Second parameter : Direction - DirectionStateMachine
  #
  def placing(transition)
    parameters = *transition.args
    @position = parameters[0] # position object
    send(parameters[1]) # direction - DirectionStateMachine
  end

  # Robot is moving, move the position in direction the robot is facing
  #
  def moving
    @position.send(direction)
    finished_moving
  end

  # Print to stdout
  # Example:
  #  * Output: 1,1,NORTH
  #
  def communicate
    puts 'Output: ' + @position.x.to_s + ',' + @position.y.to_s + ',' + direction
  end

  # If I move will I be outside the playarea and die?
  #
  def going_to_die?
    nextposition = @position.dup
    nextposition.send(direction)

    fall_into_the_abyss?(nextposition)
  end

  # Check if the position is inside the playarea
  #
  def fall_into_the_abyss?(position)
    @playarea.position_in_bounds?(position)
  end
end
