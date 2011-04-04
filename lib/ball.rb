$LOAD_PATH.unshift(File.join(File.dirname(__FILE__)))
require 'zorder'

require 'gosu'

class Ball
  attr_accessor :angle, :speed
  attr_reader :x, :y, :width, :height

  def initialize(window, width, height)
    @window = window
    @x = @y = @angle = @speed = 0
    @width, @height = width, height
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
      @window.translate(@x, @y) do
        hw, hh = @width / 2.0, @height / 2.0
        # Ball
        @window.draw_quad(-hw, -hh, Gosu::Color::WHITE, 
                           hw, -hh, Gosu::Color::WHITE, 
                           hw,  hh, Gosu::Color::WHITE, 
                          -hw,  hh, Gosu::Color::WHITE, 
                          ZOrder::BALL)
        # Top Glow
        @window.draw_quad(-hw, -hh,      Gosu::Color::WHITE, 
                          -hw, -@height, Gosu::Color::NONE, 
                           hw, -@height, Gosu::Color::NONE, 
                           hw, -hh,      Gosu::Color::WHITE, 
                          ZOrder::BALL_GLOW)
        # Right Glow
        @window.draw_quad(hw,     -hh, Gosu::Color::WHITE, 
                          @width, -hh, Gosu::Color::NONE, 
                          @width,  hh, Gosu::Color::NONE, 
                          hw,      hh, Gosu::Color::WHITE, 
                          ZOrder::BALL_GLOW)
        # Bottom Glow
        @window.draw_quad(-hw, hh,      Gosu::Color::WHITE, 
                           hw, hh,      Gosu::Color::WHITE, 
                           hw, @height, Gosu::Color::NONE, 
                          -hw, @height, Gosu::Color::NONE, 
                          ZOrder::BALL_GLOW)
        # Left Glow
        @window.draw_quad(-hw,     -hh, Gosu::Color::WHITE, 
                          -hw,      hh, Gosu::Color::WHITE, 
                          -@width,  hh, Gosu::Color::NONE, 
                          -@width, -hh, Gosu::Color::NONE, 
                          ZOrder::BALL_GLOW)
        # Top/Right Glow
        @window.draw_triangle(hw,     -hh,      Gosu::Color::WHITE, 
                              hw,     -@height, Gosu::Color::NONE, 
                              @width, -hh,      Gosu::Color::NONE, 
                              ZOrder::BALL_GLOW)
        # Bottom/Right Glow
        @window.draw_triangle(hw,     hh,      Gosu::Color::WHITE, 
                              @width, hh,      Gosu::Color::NONE, 
                              hw,     @height, Gosu::Color::NONE, 
                              ZOrder::BALL_GLOW)
        # Bottom/Left Glow
        @window.draw_triangle(-hw,     hh,      Gosu::Color::WHITE, 
                              -hw,     @height, Gosu::Color::NONE, 
                              -@width, hh,      Gosu::Color::NONE, 
                              ZOrder::BALL_GLOW)
        # Top/Left Glow
        @window.draw_triangle(-hw,     -hh,      Gosu::Color::WHITE, 
                              -@width, -hh,      Gosu::Color::NONE, 
                              -hw,     -@height, Gosu::Color::NONE, 
                              ZOrder::BALL_GLOW)
      end
    end
  end
end
