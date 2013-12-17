 
 /*------------------------------------------------------------------------
    File        : MapKey
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 21 14:47:23 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Test.TwoPropObj.

block-level on error undo, throw.

class OpenEdge.Test.MapKey inherits TwoPropObj: 

    constructor public MapKey ( input p1 as integer, input p2 as character ):
        super (input p1, input p2).
    end constructor.
    
end class.