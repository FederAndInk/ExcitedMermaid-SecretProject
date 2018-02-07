require 'gosu'
require 'em/view/menu'
require 'em/view/MenuItem'
require 'em/view/parameter'
require 'em/view/game'

class MainMenu < Gosu::Window
  def initialize
      super(640, 640, false)
      @cursor = Gosu::Image.new(self, ASSETPATH+"Curseurx20.png", false)
      x = self.width / 2 - 100
      y = self.height  / 2 - 100
      lineHeight = 150
      self.caption = "red glasses"
      
      #array a modifier pour les boutons
      nbButton = 3
      texts = [" jouer", "option", "quitter"]
      
      items = Array.new(nbButton,"jouer")
      actions = Array[lambda { Game.new.show}, lambda {
#        @menu.add_item(Gosu::Image.new(self, ASSETPATH+"space.png", false), x, y, 1,texts[], lambda { })
        y += lineHeight
      }, lambda { self.close()}]
      @menu = Menu.new(self)
      for i in (0..items.size - 1)
        @menu.add_item(Gosu::Image.new(self, ASSETPATH+"#{items[i]}.png", false), x, y, 1, actions[i],texts[i], Gosu::Image.new(self, ASSETPATH+"#{items[i]}.png", false))
        y += lineHeight
        puts(texts[i])
      end
      @back = Gosu::Image.new(self, ASSETPATH+"Jaquette.png", false)
    end
  
    def update
      @menu.update
    end
  
    def draw
      @cursor.draw(self.mouse_x-5, self.mouse_y-5, 2, 0.05, 0.05)
      @back.draw(0,0,0)
      @menu.draw
    end
  
    def button_down (id)
      if id == Gosu::MsLeft then
        @menu.clicked
      end
    end
end

MainMenu.new.show