/*------------------------------------------------------------------------
    File        : WarriorModule
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:07:55 EST 2010
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
using OpenEdge.Test.IWeapon.

class OpenEdge.Test.WarriorModule inherits InjectionModule:
    
    constructor public WarriorModule():
        super().
    end constructor.

    method override public void Load():
        def var oParam as IParameter extent no-undo.
        
        /* use oBS as bug workaround */
        def var obs as IBindingSyntax.
        
        /* Samurai! */
        obs = Bind(get-class(OpenEdge.Test.IWeapon)).
        obs = obs:To(get-class(OpenEdge.Test.Sword)).
        
        obs = Bind(get-class(OpenEdge.Test.IWeapon)).
        obs = obs:To(get-class(OpenEdge.Test.Shuriken)):Named('alternateweapon').
        
        obs = Bind(get-class(OpenEdge.Test.Samurai)).
        obs = obs
            :ToSelf()
            :Using(get-class(OpenEdge.Test.SamuraiProvider))
            :WithPropertyValue('Dojo', 'Ninja Gym East')
        .
        
        extent(oParam) = ?.
        extent(oParam) = 1.
        oParam[1] = new Parameter('4', DataTypeEnum:Integer).

        obs
            :WithPropertyValue('NumberOfAssistants', oParam).
        
        
        extent(oParam) = ?.
        extent(oParam) = 2.
        oParam[1] = new Parameter('Mike').
        oParam[2] = new Parameter('Dwight').
        
        obs    
            :WithMethodValue('SetNinjaMasters', oParam)
            :WithMethodValue('SetAlternateWeapon', get-class(IWeapon))
            /*:OnServerSession()*/
            .
        
        /*
        obs = Bind(get-class(OpenEdge.Test.Samurai').
        obs = obs
            :To(get-class(OpenEdge.Test.ClientSamurai')
            :Using('OpenEdge.Test.SamuraiProvider')
            /*:OnClientSession()*/
            .
        */            
    end method.

end class.