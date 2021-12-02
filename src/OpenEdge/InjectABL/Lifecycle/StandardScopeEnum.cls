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
    File        : StandardScopeEnum
    Purpose     : Enumeration of InjectABL scopes. This is the standard/default set. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 04 13:50:10 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

enum OpenEdge.InjectABL.Lifecycle.StandardScopeEnum:
    define enum /** One instance, running free, like a wolf. */
                Transient
                /** Only one instance at a time: effectively scoped to the life of the InjectABL kernel. */
                Singleton 
                /** One instance per AVM Session. */
                ABLSession
                /** One instance per connection; meaningless for statefree Appservers */
                AgentConnection
                /** One instance per AppServer request */
                AgentRequest
                /** Custom scope */
                Custom 
                Default = Transient
                .
end enum.
