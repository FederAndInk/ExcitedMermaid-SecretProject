require 'gosu'
require 'observer'
require 'em/view/teacher'
require 'em/view/background'
require 'em/model/Actions'

class Game < Gosu::Window
  include(Observable)
  def initialize()
    super 4800,2660, false
    fullscreen=($fullsc)
    @mus = $music
    @vol = $volume
    @toDraw = []
    @background =  Background.new(self, "classroom")
    @toDraw << @background
    @gameOver = false
    @keys = Array.new()
    @cursorPicture = Gosu::Image.new(self, ASSETPATH+"Curseurx20.png", false)
    @playButton = Gosu::Image.new(self,ASSETPATH+"jouer.png", false)
    @rejouer = MenuItem.new(self,@playButton,self.width/2-150, self.height/2,9999,lambda{notify_observers(Action::GAMEOVER, self)},"REJOUER",nil, true)
    @quitter = MenuItem.new(self,@playButton,self.width/2-150,self.height/2+250,9999,lambda{self.close},"QUITTER",nil, true)

  end

  def newTeacher(name, nameId, observer, isPrio = false)
    @toDraw << Teacher.new(self, name, nameId, isPrio)
    @toDraw.last().add_observer(observer, :entityViewUpdate)
    return @toDraw.last()
  end

  def draw
    @cursorPicture.draw(self.getCursorPos()[0]-40,self.getCursorPos()[1]-40,10000, 0.2, 0.2)
    if !@gameOver
      @toDraw.each(){ |drawable|
        drawable.draw
        if drawable.class.method_defined?("setPrio")
          drawable.setPrio()
        end
      }
    else
      @back.draw 0,0,990,self.width.to_f/@back.width.to_f, self.height.to_f/@back.height.to_f
      @rejouer.draw(0.1, 0.1)
      @quitter.draw(0.1, 0.1)
    end
  end

  def deleteEntity(entity)
    @toDraw.delete(entity)
  end

  def button_down(key)
    k = button_id_to_char(key)
    if ["z","q","s","d"].include?(k)
      @keys.push(k)
    end
    if key == Gosu::MS_LEFT or key == Gosu::MS_RIGHT or key == Gosu::KB_SPACE and !@gameOver
      #      @player.setAttack("Estoc")
      puts"nop"
      notify_observers(key, self)
      #    elsif key == Gosu::MS_RIGHT
      #      @player.setAttack("Bas")
      #       notify_observers(key, self)
    elsif @gameOver
      @quitter.clicked()
      @rejouer.clicked()
    end
  end

  def button_up(key)
    k = button_id_to_char(key)
    if ["z","q","s","d"].include?(k)
      @keys.delete(k)
    end
  end

  def gameOver
    @back = Gosu::Image.new(self,ASSETPATH+"Jaquette.png", false)
    @gameOver = true
  end

  def player=(player)
    @player = player
    @background.setPlayer(player)
  end

  def boss=(boss)
    @background.setBoss(boss)
  end

  def getCursorPos()
    return [mouse_x, mouse_y]
  end

  def update
    if(@keys.include?('z'))
      @player.moveUp()
      @player.setmoving
    end
    
    if @keys.include?('s')
      @player.moveDown()
      @player.setmoving
    end
    
    if @keys.include?('d')
      @player.moveRight()
      @player.setmoving
    end

    if @keys.include?('q')
      @player.moveLeft()
      @player.setmoving
    end

    if @keys.empty?()
      @player.setIdle
    end
    #        if button_down?(Gosu::MS_LEFT)
    #      @player.setAttack("Estoc")
    #    else
    #      @player.setAttack("meh")

    #        end
    @quitter.update()
    @rejouer.update()
  end
end

