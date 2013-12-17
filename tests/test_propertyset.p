/*------------------------------------------------------------------------
    File        : test_injectabl.p
    Purpose     : 

    Syntax      :

    Description : 

    @author pjudge
    Created     : Tue Mar 02 10:56:02 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
using   OpenEdge.Core.InjectABL.IKernel.
using   OpenEdge.Lang.Collections.ICollection.
using   OpenEdge.Lang.Collections.Collection.
using   OpenEdge.Core.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.Test.*.
using OpenEdge.Core.InjectABL.*.
using OpenEdge.Core.InjectABL.Binding.Parameters.*.
using OpenEdge.Core.InjectABL.Binding.Modules.*.
using OpenEdge.Lang.*.
using Progress.Lang.*.

def var kernel as IKernel.
def var modules as IInjectionModuleCollection.
def var params as ICollection.
def var routine as Routine.

def var warrior as Samurai.
    
modules = new IInjectionModuleCollection().
modules:Add(new WarriorModule()).

kernel = new StandardKernel(modules).

warrior = cast(kernel:Get('OpenEdge.Test.Samurai'), Samurai). 

message 
'Dojo=' warrior:Dojo skip
'NumberOfAssistants=' warrior:NumberOfAssistants
view-as alert-box.

catch a as AppError:
    message     
    'type=' a:GetClass():TypeName skip
    'msg=' a:GetMessage(1) skip
    'retval=' a:ReturnValue skip(2)
    a:CallStack
    view-as alert-box.
end catch.

catch e as Error:
    message     
        e:GetMessage(1) skip(2)
        e:CallStack
    view-as alert-box title 'Unhandled Progress.Lang.Error'.
end catch.

finally:
    if valid-object(kernel) then
        kernel:Release(warrior).

    kernel = ?.

    message 
    'are we ok?'
    view-as alert-box.        
end finally.

/* eof */