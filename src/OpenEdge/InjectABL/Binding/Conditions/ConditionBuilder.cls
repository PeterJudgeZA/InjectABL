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
    File        : ConditionBuilder
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 08 11:50:07 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.InjectABL.Binding.Conditions.Condition.
using OpenEdge.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.InjectABL.Binding.IBinding.
using OpenEdge.InjectABL.IKernel.

using OpenEdge.Core.Collections.ObjectStack.
using OpenEdge.Core.Assert.

class OpenEdge.InjectABL.Binding.Conditions.ConditionBuilder implements IConditionSyntax:
    define public property BindingCondition as ObjectStack no-undo get. private set.
    define public property Kernel as IKernel no-undo get. private set.
    
    define public property And as IConditionSyntax no-undo
        get():
            BindingCondition:Push(OpenEdge.InjectABL.Binding.Conditions.Condition:And).
            return this-object.
        end get.

    define public property Or as IConditionSyntax no-undo
        get():
            BindingCondition:Push(OpenEdge.InjectABL.Binding.Conditions.Condition:Or).
            return this-object. 
        end get.

/*
    define public property Is as IConditionSyntax no-undo
        get():
            BindingCondition:Push(Condition:Is).
            return this-object. 
        end get.
        
    define public property Not as IConditionSyntax no-undo
        get():
            BindingCondition:Push(Condition:Not).
            return this-object. 
        end get.
*/
    
    constructor public ConditionBuilder(input poBindingCondition as ObjectStack):
        BindingCondition = poBindingCondition.
        BindingCondition:Push(OpenEdge.InjectABL.Binding.Conditions.Condition:And).
    end constructor.
    
    constructor public ConditionBuilder(input poBinding as IBinding):
        Assert:NotNull(poBinding, "Binding").
        
        /* Guesstimate at default depth. */
        BindingCondition = new ObjectStack(10).
        BindingCondition:AutoExpand = true.
        
        poBinding:Condition = BindingCondition.
        
        BindingCondition:Push(OpenEdge.InjectABL.Binding.Conditions.Condition:When).
    end constructor.
    
    method public IConditionSyntax Condition(input poCondition as ICondition).
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
    method public IConditionSyntax Is(input poCondition as ICondition):
        BindingCondition:Push(OpenEdge.InjectABL.Binding.Conditions.Condition:Is).
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
    method public IConditionSyntax Not(input poCondition as ICondition):
        BindingCondition:Push(OpenEdge.InjectABL.Binding.Conditions.Condition:Not).
        BindingCondition:Push(poCondition).
        return this-object.
    end method.
    
end class.
