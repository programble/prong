require 'gosu'

class Rectangle
  attr_accessor :angle, :color
  attr_reader :x, :y, :width, :height
  
  def initialize(window, width, height, color, zorder, glow, glow_zorder)
    @window = window
    @width, @height = width, height
    @color = color
    @zorder = zorder
    @glow = glow
    @glow_zorder = glow_zorder
    @x = @y = @angle = 0
  end
  
  def warp(x, y)
    @x, @y = x, y
  end
  
  def draw
    @window.rotate(@angle, @x, @y) do
      @window.translate(@x, @y) do
        hw, hh = @width / 2.0, @height / 2.0
        # Rectangle
        @window.draw_quad(-hw, -hh, @color, 
                           hw, -hh, @color, 
                           hw,  hh, @color, 
                          -hw,  hh, @color, 
                          @zorder)
        if @glow
          # Top Glow
          @window.draw_quad(-hw, -hh,      @color, 
                            -hw, -@height, Gosu::Color::NONE, 
                             hw, -@height, Gosu::Color::NONE, 
                             hw, -hh,      @color, 
                            @glow_zorder)
          # Right Glow
          @window.draw_quad(hw,     -hh, @color, 
                            @width, -hh, Gosu::Color::NONE, 
                            @width,  hh, Gosu::Color::NONE, 
                            hw,      hh, @color, 
                            @glow_zorder)
          # Bottom Glow
          @window.draw_quad(-hw, hh,      @color, 
                             hw, hh,      @color, 
                             hw, @height, Gosu::Color::NONE, 
                            -hw, @height, Gosu::Color::NONE, 
                            @glow_zorder)
          # Left Glow
          @window.draw_quad(-hw,     -hh, @color, 
                            -hw,      hh, @color, 
                            -@width,  hh, Gosu::Color::NONE, 
                            -@width, -hh, Gosu::Color::NONE, 
                            @glow_zorder)
          # Top/Right Glow
          @window.draw_triangle(hw,     -hh,      @color, 
                                hw,     -@height, Gosu::Color::NONE, 
                                @width, -hh,      Gosu::Color::NONE, 
                                @glow_zorder)
          # Bottom/Right Glow
          @window.draw_triangle(hw,     hh,      @color, 
                                @width, hh,      Gosu::Color::NONE, 
                                hw,     @height, Gosu::Color::NONE, 
                                @glow_zorder)
          # Bottom/Left Glow
          @window.draw_triangle(-hw,     hh,      @color, 
                                -hw,     @height, Gosu::Color::NONE, 
                                -@width, hh,      Gosu::Color::NONE, 
                                @glow_zorder)
          # Top/Left Glow
          @window.draw_triangle(-hw,     -hh,      @color, 
                                -@width, -hh,      Gosu::Color::NONE, 
                                -hw,     -@height, Gosu::Color::NONE, 
                                @glow_zorder)
        end
      end
    end
  end
end
