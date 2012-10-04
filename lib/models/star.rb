require File.expand_path(File.dirname(__FILE__) + "/vector.rb")

class Star
  attr_accessor :position, :velocity, :acceleration, :mass, :size

  def initialize(x, y, mass, vx = 0.0, vy = 0.0)
    @position = Vector.new(x, y)
    @velocity = Vector.new(vx, vy)
    @acceleration = Vector.new(0.0, 0.0)
    @mass = mass
    @size = Math.log(mass*0.01 + 2.2).round
  end

  def self.generate_random(size)
    random_x = size * rand
    random_y = size * rand
    random_mass = Math.exp(10 * rand)
    new(random_x, random_y, random_mass)
  end

  def update_acceleration(force_vector)
    @acceleration += force_vector / mass
  end
  
  def move
    @velocity += @acceleration
    @position += @velocity
    @acceleration.reset
  end

  def distance_to(star)
    (self.position - star.position).normal_sum
  end
end