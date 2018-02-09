$:.unshift(Dir.pwd)

require 'gosu'
require 'em/view/menu'
require 'em/view/MenuItem'
require 'em/view/parameter'
require 'em/view/game'
require("em/model/Terrain")

class MainMenu < Gosu::Window
  def initialize
      super(640, 640, false)
      @cursor = Gosu::Image.new(self, ASSETPATH+"Curseurx20.png", false)
      x = 0
      y = self.height - 100
      lineHeight = 120
      lineWidth = 220
      self.caption = "red glasses"
      
      #array a modifier pour les boutons
      nbButton = 3
      texts = ["JOUER", "OPTIONS", "QUITTER"]
      optionTexts = ["fullscreen","audio","volume+","volume-", "retour"]
      
      items = Array.new(nbButton,"jouer")
      optionAction = Array[lambda { if (!$fullsc) 
                                      $fullsc = true
#                                      optionTexts[0] = "fullscreen"
                                      @option.setText("fullscreen")
                                      puts($fullsc)
                                    else 
                                      $fullsc = false
#                                      optionTexts[0] = "fenetré"
                                      @option.setText("fenetré")
#                                      needs_redraw?()
                                      puts($fullsc)
                                    end  }, lambda{
                                    if ($music) 
                                      $music = false 
                                    else $music = true 
                                    end }, 
                                    lambda { $volume += 0.1 }, lambda{$volume -= 0.1}, lambda{@option.clean()}]
      actions = Array[lambda { 
        game = Game.new
        game.fullscreen=($fullsc) 
        Terrain.new(game)}, 
          lambda {
        x = self.width()/2 - 100
        y = 50
        for i in (0..optionAction.length-1)
          @option.add_item(Gosu::Image.new(self, ASSETPATH+"jouer.png", false), x, y, 1,optionAction[i],optionTexts[i], Gosu::Image.new(self, ASSETPATH+"jouer.png", false))
          y += lineHeight
#          puts"#{optionTexts[0]}"
        end
      }, lambda { self.close()}]
        
      @menu = Menu.new(self)
      @option = Menu.new(self)
      for i in (0..items.size - 1)
        @menu.add_item(Gosu::Image.new(self, ASSETPATH+"#{items[i]}.png", false), x, y, 1, actions[i],texts[i], Gosu::Image.new(self, ASSETPATH+"#{items[i]}.png", false))
        x += lineWidth
      end
      @back = Gosu::Image.new(self, ASSETPATH+"Jaquette.png", false)
    end
  
    def update
      @menu.update()
      @option.update()
    end
  
    def draw
      @cursor.draw(self.mouse_x-5, self.mouse_y-5, 2, 0.05, 0.05)
      @back.draw(0,0,0)
      if @option.isEmpty
        @menu.draw
      else
#        puts("draw option")
        @option.draw
      end
    end
  
    def button_down (id)
      if id == Gosu::MsLeft then
        if @option.isEmpty
          @menu.clicked
        else
          @option.clicked
        end
      end
    end
end

MainMenu.new.show


