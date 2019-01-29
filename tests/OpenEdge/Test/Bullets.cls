 
 /*------------------------------------------------------------------------
    File        : Bullets
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Boehme_A
    Created     : Fri Dec 14 12:19:00 CET 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Test.IAmmo.

block-level on error undo, throw.

class OpenEdge.Test.Bullets implements IAmmo: 
  
  method public integer iImpact( ):
    
    return 10.
    
  end method.
    
  method public void Unpack
    (  ):

    message
      "Unpacked the bullets, ready for load." skip
      view-as alert-box
      title program-name(1).

  end method. /* Load */

end class.