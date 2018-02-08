require 'gosu'
require 'em/view/teacher'
require 'em/view/background'

class Game < Gosu::Window
  def initialize()
    super 4800,2660, false
    fullscreen=($fullsc)
    @mus = $music
    @vol = $volume

    @player = Teacher.new self,"Blanchon", "player"
    @boss = Teacher.new(self,"Blanchon","boss")
    @boss2 = Teacher.new(self,"Blanchon","boss")
    @backdrop = Background.new self, "classroom", @player, @boss

    @player.move_To(1500,1200)
    @boss.move_To(3500,1200)
    @boss2.move_To(3700,1500)

    @keys = Array.new()
    @backdrop.setPvP(5,5)
    @backdrop.addBuff("staline")
    @backdrop.addBuff("perso_face_32")
    @backdrop.addBuff("staline")
    @backdrop.removeBuff(2)
    
    @backdrop.setPvB(3,5)
  end
  

  def draw
    puts($fullsc)
    puts(fullscreen?())
    @player.setPrio(@player.posy())
    @boss.setPrio(@boss.posy())
    @boss2.setPrio(@boss2.posy())
    @backdrop.draw
    @player.draw
    @boss.draw()
    @boss2.draw()
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

#Game.new.show
