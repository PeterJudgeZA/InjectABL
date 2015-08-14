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
    File        : SessionTypeCondition
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

using OpenEdge.InjectABL.Binding.Conditions.SessionTypeCondition.
using OpenEdge.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.InjectABL.Binding.Conditions.Condition.
using OpenEdge.InjectABL.Binding.Conditions.StandardConditionResolver.
using OpenEdge.InjectABL.Binding.Conditions.SessionTypeConditionResolver.

using OpenEdge.Core.String.
using Progress.Lang.Class. 
using Progress.Lang.Object.

class OpenEdge.InjectABL.Binding.Conditions.SessionTypeCondition inherits Condition:
    
    /* ThinClient, Server, FatClient used for RHS, to compare to the 'Condition:Type' condition */
    define static public property ThinClient as SessionTypeCondition no-undo get. private set. 
    define static public property Server     as SessionTypeCondition no-undo get. private set.
    define static public property FatClient  as SessionTypeCondition no-undo get. private set.
    
    define static private property ConditionResolverType as Progress.Lang.Class no-undo get. set.
    
    constructor static SessionTypeCondition():
        assign SessionTypeCondition:ThinClient = new SessionTypeCondition('ThinClient')
               SessionTypeCondition:Server     = new SessionTypeCondition('Server')
               SessionTypeCondition:FatClient  = new SessionTypeCondition('FatClient')
               
               SessionTypeCondition:ConditionResolverType = get-class(SessionTypeConditionResolver).
    end constructor.
    
    constructor public SessionTypeCondition (input pcValue as character):
        super (new String(pcValue)).
    end constructor.

    constructor public SessionTypeCondition (input poValue as Object):
        super (input poValue).
    end constructor.
    
    method override public IConditionResolver GetResolver():
        return StandardConditionResolver:GetResolver(SessionTypeCondition:ConditionResolverType). 
    end method.
    
end class.
