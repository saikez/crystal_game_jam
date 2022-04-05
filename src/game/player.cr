class Player < Actor
  # For some reason the compiler can't deal with this
  #
  def initialize(@name : String, @position : SF::Vector2i)
    if @name.downcase == "visk"
      super @position, SF.int_rect(128, 228, 16, 28)
    end
  end
end
