require "em/view/parameter"

class Background
  def initialize(window, room)
    @window = window
    @pvArrayP = []
    @buffArray = []
    @lifeBar = Gosu::Image.new(window,ASSETPATH+"IHM-TableauPVx20.png", false)
    @life = Gosu::Image.new(window,ASSETPATH+"IHM-PVPleinx20.png", false)
    @Nlife = Gosu::Image.new(window,ASSETPATH+"IHM-PVVidex20.png", false)
    @cursorPicture = Gosu::Image.new(@window, ASSETPATH+"Curseurx20.png", false)

    #FIXME : add methods changePortraitBoss/Player
    @buffCase = Gosu::Image.new(window,ASSETPATH+"IHM-TableauAmeliorationx20.png", false)
    @portrait = Gosu::Image.new(window,ASSETPATH+"IHM-TableauPortraitx20.png", false)
    case room
    when "coridor"
    when "classroom"
      @ground = Gosu::Image.new(window,ASSETPATH+"Plancherx20.png", false)
      @bottom = Gosu::Image.new(window,ASSETPATH+"PlancherPublicx20.png", false)
      @wall = Gosu::Image.new(window,ASSETPATH+"Murx20.png", false)
      @pub1 = Gosu::Image.new(window,ASSETPATH+"Publicx20.png", false)
      @pub2 = Gosu::Image.new(window,ASSETPATH+"Public2x20.png", false)
      @pvArrayB = []
    end
  end
  
  def setPlayer(player)
    @player = player
  end
  
  def setBoss(boss)
    @boss = boss
  end
  
  def setPvP(vie, vieMax)
    @pvArrayP.clear()
    if vie < vieMax
      for i in 1..vie
        @pvArrayP.push(0)
      end
      for i in vie+1..vieMax
        @pvArrayP.push(1)
      end
    else
      for i in 1..vieMax
        @pvArrayP.push(0)
      end
    end
  end

  def setPvB(vie, vieMax)
    @pvArrayB.clear()
    if vie < vieMax
      for i in 1 .. vieMax-vie
        @pvArrayB.push(1)
      end
      for i in 1 .. vie
        @pvArrayB.push(0)
      end
    else
      for i in 1..vieMax
        @pvArrayB.push(0)
      end
    end
    puts "#{@pvArrayB}"
  end
  
  def addBuff(name)
    picture = Gosu::Image.new(@window,ASSETPATH+"#{name}Buffx20.png", false)
    @buffArray.push(picture)
    puts"#{@buffArray}"
  end

  def removeBuff(pos)
    @buffArray.delete_at(pos)
    puts"#{@buffArray}"
  end

  def draw
    @cursorPicture.draw(@window.getCursorPos()[0]-20,@window.getCursorPos()[1]-20,99, 0.2, 0.2)
    @wall.draw 0,0,0
    #FIXME : add methods portrait
    @portrait.draw 40,40, 0
    @portrait.draw 4200, 40, 0
    if @player
      if @pvArrayP.count(1) == 0
        @Ppicture = Gosu::Image.new(@window,ASSETPATH+"#{@player.name}Fullx20.png", false)
      elsif @pvArrayP.count(1) >= @pvArrayP.length-1
        @Ppicture = Gosu::Image.new(@window,ASSETPATH+"#{@player.name}Lowx20.png", false)
      else
        @Ppicture = Gosu::Image.new(@window,ASSETPATH+"#{@player.name}Normalx20.png", false)
        #    elsif @pvArrayP.count(1) == @pvArrayP.length()
      end
      @Ppicture.draw 60,40,2
    end

    if @boss
#      if @pvArrayB.count(1) == 0
#        @Ppicture = Gosu::Image.new(@window,ASSETPATH+"#{@boss.name}Fullx20.png", false)
#      elsif @pvArrayB.count(1) >= @pvArrayB.length-1
#        @Ppicture = Gosu::Image.new(@window,ASSETPATH+"#{@boss.name}Lowx20.png", false)
#      else @pvArrayB.count(1) > 1 and @pvArrayB.count(1) < @pvArrayB.length()
        @Ppicture = Gosu::Image.new(@window,ASSETPATH+"#{@boss.name}Normalx20.png", false)
        #    elsif @pvArrayP.count(1) == @pvArrayP.length()
#      end
      @Ppicture.draw 4760,40,2, -1
    end

    #life and buff player
    @lifeBar.draw 620,40,1
    x = 540
    for i in 0 .. @pvArrayP.length-1
      x += 140
      if @pvArrayP[i] == 0
        @life.draw x,100,2
      else
        @Nlife.draw x,100,2
      end
      x += 20
    end
    for i in 0.. @buffArray.length-1
      @buffCase.draw 620+320*i,300,49
      @buffArray[i].draw 620+320*i+60,300+60,49
    end
    #life boss
    @lifeBar.draw 3270,40,1
    x = 3270-80
    for i in 0 .. @pvArrayB.length-1
      x += 140
      if @pvArrayB[i] == 0
        @life.draw x,100,2
      else
        @Nlife.draw x,100,2
      end
      x += 20
    end
    @bottom.draw 0,2200,0
    @ground.draw 0,620,0
    i = [Gosu.milliseconds / 3 %200].first()
    if i < 100
      mouv = -i
      mouv2 = i - 200
    else
      mouv = i - 200
      mouv2 = -i
    end
    @pub1.draw 320,2500 + mouv, 0
    @pub2.draw 320,2500 + mouv2, 0
  end
end
