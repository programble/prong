$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
require 'rectangle'
require 'zorder'

require 'gosu'

class Ball < Rectangle
  attr_accessor :angle, :speed
  attr_reader :x, :y, :width, :height

  def initialize(window, width, height)
    super(window, width, height, Gosu::Color::WHITE, ZOrder::BALL, true, ZOrder::BALL_GLOW)
    @blurs = []
  end
  
  def move
    blur = Rectangle.new(@window, @width, @height, @color, ZOrder::BALL_BLUR, true, ZOrder::BALL_BLUR_GLOW)
    blur.warp(@x, @y)
    blur.angle = @angle
    @blurs.unshift(blur)
    @blurs = @blurs[0..5]
    @blurs.each do |x|
      new_alpha = x.color.alpha - 60
      new_alpha < 0 && new_alpha = 0
      x.color = Gosu::Color.new(new_alpha, x.color.red, x.color.green, x.color.blue)
    end
    
    @x += Gosu::offset_x(@angle, @speed)
    @y += Gosu::offset_y(@angle, @speed)
    
    # Top/Bottom collision
    if Gosu::distance(@x, @y, @x, 0) <= @speed || Gosu::distance(@x, @y, @x, @window.height) <= @speed
      @angle = 180 - @angle
    end
  end
  
  def draw
    super
    @blurs.each do |blur|
      blur.draw
    end
  end
end
