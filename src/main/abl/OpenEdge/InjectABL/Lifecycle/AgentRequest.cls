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
    File        : AgentRequest
    Purpose     : 
    Syntax      : 
    Description : AgentRequest object : this object lives for the lifespan of 
                  an AppServer
    @author pjudge
    Created     : Fri Jun 04 15:00:56 EDT 2010
    Notes       : * The instance's lifespan is managed by as AppServer activate/deactivate
                    procedures.
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.InjectABL.Lifecycle.AgentRequest.
using OpenEdge.Core.Collections.Map.
using OpenEdge.Core.Collections.IMap.

using Progress.Lang.OERequestInfo.

class OpenEdge.InjectABL.Lifecycle.AgentRequest:
    define public property ActiveSince as datetime-tz no-undo get. private set.
    
    /* A collection of user-defined properties */
    define public property RequestProperties as IMap no-undo get. private set.
    
    define static public property Instance as AgentRequest no-undo  
        get():
            if not valid-object(Instance) then
                Instance = new AgentRequest().
            return Instance.
        end get.
        private set.
    
    define public property Id as char no-undo get. private set.
    
    constructor private AgentRequest():
        assign this-object:Id = cast(session:current-request-info, OERequestInfo):RequestId
               RequestProperties = new Map()
               ActiveSince = now.
    end constructor.

end class.
