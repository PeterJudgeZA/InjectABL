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

using OpenEdge.Test.Samurai.

using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.InjectABL.Binding.Parameters.Routine.
using OpenEdge.Core.RoutineTypeEnum.
using OpenEdge.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Core.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.Test.SamuraiProvider inherits StandardProvider: 
    
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