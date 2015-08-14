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
    File        : IInjectionModule
    Purpose     : Interface for module containing a collection of bindings
                  used for dependency injection.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:09:36 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.InjectABL.IKernel.

interface OpenEdge.InjectABL.Binding.Modules.IInjectionModule:
    
    /** Gets the module's name. */
    define public property Name as character no-undo get.
    
    /** Called when the module is loaded into a kernel.
         @param IKernel The kernel that is loading the module. */
     method public void OnLoad(poKernel as IKernel).
     
     /** Called when the module is unloaded from a kernel.
         @param IKernel The kernel that is unloading the module. */
     method public void OnUnload(poKernel as IKernel).
          
end interface.
