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
    File        : IInjectionRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 19 15:58:31 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using Progress.Lang.Class.

interface OpenEdge.InjectABL.IInjectionRequest:
    /** The
      */         
    define public property ServiceType as Progress.Lang.Class no-undo get.
    
    /** (optional) If a service is named in the binding, allow specification of the name
        for the request.  */
    define public property Name as character no-undo get.
    
    /** (optional) Gets the parameters that were passed to manipulate the activation process. 
    define public property Parameters as IParameterCollection no-undo get. set.
    */
  
end interface.
