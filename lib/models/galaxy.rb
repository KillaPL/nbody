require File.expand_path(File.dirname(__FILE__) + "/star.rb")

class Galaxy
  attr_accessor :stars

  def initialize(size, stars_count, gravity_constant, force_change_distance, stars_distribution)
    @size_x = size
    @size_y = size
    @gravity_constant = gravity_constant
    @force_change_distance = force_change_distance

    @stars = []
    
    stars_count.times do |i|
      @stars << Star.generate_random(@size_x, @size_y, stars_distribution)
    end
  end

  def distance_between(star_1, star_2)
    Math.sqrt((star_1.x - star_2.x) ** 2 + (star_1.y - star_2.y) ** 2)
  end

  def force_between(star_1, star_2, distance)
    if distance > @force_change_distance
      1.0 * @gravity_constant * star_1.mass * star_2.mass / distance
    else
      1.0 * @gravity_constant * star_1.mass * star_2.mass / @force_change_distance
    end
  end

  def update_forces_between(star_1, star_2)
    distance = distance_between(star_1, star_2)
    force = force_between(star_1, star_2, distance)
    force_x = force * (star_1.x - star_2.x) / distance
    force_y = force * (star_1.y - star_2.y) / distance
    star_1.update_acceleration(-force_x, -force_y)
    star_2.update_acceleration(force_x, force_y)
  end

  def calculate_forces
    each_stars_pair do |s1, s2|
      update_forces_between(s1, s2)
    end
  end

  def move_stars
    stars.map(&:move)
  end

  def join_stars_that_are_closer_than(joining_distance)
    each_stars_pair do |s1, s2|
      if distance_between(s1, s2) < joining_distance
        stars << s1 + s2
        stars.delete(s1)
        stars.delete(s2)
        break
      end
    end
  end

  def each_stars_pair
    (0...stars.length).each do |i|
      ((i+1)...stars.length).each do |j|
        yield stars[i], stars[j]
      end
    end
  end
end