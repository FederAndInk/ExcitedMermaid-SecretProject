  require "em/view/parameter"
  class Background 
    def initialize(window, room)
      case room
      when "coridor"
        @ground = Gosu::Image.new(window,ASSETPATH+"Plancherx20.png", false)
        @bottom = Gosu::Image.new(window,ASSETPATH+"PlancherPublicx20.png", false)
        @wall = Gosu::Image.new(window,ASSETPATH+"Murx20.png", false)
      when "classroom"
      end
    end
    def draw
      @wall.draw 0,0,0
      @ground.draw 0,620,0
      @bottom.draw 0,2200,0
    end
  end
