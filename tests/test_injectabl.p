/*------------------------------------------------------------------------
    File        : test_injectabl.p
    Purpose     :

    Syntax      :

    Description :

    @author pjudge
    Created     : Tue Mar 02 10:56:02 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
using OpenEdge.Core.Collections.Collection.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.RoutineTypeEnum.
using OpenEdge.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.InjectABL.Binding.Parameters.Routine.
using OpenEdge.InjectABL.IKernel.
using OpenEdge.InjectABL.StandardKernel.
using OpenEdge.Test.Samurai.
using OpenEdge.Test.WarriorModule.
using Progress.Lang.AppError.
using Progress.Lang.Error.
using OpenEdge.Core.System.ArgumentError.
using OpenEdge.Test.Shuriken.

def var kernel as IKernel.
def var modules as IInjectionModuleCollection.
def var params as ICollection.
def var routine as Routine.
def var warrior as Samurai.

session:error-stack-trace = yes.

modules = new IInjectionModuleCollection().
modules:Add(new WarriorModule()).

kernel = new StandardKernel(modules).

warrior = cast(kernel:Get(get-class(OpenEdge.Test.Samurai)), Samurai).

warrior:Attack("the evildoers").


params = new Collection().

routine = new Routine(get-class(Samurai),
                      'SetPrimaryWeapon',
                      RoutineTypeEnum:Method).

extent(routine:Parameters) = 1.

routine:Parameters[1] = new Parameter(get-class(Shuriken)).

params:Add(routine).

routine = new Routine(get-class(Samurai),
                      'UseAlternate',
                      RoutineTypeEnum:PropertySetter).

extent(routine:Parameters) = 1.

routine:Parameters[1] = new Parameter('true', DataTypeEnum:Logical).

params:Add(routine).

message
  "First: " warrior:toString() skip
  view-as alert-box
  title program-name(1).

kernel:Inject(warrior, params).

message
  warrior:toString() skip
  view-as alert-box
  title program-name(1).

warrior:Attack("a melon").

catch a as AppError:
    message
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
end finally.
/* eof */
