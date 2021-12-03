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
    File        : IBinding
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:30:06 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.InjectABL.Binding.BindingTargetEnum.
using OpenEdge.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.InjectABL.Binding.IBinding.
/*using OpenEdge.InjectABL.Binding.Parameters.IParameterCollection.*/
using OpenEdge.InjectABL.Lifecycle.IProvider.
using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.Collections.ObjectStack.
using OpenEdge.Core.Collections.ICollection.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.InjectABL.Binding.IBinding:
    /** Gets the service type that is controlled by the binding. */
    define public property Service as Progress.Lang.Class no-undo get.
    
    /** Gets or sets the type of target for the binding. */
    define public property Target as BindingTargetEnum no-undo get. set.
    define public property TargetType as Progress.Lang.Class no-undo get. set.
    
    /** Gets or sets  the optional name defined for the binding target. 
    define public property TargetName as character no-undo get. set.
    */
    
    /** Gets a value indicating whether the binding has a condition associated with it. */
    define public property IsConditional as logical no-undo get.
    
    /** Gets or sets the condition defined for the binding. */
    define public property Condition as ObjectStack no-undo get. set.
    
    /** Gets or sets the type that returns the provider that should be used by the binding. */
    define public property ProviderType as Progress.Lang.Class no-undo get. set.
    
    /** Gets or sets the callback that returns the object that will act as the binding's scope. */
    define public property Scope as StandardScopeEnum no-undo get. set. 
    define public property ScopeCallbackType as Progress.Lang.Class no-undo get. set.
    
    /** Gets the parameters defined for the binding. */
    define public property Arguments as ICollection no-undo get.
    
    /** Gets or sets  the optional name defined for the binding. */
    define public property Name as character no-undo get. set.
    
    /** Gets the provider for the binding.
        @param context The context.
        @return The provider to use.    */
    method public IProvider GetProvider().
    
    /** Gets the scope for the binding, if any.
        @param context The context.
        @return The object that will act as the scope, or unknown if the service is transient. */
    method public Object GetScope(poContext as ILifecycleContext).

    /** Determines whether the specified request satisfies the conditions defined on this binding.
        @param request The request.
        @return <c>True</c> if the request satisfies the conditions. otherwise <c>false</c>. */
    method public logical Matches(poBinding as IBinding).
    
end interface.
