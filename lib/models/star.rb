class Star
  attr_accessor :x, :y, :mass, :size, :vx, :vy

  def initialize(x, y, mass, vx = 0, vy = 0)
    @x = x
    @y = y
    @mass = mass
    @size = Math.log(mass*0.01 + 2.2)
    @vx = vx
    @vy = vy
    @ax = 0
    @ay = 0
  end

  def self.generate_random(galaxy_size_x, galaxy_size_y, distribution)
    random_x = galaxy_size_x * rand
    random_y = galaxy_size_y * rand
    random_mass = Math.exp(10 * rand)
    
    new(random_x, random_y, random_mass)
  end

  def +(another_star)
    new_x = (0.5 * (self.x + another_star.x))
    new_y = (0.5 * (self.y + another_star.y))
    new_mass = self.mass + another_star.mass
    new_vx = (self.vx * self.mass + another_star.vx * another_star.mass) / new_mass
    new_vy = (self.vy * self.mass + another_star.vy * another_star.mass) / new_mass
    Star.new(new_x, new_y, new_mass, new_vx, new_vy)
  end

  def update_acceleration(force_x, force_y)
    @ax += force_x / mass
    @ay += force_y / mass
  end
  
  def move
    @vx += @ax
    @vy += @ay
    @x  += @vx
    @y  += @vy
    @ax = 0
    @ay = 0
  end
end