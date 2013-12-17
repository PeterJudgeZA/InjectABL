 
 /*------------------------------------------------------------------------
    File        : Sword
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:01:57 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Test.*.

block-level on error undo, throw.

class OpenEdge.Test.Sword implements IWeapon:
    
     method public void Hit(target as char):
        message 
        substitute("Chopped &1 clean in half", target)
        view-as alert-box.    
     end method.

    constructor public Sword():
    end constructor.
end class.