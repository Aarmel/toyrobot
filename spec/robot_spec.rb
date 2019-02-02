require './lib/robot/Robot'
require './lib/Position'

RSpec.describe Robot do
  before do
    @robot = Robot.new
    @direction = 'NORTH'
    @position = Position.new(0, 0)
    @to_far_north = Position.new(0, 5)
    @to_far_west = Position.new(5, 0)
    @to_far_south = Position.new(0, -1)
    @to_far_east = Position.new(-1, 0)
  end

  context 'has not been placed' do
    it 'direciton is none' do
      expect(@robot.direction).to eq 'none'
    end

    it 'in limbo' do
      expect(@robot.limbo?).to eq true
    end

    it 'cannot turn left' do
      expect(@robot.can_LEFT?).to eq false
    end

    it 'cannot turn right' do
      expect(@robot.can_RIGHT?).to eq false
    end

    it 'cannot move' do
      expect(@robot.can_MOVE?).to eq false
    end

    it 'cannot report' do
      expect(@robot.can_REPORT?).to eq false
    end
  end

  context 'has not been placed' do
    it 'cannot be placed off the table' do
      @robot.PLACE(@to_far_north, @direction)
      expect(@robot.limbo?).to eq true

      @robot.PLACE(@to_far_west, @direction)
      expect(@robot.limbo?).to eq true

      @robot.PLACE(@to_far_south, @direction)
      expect(@robot.limbo?).to eq true

      @robot.PLACE(@to_far_east, @direction)
      expect(@robot.limbo?).to eq true
    end

    it 'cannot be placed with an invalid direction' do
      @robot.PLACE(@position, 'NORTHs')
      expect(@robot.limbo?).to eq true
    end

    it 'can be placed on table' do
      @robot.PLACE(@position, @direction)
      expect(@robot.placed?).to eq true
    end
  end

  context 'has been placed' do
    before do
      @robot.PLACE(@position, @direction)
    end

    it 'can be placed in a different position' do
      @robot.PLACE(Position.new(3, 3), @direction)
    end

    it 'cannot be placed off the table' do
      @robot.PLACE(@to_far_north, @direction)
    end
  end

  context 'has been placed facing north,0,0' do
    before do
      @robot.PLACE(@position, @direction)
    end

    it 'direction is north' do
      expect(@robot.direction).to eq 'NORTH'
    end

    it 'state is placed' do
      expect(@robot.state).to eq 'placed'
    end

    context 'turns left' do
      before { @robot.LEFT }

      it 'direction is WEST' do
        expect(@robot.direction).to eq 'WEST'
      end

      context 'turns right' do
        before { @robot.RIGHT }

        it 'direction is NORTH' do
          expect(@robot.direction).to eq 'NORTH'
        end
      end
    end
  end

  context 'has been placed facing south at 0,0' do
    before do
      @robot.PLACE(@position, 'SOUTH')
    end

    it 'cannot move off table' do
      expect(@robot.can_MOVE?).to eq false
    end

    context 'turns left' do
      before { @robot.LEFT }

      it 'can move' do
        expect(@robot.can_MOVE?).to eq true
      end

      context 'moves' do
        before { @robot.MOVE }

        it '#REPORT outputs "Output: 1,0,EAST"' do
          expect { @robot.REPORT }.to output('Output: 1,0,EAST').to_stdout
        end
      end
    end
  end
end
