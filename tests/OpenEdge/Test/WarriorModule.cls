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

using OpenEdge.Core.DataTypeEnum.
using OpenEdge.InjectABL.Binding.Modules.InjectionModule.
using OpenEdge.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.InjectABL.Lifecycle.ConstructorInjectionProvider.
using OpenEdge.Test.Gun.
using OpenEdge.Test.IAmmo.
using OpenEdge.Test.IArmor.
using OpenEdge.Test.IWeapon.
using OpenEdge.Test.Kusari.
using OpenEdge.Test.Samurai.
using OpenEdge.Test.Shuriken.
using OpenEdge.Test.WoodBullets.

class OpenEdge.Test.WarriorModule inherits InjectionModule:

    constructor public WarriorModule():
        super().
    end constructor.

    method override public void Load():
        def var oParam as IParameter extent no-undo.

        /* Samurai init */
        this-object:Bind(get-class(IWeapon))
          :To(get-class(Gun))
          :Using(get-class(ConstructorInjectionProvider)).

        this-object:Bind(get-class(IAmmo))
          :To(get-class(WoodBullets))
          :Using(get-class(ConstructorInjectionProvider)).

        this-object:Bind(get-class(IArmor))
          :To(get-class(Kusari))
          :Using(get-class(ConstructorInjectionProvider)).

        this-object:Bind(get-class(IWeapon))
          :To(get-class(Shuriken)):Named('alternateweapon').

        extent(oParam) = ?.
        extent(oParam) = 2.
        oParam[1] = new Parameter('Mike').
        oParam[2] = new Parameter('Dwight').

        this-object:Bind(get-class(Samurai))
          :ToSelf()
          :Using(get-class(ConstructorInjectionProvider))
          :WithPropertyValue('Dojo', 'Ninja Gym East')
          :WithPropertyValue('NumberOfAssistants', new Parameter('1':U,  DataTypeEnum:Integer))
          :WithMethodValue('SetNinjaMasters', oParam)
          :WithMethodValue('SetAlternateWeapon', get-class(IWeapon), 'AlternateWeapon')
        .
    end method.

end class.
