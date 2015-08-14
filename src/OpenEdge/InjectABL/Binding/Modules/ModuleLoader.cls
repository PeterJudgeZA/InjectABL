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
    File        : ModuleLoader
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 10:23:08 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.Modules.IInjectionModule.
using OpenEdge.InjectABL.IKernel.
using OpenEdge.Core.Assert.

class OpenEdge.InjectABL.Binding.Modules.ModuleLoader: 
        /** Gets or sets the kernel into which modules will be loaded. **/
        define public property Kernel as IKernel no-undo get. private set.

        /** Initializes a new instance of the <see cref="ModuleLoader"/> class. 
            <param name="kernel">The kernel into which modules will be loaded.</param>
        **/
        constructor public ModuleLoader(poKernel as IKernel):
            Assert:NotNull(poKernel, "kernel").
            Kernel = poKernel.
        end constructor.

        /** Loads any modules found in the files that match the specified patterns.
            <param name="patterns">The patterns to search.</param>
        **/
        method public void LoadModules(pcPatterns as char extent):
            def var oModule as IInjectionModule.
            
            Kernel:Load(oModule).
        end.
end class.
