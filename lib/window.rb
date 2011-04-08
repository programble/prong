$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
require 'zorder'
require 'ball'
require 'paddle'

require 'rubygems'
require 'gosu'

class GameWindow < Gosu::Window
  def initialize(width, height, fullscreen)
    super(width, height, fullscreen)
    self.caption = "Prong"
    
    @fps_font = Gosu::Font.new(self, Gosu::default_font_name, 15)
    @debug_font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    
    @frames = 0
    @framerate = 1
    @framerate_start = Time.new
    
    @ball = Ball.new(self, 10, 10)
    @ball.speed = 2.0
    @ball.angle = 45
    @ball.warp(width / 2.0, height / 2.0)
    
    @player_paddle = Paddle.new(self, 10, 60, 0.5)
    @player_paddle.warp(20, height / 2)
    
    @ai_paddle = PerfectAIPaddle.new(self, 10, 60, 0.5)
    @ai_paddle.warp(width - 20, height / 2)
  end

  def update
    @ball.move([@player_paddle, @ai_paddle])
    @player_paddle.destination = mouse_y
    @player_paddle.move
    @ai_paddle.calculate(@ball)
    @ai_paddle.move
  end

  def draw
    @frames += 1
    
    @debug_font.draw("(#{@ball.x.round},#{@ball.y.round}) angle: #{@ball.angle} speed: #{@ball.speed.round(2)}", 0, 0, ZOrder::DEBUG, 1.0, 1.0, Gosu::Color::GREEN)
    
    # Background
    draw_quad(0, 0, Gosu::Color::BLACK, width, 0, Gosu::Color::BLACK, 0, height, Gosu::Color::BLACK, width, height, Gosu::Color::BLACK, ZOrder::BACKGROUND)
    
    fps = "#{@framerate.round} FPS"
    @fps_font.draw(fps, width - @fps_font.text_width(fps), 0, ZOrder::FPS, 1.0, 1.0, Gosu::Color::WHITE)
    
    @ball.draw
    @player_paddle.draw
    @ai_paddle.draw
    
    if Time.new - @framerate_start >= 1.0
      @framerate = @frames
      @frames = 0
      @framerate_start = Time.new
    end
  end
end
