class Projectile
  include SF::Drawable

  property position
  property direction

  @speed = 10
  @texture = SF::Texture.from_file "./src/assets/textures/Dungeon/0x72 Dungeon Individual Frames/Weapons/weapon_spear.png"

  def initialize(@position : SF::Vector2f, @direction : SF::Vector2f)
    @sprite = SF::Sprite.new @texture
    @sprite.origin = @sprite.local_bounds.center
    @sprite.position = @position
    @sprite.rotation = -(Math.atan2(@direction.x, @direction.y) * 180 / Math::PI)
  end

  def draw(target, states)
    target.draw @sprite
  end

  def move
    movement = apply_speed(normalize_movement)
    @position += movement

    @sprite.move movement
  end

  def normalize_movement
    direction = SF.vector2f 0, 0

    unless @direction == SF.vector2i 0, 0
      length = Math.sqrt(@direction.x ** 2 + @direction.y ** 2)
      direction.x = -(@direction.x / length).to_f32
      direction.y = -(@direction.y / length).to_f32
    end

    direction
  end

  def apply_speed(direction)
    direction * @speed
  end

  def collides?(enemy : Enemy)
    @sprite.global_bounds.intersects? enemy.global_bounds
  end

  def global_bounds
    @sprite.global_bounds
  end
end
