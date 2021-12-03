 
 /*------------------------------------------------------------------------
    File        : Gun
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Boehme_A
    Created     : Fri Dec 14 12:43:35 CET 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using KernelGet.Test.*.

block-level on error undo, throw.

class KernelGet.Test.Gun implements IWeapon:
    
    define protected property mAmmo as IAmmo no-undo protected get. protected set. 
    
    constructor Gun(poAmmo as IAmmo):
      mAmmo = poAmmo.
      mAmmo:Unpack().
    end.
    
     method public void Hit(target as char):
        message 
        substitute("Fired at &1. Lost &2 health points.", target, string(mAmmo:iImpact()))
        view-as alert-box.    
     end method.

end class.