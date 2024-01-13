# frozen_string_literal: true

# A Player represents a user playing the game
class Player
  attr_reader :name, :marker

  private

  attr_writer :name, :marker

  def initialize(name, marker)
    self.name = name
    self.marker = marker
  end
end
