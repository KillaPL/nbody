module Draw
  def draw_galaxy(galaxy)
    galaxy.stars.each do |star|
      draw_star(star)
    end
  end

  def draw_star(star)
    draw_quad(
      star.x,             star.y,             0xffffffff, 
      star.x + star.size, star.y,             0xffffffff, 
      star.x + star.size, star.y + star.size, 0xffffffff, 
      star.x,             star.y + star.size, 0xffffffff, 
      )
  end
end