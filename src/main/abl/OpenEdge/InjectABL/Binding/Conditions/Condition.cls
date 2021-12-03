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
    File        : Condition
    Purpose     :
    Syntax      :
    Description :
    @author pjudge
    Created     : Mon Mar 08 15:22:04 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.String.
using OpenEdge.InjectABL.Binding.Conditions.Condition.
using OpenEdge.InjectABL.Binding.Conditions.ICondition.
using OpenEdge.InjectABL.Binding.Conditions.IConditionResolver.
using OpenEdge.InjectABL.Binding.Conditions.StandardConditionResolver.
using Progress.Lang.Object.

class OpenEdge.InjectABL.Binding.Conditions.Condition implements ICondition:

    define static private property ConditionResolverType as Progress.Lang.Class no-undo get. set.

    define private variable moValue as Object no-undo.

    /* general condition types, to avoid having a SessionName and UIType etc. */
    define static public property Name as ICondition no-undo get. private set.
    define static public property Type as ICondition no-undo get. private set.

    /* Operators */
    define static public property And as ICondition no-undo get. private set.
    define static public property Or as ICondition no-undo get. private set.

    /* Comparers */
    define static public property When as ICondition no-undo get. private set.
    define static public property Is as ICondition no-undo get. private set.
    define static public property Not as ICondition no-undo get. private set.

    constructor static Condition():
        define variable oType as Progress.Lang.Class no-undo.
        
        assign OpenEdge.InjectABL.Binding.Conditions.Condition:ConditionResolverType = get-class(StandardConditionResolver)
               
               Condition:And = new Condition('and')
               Condition:Or  = new Condition('or')
               
               Condition:Is   = new Condition('is')
               Condition:When = new Condition('when')
               Condition:Not  = new Condition('not')

               OpenEdge.InjectABL.Binding.Conditions.Condition:Name = new OpenEdge.InjectABL.Binding.Conditions.Condition('Name')
               OpenEdge.InjectABL.Binding.Conditions.Condition:Type = new OpenEdge.InjectABL.Binding.Conditions.Condition('Type')
               .
    end constructor.

    constructor public Condition(input pcValue as char):
        this-object(new String(pcValue)).
    end constructor.

    constructor public Condition(poValue as Object):
        Assert:NotNull(poValue, 'Condition value').
        moValue = poValue.
    end constructor.

    method public IConditionResolver GetResolver():
        return StandardConditionResolver:GetResolver(OpenEdge.InjectABL.Binding.Conditions.Condition:ConditionResolverType).
    end method.

    method static public logical Equals(poCondition1 as ICondition, poCondition2 as ICondition):
        define variable lEquals as logical no-undo.

        if not valid-object(poCondition1) or
           not valid-object(poCondition2) then
           lEquals = false.

        if lEquals then
            lEquals = poCondition1:Equals(poCondition2).

        return lEquals.
    end method.

    method override public logical Equals(poCondition as Object):
        define variable lEquals as logical no-undo.

        lEquals = valid-object(poCondition).

        /* need to match types */
        if lEquals then
            lEquals = poCondition:GetClass():IsA(this-object:GetClass()).

        if lEquals then
            lEquals = poCondition:ToString() eq this-object:ToString().

        return lEquals.
    end method.

    method override public character ToString():
        return moValue:ToString().
    end method.

end class.
