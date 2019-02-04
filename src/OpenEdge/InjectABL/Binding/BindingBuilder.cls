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
    File        : BindingBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 14:51:10 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.IBindingSyntax.
using OpenEdge.InjectABL.Binding.IBinding.
using OpenEdge.InjectABL.Binding.BindingTargetEnum.
using OpenEdge.InjectABL.Binding.Parameters.Routine.
using OpenEdge.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.InjectABL.Binding.Parameters.Routine.
using OpenEdge.InjectABL.Binding.Conditions.Condition.
using OpenEdge.InjectABL.Binding.Conditions.ConditionBuilder.
using OpenEdge.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.InjectABL.Binding.Conditions.UITypeCondition.
using OpenEdge.InjectABL.Lifecycle.StandardScope.
using OpenEdge.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.InjectABL.IKernel.

using OpenEdge.Core.SessionClientTypeEnum.
using OpenEdge.Core.RoutineTypeEnum.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.Assert.
using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.InjectABL.Binding.BindingBuilder implements IBindingSyntax:
    
    /** Gets the binding being built.  */
    define public property Binding as IBinding no-undo get. private set.
    
    /** Gets the kernel.  */
    define public property Kernel as IKernel no-undo get. private set.
    
    /** Initializes a new instance of the BindingBuilder&lt.T&gt. class.
        @param IBinding The binding to build.
        @param IKernel The kernel. */
    constructor public BindingBuilder(input poBinding as IBinding, input poKernel as IKernel):
        Assert:NotNull(poBinding, "binding").
        Assert:NotNull(poKernel, "kernel").
        
        Binding = poBinding.
        Kernel = poKernel.
    end constructor.
    
    /** Indicates that the service should be self-bound.
        @return IBindingSyntax The current binding builder (for fluent syntax) */
    method public IBindingSyntax ToSelf():   
        Binding:TargetType = Binding:Service.
        Binding:Target = BindingTargetEnum:Self.
                
        return this-object.
    end method.
    
    /** Indicates that the service should be bound to the specified implementation type.
        
        @param Class The implementation type. This has to be a concrete type (ie not abstract 
               or an interface). 
        @return IBindingSyntax The current binding builder (for fluent syntax) */    
    method public IBindingSyntax To(input poImplementation as Progress.Lang.Class):
        Binding:TargetType = poImplementation.
        Binding:Target = BindingTargetEnum:Type.
        
        return this-object.
    end method.
    
    /** Indicates that the service should be bound to an instance of the specified provider type.
        The instance will be activated via the kernel when an instance of the service is activated.
        
        @param Class The type of provider to activate.
        @return IBindingSyntax The current binding builder (for fluent syntax)  */    
    method public IBindingSyntax Using(input poProviderType as Progress.Lang.Class):
        Binding:ProviderType = poProviderType.
        return this-object.
    end method.
        
    /** Indicates that only a single instance of the binding should be created, and then
        should be re-used for all subsequent requests.  */
    method public IBindingSyntax InSingletonScope():
        Binding:Scope = StandardScopeEnum:Singleton.        
        return this-object.
    end method.
    
    /** Indicates that instances activated via the binding should not be re-used, nor have
        their lifecycle managed by InjectABL.  
        
        @return IBindingSyntax The current binding builder (for fluent syntax) */
    method public IBindingSyntax InTransientScope():
        Binding:Scope = StandardScopeEnum:Transient.
        return this-object.
    end method.
    
    /** Indicates that an instance will be reused across an AppServer connection. 
        Meaningless for statefree AppServers. 
        
        @return IBindingSyntax The current binding builder (for fluent syntax) */
    method public IBindingSyntax InAgentConnectionScope():
        Binding:Scope = StandardScopeEnum:AgentConnection.
        return this-object.
    end method.
    
    /** Indicates that an instance will be reused across an AppServer request.
     
        @return IBindingSyntax The current binding builder (for fluent syntax) */
    method public IBindingSyntax InAgentRequestScope():
        Binding:Scope = StandardScopeEnum:AgentRequest.
        return this-object.
    end method.
    
    /** Generic scope binding
        
        @param Class The type providing the scope
        @return IBindingSyntax The current binding builder (for fluent syntax) */
    method public IBindingSyntax InScope(input poScopeCallback as Progress.Lang.Class, poScope as StandardScopeEnum):
        Assert:NotNull(poScopeCallback, 'Custom scope callback type').
        Assert:NotNull(poScope, 'Custom scope').
                
        /* Even though this is statically-called, we can still type-check */
        Assert:IsType(poScopeCallback, get-class(StandardScope)).
        
        Binding:Scope = poScope.
        Binding:ScopeCallbackType = poScopeCallback.
        
        return this-object.
    end method.
    
