require "em/view/parameter"
require("observer")

module Attaque
  ESTOC = "Estoc"
  BAS = "Bas"
end

class Teacher
  include(Observable)
  attr_reader :name, :nameId, :posy, :prio, :flip

  SPEED = 20
  ATTACKSPEED = 75
  def initialize(window, name, nameId, isPrio)
    @meh = window
    @name = name
    @nameId = nameId
    @isPrio = isPrio
    #      @image = Gosu::Image.new(window, "assets/Character#{name}x20.png", false)
    @walk = Gosu::Image.load_tiles(ASSETPATH+"Character#{name}Walkingx20.png",640,640)
    if isPrio
      @die = Gosu::Image.load_tiles(ASSETPATH+"Character#{name}Diex20.png", 640,640)
      @hitted = Gosu::Image.new(@meh, ASSETPATH+"Character#{name}Hitx20.png", false)
    else
      @die = Gosu::Image.load_tiles(ASSETPATH+"BossDeath-Shee0x20t.png", 640,640)
      @hitted = Gosu::Image.new(@meh, ASSETPATH+"Character#{name}x20.png", false)
    end
    @idle = Gosu::Image.new(@meh, ASSETPATH+"Character#{name}x20.png", false)
    @posx = 0
    @posy = 0
    @prio = @posy
    @flip = 1
    @image = @walk.first
    @state = "idle"
    @attack
    @mbegin = 1
    @hittedState = 999
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
    if @state != "dead" and @hittedState >= 50
      @state = "move"
      changed()
      notify_observers(Action::ENTITY_MOVED, self)
    end
  end

  def setIdle
    if @state != "dead" and @hittedState >= 50
      @state = "idle"
    end
  end

  def setAttack(type = "rien")
    #      puts "#{@attack}"
    @attack = type
    @attackBegin = [Gosu.milliseconds / ATTACKSPEED].first()
  end

  def moveLeft
    if @state != "hit"
      @posx -= SPEED if ((@posx - SPEED) > 640-150)
      if @flip == 1
        @posx +=640
      end
      @flip = -1
    end
  end

  def moveRight
    if @state != "hit"
      @posx += SPEED if ((@posx - SPEED) < 4800-480)
      if @flip == -1
        @posx -=640
      end
      @flip = 1
    end
  end

  def moveUp
    if @state != "hit"
      @posy -= SPEED  if ((@posy - SPEED) > 100)
    end
  end

  def moveDown
    if @state != "hit"
      @posy += SPEED if ((@posy - SPEED) < 2200-640)
    end
  end

  def setDead()
    @state = "dead"
    @mbegin = [Gosu.milliseconds / 120].first()
  end

  def setHit()
    @hittedState = 0
    @state = "hit"
  end

  def draw
    colour = 0xff_ffffff
    if @state == "move"
      @i = [Gosu.milliseconds / 125 % @walk.length]
      @image = @walk.at(@i.first())
    elsif @state == "idle"
      @image = @idle
    elsif @state == "hit"
      if @isPrio
        @image = @hitted
      else
        puts"aaaaaaaaaaah"
        puts(@hittedState)
        colour = 0xff_ff0000
      end
      @hittedState += 1
      if @hittedState >= 51
        setIdle()
      end
    elsif @state == "dead"
      @m = [Gosu.milliseconds / 150].first()
      @m -= @mbegin
      if @isPrio and @m < @die.length
        @image = @die.at(@m)
      elsif @m < @die.length
        @image = @die.at(@m)
        @idle.draw(@posx, @posy, @prio, @flip)
      else
        @meh.deleteEntity(self)
      end
    end

    #attack handler draw
    if (@attack == Attaque::ESTOC or @attack == Attaque::BAS)
      #        @image = @walk.at(@i.first())
      @mele = Gosu::Image.load_tiles(ASSETPATH+"Coup#{@attack}x20.png",640,640)
      @m = [Gosu.milliseconds / ATTACKSPEED].first() - @attackBegin
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
    @image.draw @posx, @posy, @prio, @flip, 1, colour
  end
end
