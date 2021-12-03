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
    File        : Routine
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Thu Nov 18 14:31:22 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.Parameters.Routine.
using OpenEdge.InjectABL.Binding.Parameters.IParameter.

using OpenEdge.Core.RoutineTypeEnum.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.InjectABL.Binding.Parameters.Routine:
    /** The InjectABL service that's a parent for this routine  */
    define public property Service as Progress.Lang.Class no-undo get. private set.
    /** The name of the routine */     
    define public property RoutineName as character no-undo get. private set.
    
    /** Is the routine a Constructor, Method or Property (setter) */
    define public property RoutineType as RoutineTypeEnum no-undo get. private set.
    
    /** The parameter to be passed to the routine */
    define public property Parameters as IParameter extent no-undo get. set.
    
    constructor public Routine(input poService as Progress.Lang.Class,
                               input pcRoutineName as character,
                               input poRoutineType as RoutineTypeEnum ):
        Service = poService.
        RoutineName = pcRoutineName.
        RoutineType = poRoutineType.
    end method.
    
    method override public Object Clone():
        define variable oClone as Routine no-undo.
        
        oClone = new Routine(this-object:Service,
                             this-object:RoutineName,
                             this-object:RoutineType).
        
        oClone:Parameters = this-object:Parameters.
        return oClone.        
    end method.

end class.
