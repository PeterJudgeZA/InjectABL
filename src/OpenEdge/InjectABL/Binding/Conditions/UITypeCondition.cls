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
    File        : UITypeCondition
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Apr 23 15:11:37 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
using OpenEdge.InjectABL.Binding.Conditions.UITypeCondition.
using OpenEdge.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.InjectABL.Binding.Conditions.Condition.
using OpenEdge.InjectABL.Binding.Conditions.UITypeEnum.

class OpenEdge.InjectABL.Binding.Conditions.UITypeCondition: 

    define static public property TTY     as ICondition no-undo get. private set. 
    define static public property ABL     as ICondition no-undo get. private set.
    define static public property Web     as ICondition no-undo get. private set.
    define static public property DotNet  as ICondition no-undo get. private set.
    define static public property Mobile  as ICondition no-undo get. private set.
    define static public property Current as ICondition no-undo get. private set.
    
    constructor static UITypeCondition():
        assign UITypeCondition:TTY       = new Condition(UITypeEnum:TTY)
               UITypeCondition:ABL       = new Condition(UITypeEnum:ABL)
               UITypeCondition:Web       = new Condition(UITypeEnum:Web)
               UITypeCondition:DotNet    = new Condition(UITypeEnum:DotNet)
               UITypeCondition:Mobile    = new Condition(UITypeEnum:Mobile)
/*               UITypeCondition:Current = new Condition(UITypeEnum:Current)*/
               .
    end constructor.
    
end class.
