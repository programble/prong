$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
require 'rectangle'
require 'zorder'

require 'gosu'

class Ball < Rectangle
  attr_accessor :angle, :speed
  attr_reader :x, :y, :width, :height

  def initialize(window, width, height)
    super(window, width, height, Gosu::Color::WHITE, ZOrder::BALL, true, ZOrder::BALL_GLOW)
  end
  
  def move
    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)
    
    # Top/Bottom collision
    if Gosu::distance(@x, @y, @x, 0) <= @speed || Gosu::distance(@x, @y, @x, @window.height) <= @speed
      @angle = 180 - @angle
    end
  end
end
