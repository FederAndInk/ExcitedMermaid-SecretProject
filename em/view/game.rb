require 'gosu'
require 'observer'
require 'em/view/teacher'
require 'em/view/background'

class Game < Gosu::Window
  include(Observable)
  def initialize
    super 4800,2660, false

    @toDraw = []
    @background =  Background.new(self, "classroom")
    @toDraw << @background

    @keys = Array.new()

  end

  def newTeacher(name, nameId, observer, isPrio = false)
    @toDraw << Teacher.new(self, name, nameId, isPrio)
    @toDraw.last().add_observer(observer, :entityViewUpdate)
    return @toDraw.last()
  end

  def draw
    @toDraw.each(){ |drawable|
      drawable.draw
      if drawable.class.method_defined?("setPrio")
        drawable.setPrio()
      end
    }
  end
  
  def deleteEntity(entity)
    @toDraw.delete(entity)
  end
  
  def button_down(key)
    k = button_id_to_char(key)
    if ["z","q","s","d"].include?(k)
      @keys.push(k)
    end
    if key == Gosu::MS_LEFT or key == Gosu::MS_RIGHT or key == Gosu::KB_SPACE
#      @player.setAttack("Estoc")
       notify_observers(key, self)
#    elsif key == Gosu::MS_RIGHT
#      @player.setAttack("Bas")
#       notify_observers(key, self)
    end
  end

  def button_up(key)
    k = button_id_to_char(key)
    if ["z","q","s","d"].include?(k)
      @keys.delete(k)
    end
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
    case @keys.last()
    when 'z'
      @player.moveUp()
      @player.setmoving

    when 's'
      @player.moveDown()
      @player.setmoving

    when 'd'
      @player.moveRight()
      @player.setmoving

    when 'q'
      @player.moveLeft()
      @player.setmoving
    else
      @player.setIdle
    end
    #    if button_down?(Gosu::MS_LEFT)
    #      @player.setAttack("Estoc")
    #    else
    #      @player.setAttack("meh")
    #    end
  end
end

