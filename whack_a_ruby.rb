require 'gosu'

class WhackARuby < Gosu::Window
  def initialize()
    super(800,600)
    self.caption = 'Whack the Ruby!'
    @ruby_image = Gosu::Image.new('ruby.png')
    @x=150; @y=200
    @width=50; @height=43
    @velocity_x=5; @velocity_y=5
    @visible=0
    @hammer_image = Gosu::Image.new('hammer.png')
    @hit=0
    @font=Gosu::Font.new(30)
    @score=0
    @playing = true
    @start_time=0
    @hits=0
    @misses=0
  end

  def update
    if @playing
      @x+=@velocity_x
      @y+=@velocity_y
      @velocity_x*=-1 if (@x+@width/2)>800 || (@x-@width/2)<0
      @velocity_y*=-1 if (@y+@height/2)>600 || (@y-@height/2)<0
      @visible-=1
      @visible=35 if @visible<-10 && rand<0.012
      def button_down(id)
        if @playing
          if id==Gosu::MsLeft
            if Gosu.distance(mouse_x,mouse_y, @x, @y) < 55 && @visible >= 0
              @hit=1
              @score+=1000
              @hits+=1
            else
              @hit=-1
              @score-=200
              @misses+=1
            end
          end
        else
          if id==Gosu::KbSpace
            @playing = true
            @visible = -10
            @start_time = Gosu::milliseconds
            @score = 0
            @hits=0
            @misses=0
          end
        end
      end
      @time_left = (100 - ((Gosu.milliseconds-@start_time)/1000))
      @playing=false if @time_left<=0
    end
  end

  def draw
    @ruby_image.draw(@x - (@width/2), @y - (@height/2),1) if @visible>0
    @hammer_image.draw(mouse_x - 40, mouse_y - 10, 1)
    if @hit==0
      c = Gosu::Color::NONE
    elsif @hit==1
      c = Gosu::Color::GREEN
    elsif @hit==-1
      c = Gosu::Color::RED
    end
    draw_quad(0,0,c,800,0,c,800,600,c,0,600,c)
    @hit=0
    @font.draw("Score: #{@score}",600, 20, 2)
    @font.draw("Time left: #{@time_left}s", 20, 20, 3)
    unless @playing
      @font.draw('Game Over', 300,300,1)
      @font.draw('Press the Space Bar to Play Again', 175, 350, 3)
      @visible = 20
      @font.draw("You have #{@hits} hits,", 100, 100, 3)
      @font.draw("and #{@misses} misses.", 100, 130, 3)
    end
  end
end

window = WhackARuby.new
window.show
