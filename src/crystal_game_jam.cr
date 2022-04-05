require "./game/helper"

struct SF::Rect
  def center
    SF::Vector2.new left + width / 2, top + height / 2
  end
end

class WorldClock
  @@clock = SF::Clock.new

  def self.elapsed_time
    @@clock.elapsed_time
  end

  def self.milliseconds
    @@clock.elapsed_time.as_milliseconds
  end

  def self.seconds
    @@clock.elapsed_time.as_seconds
  end
end

Up         = SF.vector2 0, -10
Down       = SF.vector2 0, 10
Left       = SF.vector2 -10, 0
Right      = SF.vector2 10, 0
UpLeft     = SF.vector2 -5, -5
UpRight    = SF.vector2 5, -5
DownLeft   = SF.vector2 -5, 5
DownRight  = SF.vector2 5, 5
Directions = [Left, Up, Right, Down, UpLeft, UpRight, DownLeft, DownRight]

# music = SF::Music.from_file("src/assets/sounds/music/Tragique.ogg")

# music.volume = 50 # reduce the volume
# music.loop = true # make it loop

video_mode = SF::VideoMode.new 800, 600
window = SF::RenderWindow.new video_mode, "Visk's End of the World Adventure"
# window.vertical_sync_enabled = true
window.framerate_limit = 60

font = SF::Font.from_file "src/assets/fonts/AncientModernTales.ttf"

title_text = SF::Text.new
title_text.font = font
title_text.string = "Visk's End of the World Adventure"
title_text.character_size = 48
title_text.color = SF::Color::White
# title_text.style = (SF::Text::Bold | SF::Text::Underlined)
title_text.origin = title_text.local_bounds.center
title_text.position = SF.vector2 400, 400

clock = SF::Clock.new
clock_text = SF::Text.new "", font, 20

fps_clock = SF::Clock.new
fps_text = SF::Text.new "", font, 20
fps_text.position = SF.vector2 0, 20

actors = [] of Actor
# player = Player.new "Visk", SF.vector2(400, 300)
player = Player.new SF.vector2(400, 300), SF.int_rect(128, 228, 16, 28)

player_movement = SF.vector2 0, 0

# Music doesn't want to play :c
# This is more than likely a WSL issue... should work on desktop
# music.play

# Start Game Loop
while window.open?
  window.clear SF::Color::Black

  current_time = WorldClock.milliseconds

  while event = window.poll_event
    # Closing window or pressing ESC exits the game
    if (
         event.is_a?(SF::Event::Closed) ||
         (event.is_a?(SF::Event::KeyPressed) && event.code.escape?)
       )
      window.close
      # Movement is a little funky atm.. gotta fix later
    elsif event.is_a? SF::Event::KeyPressed
      if SF::Keyboard.key_pressed?(SF::Keyboard::Key::W) && SF::Keyboard.key_pressed?(SF::Keyboard::Key::A)
        player_movement = UpLeft
      elsif SF::Keyboard.key_pressed?(SF::Keyboard::Key::W) && SF::Keyboard.key_pressed?(SF::Keyboard::Key::D)
        player_movement = UpRight
      elsif SF::Keyboard.key_pressed?(SF::Keyboard::Key::S) && SF::Keyboard.key_pressed?(SF::Keyboard::Key::A)
        player_movement = DownLeft
      elsif SF::Keyboard.key_pressed?(SF::Keyboard::Key::S) && SF::Keyboard.key_pressed?(SF::Keyboard::Key::D)
        player_movement = DownRight
      elsif SF::Keyboard.key_pressed?(SF::Keyboard::Key::W)
        player_movement = Up
      elsif SF::Keyboard.key_pressed?(SF::Keyboard::Key::S)
        player_movement = Down
      elsif SF::Keyboard.key_pressed?(SF::Keyboard::Key::A)
        player_movement = Left
      elsif SF::Keyboard.key_pressed?(SF::Keyboard::Key::D)
        player_movement = Right
      end
    elsif !(SF::Keyboard.key_pressed?(SF::Keyboard::Key::W) || SF::Keyboard.key_pressed?(SF::Keyboard::Key::A) || SF::Keyboard.key_pressed?(SF::Keyboard::Key::S) || SF::Keyboard.key_pressed?(SF::Keyboard::Key::D))
      player_movement = SF.vector2 0, 0
    end
  end

  player.move player_movement

  clock_text.string = current_time.to_s
  fps_text.string = (1000 / fps_clock.restart.as_milliseconds).to_s

  player.update(current_time)

  window.draw clock_text
  window.draw fps_text
  window.draw title_text
  window.draw player

  window.display
end
