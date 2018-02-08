require("em/model/Entite")
require("em/model/Personnage")
require("em/model/Ennemi")
require("em/model/Boss")
require("em/model/Projectile")
require("em/model/ProjDist")
require("em/model/ProjDistPerf")
require("em/model/ProjDistZigZag")
require("em/model/ProjCaCDes")

class Test
  #
  # Accessor Methods
  #
  def initialize()
    @entities = Hash.new()
    @proj = ProjCaCDes.new("projDistPerd",200,0, 0, 4, 10)

    perso = newPerso("Blanchon")
    @perso = perso.values[0]
    @entities.merge!(perso)

    ennemi = newEnnemi("Ennemi")
    @ennemi = ennemi.values[0]
    @entities.merge!(ennemi)

    distBoule = newProj(ProjDist.name)
    @entities.merge!(distBoule)
distBoule = newProj(ProjDist.name)
    @entities.merge!(distBoule)
distBoule = newProj(ProjDist.name)
    @entities.merge!(distBoule)
    
    
    while(!Projectile.projectilesActifs.empty?)
      Projectile.projectilesActifs.each {
        |projectile|
        projectile.nextStep(@entities.values)
        puts ""
      }
    end
  end

  def entiteUpdate(action, entite, entiteAttaquante)
    case action
    when Action::ENTITY_DIED
      puts ("entity : " + entite.name + " died from " + entiteAttaquante.name)
      if(entite.class.superclass.name == "Projectile")
        Projectile.projectilesActifs.delete(entite)
      end
      #      @entities[entite.name]
    when Action::WEAPON_BROKE

    end
  end

  protected

  private

  def newPerso(name)
    newName = getNewName(name)
    perso = Personnage.new(newName, 4, 0, 0, 50, 50)
    perso.deplacer(100,0)
    perso.add_observer(self, :entiteUpdate)
    return {newName => perso}
  end

  def newProj(name)
    newName = getNewName(name)
    proj = @proj.copyAndActive(newName,2,[10,10],[5,2],-1,@ennemi)
    proj.add_observer(self, :entiteUpdate)
    return {newName => proj}
  end

  def newEnnemi(name)
    newName = getNewName(name)
    ennemi = Ennemi.new(newName, 4, 0, 0, 50, 50)
    ennemi.deplacer(50, 0)
    ennemi.add_observer(self, :entiteUpdate)
    return {newName => ennemi}
  end

  def newBoss(name)

  end

  def getNewName(name)
    nameTmp = name
    i = 1
    while @entities.has_key?(nameTmp)
      nameTmp = name + i.to_s
      i+=1
    end
    return nameTmp
  end

end

test = Test.new