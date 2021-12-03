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
    File        : LifecycleStrategy
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 05 07:58:07 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.InjectABL.Lifecycle.ILifecycleStrategy.
using Progress.Lang.Object.

class OpenEdge.InjectABL.Lifecycle.LifecycleStrategy abstract implements ILifecycleStrategy: 
    
    constructor public LifecycleStrategy ():
    end constructor.
    
    @method(virtual="True").
    method public void Activate(poContext as ILifecycleContext, poInstance as Object):
    end method.
    
    @method(virtual="True").
    method public void Deactivate(poContext as ILifecycleContext, poInstance as Object):
    end method.
    
end class.