/* WithConstructorArgument */
    /* generalised case; all other WithConstructorArgument() methods pass through this one. */
    method public IBindingSyntax WithConstructorArgument(input poParameter as IParameter extent):    
        define variable oRoutine as Routine no-undo.
        
        oRoutine = new Routine(Binding:Service, '', RoutineTypeEnum:Constructor).
        oRoutine:Parameters = poParameter.
        
        Binding:Arguments:Add(oRoutine).
        return this-object.
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Progress.Lang.Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Progress.Lang.Class, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        oParameter[1]:ServiceInstanceName = pcInstanceName.
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Progress.Lang.Class, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDataType).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(poValue as Progress.Lang.Class, poDataType as DataTypeEnum, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDataType).
        oParameter[1]:ServiceInstanceName = pcInstanceName.
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(poService as Progress.Lang.Class extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(poService as Progress.Lang.Class extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, poDataType).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(poValue as Object, poDeclaringType as Progress.Lang.Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDeclaringType).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object extent):
        define variable oParameter as IParameter extent 1 no-undo.
        
        /* compiler should call WithConstructorArg(IParameter[]) not this one! */
        Assert:NotType(poValue[1], get-class(IParameter)).

        oParameter[1] = new Parameter(poValue).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(poValue as Object extent, poDeclaringType as Progress.Lang.Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDeclaringType).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(pcValue as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(pcValue as character, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithConstructorArgument(oParameter). 
    end method.

    method public IBindingSyntax WithConstructorArgument(pcValue as character extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
    method public IBindingSyntax WithConstructorArgument(pcValue as character extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithConstructorArgument(oParameter). 
    end method.
    
/* WithPropertyValue */
    /** Generalised case for more complex scenarios; all other WithPropertyValue() methods pass through this one. This method will probably never be called directly, but
        it doesn't hurt to have here. */
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character,
                                                   input poParameter as IParameter extent).    
        define variable oRoutine as Routine no-undo.
        
        oRoutine = new Routine(Binding:Service, pcPropertyName, RoutineTypeEnum:PropertySetter).
        oRoutine:Parameters = poParameter.
        
        Binding:Arguments:Add(oRoutine).
        return this-object.
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as Progress.Lang.Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as Progress.Lang.Class, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, pcInstanceName).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as Progress.Lang.Class, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, poDataType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as Progress.Lang.Class, poDataType as DataTypeEnum, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, poDataType, pcInstanceName).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as class  Class extent ):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poService as Progress.Lang.Class extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, poDataType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poValue as Object ):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).

        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poValue as Object, poDeclaringType as Progress.Lang.Class):
        define variable oParameter as IParameter extent 1 no-undo.
        
        oParameter[1] = new Parameter(poValue, poDeclaringType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poValue as Object extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, poValue as Object extent, poDeclaringType as Progress.Lang.Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDeclaringType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
        
    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, pcValue as character ):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, pcValue as character, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, pcValue as character extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.

    method public IBindingSyntax WithPropertyValue(input pcPropertyName as character, pcValue as character extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithPropertyValue(pcPropertyName, oParameter). 
    end method.
    
/* WithMethodValue */
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poService as Progress.Lang.Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poService).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poService as Progress.Lang.Class, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poService, pcInstanceName).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poService as Progress.Lang.Class extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poService).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Object, poDeclaringType as Progress.Lang.Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue, poDeclaringType).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Object):
        define variable oParameter as IParameter extent 1 no-undo.
        
        oParameter[1] = new Parameter( poValue).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.
        
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Progress.Lang.Class, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue, poDataType).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Progress.Lang.Class, poDataType as DataTypeEnum, input pcInstanceName as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(poValue, poDataType, pcInstanceName).

        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Object extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Object extent, poDeclaringType as Progress.Lang.Class):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue, poDeclaringType).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, poValue as Progress.Lang.Class extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( poValue, poDataType).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, pcValue as character):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( pcValue).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, pcValue as character, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter(pcValue, poDataType).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character, pcValue as character extent):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( pcValue).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.

    method public IBindingSyntax WithMethodValue(input pcMethodName as character, pcValue as character extent, poDataType as DataTypeEnum):
        define variable oParameter as IParameter extent 1 no-undo.

        oParameter[1] = new Parameter( pcValue, poDataType).
        
        return WithMethodValue(pcMethodName, oParameter). 
    end method.
    
    method public IBindingSyntax WithMethodValue(input pcMethodName as character,
                                                 input poParameter as IParameter extent):
        define variable oRoutine as Routine no-undo.
        
        oRoutine = new Routine(Binding:Service, pcMethodName, RoutineTypeEnum:Method).
        oRoutine:Parameters = poParameter.
        
        Binding:Arguments:Add(oRoutine).
        return this-object.
    end method.
    
    /* When */    
    method public IConditionSyntax When():
        define variable oConditionBuilder as IConditionSyntax no-undo.
        
        if valid-object(Binding:Condition) then
            oConditionBuilder = new ConditionBuilder(Binding:Condition).
        else
            oConditionBuilder = new ConditionBuilder(Binding).
        
        return oConditionBuilder.
    end method.
    
    /** Binding is applicable to a client session. This is typically a GUI or thin-client of some sort */
    method public IBindingSyntax OnThinClientSession():
        define variable oConditionSyntax as IConditionSyntax no-undo.
        
        oConditionSyntax = this-object:When().
        oConditionSyntax:Condition(OpenEdge.InjectABL.Binding.Conditions.Condition:Type):Is(SessionTypeCondition:ThinClient).

        return this-object.
    end method.

    /** Binding applicable to a server session. This is any headless backend - appserver, webserver etc */
    method public IBindingSyntax OnServerSession():
        define variable oConditionSyntax as IConditionSyntax no-undo.
        
        oConditionSyntax = this-object:When().
        oConditionSyntax:Condition(OpenEdge.InjectABL.Binding.Conditions.Condition:Type):Is(SessionTypeCondition:Server).

        return this-object.
    end method.

    /** Binding is applicable to a complete client/server session. Typically a development environment, or fat client */
    method public IBindingSyntax OnFatClientSession():
        define variable oConditionSyntax as IConditionSyntax no-undo.
        
        oConditionSyntax = this-object:When().
        oConditionSyntax:Condition(OpenEdge.InjectABL.Binding.Conditions.Condition:Type):Is(SessionTypeCondition:FatClient).

        return this-object.
    end method.
    
    /** Indicates that the binding is valid for a session as identified by an application-specific code/name */
    method public IBindingSyntax OnNamedSession(input pcSessionCode as character).
        define variable oConditionSyntax as IConditionSyntax no-undo.
        
        oConditionSyntax = this-object:When().
        oConditionSyntax:Condition(OpenEdge.InjectABL.Binding.Conditions.Condition:Name):Is(new SessionTypeCondition(pcSessionCode)).
        
        return this-object.
    end method.
    
    method public IBindingSyntax Named(pcName as character):
        Binding:Name = pcName.
        return this-object.
    end method.
    
end class.
