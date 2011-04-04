$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
require 'rectangle'
require 'zorder'

require 'rubygems'
require 'gosu'

class DropArray < Array
  def initialize(max)
    @max = max
  end
  
  def unshift(obj)
    pop if length == @max
    super(obj)
  end
end

class Ball < Rectangle
  attr_accessor :angle, :speed
  attr_reader :x, :y, :width, :height

  def initialize(window, width, height)
    super(window, width, height, Gosu::Color::WHITE, ZOrder::BALL, true, ZOrder::BALL_GLOW)
    @blurs = DropArray.new(4)
  end
  
  def move(paddles)
    blur = Rectangle.new(@window, @width, @height, @color, ZOrder::BALL_BLUR, true, ZOrder::BALL_BLUR_GLOW)
    blur.warp(@x, @y)
    blur.angle = @angle
    @blurs.unshift(blur)
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
    # FIXME: Remove Testing Code
    if Gosu::distance(@x, @y, 0, @y) <= @speed || Gosu::distance(@x, @y, @window.width, @y) <= @speed
      @angle = 360 - @angle
    end
    
    # Collide with paddles
    paddles.each do |paddle|
      if @y > paddle.y - paddle.height / 2 && @y < paddle.y + paddle.height / 2 && Gosu::distance(@x, @y, paddle.x, @y) <= @speed
        @angle = 360 - @angle
      end
    end
  end
  
  def draw
    super
    @blurs.each do |blur|
      blur.draw
    end
  end
end
