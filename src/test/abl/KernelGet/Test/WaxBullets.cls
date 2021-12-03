 
 /*------------------------------------------------------------------------
    File        : WaxBullets
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Boehme_A
    Created     : Fri Dec 14 12:24:48 CET 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using KernelGet.Test.IAmmo.

block-level on error undo, throw.

class KernelGet.Test.WaxBullets implements IAmmo: 
  
  method public integer iImpact( ):
    
    return 1.
    
  end method.
    
  method public void Unpack
    (  ):

    message
      "Unpacked the bullets made of wax. 3 already melted in my hands." skip
      view-as alert-box
      title program-name(1).

  end method. /* Unpack */

end class.