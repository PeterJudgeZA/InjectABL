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
    File        : StandardScope
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Wed Mar 03 14:37:17 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.InjectABL.Lifecycle.StandardScope.
using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.InjectABL.Lifecycle.StandardScopeEnum.

using OpenEdge.InjectABL.Lifecycle.ABLSession.
using OpenEdge.InjectABL.Lifecycle.AgentConnection.
using OpenEdge.InjectABL.Lifecycle.AgentRequest.

using Progress.Lang.AppError.
using Progress.Lang.Object.

class OpenEdge.InjectABL.Lifecycle.StandardScope:
    /** Gets the callback for scope. */
    method static public Object GetScope(poContext as ILifecycleContext,
                                         poScope as StandardScopeEnum  /* StandardScope */ ):
        case poScope:
            when StandardScopeEnum:Transient then return StandardScope:Transient(poContext).
            when StandardScopeEnum:Singleton then return StandardScope:Singleton(poContext).
            when StandardScopeEnum:ABLSession then return StandardScope:ABLSession(poContext).
            when StandardScopeEnum:AgentConnection then return StandardScope:AgentConnection(poContext).
            when StandardScopeEnum:AgentRequest then return StandardScope:AgentRequest(poContext).
        end case.
    end method.
    
    method static public Object Transient(poContext as ILifecycleContext):
        return ?.
    end method.
    
    /** Gets the callback for singleton scope. This scope is for the lifetime of the Kernel. This
        is usually the same as the session, but doesn't have to be. */
    method static public Object Singleton(poContext as ILifecycleContext):
         return poContext:Kernel.
    end method.

    /** Gets the callback for ABL Session scope. This scope is for the lifetime of the Session.
     */
    method static public Object ABLSession(poContext as ILifecycleContext):
        return ABLSession:Instance.
    end method.
    
    /** Gets the callback for Agent connection scope. This scope is for the lifetime of a connection
        to an AppServer. Not valid for statefree AppServers.   */
    method static public Object AgentConnection(poContext as ILifecycleContext):
        return AgentConnection:Instance.
    end method.
    
    /** Gets the callback for agent request scope. This scope is for the lifetime of a client's request
        to the AppServer. */
    method static public Object AgentRequest(poContext as ILifecycleContext):
        return AgentRequest:Instance.
    end method.
    
end class.
