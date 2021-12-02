/*------------------------------------------------------------------------
    File        : test_injectabl.p
    Purpose     :

    Syntax      :

    Description :

    @author pjudge
    Created     : Tue Mar 02 10:56:02 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/

using OpenEdge.Test.*.
using OpenEdge.Core.InjectABL.*.
using OpenEdge.Core.InjectABL.Binding.Parameters.*.
using OpenEdge.Core.InjectABL.Binding.Modules.*.
using OpenEdge.Lang.*.
using Progress.Lang.*.
using OpenEdge.InjectABL.IKernel from propath.
using OpenEdge.InjectABL.Binding.Modules.IInjectionModuleCollection from propath.
using OpenEdge.Core.Collections.ICollection from propath.
using OpenEdge.InjectABL.Binding.Parameters.Routine from propath.
using OpenEdge.InjectABL.StandardKernel from propath.
using OpenEdge.Core.Collections.Collection from propath.
using OpenEdge.Core.RoutineTypeEnum from propath.
using OpenEdge.InjectABL.Binding.Parameters.Parameter from propath.
using OpenEdge.Core.DataTypeEnum from propath.

def var kernel as IKernel.
def var modules as IInjectionModuleCollection.
def var params as ICollection.
def var routine as Routine.

def var warrior as Samurai.

modules = new IInjectionModuleCollection().
modules:Add(new WarriorModule()).

kernel = new StandardKernel(modules).

warrior = cast(kernel:Get(get-class(Samurai)), Samurai).

warrior:Attack("the evildoers").

/*

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
*/

/* eof */
