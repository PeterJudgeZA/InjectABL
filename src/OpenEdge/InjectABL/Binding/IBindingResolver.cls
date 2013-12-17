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
    File        : IBindingResolver
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 09 08:59:51 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.InjectABL.Lifecycle.StandardScopeEnum.

using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.IMap.
using Progress.Lang.Class.

interface OpenEdge.InjectABL.Binding.IBindingResolver:
    
    /** Returns valid binding(s) for the service from a set of bindings
        
        @param IMap The complete set of bindings to resolve
        @param Class The service type
        @param character The binding name
        @return IList  The list of bindings corresponding to the service & name */
    method public IList Resolve(input poBindings as IMap,
                                input poService as Progress.Lang.Class,
                                input pcName as character).
    
end interface.
