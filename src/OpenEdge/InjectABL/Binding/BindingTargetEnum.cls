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

enum OpenEdge.InjectABL.Binding.BindingTargetEnum :  

  define enum Self
              Type
              Provider
              Method
              Constant
              .

end enum.