module Draw
  def draw_galaxy(galaxy)
    galaxy.stars.each do |star|
      draw_star(star)
    end
  end

  def draw_star(star)
    draw_quad(
      star.position.a,             star.position.b,             0xffffffff, 
      star.position.a + star.size, star.position.b,             0xffffffff, 
      star.position.a + star.size, star.position.b + star.size, 0xffffffff, 
      star.position.a,             star.position.b + star.size, 0xffffffff, 
      )
  end

  def draw_box(box)
    draw_quad(
      box.min_x, box.min_y, 0xff0000ff, 
      box.max_x, box.min_y, 0xff0000ff, 
      box.max_x, box.max_y, 0xff0000ff, 
      box.min_x, box.max_y, 0xff0000ff, 
      )

    draw_quad(
      box.min_x + 1, box.min_y + 1, 0xff000000, 
      box.max_x - 1, box.min_y + 1, 0xff000000, 
      box.max_x - 1, box.max_y - 1, 0xff000000, 
      box.min_x + 1, box.max_y - 1, 0xff000000, 
      )

    if box.internal?
      draw_box(box.top_left_child)
      draw_box(box.top_right_child)
      draw_box(box.bottom_left_child)
      draw_box(box.bottom_right_child)
    end
  end
end