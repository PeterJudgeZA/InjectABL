 
 /*------------------------------------------------------------------------
    File        : ClientSamurai
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 17 11:28:17 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using KernelGet.Test.Samurai.

block-level on error undo, throw.

class KernelGet.Test.ClientSamurai inherits Samurai: 
        
    constructor public ClientSamurai ( input poWeapon as KernelGet.Test.IWeapon ):
        super (input poWeapon).
        
        message 
          'Client samurai!'
        view-as alert-box.
    end constructor.

end class.