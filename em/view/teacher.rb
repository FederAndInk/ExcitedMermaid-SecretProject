require "em/view/parameter"
require("observer")

class Teacher
  include(Observable)
  attr_reader :name , :posy

  SPEED = 20
  ATTACKSPEED = 50
  def initialize(window, name, type)
    @meh = window
    @name = name
    #      @image = Gosu::Image.new(window, "assets/Character#{name}x20.png", false)
    @walk = Gosu::Image.load_tiles(ASSETPATH+"Character#{name}Walkingx20.png",640,640)
    @posx = 0
    @posy = 0
    @image = @walk.first
    @state = "idle"
    @attack
    if type == "boss"
      @flip = -1
    else
      @flip = 1
    end
  end

  def move_To(x,y)
    @posx = x
    @posy = y
  end

  def setmoving
    @state = "move"
    changed()
    notify_observers([@posx,@posy], self)
  end

  def setIdle
    @state = "idle"
  end

  def setAttack(type = "rien")
    #      puts "#{@attack}"
    @attack = type
    @mBegin = [Gosu.milliseconds / ATTACKSPEED].first()
  end

  def moveLeft
    @posx -= SPEED if ((@posx - SPEED) > 640-150)
    if @flip == 1
      @posx +=640
    end
    @flip = -1
  end

  def moveRight
    @posx += SPEED if ((@posx - SPEED) < 4800-480)
    if @flip == -1
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
    if @state == "move"
      @image = @walk.at(@i.first())
    elsif @state == "idle"
      @image = Gosu::Image.new(@meh, ASSETPATH+"Character#{@name}x20.png", false)
    end

    #attack handler draw
    if (@attack == "Estoc" or @attack == "Bas")
      #        @image = @walk.at(@i.first())
      @mele = Gosu::Image.load_tiles(ASSETPATH+"Coup#{@attack}x20.png",640,640)
      @m = [Gosu.milliseconds / ATTACKSPEED].first() - @mBegin
      puts(@m)
      @attackPicture = @mele.at(@m)
      if @attackPicture # test si on sort pas du vecteur
        if @flip == -1
          @attackPicture.draw @posx-220, @posy, 51, @flip
        else
          @attackPicture.draw @posx+220, @posy, 51, @flip
        end
      end
      if (@m >= @mele.length()-1)
        setAttack()
      end
    end
    @image.draw @posx, @posy, 50, @flip
  end
end
