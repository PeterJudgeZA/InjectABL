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
    File        : PropertyInjectionLifecycleStrategy
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 11 09:02:02 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.InjectABL.Lifecycle.LifecycleStrategy.
using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.InjectABL.Lifecycle.PropertyInjectionLifecycleStrategy inherits LifecycleStrategy: 
    constructor public PropertyInjectionLifecycleStrategy (  ):
        super ().
    end constructor.
    
    method override public void Activate(poContext as ILifecycleContext, poInstance as Object):
        poContext:GetProvider():InjectProperties(poInstance, poContext).
    end method.
    
end class.
