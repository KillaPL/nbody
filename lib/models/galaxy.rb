require File.expand_path(File.dirname(__FILE__) + "/star.rb")
require File.expand_path(File.dirname(__FILE__) + "/box.rb")

class Galaxy
  attr_accessor :stars, :box

  def initialize(size, stars_count, gravity_constant, barnes_hut_ratio)
    @size = size
    @gravity_constant = gravity_constant
    @barnes_hut_ratio = barnes_hut_ratio

    @stars = []
    
    stars_count.times do |i|
      @stars << Star.generate_random(@size)
    end
  end


  def force_between(star_1, star_2, distance)
    (star_1.position - star_2.position) * @gravity_constant * star_1.mass * star_2.mass / (distance * distance)
  end

  def update_forces_between(star_1, star_2)
    distance = star_1.distance_to(star_2)

    if distance > star_1.size + star_2.size
      force = force_between(star_1, star_2, distance)
      star_1.update_acceleration(-force)
      star_2.update_acceleration(force)
    end
  end

  def calculate_forces(algorithm)
    case algorithm
    when :standard
      standard_move
    when :barnes_hut
      barnes_hut_move
    end
  end

  def standard_move
    #n**2 

    each_stars_pair do |s1, s2|
      update_forces_between(s1, s2)
    end
  end

  # def barnes_hut_move
  #   # n * log(n)
  #   @box = Box.from_galaxy(self)

  #   stars.each do |star|
  #     update_box_forces_between(box, star)
  #   end
  # end

  # def update_box_forces_between(box, star)
  #   distance = distance_between(box, star)
  #   if distance.zero?
  #   elsif box.width / distance < @barnes_hut_ratio
  #     count_actual_force_between(box, star, distance)
  #   elsif box.internal?
  #     update_box_forces_between(box.top_left_child, star)
  #     update_box_forces_between(box.top_right_child, star)
  #     update_box_forces_between(box.bottom_left_child, star)
  #     update_box_forces_between(box.bottom_right_child, star)
  #   elsif box.external?
  #     count_actual_force_between(box, star, distance)
  #   end
  # end

  # def count_actual_force_between(box, star, distance)
  #   force = force_between(box, star, distance) / distance
  #   force_x = force * (box.x - star.x)
  #   force_y = force * (box.y - star.y)
  #   star.update_acceleration(force_x, force_y)
  # end

  def move_stars
    stars.map(&:move)
  end

  def each_stars_pair
    (0...stars.length).each do |i|
      ((i+1)...stars.length).each do |j|
        yield stars[i], stars[j]
      end
    end
  end
end