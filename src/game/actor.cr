class Actor
  include SF::Drawable

  property position

  @idle_animation = [] of SF::IntRect
  @run_animation = [] of SF::IntRect
  @hit_animation : SF::IntRect

  @full_texture_file = SF::Texture.from_file "./src/assets/textures/Dungeon/0x72 Dungeon Tileset.png"

  @anim_step_time = 125
  @next_anim_step_time : Int32

  @anim_index = 0

  @speed = 5
  @moving = false
  @facing_left = false

  def initialize(@position : SF::Vector2f, texture_rect : SF::IntRect)
    (0..3).each do |i|
      @idle_animation << animation_rect(texture_rect, i)
    end

    (4..7).each do |i|
      @run_animation << animation_rect(texture_rect, i)
    end

    @hit_animation = animation_rect(texture_rect, 8)

    @next_anim_step_time = WorldClock.milliseconds + @anim_step_time

    @sprite = SF::Sprite.new @full_texture_file, @idle_animation.first
    @sprite.origin = @sprite.local_bounds.center
    @sprite.scale SF.vector2 2, 2
    @sprite.position = @position
  end

  def update(time)
    if time >= @next_anim_step_time
      @next_anim_step_time = time + @anim_step_time
      next_animation_step
    end
  end

  def draw(target, states)
    target.draw @sprite
  end

  def animation_rect(rect, i) : SF::IntRect
    SF.int_rect(rect.left + (rect.width * i), rect.top, rect.width, rect.height)
  end

  def next_animation_step
    @sprite.texture_rect = animation_step
    @anim_index += 1
    @anim_index = 0 if @anim_index == @idle_animation.size
  end

  def animation_step
    if @moving
      @run_animation[@anim_index]
    else
      @idle_animation[@anim_index]
    end
  end

  def move(direction : SF::Vector2f)
    animation_reset direction
    animation_facing direction

    @sprite.move apply_speed(normalize_movement(direction))
  end

  def normalize_movement(direction : SF::Vector2f)
    unless direction == SF.vector2f 0, 0
      length = Math.sqrt(direction.x ** 2 + direction.y ** 2)
      direction.x /= length
      direction.y /= length
    end

    direction
  end

  def apply_speed(direction : SF::Vector2f)
    direction * @speed
  end

  def animation_reset(direction)
    prev_moving = @moving
    @moving = direction.x != 0 || direction.y != 0

    if prev_moving != @moving
      @anim_index = 0
      @next_anim_step_time = 0
    end
  end

  def animation_facing(direction)
    if direction.x < 0 && !@facing_left
      @facing_left = !@facing_left
      @sprite.scale -1, 1
    elsif direction.x > 0 && @facing_left
      @facing_left = !@facing_left
      @sprite.scale -1, 1
    end
  end
end
