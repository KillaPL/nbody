class Box
  attr_accessor :min_x, :max_x, :min_y, :max_y, :width, :top_left_child, :top_right_child, :bottom_left_child, :bottom_right_child, :mass, :level, :star

  def initialize(min_x, min_y, max_x, max_y, level)
    @min_x = min_x
    @min_y = min_y
    @max_x = max_x
    @max_y = max_y
    @mid_x = (@max_x + @min_x) / 2
    @mid_y = (@max_y + @min_y) / 2

    @width = Math.sqrt((max_x - min_y)**2 + (max_x - min_y)**2)

    @star = nil

    @top_left_child = nil
    @top_right_child = nil
    @bottom_left_child = nil
    @bottom_right_child = nil

    @center_of_mass_x = 0
    @center_of_mass_y = 0
    @mass = 0

    @level = level
  end

  def self.from_galaxy(galaxy)
    new_min_x = galaxy.stars.first.x
    new_min_y = galaxy.stars.first.y
    new_max_x = galaxy.stars.first.x
    new_max_y = galaxy.stars.first.y

    galaxy.stars.each do |star|
      new_min_x = star.x if star.x < new_min_x
      new_min_y = star.y if star.y < new_min_y
      new_max_x = star.x if star.x > new_max_x
      new_max_y = star.y if star.y > new_max_y
    end

    box = new(new_min_x - 1, new_min_y - 1, new_max_x + 1, new_max_y + 1, 0)

    galaxy.stars.each do |star|
      box.insert(star)
    end

    box
  end

  def x
    @center_of_mass_x
  end

  def y
    @center_of_mass_y
  end

  def insert(star)
    if empty?
      insert_to_empty(star)
    elsif internal?
      update_mass_data(star)
      insert_into_child(star)
    else
      subdivide!
      update_mass_data(star)
      insert_into_child(@star)
      insert_into_child(star)
      remove_self_star!
    end
  end

  def subdivide!
    @top_left_child     = Box.new(@min_x, @mid_y, @mid_x, @max_y, @level + 1)
    @top_right_child    = Box.new(@mid_x, @mid_y, @max_x, @max_y, @level + 1)
    @bottom_left_child  = Box.new(@min_x, @min_y, @mid_x, @mid_y, @level + 1)
    @bottom_right_child = Box.new(@mid_x, @min_y, @max_x, @mid_y, @level + 1)
  end

  def remove_self_star!
    @star = nil
  end

  def insert_to_empty(star)
    @star = star
    @center_of_mass_x = star.x
    @center_of_mass_y = star.y
    @mass = star.mass
  end

  def update_mass_data(star)
    @center_of_mass_x = 1.0 * (@center_of_mass_x * @mass + star.x * star.mass) / (@mass + star.mass)
    @center_of_mass_y = 1.0 * (@center_of_mass_y * @mass + star.y * star.mass) / (@mass + star.mass)
    @mass += star.mass
  end

  def insert_into_child(star)
    if star.x >= @mid_x
      if star.y >= @mid_y
        @top_right_child.insert(star)
      else
        @bottom_right_child.insert(star)
      end
    else
      if star.y >= @mid_y
        @top_left_child.insert(star)
      else
        @bottom_left_child.insert(star)
      end
    end
  end

  def empty?
    @star.nil? and @mass.zero?
  end

  def internal?
    !@top_left_child.nil?
  end

  def external?
    @top_left_child.nil?
  end
end