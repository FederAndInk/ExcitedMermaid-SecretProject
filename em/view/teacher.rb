require "em/view/parameter"
require("observer")
require("em/model/weaponType")
require("em/view/MenuItem")

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
    @weapon = nil
    @weaponType
    @j = 0
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

  def setWeapon(weapon, weaponType)
    @weapon = weapon
    @weaponPicture = Gosu::Image.new(@meh, ASSETPATH+"#{weapon}x20.png", false)
    @weaponType = weaponType
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
    @mBegin = [Gosu.milliseconds / ATTACKSPEED].first()
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
      if @isPrio
        @arm = Gosu::Image.new(@meh, ASSETPATH+"arm#{@name}x20.png", false)
      end
    elsif @state == "idle"
      @image = @idle
      if @isPrio
        @arm = Gosu::Image.new(@meh, ASSETPATH+"arm#{@name}x20.png", false)
      end
    elsif @state == "hit"
      if @isPrio
        @image = @hitted
      else
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
    #    bx = @posx + 211
    #    by = @posy + 394
    #    ox = @posx + 273
    #    oy = @posy + 231
    oy = @posy + 231
    by = @posy + 320
    
    if @flip == 1
      bx = @posx + 280
      ox = @posx + 273
    else
      bx = @posx + 280 - 535
      ox = @posx + 273 - 537
    end
    
    cur = @meh.getCursorPos()
    ax = cur[0]
    ay = cur[1]
    #    angle = Math.atan2(p3y - p1y, p3x - p1x) - atan2(p2y - p1y, p2x, p1x)
    angle = Math.atan(((ax-ox)*(by-oy)+(ay-oy)*(bx-ox)) / ((ax-ox)*(bx-ox)-(ay-oy)*(by-oy)))
    angle = (angle*180)/(Math::PI)
    #    if(angle < 0)
    #      angle = 180 + angle;
    #    end
    a = (by.to_f-oy.to_f ) / ((bx.to_f-ox.to_f))
    b = oy-a*ox
    y = a*ax+b
    if angle < 0
      angle = angle + 180
    end
    if (y > ay)
      angle = angle + 180
    end
    if (angle > 170 && angle < 180)
      angle += 540
    end
    if (angle > 351 && angle < 360)
      angle += 540
    end
    #    if @weaponType == MELEE
    #      @arm.draw @posx, @posy, @prio, @flip
    #    else
    #    end

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
    #      puts(@weaponType)

    # entite draw
    @image.draw @posx, @posy, @prio, @flip, 1, colour

    if @state == "dead" or @state == "hit" or !@isPrio
    elsif @weaponType == WEAPONTYPE::RANGED and !(@state == "dead" or @state == "hit")
      pointa = (@arm.width().to_f - (@arm.width().to_f - 273.0)) / @arm.width.to_f
      pointb = (@arm.height().to_f - (@arm.height().to_f - 231.0)) / @arm.height().to_f
      #      if @weapon
      #        @weaponPicture.draw_rot(@posx, @posy,@prio, angle, pointa, pointb, @flip)
      #      end
      #      puts(angle)
      if @flip == 1
        @weaponPicture.draw_rot(@posx+273, @posy+231,@prio, angle, pointa, pointb, @flip)
        @arm.draw_rot @posx+273, @posy+231,@prio, angle, pointa, pointb, @flip
      else
        @weaponPicture.draw_rot(@posx-273, @posy+231,@prio, angle, pointa, pointb, @flip)
        @arm.draw_rot @posx-273, @posy+231,@prio, angle, pointa, pointb, @flip
      end
    elsif @weaponPicture
      pointa = (@arm.width().to_f - (@arm.width().to_f - 273.0)) / @arm.width.to_f
      pointb = (@arm.height().to_f - (@arm.height().to_f - 231.0)) / @arm.height().to_f
      if @j== 0
        @weaponPicture.draw @posx,@posy,@prio, @flip
        @arm.draw @posx, @posy, @prio, @flip, 1
      end
      #      attack handler draw
      if (@attack == Attaque::BAS)
        #        @image = @walk.at(@i.first())
        #        @mele = Gosu::Image.load_tiles(ASSETPATH+"Coup#{@attack}x20.png",640,640)
        @m = [Gosu.milliseconds / ATTACKSPEED].first() - @mBegin
        if @j < 170
          if @flip == 1
            @weaponPicture.draw_rot(@posx+273, @posy+231,@prio, 180+20+@j, pointa, pointb, @flip)
            @arm.draw_rot @posx+273, @posy+231,@prio, 180+20+@j, pointa, pointb, @flip
          else
            @weaponPicture.draw_rot(@posx-273, @posy+231,@prio, 180+20+@j, pointa, pointb, @flip)
            @arm.draw_rot @posx-273, @posy+231,@prio, 180+20+@j, pointa, pointb, @flip
          end
          @j += 8
        else
          @j = 0
          setAttack()
        end
        #        @weaponPicture.draw @posx,@posy,@prio, @flip
        #        @arm.draw @posx, @posy, @prio, @flip, 1
      elsif(@attack == Attaque::ESTOC)
        #        if  = [Gosu.milliseconds / ATTACKSPEED].first() - @mBegin
        if @j < 90
          if @flip == 1
            @weaponPicture.draw_rot(@posx+273, @posy+231,@prio, -@j, pointa, pointb, @flip)
            @arm.draw_rot @posx+273, @posy+231,@prio, -@j, pointa, pointb, @flip
          else
            @weaponPicture.draw_rot(@posx-273, @posy+231,@prio, -@j, pointa, pointb, @flip)
            @arm.draw_rot @posx-273, @posy+231,@prio, -@j, pointa, pointb, @flip
          end
          @j += 3
        else
          @j = 0
          setAttack()
        end
      else
        @weaponPicture.draw @posx,@posy,@prio, @flip
        @arm.draw @posx, @posy, @prio, @flip, 1
      end
    else
      @arm.draw @posx, @posy, @prio, @flip, 1
    end
  end
end
