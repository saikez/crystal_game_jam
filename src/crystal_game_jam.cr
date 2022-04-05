require "./game/helper"

Up         = SF.vector2f 0, -1
Down       = SF.vector2f 0, 1
Left       = SF.vector2f -1, 0
Right      = SF.vector2f 1, 0
Directions = [Left, Up, Right, Down]

# music = SF::Music.from_file("src/assets/sounds/music/Tragique.ogg")

# music.volume = 50 # reduce the volume
# music.loop = true # make it loop

video_mode = SF::VideoMode.new 1200, 900
window = SF::RenderWindow.new video_mode, "Visk's End of the World Adventure"
window.framerate_limit = 60

font = SF::Font.from_file "src/assets/fonts/AncientModernTales.ttf"

title_text = SF::Text.new
title_text.font = font
title_text.string = "Visk's End of the World Adventure"
title_text.character_size = 48
title_text.color = SF::Color::White
title_text.origin = title_text.local_bounds.center
title_text.position = SF.vector2 video_mode.width / 2, video_mode.height / 2 + 100

clock = SF::Clock.new
clock_text = SF::Text.new "", font, 20

fps_clock = SF::Clock.new
fps_text = SF::Text.new "", font, 20
fps_text.position = SF.vector2 0, 20

enemy_spawn_rate_increase_time = 20
enemy_spawn_rate_time = 5
next_spawn = 0
spawn_x = false
negative = false
enemies = [] of Actor
enemy_textures = [
  SF.int_rect(128, 196, 16, 28), # Female Lizard texture
  SF.int_rect(16, 272, 32, 32),  # Giant Plant texture
  SF.int_rect(16, 320, 32, 32),  # Giant Ogre texture
  SF.int_rect(16, 368, 32, 32),  # Giant Demon texture
  SF.int_rect(368, 50, 16, 16),  # Tiny Demon texture
  SF.int_rect(368, 80, 16, 16),  # Normal Skeleton texture
  SF.int_rect(368, 302, 16, 18), # Normal Demon 1 texture
  SF.int_rect(368, 206, 16, 18), # Normal Ogre 2 texture
]

projectiles = [] of Projectile
projectile_delay = 500
next_projectile_time = 0

player = Player.new SF.vector2f(video_mode.width / 2, video_mode.height / 2), SF.int_rect(128, 228, 16, 28)

player_movement = SF.vector2f 0, 0

random = Random.new

# Music doesn't want to play :c
# This is more than likely a WSL issue... should work on desktop
# music.play

# Start Game Loop
while window.open?
  window.clear SF::Color::Black

  current_time = WorldClock.milliseconds
  current_time_seconds = WorldClock.seconds

  # Enemy spawn routine
  #
  if current_time_seconds >= next_spawn
    ((current_time_seconds.to_i // enemy_spawn_rate_increase_time) + 1).times do
      enemy_spawn_position = SF.vector2f 0, 0
      spawn_x = random.rand(1..2) == 1
      negative = random.rand(1..2) == 1

      if spawn_x
        enemy_spawn_position.y = (random.rand(video_mode.height + 200.0) - 100.0).to_f32
        if negative
          enemy_spawn_position.x -= 100
        else
          enemy_spawn_position.x += video_mode.width + 100
        end
      else
        enemy_spawn_position.x = (random.rand(video_mode.width + 200.0) - 100.0).to_f32
        if negative
          enemy_spawn_position.y -= 100
        else
          enemy_spawn_position.y += video_mode.height + 100
        end
      end

      enemies << Enemy.initialize_minion enemy_spawn_position, enemy_textures.sample
    end
    next_spawn += enemy_spawn_rate_time
  end

  while event = window.poll_event
    # Closing window or pressing ESC exits the game
    if (
         event.is_a?(SF::Event::Closed) ||
         (event.is_a?(SF::Event::KeyPressed) && event.code.escape?)
       )
      window.close
    elsif event.is_a? SF::Event::KeyPressed
      if SF::Keyboard.key_pressed?(SF::Keyboard::Key::W)
        player_movement += Up if player_movement.y == 0
      end
      if SF::Keyboard.key_pressed?(SF::Keyboard::Key::S)
        player_movement += Down if player_movement.y == 0
      end
      if SF::Keyboard.key_pressed?(SF::Keyboard::Key::A)
        player_movement += Left if player_movement.x == 0
      end
      if SF::Keyboard.key_pressed?(SF::Keyboard::Key::D)
        player_movement += Right if player_movement.x == 0
      end
    elsif SF::Mouse.button_pressed? SF::Mouse::Left
      if current_time > next_projectile_time
        projectiles << Projectile.new player.position, player.position - SF::Mouse.get_position(window)
        next_projectile_time = current_time + projectile_delay
      end
    elsif !(SF::Keyboard.key_pressed?(SF::Keyboard::Key::W) || SF::Keyboard.key_pressed?(SF::Keyboard::Key::S))
      player_movement.y = 0
    elsif !(SF::Keyboard.key_pressed?(SF::Keyboard::Key::A) || SF::Keyboard.key_pressed?(SF::Keyboard::Key::D))
      player_movement.x = 0
    end
  end

  clock_text.string = current_time.to_s
  fps_text.string = (1000 / fps_clock.restart.as_milliseconds).to_s

  player.move player_movement
  enemies.each { |enemy| enemy.move player.position }
  projectiles.each { |projectile| projectile.move }

  player.update(current_time)
  enemies.each { |enemy| enemy.update(current_time) }

  window.draw clock_text
  window.draw fps_text
  window.draw title_text if current_time_seconds < 5

  window.draw player
  enemies.each { |enemy| window.draw enemy }
  projectiles.each { |projectile| window.draw projectile }

  window.display
end
