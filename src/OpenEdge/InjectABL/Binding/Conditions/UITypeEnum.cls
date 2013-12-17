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
    File        : UITypeEnum
    Purpose     : Lists the supported UI types  
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Apr 23 15:08:30 EDT 2010
    Notes       : * This class is not final since implementers could have their
                    own names for UI types.
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.Conditions.UITypeEnum.
using OpenEdge.Core.EnumMember.

class OpenEdge.InjectABL.Binding.Conditions.UITypeEnum serializable inherits EnumMember:
    /** Character-mode UI */
    define static public property TTY    as UITypeEnum no-undo get. private set.
    /** 'Classic' ABL GUI */
    define static public property ABL    as UITypeEnum no-undo get. private set.
    /* OpenEdge GUI for .NET */
    define static public property DotNet as UITypeEnum no-undo get. private set.
    /** Web UI */
    define static public property Web    as UITypeEnum no-undo get. private set.
    /** Mobile UI */
    define static public property Mobile as UITypeEnum no-undo get. private set.
    
    constructor static UITypeEnum():
        assign UITypeEnum:TTY    = new UITypeEnum('TTY')
               UITypeEnum:ABL    = new UITypeEnum('ABL')
               UITypeEnum:DotNet = new UITypeEnum('DotNet')
               UITypeEnum:Web    = new UITypeEnum('Web')
               UITypeEnum:Mobile = new UITypeEnum('Mobile')
               .
    end constructor.
    
    constructor public UITypeEnum ( input pcName as character ):
        super (input pcName).
    end constructor.
    
end class.
