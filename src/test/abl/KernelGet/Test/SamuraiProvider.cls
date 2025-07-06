/*------------------------------------------------------------------------
    File        : SamuraiProvider
    Purpose     :
    Syntax      :
    Description :
    @author pjudge
    Created     : Tue Mar 02 13:21:45 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using KernelGet.Test.*.
using OpenEdge.Core.*.
using OpenEdge.InjectABL.Binding.Parameters.*.
using OpenEdge.InjectABL.Lifecycle.*.
using Progress.Lang.*.

class KernelGet.Test.SamuraiProvider inherits StandardProvider:

    constructor public SamuraiProvider(poClass as Progress.Lang.Class):
        super(poClass).
    end constructor.

    method override public Object Create(poContext as ILifecycleContext):
        def var oSamurai as Object.
        define variable oNewParams as IParameter extent 1 no-undo.
        define variable oRoutine as Routine no-undo.

        oRoutine  = new Routine(poContext:Binding:Service, '', RoutineTypeEnum:Constructor).
        poContext:Arguments:Add(oRoutine).

        oNewParams[1] = new Parameter(get-class(IWeapon)).

        extent(oRoutine:Parameters) = ?.
        oRoutine:Parameters = oNewParams.

        oSamurai = cast(super:Create(poContext), Samurai).

        return oSamurai.
    end method.


end class.
