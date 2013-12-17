/** ****************************************************************************
  Copyright 2012 Progress Software Corporation
  
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
    File        : IParameter
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 09:26:12 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.DataTypeEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.InjectABL.Binding.Parameters.IParameter:
    /** (optional) Gets the name of the parameter. Only informational.*/
    define public property Name as character no-undo get. set.
    
    /** Gets the optional instance name of the parameter. This is only used when the parameter
        is a type/class which InjectABL will resolves from a pre-existing binding. The parameter 
        might be a general interface (IDataAccess) but the binding will specify a name ("EmployeeDA");
        this property allows us to specify that object. */
    define public property ServiceInstanceName as character no-undo get. set.
    
    /** (mandatory) The datatype of the parameter. */
    define public property DataType as DataTypeEnum no-undo get.
    
    /** (mandatory) Specify a declared type for cases where the parameter an object or array thereof. ABL doesn't currently (10.2B)
        allow us to discover either the declared type of the array, or the signature of the callee (method, property, ctor),
        and so we need to specify the type for the InjectABL kernel. */
    define public property DeclaredType as Progress.Lang.Class no-undo get.
    
    /** Gets the value for the parameter within the specified context.
        @param context The context.
        @return The value for the parameter. */
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object).
    method public void GetValue(poContext as ILifecycleContext, output poValue as Object extent).
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character).
    method public void GetValue(poContext as ILifecycleContext, output pcValue as character extent).
    
end interface.
