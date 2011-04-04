$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
require 'zorder'
require 'ball'

require 'gosu'

class GameWindow < Gosu::Window
  def initialize(width, height, fullscreen)
    super(width, height, fullscreen)
    self.caption = "Prong"
    
    @debug_font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    
    @framerate = 0.0
    
    @ball = Ball.new(self, 10, 10)
    @ball.speed = 1.0
    @ball.angle = 0
    @ball.warp(width / 2.0, height / 2.0)
  end

  def update
    @ball.move
    @ball.speed += 0.01
  end

  def draw
    frame_start = Time.new
    
    @debug_font.draw("(#{@ball.x.round},#{@ball.y.round}) #{@ball.angle} #{@ball.speed.round(2)}", 0, 0, ZOrder::DEBUG, 1.0, 1.0, Gosu::Color::GREEN)
    @debug_font.draw(@framerate.ceil.to_s, 0, 20, ZOrder::DEBUG, 1.0, 1.0, Gosu::Color::GREEN)
    
    # Background
    draw_quad(0, 0, Gosu::Color::BLACK, width, 0, Gosu::Color::BLACK, 0, height, Gosu::Color::BLACK, width, height, Gosu::Color::BLACK, ZOrder::BACKGROUND)
    
    @ball.draw
    
    @framerate = 60 / (Time.new - frame_start) / 10000
  end
end
