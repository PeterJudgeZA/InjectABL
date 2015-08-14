/*------------------------------------------------------------------------
    File        : Samurai
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 10:58:45 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Lang.*.
using OpenEdge.InjectABL.*.
using OpenEdge.Test.*.


class OpenEdge.Test.Samurai:
    
    define private variable moWeapon as IWeapon no-undo.
    define private variable moAlternateWeapon as IWeapon no-undo.
    define public property Dojo as character no-undo get. set.
    define public property UseAlternate as logical no-undo get. set.
    define public property NumberOfAssistants as integer no-undo get. set.
    define private variable mcNinjaMaster as character no-undo.
    define private variable mcAssistantToTheMaster as character no-undo.
    
    constructor public Samurai(poWeapon as IWeapon):
        moWeapon = poWeapon.
    end constructor.
    
    method public void Attack(target as char):
        message
        'students at '  Dojo ' about to attack ... ' 
        view-as alert-box.
        
        if UseAlternate then
            moAlternateWeapon:Hit(target).
        else
            moWeapon:Hit(target).
        
        message 
        '(NinjaMaster ' mcNinjaMaster '): you have done well!' skip
        '(AssitantToTheNinjaMaster ' mcAssistantToTheMaster '): you have done well, says NinjaMaster!' skip
        view-as alert-box.
        
    end method.
    
    method public void SetAlternateWeapon(poAlternate as IWeapon):
        moAlternateWeapon = poAlternate.
    end method.
    
    method public void SetPrimaryWeapon(poWeapon as IWeapon):
        moWeapon = poWeapon.
    end method.
    
    method public void SetNinjaMasters(pcMaster as character,
                                       pcAssistantToTheMaster as character):
        mcNinjaMaster = pcMaster.
        mcAssistantToTheMaster = pcAssistantToTheMaster. 
    end method.
    
end class.