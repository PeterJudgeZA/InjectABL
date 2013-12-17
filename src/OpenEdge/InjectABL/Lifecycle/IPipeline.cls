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
    File        : IPipeline
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 05 08:09:14 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.InjectABL.Lifecycle.*.
using Progress.Lang.*.

interface OpenEdge.InjectABL.Lifecycle.IPipeline:  
    /** Gets the strategies that contribute to the activation and deactivation processes. **/
    define public property Strategies as ILifecycleStrategyCollection no-undo get.

    /** Activates the instance in the specified context. 
        @param ILifecycleContext The context.
        @param Object The instance reference. */
    method public void Activate(poContext as ILifecycleContext, poInstance as Object).

    /** Deactivates the instance in the specified context.
        @param ILifecycleContext The context
        @param Object The instance reference. */
    method public void Deactivate(poContext as ILifecycleContext, poInstance as Object).
  
end interface.
