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
    File        : Pipeline
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 05 08:14:13 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.InjectABL.Lifecycle.IPipeline.
using OpenEdge.InjectABL.Lifecycle.ILifecycleStrategyCollection.
using OpenEdge.InjectABL.Lifecycle.ILifecycleStrategy.
using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.Collections.IIterator.

using OpenEdge.Core.Assert.
using Progress.Lang.Object.

class OpenEdge.InjectABL.Lifecycle.StandardPipeline implements IPipeline:
    
    define public property Strategies as ILifecycleStrategyCollection no-undo get. private set. 

    constructor public StandardPipeline(poStrategies as ILifecycleStrategyCollection):
        Assert:NotNull(poStrategies, 'Lifecycle strategies').
        
        Strategies = poStrategies.
    end constructor.
    
    method public void Activate(poContext as ILifecycleContext, poInstance as Object):
        define variable oIterator as IIterator no-undo.
        
        Assert:NotNull(poInstance, 'Instance').
        Assert:NotNull(poContext, 'Lifecycle context').
        
        oIterator = Strategies:Iterator().
        do while oIterator:HasNext():
            cast(oIterator:Next(), ILifecycleStrategy):Activate(poContext, poInstance).
        end.
    end method.
    
    method public void Deactivate(poContext as ILifecycleContext, poInstance as Object):
        define variable oIterator as IIterator no-undo.

        Assert:NotNull(poInstance, 'Instance').
        Assert:NotNull(poContext, 'Lifecycle context').
        
        oIterator = Strategies:Iterator().
        do while oIterator:HasNext():
            cast(oIterator:Next(), ILifecycleStrategy):Deactivate(poContext, poInstance).
        end.
    end method.
    
end class.
