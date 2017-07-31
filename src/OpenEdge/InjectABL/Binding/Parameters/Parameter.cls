/** ****************************************************************************
  Copyright 2012, 2017 Progress Software Corporation
  
  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at
  
    http://www.apache.org/licenses/LICENSE-2.0
  
  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
**************************************************************************** **/
/** ------------------------------------------------------------------------
    File        : Parameter
    Purpose     : Constructor, method or property parameter/argument class for
                  dependency injection.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 16:03:46 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.System.InvalidValueSpecifiedError.
using OpenEdge.Core.System.InvalidCallError.
using OpenEdge.Core.System.ArgumentError.

using OpenEdge.Core.RoutineTypeEnum.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.Assert.

using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.InjectABL.Binding.Parameters.Parameter implements IParameter:
    /** (optional) Gets the name of the parameter. Only informational.*/
    define public property Name as character no-undo get. set.
    
    /** (optional) Gets the instance name of the parameter value. This is only used when the parameter
        is a type/class which InjectABL will resolves from a pre-existing binding. The parameter 
        might be a general interface (IDataAccess) but the binding will specify a name ("EmployeeDA");
        this property allows us to specify that object.
        
        Note that this is only valid for scalar arguments, not vectors/arrays.  */
    define public property ServiceInstanceName as character no-undo get. set.
    
    /** (mandatory) The datatype of the parameter. */
    define public property DataType as DataTypeEnum no-undo get. private set.
    
    /** (mandatory) Specify a declared type for cases where the parameter an object or array
        thereof. ABL doesn't currently (10.2B) allow us to discover either the declared type
        of the array, or the signature of the callee (method, property, ctor), and so we need
        to specify the type for the InjectABL kernel. */
    define public property DeclaredType as Progress.Lang.Class no-undo get. private set.
    
    define private variable moValue as Object extent no-undo.
    define private variable mcValue as character extent no-undo.
    
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object):
        if DataTypeHelper:IsPrimitive(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not an object data type ').
        if DataTypeHelper:IsArray(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is an not a scalar value').
        
        if DataType:Equals(DataTypeEnum:Class) then
            poValue = poContext:Kernel:Get(cast(moValue[1], Class), ServiceInstanceName).
        else
            poValue = moValue[1].
    end method.
    
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        if DataTypeHelper:IsPrimitive(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not an object data type').
        
        if not DataTypeHelper:IsArray(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is an not array').
        
        iMax = extent(moValue).
        extent(poValue) = iMax.
        
        do iLoop = 1 to iMax:
            if DataType:Equals(DataTypeEnum:ClassArray) then
                poValue[iLoop] = poContext:Kernel:Get(cast(moValue[iLoop], Class)).
            else
                poValue = moValue.
        end.
    end method.
    
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character):
        if not DataTypeHelper:IsPrimitive(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not a primitive data type').
        
        if DataTypeHelper:IsArray(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not a scalar value').
        
        pcValue = mcValue[1].
    end method.
    
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character extent):
        if not DataTypeHelper:IsPrimitive(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is not a primitive data tye').
                           
        if not DataTypeHelper:IsArray(DataType) then
            undo, throw new InvalidCallError(RoutineTypeEnum:Method:ToString(), 'parameter value is an not array').
        
        pcValue = mcValue.
    end method.
    
/* Primitive value constructors */
    constructor public Parameter(input pcValue as character):
        this-object(pcValue, DataTypeEnum:Character).
    end constructor.
    
    constructor public Parameter(input pcValue as character extent):
        this-object(pcValue, DataTypeEnum:Character).
    end constructor.
    
    constructor public Parameter(input pcValue as character, input poDataType as DataTypeEnum):
        assign DataType = poDataType
               extent(mcValue) = 1
               mcValue[1] = pcValue.
    end constructor.
    
    constructor public Parameter(input pcValue as character extent, input poDataType as DataTypeEnum):
        assign DataType = poDataType
               mcValue = pcValue.
    end constructor.
    
/* Object value constructors */
    constructor public Parameter(input poValue as Object):
        this-object(poValue,
                    if valid-object(poValue) then poValue:GetClass() else get-class(Progress.Lang.Object) ).
    end constructor.
    
    constructor public Parameter(input poValue as Object, input poDeclaredType as Progress.Lang.Class):
        Assert:NotNull(poDeclaredType, 'Declared type').
        
        /* Use another ctor for this */
        if valid-object(poValue) and type-of(poValue, Progress.Lang.Class) then
            undo, throw new ArgumentError('Argument cannot be of type Progress.Lang.Class', 'poValue').
        
        assign extent(moValue) = 1
               moValue[1] = poValue
               DeclaredType = poDeclaredType
               DataType = DataTypeEnum:ProgressLangObject.
    end constructor.
            
    constructor public Parameter(input poValue as Object extent):
        this-object(poValue,
                    if valid-object(poValue[1]) then poValue[1]:GetClass() else get-class(Progress.Lang.Object)).
    end constructor.
    
    constructor public Parameter(input poValue as Object extent, input poDeclaredType as Progress.Lang.Class):
        Assert:NotNull(poDeclaredType, 'Declared type').
        
        if valid-object(poValue[1]) and type-of(poValue[1], Progress.Lang.Class) then
            undo, throw new ArgumentError('Argument cannot be of type Progress.Lang.Class', 'poValue').
        
        assign moValue = poValue
               DeclaredType = poDeclaredType
               DataType = DataTypeEnum:ProgressLangObject.        
    end constructor.        

/* Class (service or value) constructors */
    constructor public Parameter(input poType as Progress.Lang.Class):
        /* Defaults to a service */ 
        this-object(poType, DataTypeEnum:Class, '').
    end constructor.
    
    constructor public Parameter(input poType as Progress.Lang.Class, input pcInstanceName as character):
        /* Defaults to a service */ 
        this-object(poType, DataTypeEnum:Class, pcInstanceName).
    end constructor.
    
    constructor public Parameter(input poType as Progress.Lang.Class, input poDataType as DataTypeEnum):
        this-object(poType, poDataType, '').
    end constructor.        
    
    constructor public Parameter(input poType as Progress.Lang.Class,
                                 input poDataType as DataTypeEnum,
                                 input pcServiceInstanceName as character):
        Assert:NotNull(poType, 'Object value').
        Assert:NotNull(poDataType, 'Data type').
        
        assign extent(moValue) = 1
               moValue[1] = poType               
               DataType = poDataType
               ServiceInstanceName = pcServiceInstanceName.
        
        /* If this is a reference, the declared type is a Progress.Lang.Class object;
           if not, then we take the given type as the declared type.  */
        if poDataType:Equals(DataTypeEnum:ProgressLangObject) then
            DeclaredType = get-class(Progress.Lang.Class).
        else
            DeclaredType = poType.
    end constructor.        
    
    constructor public Parameter(input poType as Progress.Lang.Class extent):
        this-object(poType, get-class(Progress.Lang.Class)).
        
        /* Assume this is a service */
        DataType = DataTypeEnum:Class.
    end constructor.
            
    constructor public Parameter(input poType as Progress.Lang.Class extent, input poDataType as DataTypeEnum):
        /* These are always PLC */
        this-object(poType, get-class(Progress.Lang.Class)).
        DataType = poDataType.
    end constructor.
    
end class.
