 
 /*------------------------------------------------------------------------
    File        : WoodBullets
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Boehme_A
    Created     : Fri Dec 14 12:40:58 CET 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using KernelGet.Test.IAmmo.


block-level on error undo, throw.

class KernelGet.Test.WoodBullets implements IAmmo: 
  
  method public integer iImpact( ):
    
    return 4.
    
  end method.
    
  method public void Unpack
    (  ):

    message
      "Unpacked the bullets made of wood. 2 of them already damaged by a worm." skip
      view-as alert-box
      title program-name(1).

  end method. /* Unpack */

end class.