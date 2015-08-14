/*------------------------------------------------------------------------
    File        : TwoPropObj
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Apr 21 11:03:29 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Test.TwoPropObj.
using Progress.Lang.*.

block-level on error undo, throw.

class OpenEdge.Test.TwoPropObj: 
    def public property PropOne as int no-undo get. set.
    def public property PropTwo as char no-undo get. set.

    constructor public TwoPropObj(p1 as int, p2 as char):
        PropOne = p1.
        PropTwo = p2.
    end constructor.

    method override public logical Equals( input p0 as Progress.Lang.Object ):
        def var leq as log init false.
        
        if type-of(p0, TwoPropObj) then
        leq = this-object:PropOne eq cast(p0, TwoPropObj):PropOne
                        and
               this-object:PropTwo eq cast(p0, TwoPropObj):PropTwo.
                        
       return leq.
    end method. 

    method override public character ToString(  ):
        return PropTwo.
    end method.
    
end class.