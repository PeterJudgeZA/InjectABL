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
    File        : ConnectionCondition
    Purpose     : Session type and session code conditions for bindings.
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 11:02:32 EST 2010
    Notes       : * We need a separate Condition class here since we want to 
                    have our own ConditionResolver, since there may be 
                    some special treatment
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.Conditions.ConnectionCondition.
using OpenEdge.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.InjectABL.Binding.Conditions.Condition.
using OpenEdge.InjectABL.Binding.Conditions.StandardConditionResolver.
using OpenEdge.InjectABL.Binding.Conditions.ConnectionConditionResolver.

using Progress.Lang.Class. 
using Progress.Lang.Object.

class OpenEdge.InjectABL.Binding.Conditions.ConnectionCondition inherits Condition:
    define static public property CurrentConnection as ICondition no-undo get. set.
    
    define static private property ConditionResolverType as Progress.Lang.Class no-undo get. set.
    
    constructor static ConnectionCondition():
          ConnectionCondition:CurrentConnection = new ConnectionCondition('CURRENT_CONNECTIONS'). 
          ConnectionCondition:ConditionResolverType = get-class(ConnectionConditionResolver).
    end constructor.
    
    constructor public ConnectionCondition (input pcValue as character):
        super(pcValue).
    end constructor.

    constructor public ConnectionCondition (input poValue as Object):
        super (input poValue).
    end constructor.
    
    method override public IConditionResolver GetResolver():
        return StandardConditionResolver:GetResolver(ConnectionCondition:ConditionResolverType). 
    end method.
    
end class.
