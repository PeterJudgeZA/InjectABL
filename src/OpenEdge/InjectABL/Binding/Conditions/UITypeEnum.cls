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
  ---------------------------------------------------------------------- */

enum OpenEdge.InjectABL.Binding.Conditions.UITypeEnum:
    define enum /** Character-mode UI */
                TTY
                /** 'Classic' ABL GUI */
                ABL
                /* OpenEdge GUI for .NET */
                DotNet
                /** Web UI */
                Web
                /** Mobile UI */
                Mobile
                .
end enum.
