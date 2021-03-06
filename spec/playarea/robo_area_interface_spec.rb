require './lib/playarea/robo_area_interface'

describe RoboAreaInterface do
  before :all do
    @implementations =
      ObjectSpace.each_object(Class).select { |klass| klass < RoboAreaInterface }
  end

  it 'enforces that the interface is implemented' do
    @implementations.each do |klass|
      entity = klass.new
      expect { entity.position_in_bounds?(Position.new(0, 1)) }.not_to raise_error
    end
  end
end
