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
    File        : BindingTarget
    Purpose     : Enumeration of InjectABL binding target types 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 11:37:41 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.BindingTargetEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.InjectABL.Binding.BindingTargetEnum inherits EnumMember: 
    /** Indicates that the binding is from a type to itself. **/
    define static public property Self as BindingTargetEnum no-undo get. private set.

    /** Indicates that the binding is from one type to another. **/
    define static public property Type as BindingTargetEnum no-undo get. private set.

    /** Indicates that the binding is from a type to a provider. **/
    define static public property Provider as BindingTargetEnum no-undo get. private set.

    /** Indicates that the binding is from a type to a callback method. **/
    define static public property Method as BindingTargetEnum no-undo get. private set.

    /** Indicates that the binding is from a type to a constant value. **/
    define static public property Constant  as BindingTargetEnum no-undo get. private set.
        
    constructor static BindingTargetEnum():
        BindingTargetEnum:Self = new BindingTargetEnum().
        BindingTargetEnum:Type = new BindingTargetEnum().
        BindingTargetEnum:Provider = new BindingTargetEnum().
        BindingTargetEnum:Method = new BindingTargetEnum().
        BindingTargetEnum:Constant = new BindingTargetEnum().
    end constructor.
    
    constructor private BindingTargetEnum():
        super(?,?).
    end constructor.
        
end class.
