/*------------------------------------------------------------------------
    File        : IInjectionModuleCollection
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 14:07:31 EST 2010
    Notes       : * This class based on the 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.Modules.IInjectionModule.
using OpenEdge.Core.String.

{OpenEdge/Core/Collections/typedmapclass.i
    &Package    = OpenEdge.InjectABL.Binding.Modules
    &MapType    = IInjectionModuleCollection
    &KeyType    = String
    &ValueType  = IInjectionModule
    &NoEndClass = true
}

    method public IInjectionModule Add(input poValue as IInjectionModule):
        return this-object:Put(input new String(poValue:Name), input poValue).
    end method.
    
end class.