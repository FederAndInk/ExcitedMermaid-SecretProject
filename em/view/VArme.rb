require("em/view/teacher")

class VArme < Teacher
  def initialize(window, name, nameId, isPrio)
    @meh = window
    @name = name
    @nameId = nameId
    @isPrio = isPrio
    #      @image = Gosu::Image.new(window, "assets/Character#{name}x20.png", false)
    @walk = Gosu::Image.new(window, ASSETPATH + "#{name}x20.png", false)
    @posx = 0
    @posy = 0
    @prio = @posy
    @flip = 1
    @image = @walk
    @state = "idle"
    @attack
  end
  
  def draw
    @image.draw @posx, @posy, @prio, @flip
  end
end