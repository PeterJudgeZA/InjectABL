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
/**------------------------------------------------------------------------
    File        : StandardBindingResolver
    Purpose     : Returns all bindings for (typically) a service that meet
                  service, name and condition requirements. More than one
                  binding may be returned. The decision of which binding to
                  use is done by the InjectABL Kernel.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 09 09:02:30 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.InjectABL.Binding.IBindingResolver.
using OpenEdge.InjectABL.Binding.IBinding.
using OpenEdge.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.InjectABL.Binding.Conditions.Condition.
using OpenEdge.Core.System.NotFoundError.

using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.ObjectStack.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.InjectABL.Binding.StandardBindingResolver implements IBindingResolver:
    
    /** Returns valid binding(s) for the service from a set of bindings
        
        @param IMap The complete set of bindings to resolve
        @param Class The service type
        @param character The binding name
        @return IList  The list of bindings corresponding to the service & name */
    method public IList Resolve(input poBindings as IMap,
                                input poService as Progress.Lang.Class,
                                input pcName as character):
        define variable oResolvedBindings as IList no-undo.
        define variable oServiceBindings as IList no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oBinding as IBinding no-undo.
        
        oServiceBindings = cast(poBindings:Get(poService), IList).
        if not valid-object(oServiceBindings) then
            undo, throw new NotFoundError(
                    substitute('Service &1', poService:TypeName),
                    'kernel bindings').

        assign oResolvedBindings = new List().
               oIterator = oServiceBindings:Iterator().
        
        do while oIterator:HasNext():
            oBinding = cast(oIterator:Next(), IBinding).
            
            /* Names need to match */
            if oBinding:Name ne pcName then
                next.
            
            /* All conditions need to be satisfied */
            if oBinding:IsConditional and
               not ResolveCondition(oBinding) then
                next.
            
            /* We can use this binding */
            oResolvedBindings:Add(oBinding).
        end.
        
        return oResolvedBindings.
    end method.
    
    /** Resolved the conditions attached to a binding
        
        @param IBinding The biding in question
        @return Logical Whether the binding meets the conditions or not. */
    method protected logical ResolveCondition(input poBinding as IBinding):
        define variable oFIFOConditions as ObjectStack no-undo.
        define variable oCondition as ICondition no-undo.
        define variable lConditionsMet as logical no-undo.
        define variable lSubconditionMet as logical no-undo.
        define variable oLHS as ICondition no-undo.
        define variable oClauseOperator as ICondition no-undo.
        define variable oRHS as ICondition no-undo.
        define variable oOperator as ICondition no-undo.
        
        /* Extract the stack since we basically want to stack to be immutable, since we may
           use the binding again. Pop() will clear the stack. */
        oFIFOConditions = cast(poBinding:Condition:Clone(), ObjectStack).
        /* Invert the stack since we want to work backwards through the stack - FIFO rather than 
           LIFO - since the conditions are added 'forwards' and we want to read 'em that way. */
        oFIFOConditions:Invert().

        lConditionsMet = true.
        
        do while oFIFOConditions:Size gt 0:
            assign oCondition = cast(oFIFOConditions:Pop(), ICondition).
            
            case oCondition:
                /* 'When' starts a new set of evaluations. We treat this as an And (true);
                   this is necessary for cases where there is only one condition. */ 
                when OpenEdge.InjectABL.Binding.Conditions.Condition:When then
                    assign oOperator = OpenEdge.InjectABL.Binding.Conditions.Condition:And
                           lSubconditionMet = true.
                
                when OpenEdge.InjectABL.Binding.Conditions.Condition:And or 
                when OpenEdge.InjectABL.Binding.Conditions.Condition:Or then
                    oOperator = oCondition.
                
                otherwise
                    /* Clauses appear on the stack as Condition, Is/Not, Condition */
                    assign oLHS = oCondition
                           oClauseOperator = cast(oFIFOConditions:Pop(), ICondition) 
                           oRHS = cast(oFIFOConditions:Pop(), ICondition)
                           /* Use RHS for resolver, since the RHS is more likely to be more specialised:
                              the LHS might be 'Name' and the RHS refer to a session type or ui type.
                              
                              The resolver can check the LHS if it chooses to, for type compatability */            
                           lSubconditionMet = oRHS:GetResolver():EvaluateClause(oLHS, oClauseOperator, oRHS).
            end case.
            
            /* if need be, do the comparison */
            if valid-object(oOperator) then
            do:
                case oOperator:
                    when OpenEdge.InjectABL.Binding.Conditions.Condition:Or then
                    do:
                        lConditionsMet = lConditionsMet or lSubconditionMet.
                        
                        /* If we've satisfied at least one of the OR conditions,
                           we can leave this When block. Don't leave is the conditions
                           are false, since we may come across a true condition later. */
                        if lConditionsMet then
                            leave.
                    end.
                    
                    when OpenEdge.InjectABL.Binding.Conditions.Condition:And then
                    do:
                        lConditionsMet = lConditionsMet and lSubconditionMet.
                        
                        /* If we come across a single false condition, leave, since we know there
                           is nothing more to do.  */
                        if not lConditionsMet then
                            leave.
                    end.
                end case.   /* operator */
            end.    /* valid operator */
        end.   /* stuff on stack */
        
        return lConditionsMet.
    end method.
    
end class.
