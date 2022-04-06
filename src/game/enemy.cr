class Enemy < Actor
  @speed = 4
  @hp = 2

  @textures = [
    SF.int_rect(368, 80, 16, 16),  # Normal Skeleton
    SF.int_rect(368, 174, 16, 18), # Normal Orc 1
    SF.int_rect(368, 206, 16, 18), # Normal Orc 2
    SF.int_rect(368, 238, 16, 18), # Normal Orc 3
    SF.int_rect(368, 302, 16, 18), # Normal Demon 1
    SF.int_rect(368, 328, 16, 24), # Normal Demon 2
  ]

  # Move towards player
  #
  def move(player_position : SF::Vector2f)
    super player_position - @position
  end
end
