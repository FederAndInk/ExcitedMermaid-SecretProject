  require 'gosu'
  require 'em/view/teacher'
  require 'em/view/background'
  class Game < Gosu::Window
    def initialize
      super 4800,2700, false
      
      @blanchon = Teacher.new self,"Blanchon"
      @backdrop = Background.new self, "coridor"
      
      @blanchon.move_To(1500,1200)
      
    end
    
    def draw
      @backdrop.draw
      @blanchon.draw 
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
        @blanchon.setmoving(true)
        @blanchon.moveUp() 
      elsif button_down? char_to_button_id("s")
        @blanchon.setmoving(true)
        @blanchon.moveDown()
      elsif button_down? char_to_button_id("d")
        @blanchon.setmoving(true)
        @blanchon.moveRight()
      elsif button_down? char_to_button_id("q")
        @blanchon.setmoving(true)
        @blanchon.moveLeft()
      else
        @blanchon.setmoving(false)
      end
    end
  end
Game.new.show
