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
    
    @frames = 0
    @framerate = 1
    @framerate_start = Time.new
    
    @show_fps = false
    @debug = false
    
    @fps_font = Gosu::Font.new(self, Gosu::default_font_name, 15)
    @score_font = Gosu::Font.new(self, File.join(File.dirname(__FILE__), '..', 'media', 'imagine_font.ttf'), 40)
    @debug_font = Gosu::Font.new(self, Gosu::default_font_name, 20)
    
    @ball = Ball.new(self, 10, 10)
    @ball.angle = 45
    @ball.warp(width / 2.0, height / 2.0)
    
    @player_paddle = Paddle.new(self, 10, 60, 0.25)
    @player_paddle.warp(20, height / 2)
    
    @ai_paddle = PerfectAIPaddle.new(self, 10, 60, 0.125)
    @ai_paddle.warp(width - 20, height / 2)
  end
  
  def serve
    @ball.speed = 2.0 if @ball.speed == 0.0
  end

  def update
    @ball.move([@player_paddle, @ai_paddle])
    @player_paddle.destination = mouse_y
    @player_paddle.move
    @ai_paddle.calculate(@ball)
    @ai_paddle.move
  end
  
  def button_down(id)
    case id
    when Gosu::Button::MsLeft
      serve
    when Gosu::Button::KbEscape
      close
    when Gosu::Button::KbF2
      @show_fps = !@show_fps
    when Gosu::Button::KbF3
      @debug = !@debug
    end
  end

  def draw
    @frames += 1
    
    @debug_font.draw("(#{@ball.x.round},#{@ball.y.round}) angle: #{@ball.angle} speed: #{@ball.speed.round(2)}", 0, 0, ZOrder::DEBUG, 1.0, 1.0, Gosu::Color::GREEN) if @debug
    
    # Background
    draw_quad(0, 0, Gosu::Color::BLACK, width, 0, Gosu::Color::BLACK, 0, height, Gosu::Color::BLACK, width, height, Gosu::Color::BLACK, ZOrder::BACKGROUND)
    
    if @show_fps
      fps = "#{@framerate.round} FPS"
      @fps_font.draw(fps, width - @fps_font.text_width(fps), 0, ZOrder::FPS, 1.0, 1.0, Gosu::Color::WHITE)
    end
    
    @score_font.draw(@player_paddle.score.to_s, width / 2 - 10 - @score_font.text_width(@player_paddle.score.to_s), 10, ZOrder::SCORE, 1.0, 1.0, Gosu::Color::WHITE)
    @score_font.draw(@ai_paddle.score.to_s, width / 2 + 10, 10, ZOrder::SCORE, 1.0, 1.0, Gosu::Color::WHITE)
    
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
