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
    File        : IKernel
    Purpose     : InjectABL Kernel interface
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:24:26 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */

using OpenEdge.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.InjectABL.Binding.Modules.IInjectionModule.
using OpenEdge.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.InjectABL.IInjectionRequest.
using OpenEdge.InjectABL.ComponentContainer.
using OpenEdge.InjectABL.KernelSettings.

using OpenEdge.Core.Collections.ICollection.
using Progress.Lang.Class.
using Progress.Lang.Object.

interface OpenEdge.InjectABL.IKernel: /* inherits IBindingRoot */
    
    /** Gets the injection kernel settings  */
    define public property Settings as KernelSettings no-undo get.
    
    /** Gets the component container, which holds components that contribute to InjectABL.  */
    define public property Components as ComponentContainer no-undo get.

    /** Gets the modules that have been loaded into the kernel.  */
    define public property Modules as IInjectionModuleCollection no-undo get.

    /** Instantiates an instance of an object that matches the passed service,
        as determined by the bindings in a loaded module. 
    
        @param Class A service represented by a Progress.Lang.Class type instance.
        @return An instance of the requested service/interface    */
    method public Object Get(input poService as Progress.Lang.Class).
        
    /** Instantiates an instance of an object that matches the passed service and
        name, as determined by the bindings in a loaded module. 
        
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param character A name for the service   
        @return An instance of the requested service/interface    */
    method public Object Get(input poService as Progress.Lang.Class,
                             input pcName as character).
    
    /** Instantiates an instance of an object that matches the passed service,
        as determined by the bindings in a loaded module. 
    
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param ICollection A collection of arguments to add to the bindings for the
                            object being instantiated.  
        @return Object An instance of the requested service/interface    */
    method public Object Get(input poService as Progress.Lang.Class,
                             input poArguments as ICollection).
    
    /** Determines whether a module with the specified name has been loaded in the kernel.
        
        @param character The name of the module.
        @return True if the specified module has been loaded. otherwise, false. */
    method public logical HasModule(input pcName as character).

    /** Loads module(s) into the kernel.
        
        @param IInjectionModuleCollection The modules to load. */
    method public void Load(input poModules as IInjectionModuleCollection).
    
    /** Loads a single module into the kernel.
        
        @param IInjectionModule The module to load. */
    method public void Load(input poModules as IInjectionModule).

    /** Loads modules from the files that match the specified pattern(s).
        @param character An array of file patterns (i.e. "*.dll", "modules/ *.rb") 
                         to match. */
    method public void Load(input pcFilePatterns as character extent).
    
    /** Unloads the plugin with the specified name.
        @param character The plugin's name. */
    method public void Unload(input pcName as char).
    
    /** Injects the specified existing instance, without managing its lifecycle.
        @param Object The instance to inject.
        @param ICollection A collection of arguments to add to the bindings for the
                            object being instantiated.  */
    method public void Inject(input poInstance as Object,
                              input poArguments as ICollection).

    /** Deactivates and releases the specified instance if it is currently managed by InjectABL.
        
        @param Object The instance to release.
        @return logical True if the instance was found and released. otherwise false. */
    method public logical Release(input poInstance as Object).

    /** Deactivates and releases all instances scoped to the specified object.
    
        @param Object The scope object for which to release instances.  */
    method public void Clear(input poScope as Object).
    
    /** Indicates whether a service is cached or not. 
        
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param character A name for the service
        @return Logical Returns true if the service is being cached ; false if not in cache.
                Note that a true return value doesn't mean there isn't a running instance of the service -
                since transient instances aren't cached - but only that there are no cached instances. */        
    method public logical IsCached(input poService as Progress.Lang.Class,
                                   input pcName as character).

    /** Indicates whether a service is cached or not. 
        
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param character A name for the service
        @param ICollection A collection of arguments to add to the bindings for the
                            object being instantiated.        
        @return Logical Returns true if the service is being cached ; false if not in cache.        
                Note that a true return value doesn't mean there isn't a running instance of the service -
                since transient instances aren't cached - but only that there are no cached instances. */        
    method public logical IsCached(input poService as Progress.Lang.Class,
                                   input pcName as character,
                                   input poArguments as ICollection).
    
end interface.
