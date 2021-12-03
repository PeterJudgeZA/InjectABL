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
    File        : InjectionRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Apr 19 14:39:18 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using Progress.Lang.Class.

class OpenEdge.InjectABL.InjectionRequest:
    @todo(task="implement", action="implement this, so that a request can be made (pass into KernelBase:Inject() ").
    
    define public property ServiceType as Progress.Lang.Class no-undo get. private set.
    define public property Name as character no-undo get. private set.
    
    /** (optional) Gets the parameters that were passed to manipulate the activation process. 
    define public property Parameters as IParameter extent no-undo get. set.
    */
    
    constructor public InjectionRequest(poService as Progress.Lang.Class, pcName as char):        
        assign this-object:Name = pcName
               this-object:ServiceType = poService.
    end constructor.

    /*
    constructor public InjectionRequest(poService as Progress.Lang.Class, pcName as char, poParameters as IParameter extent):
        this-object(poService, pcName).        
        assign this-object:Parameters = poParameters.
    end constructor.
    */
    
end class.
