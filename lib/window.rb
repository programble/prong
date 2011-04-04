$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
require 'zorder'
require 'ball'

require 'gosu'

class GameWindow < Gosu::Window
  def initialize(width, height, fullscreen)
    super(width, height, fullscreen)
    self.caption = "Prong"
    
    @debug_font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    
    @ball = Ball.new(self)
    @ball.speed = 4.0
    @ball.angle = 0
    @ball.warp(width / 2.0, height / 2.0)
  end

  def update
    @ball.move
  end

  def draw
    @debug_font.draw("(#{@ball.x.round},#{@ball.y.round}) #{@ball.angle}", 0, 0, ZOrder::DEBUG, 1.0, 1.0, Gosu::Color::GREEN)
    
    # Background
    draw_quad(0, 0, Gosu::Color::BLACK, width, 0, Gosu::Color::BLACK, 0, height, Gosu::Color::BLACK, width, height, Gosu::Color::BLACK, ZOrder::BACKGROUND)
    
    @ball.draw
  end
end
