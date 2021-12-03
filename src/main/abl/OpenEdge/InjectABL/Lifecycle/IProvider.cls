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
    File        : IProvider
    Purpose     : 
    Syntax      : 
    Description : Creates instances of services.
    @author pjudge
    Created     : Tue Mar 02 13:27:19 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using Progress.Lang.Object.
using Progress.Lang.Class.

interface OpenEdge.InjectABL.Lifecycle.IProvider:  
    /** Gets the type (or prototype) of instances the provider creates. */
    define public property Type as Progress.Lang.Class no-undo get.

    /** Creates an instance within the specified context.
    
        @param ILifecycleContext The context used to create the object.
        @return Object The created instance. */
    method public Object Create(poContext as ILifecycleContext).
    
    /** Dependency injection into a method.
    
        @param Object The instance into which we inject values
        @param ILifecycleContext The context containing the values to be injected */
    method public void InjectMethods(poInstance as Object, poContext as ILifecycleContext).    
    
    /** Dependency injection into a property.
        
        @param Object The instance into which we inject values
        @param ILifecycleContext The context containing the values to be injected */
    method public void InjectProperties(poInstance as Object, poContext as ILifecycleContext).
    
end interface.
