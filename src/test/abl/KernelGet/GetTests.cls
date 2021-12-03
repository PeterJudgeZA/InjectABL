 
 /*------------------------------------------------------------------------
    File        : GetTests
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : pjudge
    Created     : Thu Dec 02 21:04:25 EST 2021
    Notes       :
  ----------------------------------------------------------------------*/

block-level on error undo, throw.

using KernelGet.Test.Samurai.
using KernelGet.Test.Shuriken.
using KernelGet.Test.WarriorModule.
using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.Collection.
using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.RoutineTypeEnum.
using OpenEdge.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.InjectABL.Binding.Parameters.Routine.
using OpenEdge.InjectABL.IKernel.
using OpenEdge.InjectABL.StandardKernel.

class KernelGet.GetTests:
    define private variable kernel as IKernel no-undo.
    
    @Before.
    method public void BeforeAll():
        define variable modules as IInjectionModuleCollection no-undo.
        
        modules = new IInjectionModuleCollection().
        modules:Add(new WarriorModule()).
        
        kernel = new StandardKernel(modules).
    end method.
    
    
    @After.
    method public void AfterAll():
        kernel = ?.
    end method.
    
    @Test.
    method public void GetWarrior():
        define variable svc as Progress.Lang.Object no-undo.
        define variable warrior as Samurai no-undo.
        
        svc = kernel:Get(get-class(Samurai)).
        Assert:IsType(svc, get-class(Samurai)).
        
        warrior = cast(svc, Samurai).
        
        Assert:NotNull(warrior, 'Warrior').
        
        Assert:Equals('Ninja Gym East', warrior:Dojo).
        Assert:Equals(1, warrior:NumberOfAssistants).
    end method.

    @Test.
    method public void GetWarriorAndInject():
        define variable params as ICollection no-undo.
        define variable routine as Routine no-undo.
        define variable warrior as Samurai no-undo.
        
        warrior = cast(kernel:Get(get-class(Samurai)), Samurai).
        
        Assert:NotNull(warrior, 'Warrior').
        
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
        
        kernel:Inject(warrior, params).
    end method.
    
end class.