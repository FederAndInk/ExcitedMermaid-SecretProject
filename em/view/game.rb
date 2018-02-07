require 'gosu'
require 'em/view/teacher'
require 'em/view/background'

class Game < Gosu::Window
  attr_accessor(:teacher)
  def initialize
    super 4800,2700, false

    @toDraw = []
    @toDraw << Background.new(self, "coridor")

    #      @blanchon.move_To(1500,1200)

  end

  def newTeacher(name, nameId, observer)
    @toDraw << Teacher.new(self, name, nameId)
    @toDraw.last().add_observer(observer, :entityViewUpdate)
    return @toDraw.last()
  end
  
  def draw
    @toDraw.each(){ |drawable|
      drawable.draw
    }
  end

  #    def button_down(key)
  #        @blanchon.setmoving(true)
  #    end
  #
  #    def button_up(key)
  #      @blanchon.setmoving(false)
  #    end

  def update
    if button_down? char_to_button_id("z")
      @teacher.moveUp()
      @teacher.setmoving(true)
    elsif button_down? char_to_button_id("s")
      @teacher.moveDown()
      @teacher.setmoving(true)
    elsif button_down? char_to_button_id("d")
      @teacher.moveRight()
      @teacher.setmoving(true)
    elsif button_down? char_to_button_id("q")
      @teacher.moveLeft()
      @teacher.setmoving(true)
    else
      @teacher.setmoving(false)
    end
  end
end
