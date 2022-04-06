class TinyEnemy < Enemy
  @speed = 6
  @hp = 1

  @textures = [
    SF.int_rect(368, 20, 16, 12),  # Tiny Undead
    SF.int_rect(368, 36, 16, 12),  # Tiny Orc
    SF.int_rect(368, 50, 16, 16),  # Tiny Demon
    SF.int_rect(368, 370, 16, 14), # Tiny Cherub
  ]
end
