class Scene
  include SF::Drawable

  getter size

  def initialize(@size : SF::Vector2i)
  end

  def update()
  end

  def draw(target, states)
  end
end
