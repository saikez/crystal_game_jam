require "./game/helper"

struct SF::Rect
  def center
    SF::Vector2.new left + width / 2, top + height / 2
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

full_texture_file = SF::Texture.from_file "./src/assets/textures/Dungeon/0x72 Dungeon Tileset.png"

visk_idle_1 = SF.int_rect 128, 228, 16, 28
visk_idle_2 = SF.int_rect 144, 228, 16, 28
visk_idle_3 = SF.int_rect 160, 228, 16, 28
visk_idle_4 = SF.int_rect 176, 228, 16, 28
visk_animation = [visk_idle_1, visk_idle_2, visk_idle_3, visk_idle_4].cycle
visk = SF::Sprite.new full_texture_file, visk_idle_1
visk.origin = visk.local_bounds.center
visk.position = SF.vector2 400, 300
visk.scale SF.vector2 2, 2

clock = SF::Clock.new
clock_text = SF::Text.new "", font, 20

fps_clock = SF::Clock.new
fps_text = SF::Text.new "", font, 20
fps_text.position = SF.vector2 0, 20

animation_step_time = 125
next_animation_step_time = animation_step_time



# Start Game Loop
while window.open?
  window.clear SF::Color::Black

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

      # Alt Controls
      when.up?
        # Go Up
      when.left?
        # Go Left
      when.down?
        # Go Down
      when.right?
        # Go Right
      end
    end
  end

  clock_text.string = clock.elapsed_time.as_seconds.to_s
  fps_text.string = (1000 / fps_clock.restart.as_milliseconds).to_s

  if clock.elapsed_time.as_milliseconds >= next_animation_step_time
    next_animation_step_time = clock.elapsed_time.as_milliseconds + animation_step_time
    visk.texture_rect = visk_animation.next.as SF::Rect(Int32)
  end

  window.draw clock_text
  window.draw fps_text
  window.draw title_text
  window.draw visk

  window.display
end
