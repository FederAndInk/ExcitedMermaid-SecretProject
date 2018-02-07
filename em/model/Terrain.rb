#
# 
#
require 'em/model/DistBoule'
require 'em/model/Projectile'
require 'em/model/Personnage'
require 'em/model/Ennemi'
class Terrain
  #
  # Accessor Methods
  #

  attr_accessor :dim

  public
  def initialize
    proj = DistBoule.new(0,0,10,10)
    joueur = Personnage.new(20,100,0,0,0,100,100)
    ennemi = Ennemi.new(20,100,200,0,0,100,100)
    
    entites = [joueur,ennemi]
    
    proj.copyAndActive([0,0,],[5,0],ennemi)
    
    while(!Projectile.projectilesActifs.empty? && )
      
      Projectile.projectilesActifs.each { 
            |projectile|
        puts "Projectile en vie à la position (" + projectile.position["x"].to_s + "," + projectile.position["y"].to_s+")? : " + (projectile.vie <=0 ? "Yes" : "No")
        projectile.nextStep(entites)
          }
    end
  end
  
  
  protected

  private

end

terrain = Terrain.new