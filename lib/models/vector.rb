class Vector
  attr_accessor :a, :b

  def initialize(a, b)
    @a = a
    @b = b
    self
  end

  def -@
    Vector.new(-self.a, -self.b)
  end

  def +(vector)
    Vector.new(@a + vector.a, @b + vector.b)
  end

  def -(vector)
    Vector.new(@a - vector.a, @b - vector.b)
  end

  def *(number)
    Vector.new(@a*number, @b*number)
  end

  def /(number)
    Vector.new(@a/number, @b/number)
  end

  def reset
    @a = 0.0
    @b = 0.0
  end

  def normal_sum
    Math.sqrt(@a*@a + @b*@b)
  end
end
