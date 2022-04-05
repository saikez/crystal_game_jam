struct SF::Rect
  def center
    SF::Vector2.new left + width / 2, top + height / 2
  end
end
