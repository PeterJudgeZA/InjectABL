 
 /*------------------------------------------------------------------------
    File        : MapValue
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 21 14:48:09 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Test.*.

block-level on error undo, throw.

class OpenEdge.Test.MapValue inherits TwoPropObj: 
        
    constructor public MapValue ( input p1 as integer, input p2 as character ):
        super (input p1, input p2).
        
    end constructor.


end class.