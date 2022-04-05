class Enemy < Actor
  @speed = 4

  # Instanciate a minion type enemy # Do I need this?
  #
  def self.initialize_minion(position : SF::Vector2f, texture_rect : SF::IntRect)
    self.new position, texture_rect
  end

  # Move towards player
  #
  def move(player_position : SF::Vector2f)
    super player_position - @position
  end
end
