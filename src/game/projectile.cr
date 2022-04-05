class Projectile
  include SF::Drawable

  property position
  property direction

  @speed = 10
  @texture = SF::Texture.from_file "./src/assets/textures/Dungeon/0x72 Dungeon Individual Frames/Weapons/weapon_spear.png"

  def initialize(@position : SF::Vector2f, @direction : SF::Vector2i)
    @sprite = SF::Sprite.new @texture
    @sprite.origin = @sprite.local_bounds.center
    @sprite.scale SF.vector2 2, 2
    @sprite.position = @position
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
    unless @direction == SF.vector2f 0, 0
      length = Math.sqrt(@direction.x ** 2 + @direction.y ** 2)
      @direction.x /= length
      @direction.y /= length
    end

    @direction
  end

  def apply_speed(direction)
    direction * @speed
  end
end
