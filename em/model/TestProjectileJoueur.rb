require("em/model/Entite")
require("em/model/Personnage")
require("em/model/Ennemi")
require("em/model/Boss")
require("em/model/Projectile")
require("em/model/DistBoule")

class Test
  #
  # Accessor Methods
  #
  def initialize()
    @entities = Hash.new()
    @proj = DistBoule.new("distBoule",0, 0, 10, 10)

    perso = newPerso("Blanchon")
    @perso = perso.values[0]
    @entities.merge!(perso)

    ennemi = newEnnemi("Ennemi")
    @ennemi = ennemi.values[0]
    @entities.merge!(ennemi)

    distBoule = newProj("DistBoule")
    @entities.merge!(distBoule)
    distBoule = newProj("DistBoule")
    @entities.merge!(distBoule)

    while(!Projectile.projectilesActifs.empty?)
 
      Projectile.projectilesActifs.each {
        |projectile|
        puts projectile.name + " en vie à la position (" + projectile.position["x"].to_s + "," + projectile.position["y"].to_s+")? : " + (projectile.vie <=0 ? "No" : "Yes")
        projectile.nextStep(@entities.values)
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
    perso = Personnage.new(newName, 4, 100, 0, 0, 0, 50, 50)
    perso.add_observer(self, :entiteUpdate)
    return {newName => perso}
  end

  def newProj(name)
    newName = getNewName(name)
    @proj.copyAndActive(newName,[0,0],[5,0],@ennemi).add_observer(self, :entiteUpdate)
    return {newName => @proj}
  end

  def newEnnemi(name)
    newName = getNewName(name)
    ennemi = Ennemi.new(newName, 4, 50, 0, 0, 0, 50, 50)
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
    end
    return nameTmp
  end

end

test = Test.new