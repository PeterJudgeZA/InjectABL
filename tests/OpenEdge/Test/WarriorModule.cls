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
using OpenEdge.Test.*.

class OpenEdge.Test.WarriorModule inherits InjectionModule:

    constructor public WarriorModule():
        super().
    end constructor.

    method override public void Load():
        def var oParam as IParameter extent no-undo.

        /* Samurai init */

        bind(get-class(IWeapon))
          :To(get-class(Gun))
          :Using(get-class(ConstructorInjectionProvider)).

        bind(get-class(IAmmo))
          :To(get-class(WoodBullets))
          :Using(get-class(ConstructorInjectionProvider)).

        bind(get-class(IArmor))
          :To(get-class(Kusari))
          :Using(get-class(ConstructorInjectionProvider)).

        bind(get-class(IWeapon))
          :To(get-class(Shuriken)):Named('alternateweapon').

        extent(oParam) = ?.
        extent(oParam) = 2.
        oParam[1] = new Parameter('Mike').
        oParam[2] = new Parameter('Dwight').

        bind(get-class(Samurai))
          :ToSelf()
          :Using(get-class(ConstructorInjectionProvider))
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
