#
# 
#

class Personnage < Entite

  #
  # Accessor Methods
  #


  public
  
  def initialize(name, vie_max,pos_x,pos_y,dim_x,dim_y)
    super(name, vie_max,pos_x,pos_y,dim_x,dim_y)
  end
  
  protected

  private

end

