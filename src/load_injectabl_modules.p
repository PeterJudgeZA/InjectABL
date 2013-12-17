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
    File        : load_injectabl_modules.p
    Purpose     : InjectABL module loader for the OERA Support layer
    Syntax      :
    Description : 
    @author pjudge
    Created     : Mon Dec 13 13:40:24 EST 2010
    Notes       :
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.InjectABL.IKernel.

/** -- defs  -- **/
define input parameter poKernel as IKernel no-undo.

/** -- main -- **/

/** -- eof -- **/
