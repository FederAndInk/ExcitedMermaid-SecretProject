require "em/view/parameter"
require("observer")

class Teacher
  include(Observable)
  attr_reader :name, :nameId, :posy, :prio

  SPEED = 20
  ATTACKSPEED = 75
  def initialize(window, name, nameId, isPrio)
    @meh = window
    @name = name
    @nameId = nameId
    @isPrio = isPrio
    #      @image = Gosu::Image.new(window, "assets/Character#{name}x20.png", false)
    @walk = Gosu::Image.load_tiles(ASSETPATH+"Character#{name}Walkingx20.png",640,640)
    @posx = 0
    @posy = 0
    @prio = @posy
    @flip = 1
    @image = @walk.first
    @state = "idle"
    @attack
  end

  def setPrio(nb = @posy)
    @prio = nb
    if @isPrio
      @prio += 1
    end
  end

  def moveTo(x,y)
    @posx = x
    @posy = y
  end

  def getPosition()
    return Hash["x" => @posx, "y" => @posy]
  end

  def setmoving()
    @state = "move"
    changed()
    notify_observers(Action::ENTITY_MOVED, self)
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
      @attackPicture = @mele.at(@m)
      if @attackPicture # test si on sort pas du vecteur
        if @flip == -1
          @attackPicture.draw @posx-220, @posy, @prio, @flip
        else
          @attackPicture.draw @posx+220, @posy, @prio, @flip
        end
      end
      if (@m >= @mele.length()-1)
        setAttack()
      end
    end
    @image.draw @posx, @posy, @prio, @flip
  end
end
