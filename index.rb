require 'gosu'
require File.expand_path(File.dirname(__FILE__) + "/lib/helpers/draw.rb")
require File.expand_path(File.dirname(__FILE__) + "/lib/models/galaxy.rb")

class GameWindow < Gosu::Window
  include Draw

  def initialize
    @window_x = 1000
    @window_y = 1000
    @galaxy_size = 1000
    @scale = 1.0 * @window_x / @galaxy_size
    @galaxy_stars_count = 500
    @galaxy_gravity_constant = 0.00001
    @galaxy_joining_distance = 2
    @galaxy_force_change_distance = 4
    @galaxy_distribution = :unitary  #:unitary, :normal
    @galaxy_movement = :barnes_hut   #:standard, :barnes_hut
    @barnes_hut_ratio = 1.0

    @galaxy = Galaxy.new(
      @galaxy_size, 
      @galaxy_stars_count, 
      @galaxy_gravity_constant, 
      @galaxy_force_change_distance, 
      @galaxy_distribution, 
      @barnes_hut_ratio
      )

    super(@window_x, @window_y, false)
  end

  def update
    @galaxy.calculate_forces(@galaxy_movement)
    @galaxy.move_stars
    @galaxy.join_stars_that_are_closer_than(@galaxy_joining_distance)
  end
  
  def draw
    scale(@scale, @scale, 0, 0) do
      translate(@galaxy_size/2, @galaxy_size/2) do
        # draw_box(@galaxy.box) if @galaxy.box
        draw_galaxy(@galaxy)
      end
    end
  end
end

window = GameWindow.new
window.show