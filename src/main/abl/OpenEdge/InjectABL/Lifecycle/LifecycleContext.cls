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
    File        : LifecycleContext
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 10:03:26 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.InjectABL.Lifecycle.LifecycleContext.
using OpenEdge.InjectABL.ICache.
using OpenEdge.InjectABL.Lifecycle.IPipeline.
using OpenEdge.InjectABL.Lifecycle.IProvider.
using OpenEdge.InjectABL.Binding.IBinding.
using OpenEdge.InjectABL.IKernel.

using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.Collection.
using OpenEdge.Core.Assert.
using Progress.Lang.Object.

class OpenEdge.InjectABL.Lifecycle.LifecycleContext
        implements ILifecycleContext:
    
    /** Gets the kernel that is driving the activation. */
    define public property Kernel as IKernel no-undo get. private set.
    
    /** Gets the Binding */
    define public property Binding as IBinding no-undo get. private set.

    /** Gets the parameters that were passed to manipulate the activation process. */
    define public property Arguments as ICollection no-undo get. private set.

    /** Gets or sets the cache component. */
    define public property Cache as ICache no-undo get. private set.

    /** Gets or sets the pipeline component. */
    define public property Pipeline as IPipeline no-undo get. private set.

    /** Initializes a new instance of the <see cref="Context"/> class.
        @param kernel The kernel managing the resolution.
        @param request The context's Request:
        @param binding The context's Binding:
        @param cache The cache component.
        @param planner The planner component.
        @param pipeline The pipeline component. */
    constructor public LifecycleContext(poKernel as IKernel,
                                        poBinding as IBinding,
                                        poPipeline as IPipeline,
                                        poCache as ICache):
        
        Assert:NotNull(poKernel, "kernel").
        Assert:NotNull(poBinding, "binding").
        Assert:NotNull(poPipeline, "pipeline").
        Assert:NotNull(poCache, "cache").
        
        assign Kernel = poKernel
               Binding = poBinding
               /* (Deep) Clone the arguments, since we may mess with them on our travels here. */
               Arguments = cast(poBinding:Arguments:Clone(), ICollection)
               Pipeline = poPipeline
               Cache = poCache.
    end constructor.
    
    /** Gets the scope for the context that "owns" the instance activated therein.
        We don't store a reference for it since we want to be able to allow garbage 
        collection to clean it up. 
        
        @return The object that acts as the scope.
     */
    method public Object GetScope():
        return Binding:GetScope(this-object).
    end method.

    /** Gets the provider that should be used to create the instance for this context.
        @return The provider that should be used.
     */
    method public IProvider GetProvider():
        return Binding:GetProvider().
    end method.
    
    /** Resolves the instance associated with this context.
        
        @return The resolved instance.  */
    method public Object Resolve():
        define variable oInstance as Object no-undo.
        
        if Binding:TargetType:IsInterface() then
            oInstance = Kernel:Get(Binding:TargetType).
        else
        do:
            oInstance = Cache:TryGet(this-object).
            if valid-object(oInstance) then
                return oInstance.
            
            /* This will perform any constructor injection, via the provider. */
            oInstance = GetProvider():Create(this-object).
            
            /* Transient object aren't cached */
            if valid-object(GetScope()) then
                Cache:Remember(this-object, oInstance).
            
            /* Activation may have method and/or property injection */
            Pipeline:Activate(this-object, oInstance).
        end.
        
        return oInstance.
    end method.
    
    method override public Object Clone():
        define variable oClone as ILifecycleContext no-undo.
        
        oClone = new LifecycleContext(this-object:Kernel,
                                      this-object:Binding,
                                      this-object:Pipeline,
                                      this-object:Cache).
        return oClone.
    end method.
    
end class.
