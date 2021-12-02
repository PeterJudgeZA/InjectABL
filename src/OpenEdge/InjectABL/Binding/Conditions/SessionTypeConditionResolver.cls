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
    File        : SessionTypeConditionResolver
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Dec 29 10:05:25 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.SessionClientTypeEnum.
using OpenEdge.InjectABL.Binding.Conditions.Condition.
using OpenEdge.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.InjectABL.Lifecycle.ABLSession.


class OpenEdge.InjectABL.Binding.Conditions.SessionTypeConditionResolver implements IConditionResolver:
    define public property CurrentSession as SessionClientTypeEnum no-undo
        get.
        private set.
        
    constructor public SessionTypeConditionResolver():
        assign this-object:CurrentSession = SessionClientTypeEnum:GetEnum(session:client-type).
    end constructor. 
    
    /** Evaluates the provided conditions. 
        
        @param ICondition The left-hand side argument for the clauseRdatas
        @param ICondition The clause operator
        @param ICondition The right-hand side argument for the clause
        @return logical Whether the clause resolves to true or false.  */
    method public logical EvaluateClause(input poLHS as ICondition,
                                         input poOperator as ICondition,
                                         input poRHS as ICondition):
        define variable lConditionsMet as logical no-undo.
        define variable currentSession as SessionClientTypeEnum no-undo.
        
        case poLHS:
            when Condition:Type then
            do:
                /* Available SessionConditions: ThinClient, FatClient, Server */
                case poRHS:
                    when SessionTypeCondition:ThinClient then
                        lConditionsMet = this-object:CurrentSession:Equals(SessionClientTypeEnum:ABLClient)
                                      or this-object:CurrentSession:Equals(SessionClientTypeEnum:WebClient).
                    when SessionTypeCondition:FatClient then
                        /* A fat client contains client and server components, and thus is a client that is not a WebClient. */
                        lConditionsMet = this-object:CurrentSession:Equals(SessionClientTypeEnum:ABLClient)
                                       and not this-object:CurrentSession:Equals(SessionClientTypeEnum:WebClient).
                    when SessionTypeCondition:Server then
                        /* We assume that the other/underfined session client types are used as servers. */
                        lConditionsMet = this-object:CurrentSession:Equals(SessionClientTypeEnum:AppServer)
                                      or this-object:CurrentSession:Equals(SessionClientTypeEnum:WebSpeed)
                                      or this-object:CurrentSession:Equals(SessionClientTypeEnum:Other).
                end case.
            end.
            when Condition:Name then lConditionsMet = ABLSession:Instance:Name eq poRHS:ToString().
        end case.
        
        /* If the operator is Not, the flip the evaluation */
        if poOperator:Equals(Condition:Not) then
            lConditionsMet = not lConditionsMet.
        
        return lConditionsMet.
    end method.
    
end class.
