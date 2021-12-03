/*------------------------------------------------------------------------
    File        : Shuriken
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:01:57 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using KernelGet.Test.*.

block-level on error undo, throw.

class KernelGet.Test.Shuriken implements IWeapon:
    
     method public void Hit(target as char):
        message 
        substitute("Pierced &1's armor", target)
        view-as alert-box.    
     end method.

end class.