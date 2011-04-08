$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
require 'rectangle'
require 'zorder'

require 'rubygems'
require 'gosu'

class Paddle < Rectangle
  attr_accessor :destination
  
  def initialize(window, width, height, speed)
    super(window, width, height, Gosu::Color::WHITE, ZOrder::PADDLE, true, ZOrder::PADDLE_GLOW)
    @speed = speed
    @destination = 0
  end
  
  def move
    @y -= (@y - @destination) * @speed
  end
end

class PerfectAIPaddle < Paddle
  def calculate(ball)
    @destination = ball.y
  end
end
