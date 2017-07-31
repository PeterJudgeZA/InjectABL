/** ****************************************************************************
  Copyright 2012, 2017 Progress Software Corporation
  
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
    File        : StandardProvider
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 16:41:44 EST 2010
    Notes       : * We need to catch certain P.L.SysErrors since we don't
                    know in advance what the callees' signatures are, and so
                    we shoot and hope. And catch SysErrors based on number.
                    This catch allows us to handle these conditions gracefully,
                    which is what we would do if we could determine the callee
                    signatures in advance. 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.InjectABL.Binding.Parameters.Routine.
using OpenEdge.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.InjectABL.Lifecycle.IProvider.
using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.

using OpenEdge.Core.System.InvocationError.
using OpenEdge.Core.System.ArgumentError.
using OpenEdge.Core.RoutineTypeEnum.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.DataTypeEnum.
using OpenEdge.Core.DataTypeHelper.
using OpenEdge.Core.IOModeEnum.
using OpenEdge.Core.Assert.

using Progress.Lang.Class.
using Progress.Lang.ParameterList.
using Progress.Lang.AppError.
using Progress.Lang.SysError.
using Progress.Lang.Object.

class OpenEdge.InjectABL.Lifecycle.StandardProvider implements IProvider:
    define private static property ProviderType as Progress.Lang.Class no-undo get. private set.  
    
    define public property Type as Progress.Lang.Class no-undo get. private set.
    
    constructor public StandardProvider(poClass as Progress.Lang.Class):
        this-object:Type = poClass.
    end constructor.
    
    /** Method injection **/
    method protected void InjectViaMethod(poInstance as Object,
                                          poMethod as Routine,
                                          poContext as ILifecycleContext):
        define variable oPL as ParameterList no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
                
        Assert:NotNull(poMethod, 'injection method').
        
        iMax = extent(poMethod:Parameters).
        if iMax eq ? then
            iMax = 0.
        oPL = new ParameterList(iMax).
        
        do iLoop = 1 to iMax:
            SetParameterValue(poContext,
                              oPL,
                              iLoop,
                              poMethod:Parameters[iLoop]).
        end.
        
        poInstance:GetClass():Invoke(poInstance, poMethod:RoutineName, oPL).
        
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            /* Could not dynamically find method ''<name> in class ''<name> with <number> matching parameter(s). (15312) */
            case eSysErr:GetMessageNum(1):
                when 15312 then
                    undo, throw new InvocationError(eSysErr, RoutineTypeEnum:Method:ToString(), poContext:Binding:TargetType:TypeName).
                otherwise
                    undo, throw eSysErr.
            end case.
        end catch.
    end method.
    
    /** Constructor injection 
    
        At some point in the future, we may add a generic/dynamic constructor injection 
        strategy, which will determine which constructor to use. At the moment, this decision
        is based on the first constructor in the bindings with the most arguments, and attempts
        to invoke an object with those arguments. 
        
        @param ILifecycleContext The context for creating an object.
        @return Object The newly-created object         */
    method public Object Create(input poContext as ILifecycleContext):
        define variable oNew as Object no-undo.
        define variable oPL as ParameterList no-undo.
        define variable oCtorArg as Parameter extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iNumParam as integer no-undo.
        define variable oIterator as IIterator no-undo.
        define variable oCtor as Routine no-undo.
        define variable oRoutine as Routine no-undo.
        
        Assert:NotNull(poContext:Binding:TargetType, 'Binding target').
        
        iNumParam = 0.
        if not poContext:Arguments:IsEmpty() then
        do:
            oIterator = poContext:Arguments:Iterator().
            
            /* find the ctor with the largest number of parameters */
            do while oIterator:HasNext():
                oRoutine = cast(oIterator:Next(), Routine).
                if oRoutine:RoutineType:Equals(RoutineTypeEnum:Constructor) then
                do:
                    if not valid-object(oCtor) then
                        oCtor = oRoutine.
                    else
                    if extent(oRoutine:Parameters) gt extent(oCtor:Parameters) then
                        oCtor = oRoutine.
                end.
            end.
            
            if valid-object(oCtor) and extent(oCtor:Parameters) ne ? then
                assign iNumParam = extent(oCtor:Parameters)
                       extent(oCtorArg) = iNumParam
                       oCtorArg = cast(oCtor:Parameters, Parameter).
        end.
        
        oPL = new ParameterList(iNumParam).
        do iLoop = 1 to iNumParam:
            SetParameterValue(poContext,
                              oPL,
                              iLoop,
                              oCtorArg[iLoop]).
        end.
        
        oNew = poContext:Binding:TargetType:New(oPL).
        
        /* Make sure we're using the right type */
        Assert:IsType(oNew, this-object:Type).
        
        return oNew.
        
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            /* Dynamic NEW cannot NEW class <type> because an unambiguous appropriate constructor could not be found. (15310) */ 
            case eSysErr:GetMessageNum(1):
                when 15310 then
                    undo, throw new InvocationError(eSysErr, RoutineTypeEnum:Constructor:ToString(), poContext:Binding:TargetType:TypeName).
                otherwise
                    undo, throw eSysErr.                                                    
            end case.
        end catch.
    end method.
    
    method public void InjectMethods(poInstance as Object,
                                     poContext as ILifecycleContext):
        define variable oIterator as IIterator no-undo.
        define variable oRoutine as Routine no-undo.
        
        if not poContext:Arguments:IsEmpty() then
        do:
            oIterator = poContext:Arguments:Iterator().
            
            /* find the ctor with the largest number of parameters */
            do while oIterator:HasNext():
                oRoutine = cast(oIterator:Next(), Routine).
                if oRoutine:RoutineType:Equals(RoutineTypeEnum:Method) then
                    InjectViaMethod(poInstance,
                                    oRoutine,
                                    poContext).
            end.
        end.
    end method.
    
    method public void InjectProperties(poInstance as Object,
                                        poContext as ILifecycleContext):
        define variable oIterator as IIterator no-undo.
        define variable oRoutine as Routine no-undo.
        
        if not poContext:Arguments:IsEmpty() then
        do:
            oIterator = poContext:Arguments:Iterator().
            
            do while oIterator:HasNext():
                oRoutine = cast(oIterator:Next(), Routine).
                if oRoutine:RoutineType:Equals(RoutineTypeEnum:PropertySetter) then
                    this-object:SetPropertyValue(
                        poInstance,
                        poContext,
                        oRoutine:RoutineName,
                        cast(oRoutine:Parameters[1], Parameter)).
            end.
        end.
        
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            /* Could not dynamically find method ''<name> in class ''<name> with <number> matching parameter(s). (15312) */
            case eSysErr:GetMessageNum(1):
                when 16548 then
                    undo, throw new InvocationError(eSysErr, RoutineTypeEnum:PropertySetter:ToString(), poContext:Binding:TargetType:TypeName).
                otherwise
                    undo, throw eSysErr.
            end case.
        end catch.
    end method.
    
    method protected void SetPropertyValue(input poInstance as Object,
                                           input poContext as ILifecycleContext,
                                           input pcPropertyName as character,
                                           input poArgument as IParameter /* InjectABL parameter*/ ):
        define variable oValue as Object no-undo.
        define variable oValueArray as Object extent no-undo.
        define variable cValue as character no-undo.
        define variable cValueArray as character extent no-undo.
        define variable lIsArray as logical no-undo.
        
        lIsArray = DataTypeHelper:IsArray(poArgument:DataType).
        
        if DataTypeHelper:IsPrimitive(poArgument:DataType) then
        do:
            if lIsArray then
            do:
                poArgument:GetValue(poContext, output cValueArray).
                poInstance:GetClass():SetPropertyValue(
                    poInstance, 
                    pcPropertyName,
                    cValueArray).
            end.
            else
            do:
                poArgument:GetValue(poContext, output cValue).
                poInstance:GetClass():SetPropertyValue(
                    poInstance, 
                    pcPropertyName,
                    cValue).
            end.
        end.    /* primitives */
        else
        do:
            if lIsArray then
            do:
                poArgument:GetValue(poContext, output oValueArray).
                poInstance:GetClass():SetPropertyValue(
                    poInstance, 
                    pcPropertyName,
                    oValueArray).
            end.
            else
            do:
                poArgument:GetValue(poContext, output oValue).
                poInstance:GetClass():SetPropertyValue(
                    poInstance, 
                    pcPropertyName,
                    oValue).
            end.
        end.    /* objects*/
        
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            if eSysErr:NumMessages ge 2 and eSysErr:GetMessageNum(2) eq 5729 then
                undo, throw new ArgumentError(eSysErr, 'Progress.Lang.Class:SetPropertyValue', poArgument:Name).
            else
                undo, throw eSysErr.
        end catch.
    end method.
    
    method protected void SetParameterValue(poContext as ILifecycleContext,
                                            poParams as Progress.Lang.ParameterList /* fully-qualified for clarity */,
                                            piOrder as integer,
                                            poArgument as IParameter /*InjectABL parameter*/ ):
        define variable oValue as Object no-undo.
        define variable oValueArray as Object extent no-undo.
        define variable cValue as character no-undo.
        define variable cValueArray as character extent no-undo.
        define variable lIsArray as logical no-undo.
        
        lIsArray = DataTypeHelper:IsArray(poArgument:DataType).
        
        if DataTypeHelper:IsPrimitive(poArgument:DataType) then
        do:
            if lIsArray then
            do:
                poArgument:GetValue(poContext, output cValueArray).
                poParams:SetParameter(piOrder,
                                      poArgument:DataType:ToString(),
                                      IOModeEnum:Input:ToString(),
                                      cValueArray).
            end.
            else
            do:
                poArgument:GetValue(poContext, output cValue).
                poParams:SetParameter(piOrder,
                                      poArgument:DataType:ToString(),
                                      IOModeEnum:Input:ToString(),
                                      cValue).
            end.
        end.    /* primitives */
        else
        do:
            if lIsArray then
            do:
                poArgument:GetValue(poContext, output oValueArray).
                poParams:SetParameter(piOrder,
                                      substitute(DataTypeEnum:ClassArray:ToString(), poArgument:DeclaredType:TypeName),
                                      IOModeEnum:Input:ToString(),
                                      oValueArray).
            end.
            else
            do:
                poArgument:GetValue(poContext, output oValue).
                poParams:SetParameter(piOrder,
                                      substitute(DataTypeEnum:Class:ToString(), poArgument:DeclaredType:TypeName),
                                      IOModeEnum:Input:ToString(),
                                      oValue).
            end.
        end.    /* objects*/
        
        
        /** 'transform' any ABL errors into an ApplicationError. */
        catch eSysErr as SysError:
            case eSysErr:GetMessageNum(1):
                /* Unable to convert SET-PARAMETER value to datatype passed. (10059) */
                when 10059 then
                    undo, throw new ArgumentError(eSysErr, 'Progress.Lang.ParameterList:SetParameter', poArgument:Name).
                otherwise
                    undo, throw eSysErr.
            end case.
        end catch.
    end method.
           
    constructor static StandardProvider():
        StandardProvider:ProviderType = get-class(IProvider).
    end constructor.
    
    /** factory method for new IProvider instances **/
    method static public IProvider GetProvider(poProviderType as Progress.Lang.Class,
                                               poImplementation as Progress.Lang.Class):
        define variable oProvider as IProvider no-undo.
        
        Assert:NotNull(poProviderType, "provider type").
        Assert:NotNull(poImplementation, "implementation type").
        
        if not poProviderType:IsA(StandardProvider:ProviderType) then
            undo, throw new AppError('type mismatch:' + poProviderType:TypeName + ' must implement ' + StandardProvider:ProviderType:TypeName).
        
        oProvider = dynamic-new(poProviderType:TypeName) (poImplementation).
        
        return oProvider.
    end method.
    
end class.
