/*------------------------------------------------------------------------
    File        : S2
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Nov 16 15:51:08 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Util.*.
using OpenEdge.Test.*.
using Progress.Lang.*.


class OpenEdge.Test.S3 implements IExternalizable: 
    
    def private var somePrivatevalue as logical.
    def public var somePUBValue as decimal initial 777.

    
    method public void WriteObject( po as IObjectOutput):
        po:WriteLogical(somePrivatevalue).
        po:WriteDecimal(somePUBValue).
    end method.
    
    method public void ReadObject( po as IObjectInput ):
        somePrivatevalue = po:ReadLogical().
        somePUBValue = po:ReadDecimal().        
    end method.

end class.