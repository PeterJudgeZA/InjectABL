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
    File        : IConditionResolver
    Purpose     : InjectABL condition resolution interface.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 10 13:19:00 EST 2010
    Notes       : * Not all conditions resolve as simply as X:Equals(Y);
                    for example, the session type resolves may depend on
                    whether there are AppServers or DBs connected to determine
                    the validity of a clause.
  ---------------------------------------------------------------------- */
using OpenEdge.InjectABL.Binding.Conditions.ICondition.

interface OpenEdge.InjectABL.Binding.Conditions.IConditionResolver:
    
    /** Evaluates the provided conditions. 
        
        @param ICondition The left-hand side argument for the clause
        @param ICondition The clause operator
        @param ICondition The right-hand side argument for the clause
        @return logical Whether the clause resolves to true or false
         */
    method public logical EvaluateClause(input poLHS as ICondition,
                                         input poOperator as ICondition,
                                         input poRHS as ICondition).
    
end interface.
