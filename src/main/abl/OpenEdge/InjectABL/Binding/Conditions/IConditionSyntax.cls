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
/* ------------------------------------------------------------------------
    File        : IConditionSyntax
    Purpose     : Defines the syntax for operating with conditions used for
                  resolving InjectABL bindings 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Mar 08 12:02:20 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.InjectABL.Binding.Conditions.IConditionSyntax.
using OpenEdge.InjectABL.Binding.Conditions.ICondition.

interface OpenEdge.InjectABL.Binding.Conditions.IConditionSyntax:
    define public property And as IConditionSyntax no-undo get.
    define public property Or as IConditionSyntax no-undo get.

    method public IConditionSyntax Condition(input poCondition as ICondition).
    
    method public IConditionSyntax Is(input poCondition as ICondition).
    method public IConditionSyntax Not(input poCondition as ICondition).
    
/*
    method public IConditionSyntax First(input poCondition as ICondition).
    method public IConditionSyntax Last(input poCondition as ICondition).
    method public IConditionSyntax Unique(input poCondition as ICondition).
*/
    
end interface.
