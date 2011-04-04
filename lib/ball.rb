$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
require 'zorder'

require 'gosu'

class Ball
  attr_accessor :angle, :speed
  attr_reader :x, :y

  def initialize(window)
    @window = window
    @x = @y = @angle = @speed = 0
  end
  
  def warp(x, y)
    @x, @y = x, y
  end
  
  def move
    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)
    
    # Top/Bottom collision
    if Gosu::distance(@x, @y, @x, 0) <= @speed
      @angle = 180 - @angle
    elsif Gosu::distance(@x, @y, @x, @window.height) <= @speed
      @angle = 180 - @angle
    end
  end
  
  def draw
    @window.rotate(@angle, @x, @y) do
      @window.draw_quad(@x - 5, @y - 5, Gosu::Color::WHITE, @x + 5, @y - 5, Gosu::Color::WHITE, @x + 5, @y + 5, Gosu::Color::WHITE, @x - 5, @y + 5, Gosu::Color::WHITE, ZOrder::BALL)
    end
  end
end
