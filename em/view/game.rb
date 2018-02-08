require 'gosu'
require 'em/view/teacher'
require 'em/view/VArme'
require 'em/view/background'

class Game < Gosu::Window
  attr_accessor(:player)
  def initialize
    super 4800,2660, false

    @toDraw = []
    @toDraw << Background.new(self, "classroom")

    @keys = Array.new()

  end

  def newTeacher(name, nameId, observer, isPrio = false)
    @toDraw << Teacher.new(self, name, nameId, isPrio)
    @toDraw.last().add_observer(observer, :entityViewUpdate)
    return @toDraw.last()
  end

  def newArme(name, nameId, observer, isPrio = false)
    @toDraw << VArme.new(self, name, nameId, isPrio)
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

  def button_down(key)
    k = button_id_to_char(key)
    if ["z","q","s","d"].include?(k)
      @keys.push(k)
    end
    if key == Gosu::MS_LEFT
      @player.setAttack("Estoc")
    elsif key == Gosu::MS_RIGHT
      @player.setAttack("Bas")
    end
  end

  def button_up(key)
    k = button_id_to_char(key)
    if ["z","q","s","d"].include?(k)
      @keys.delete(k)
    end
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

