class Player < Actor
  @last_time = 0
  @death_speed = -550.0
  @hit_immunity = 3
  @last_hit = 0.0
  @textures = [
    SF.int_rect(128, 234, 16, 22), # Male Lizard
  ]

  def hit_immune?
    WorldClock.seconds < @last_hit
  end

  def hit
    @last_hit = WorldClock.seconds.to_f + @hit_immunity
    super
  end

  def update(time)
    elapsed_time = (time - @last_time) / 1000
    @last_time = time

    if dead?
      @death_speed += elapsed_time * 1000
      @sprite.move 0.0, (@death_speed * elapsed_time)
      if @death_speed > 0
        @sprite.rotation = @death_speed / 2
      end
    end

    super
  end
end

# class Player < Actor
#   # For some reason the compiler can't deal with this
#   #
#   def initialize(@name : String, @position : SF::Vector2i)
#     if @name.downcase == "visk"
#       super @position, SF.int_rect(128, 228, 16, 28)
#     end
#   end
# end
