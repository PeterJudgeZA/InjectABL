 
 /*------------------------------------------------------------------------
    File        : S1
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Nov 16 15:34:29 EST 2009
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.Test.*.
using Progress.Lang.*.
using OpenEdge.Core.Util.*.

class OpenEdge.Test.S1
    inherits S2
    implements /*ISerializable, */ IExternalizable:
    
    def private temp-table tt
        field f1 as char extent 12
        field f2 as int
        FIELD dFoo AS DATE    INITIAL TODAY 
        FIELD iFoo AS INTEGER INITIAL 5000
        field d1 as decimal init 123.45
        index idx1 as primary f2 dfoo.
        
         
    def protected var SomeVar as int.    
    def protected var SomeHdl as handle.
    def public property MyS0 as S0 no-undo get. set.    
    def public property MyS3 as S3 no-undo 
        get ():
            if not valid-object(MyS3) then
            do:
                MyS3 = new S3().
                MyS3:somePUBValue = 12345.44332211.
            end.
            return MyS3.
        end get. 
        set.
    def public property MySecondS3 as S3 no-undo
        get ():
            return MyS3.
        end get. 
        set.
    
    def private var ALongCharValue as longchar init 'asfasfasf'.
    def private var ALongCharNull as longchar init ?.
    
    constructor public S1():
        
    end constructor.
    
    method public void Init():
        SomeVar = 89.
        
        create tt.
        create tt.
        create tt.
    end method. 
        
    method public void WriteObject(po as IObjectOutput ):
        po:WriteInt(SomeVar).
        po:WriteHandle(SomeHdl).
        po:WriteObject(MyS0).
        po:WriteObject(MyS3).
        po:WriteObject(MySecondS3).
        po:WriteLongchar(ALongCharNull).
        po:WriteLongchar(ALongCharValue).
        
        po:WriteTable(buffer tt:handle).
    end method.
    
    method public void ReadObject(po as IObjectInput):
       SomeVar = po:ReadInt().
       SomeHdl = po:ReadHandle().
       MyS0 = cast(po:ReadObject(), S0).
       MyS3 = cast(po:ReadObject(), S3).
       MySecondS3 = cast(po:ReadObject(), S3).
       
       ALongCharNull = po:ReadLongchar().
       ALongCharValue = po:ReadLongchar().
       
       po:ReadTable(input-output table tt by-reference).
    end method.
    
end class.
