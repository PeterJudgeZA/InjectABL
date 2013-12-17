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
/*------------------------------------------------------------------------
    File        : IBindingSyntax
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 14:45:09 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.InjectABL.Binding.IBindingSyntax.
using OpenEdge.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.InjectABL.Binding.Parameters.IParameter.

using OpenEdge.Core.DataTypeEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.InjectABL.Binding.IBindingSyntax:
    
    @IBindingToSyntax.
    /** Indicates that the service should be self-bound.  */
    method public IBindingSyntax ToSelf().
    
    /** Indicates that the service should be bound to the specified implementation type.  */
    method public IBindingSyntax To(input poImplementation as Progress.Lang.Class).
    
    @IBindingUsingSyntax.
    /** Indicates that the service will be constructed with an instance of the specified provider type.  */
    method public IBindingSyntax Using(input poProvider as Progress.Lang.Class).
        
    @IBindingInSyntax.
    /** Indicates that only a single instance of the binding 
        should be created, and then should be re-used for all 
        subsequent requests.  */
    method public IBindingSyntax InSingletonScope().

    /** Indicates that instances activated via the binding should not be re-used, nor have
        their lifecycle managed by InjectABL.  */
    method public IBindingSyntax InTransientScope().
    
    /** Indicates that an instance will be reused across an AppServer connection. 
        Meaningless for statefree AppServers. */
    method public IBindingSyntax InAgentConnectionScope().
    /** Indicates that an instance will be reused across an AppServer request. */
    method public IBindingSyntax InAgentRequestScope().
    
    /* Custom scope */    
    method public IBindingSyntax InScope(input poScopeCallback as Progress.Lang.Class, input poScope as StandardScopeEnum).
    
    @IBindingOnSyntax.
    /** Binding is applicable to a client session. This is typically a GUI or thin-client of some sort */
    method public IBindingSyntax OnThinClientSession().
    /** Binding applicable to a server session. This is any headless backend - appserver, webserver etc */
    method public IBindingSyntax OnServerSession().
    /** Binding is applicable to a complete client/server session. Typically a development environment, or fat client */
    method public IBindingSyntax OnFatClientSession().
    /** Indicates that the binding is valid for a session as identified by an application-specific code/name */
    method public IBindingSyntax OnNamedSession(input pcSessionCode as character).
    
    @IBindingWhenSyntax.
    method public IConditionSyntax When().
    
    @IBindingWithSyntax.
    /** Parameters can be passed as type Progress.Lang.Class; in this case, they could be a service to be 
        invoked by InjectABL, or a simple reference which the application uses for its own purposes. For
        simple references, we specify DataTypeEnum:ProgressLangObject in the methods that support it; 
        for a service we specify DataTypeEnum:Class.

        If the overload with PLO is called and a PLC passed in, we assume it's a service.
        
        The default is a Service (ie DataTypeEnum:Class or DataTypeEnum:ClassArray).
        
        If a Service is being used, we can specify an optional InstanceName, but only for scalar values.
        
        All the With*() methods have the follwoing return signature
        @return IBindingSyntax The binding being constructed, for a fluent interface. */    

    /** Generalised case for more complex scenarios; all other WithConstructorArgument() methods pass through this one. */
    method public IBindingSyntax WithConstructorArgument(input poParameter as IParameter extent).    

    /** Indicates that the specified constructor argument should be overridden with the specified value. */
    method public IBindingSyntax WithConstructorArgument(input poService as Progress.Lang.Class).
    method public IBindingSyntax WithConstructorArgument(input poService as Progress.Lang.Class, input pcInstanceName as character).
    method public IBindingSyntax WithConstructorArgument(input poService as Progress.Lang.Class, input poDataType as DataTypeEnum).
    method public IBindingSyntax WithConstructorArgument(input poService as Progress.Lang.Class, input poDataType as DataTypeEnum, input pcInstanceName as character).
    
    method public IBindingSyntax WithConstructorArgument(input poService as Progress.Lang.Class extent).
    method public IBindingSyntax WithConstructorArgument(input poService as Progress.Lang.Class extent, input poDataType as DataTypeEnum).
    
    method public IBindingSyntax WithConstructorArgument(input poValue as Object).
    method public IBindingSyntax WithConstructorArgument(input poValue as Object, input poDeclaringType as Progress.Lang.Class).
    method public IBindingSyntax WithConstructorArgument(input poValue as Object extent).
    method public IBindingSyntax WithConstructorArgument(input poValue as Object extent, input poDeclaringType as Progress.Lang.Class).
    
    method public IBindingSyntax WithConstructorArgument(input pcValue as character).
    method public IBindingSyntax WithConstructorArgument(input pcValue as character, input poDataType as DataTypeEnum).
    method public IBindingSyntax WithConstructorArgument(input pcValue as character extent).
    method public IBindingSyntax WithConstructorArgument(input pcValue as character extent, input poDataType as DataTypeEnum).
    
    /** Indicates that the specified property should be injected with the specified value.  */
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poService as Progress.Lang.Class).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poService as Progress.Lang.Class, input pcInstanceName as character).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poService as Progress.Lang.Class, input poDataType as DataTypeEnum).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poService as Progress.Lang.Class, input poDataType as DataTypeEnum, input pcInstanceName as character).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poService as Progress.Lang.Class extent).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poService as Progress.Lang.Class extent, input poDataType as DataTypeEnum).
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poValue as Object).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poValue as Object, input poDeclaringType as Progress.Lang.Class).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poValue as Object extent).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poValue as Object extent, input poDeclaringType as Progress.Lang.Class).
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input pcValue as character).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input pcValue as character, input poDataType as DataTypeEnum).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input pcValue as character extent).
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input pcValue as character extent, input poDataType as DataTypeEnum).
    
    /** Generalised case for more complex scenarios; all other WithPropertyValue() methods pass through this one. This method will probably never be called directly, but
        it doesn't hurt to have here. */
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, input poParameter as IParameter extent).    
    
    /** Indicates that the specified method should be injected with the specified value.  */
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poService as Progress.Lang.Class).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poService as Progress.Lang.Class, input pcInstanceName as character).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poService as Progress.Lang.Class, input poDataType as DataTypeEnum).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poService as Progress.Lang.Class, input poDataType as DataTypeEnum, input pcInstanceName as character).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poService as Progress.Lang.Class extent).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poService as Progress.Lang.Class extent, input poDataType as DataTypeEnum).
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poValue as Object).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poValue as Object, input poDeclaringType as Progress.Lang.Class).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poValue as Object extent).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poValue as Object extent, input poDeclaringType as Progress.Lang.Class).
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input pcValue as character).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input pcValue as character, input poDataType as DataTypeEnum).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input pcValue as character extent).
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input pcValue as character extent, input poDataType as DataTypeEnum).
    
    /** Generalised case for more complex scenarios; all other WithMethodValue() methods pass through this one. */
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, input poParameter as IParameter extent).
    
    @IBindingNamedSyntax.
    /** Gives the service an instance name. By default this is the service name  */
    method public IBindingSyntax Named(input pcInstanceName as character).
    
end interface.
