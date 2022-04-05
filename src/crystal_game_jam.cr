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
player = Actor.new SF.vector2(400, 300), SF.int_rect(128, 228, 16, 28)

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
    elsif event.is_a? SF::Event::KeyPressed
      case event.code
      # Main Controle
      when .w?
        # Go Up
      when .a?
        # Go Left
      when .s?
        # Go Down
      when .d?
        # Go Right

        # Alt Controls?
      when .up?
        # Go Up
      when .left?
        # Go Left
      when .down?
        # Go Down
      when .right?
        # Go Right
      end
    end
  end

  clock_text.string = current_time.to_s
  fps_text.string = (1000 / fps_clock.restart.as_milliseconds).to_s

  player.update(current_time)

  window.draw clock_text
  window.draw fps_text
  window.draw title_text
  window.draw player

  window.display
end
