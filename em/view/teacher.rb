  require "em/view/parameter"
  require "observer"
  class Teacher
    include(Observable)
    SPEED = 20
    
    attr_reader(:name, :nameId)
    
    def initialize(window, name, nameId)
      @meh = window
      @name = name
      @nameId = nameId
#      @image = Gosu::Image.new(window, "assets/Character#{name}x20.png", false)
      @walk = Gosu::Image.load_tiles(ASSETPATH+"Character#{name}Walkingx20.png",640,640)
      @posx = 0
      @posy = 0
      @image = @walk.first
      @moving = false
      @flip = 1
    end
    
    def moveTo(x,y)
      @posx = x
      @posy = y
    end
    
    def getPosition()
      return Hash["x" => @posx, "y" => @posy]
    end
    
    def setmoving(yes = true)
        @moving = yes
      if @moving
        changed()
        notify_observers(Action::ENTITY_MOVED, self)
      end
    end
    
    def moveLeft
      @posx -= SPEED if ((@posx - SPEED) > 640-150)
      if @flip == 1
        puts"#{@flip}"
        @posx +=640
      end
      @flip = -1
    end
    def moveRight
      @posx += SPEED if ((@posx - SPEED) < 4800-480)
      if @flip == -1
        puts"#{@flip}"
        @posx -=640
      end
      @flip = 1
    end
    def moveUp
      @posy -= SPEED  if ((@posy - SPEED) > 100)
    end
    def moveDown
      @posy += SPEED if ((@posy - SPEED) < 2200-640)
    end
    
    def draw
      @i = [Gosu.milliseconds / 125 % @walk.length]
#      puts"#{@i}"
#      puts"#{@walk.length}"
      if @moving
        @image = @walk.at(@i.first())
      else 
        @image = Gosu::Image.new(@meh, ASSETPATH+"Character#{@name}x20.png", false)
      end
      @image.draw @posx, @posy, 99, @flip
    end
    
  end
