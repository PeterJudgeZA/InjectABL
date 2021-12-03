 
 /*------------------------------------------------------------------------
    File        : Kusari
    Purpose     : Some metal chain ninja armor.. Protects the ninja from 
                  traditional weapons like shuriken and sword. a bit useless
                  for bullets
    Syntax      : 
    Description : 
    Author(s)   : Boehme_A
    Created     : Sat Dec 15 15:50:31 CET 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using KernelGet.Test.IArmor.

block-level on error undo, throw.

class KernelGet.Test.Kusari implements IArmor: 

method public integer iProtect():
  
  return 8.
  
end method.

end class.