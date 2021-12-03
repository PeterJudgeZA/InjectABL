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
    File        : StandardKernel
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 11:23:20 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.InjectABL.KernelBase.
using OpenEdge.InjectABL.ComponentContainer.
using OpenEdge.InjectABL.KernelSettings.
using OpenEdge.InjectABL.ICache.
using OpenEdge.InjectABL.Cache.
using OpenEdge.InjectABL.Lifecycle.IPipeline.
using OpenEdge.InjectABL.Lifecycle.StandardPipeline.
using OpenEdge.InjectABL.Lifecycle.ILifecycleStrategy.
using OpenEdge.InjectABL.Lifecycle.PropertyInjectionLifecycleStrategy.
using OpenEdge.InjectABL.Lifecycle.ILifecycleStrategy.
using OpenEdge.InjectABL.Lifecycle.MethodInjectionLifecycleStrategy.
using OpenEdge.InjectABL.Binding.IBindingResolver.
using OpenEdge.InjectABL.Binding.StandardBindingResolver.
using Progress.Lang.Class.

class OpenEdge.InjectABL.StandardKernel inherits KernelBase: 
    
    method protected override void AddComponents():
        /* these are mappings */
        
        /* Cache */
        Components:Add(get-class(ICache),
                       get-class(Cache)).

        /* Pipeline */
        Components:Add(get-class(IPipeline),
                       get-class(StandardPipeline)).

        Components:Add(get-class(ILifecycleStrategy), 
                       get-class(PropertyInjectionLifecycleStrategy)).
        Components:Add(get-class(ILifecycleStrategy),
                       get-class(MethodInjectionLifecycleStrategy)).
        
        /* Binding */        
        Components:Add(get-class(IBindingResolver), 
                       get-class(StandardBindingResolver)).
    end method.
    
    constructor public StandardKernel():
        super().
    end constructor.

    constructor public StandardKernel(poModules as IInjectionModuleCollection):
        super(poModules).
    end constructor.
        
    constructor protected StandardKernel (poComponents as ComponentContainer,
                                          poModules as IInjectionModuleCollection,
                                          poSettings as KernelSettings):
        super(poComponents, poModules, poSettings).
    end constructor.
    
end class.
