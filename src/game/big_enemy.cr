class BigEnemy < Enemy
  @speed = 2
  @hp = 3

  @textures = [
    SF.int_rect(16, 272, 32, 32), # Big Undead
    SF.int_rect(16, 320, 32, 32), # Big Orc
    SF.int_rect(16, 368, 32, 32), # Big Demon
  ]
end
