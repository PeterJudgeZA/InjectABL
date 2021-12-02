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
    File        : StandardConditionResolver
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 29 10:05:25 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.InjectABL.Binding.Conditions.Condition.

using OpenEdge.Core.Assert.

using Progress.Lang.Class.

class OpenEdge.InjectABL.Binding.Conditions.StandardConditionResolver implements IConditionResolver: 

    constructor public StandardConditionResolver():
    end constructor. 

    /** Evaluates the provided conditions. 
        
        @param ICondition The left-hand side argument for the clause
        @param ICondition The clause operator
        @param ICondition The right-hand side argument for the clause
        @return logical Whether the clause resolves to true or false
         */
    method public logical EvaluateClause(input poLHS as ICondition,
                                         input poOperator as ICondition,
                                         input poRHS as ICondition):
        define variable lConditionsMet as logical no-undo.
        
        case poOperator:
            when OpenEdge.InjectABL.Binding.Conditions.Condition:Is  then lConditionsMet = poLHS:Equals(poRHS).
            when OpenEdge.InjectABL.Binding.Conditions.Condition:Not then lConditionsMet = not poLHS:Equals(poRHS).
        end case.
        
        return lConditionsMet.
    end method.
        
    /** Factory method for new IConditionResolver instances.
        
        @param Class The typename of the condition resolver.
        @return IConditionResolver The new resolver to use.      */
    method static public IConditionResolver GetResolver(input poConditionResolverType as Progress.Lang.Class):
        define variable oConditionResolver as IConditionResolver no-undo.
        
        Assert:NotNull(poConditionResolverType, 'Condition Resolver Type').
        Assert:IsType(poConditionResolverType,  get-class(IConditionResolver)).
        
        oConditionResolver = dynamic-new(poConditionResolverType:TypeName) ().
        
        return oConditionResolver.
    end method.
    
    
end class.
