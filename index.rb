require 'gosu'
require File.expand_path(File.dirname(__FILE__) + "/lib/helpers/draw.rb")
require File.expand_path(File.dirname(__FILE__) + "/lib/models/galaxy.rb")

class GameWindow < Gosu::Window
  include Draw

  def initialize
    @window_x = 1000
    @window_y = 1000
    @galaxy_size = 1000
    @galaxy_stars_count = 20
    @galaxy_gravity_constant = 0.0001
    @galaxy_movement = :standard   #:standard, :barnes_hut
    @barnes_hut_ratio = 1.0

    @galaxy = Galaxy.new(
      @galaxy_size, 
      @galaxy_stars_count, 
      @galaxy_gravity_constant, 
      @barnes_hut_ratio
      )

    super(@window_x, @window_y, false)
  end

  def update
    a = Time.now
    @galaxy.calculate_forces(@galaxy_movement)
    self.caption = 1000 * (Time.now - a)

    @galaxy.move_stars
  end
  
  def draw
    # draw_box(@galaxy.box) if @galaxy.box
    draw_galaxy(@galaxy)
  end
end

window = GameWindow.new
window.show