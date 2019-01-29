/*------------------------------------------------------------------------
    File        : AdvancedWarriorModule
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Boehme_A
    Created     : Sat Dec 15 12:02:06 CET 2018
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.InjectABL.*.
using OpenEdge.InjectABL.Binding.*.
using OpenEdge.InjectABL.Binding.Parameters.*.
using OpenEdge.InjectABL.Binding.Conditions.*.
using OpenEdge.InjectABL.Lifecycle.*.
using OpenEdge.InjectABL.Binding.Modules.*.
using OpenEdge.Core.*.
using Progress.Lang.*.
using OpenEdge.Test.IWeapon from propath.

class OpenEdge.Test.WarriorModule inherits InjectionModule:
    
    constructor public WarriorModule():
        super().
    end constructor.

    method override public void Load():
        def var oParam as IParameter extent no-undo.
               
        /* Samurai init */
        
        bind(get-class('OpenEdge.Test.IWeapon'))
          :To(get-class('OpenEdge.Test.Gun'))
          :Using(get-class('OpenEdge.InjectABL.Lifecycle.ConstructorInjectionProvider')).

        bind(get-class('OpenEdge.Test.IAmmo'))
          :To(get-class('OpenEdge.Test.Bullets'))
          :Using(get-class('OpenEdge.InjectABL.Lifecycle.ConstructorInjectionProvider')).

        bind(get-class('OpenEdge.Test.IArmor'))
          :To(get-class('OpenEdge.Test.Kusari'))
          :Using(get-class('OpenEdge.InjectABL.Lifecycle.ConstructorInjectionProvider')).
         
        bind(get-class('OpenEdge.Test.IWeapon'))
          :To(get-class('OpenEdge.Test.Shuriken')):Named('alternateweapon').
             
        extent(oParam) = ?.
        extent(oParam) = 2.
        oParam[1] = new Parameter('Mike').
        oParam[2] = new Parameter('Dwight').
             
        bind(get-class('OpenEdge.Test.Samurai'))
          :ToSelf()
          :Using(get-class('OpenEdge.InjectABL.Lifecycle.ConstructorInjectionProvider'))
          :WithPropertyValue('Dojo', 'Ninja Gym East')
          :WithPropertyValue('NumberOfAssistants', new Parameter('1':U,  DataTypeEnum:Integer))
          :WithMethodValue('SetNinjaMasters', oParam)
          :WithMethodValue('SetAlternateWeapon', get-class(IWeapon), 'AlternateWeapon')
        .

        
        /*
        obs = Bind('OpenEdge.Test.Samurai').
        obs = obs
            :To('OpenEdge.Test.ClientSamurai')
            :Using('OpenEdge.Test.SamuraiProvider')
            /*:OnClientSession()*/
            .
        */            
    end method.

end class.