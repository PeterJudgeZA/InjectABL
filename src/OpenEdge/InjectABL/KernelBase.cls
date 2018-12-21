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
    File        : StandardKernel
    Purpose     : Standard/default InjectABL dependency injection kernel. 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Mar 02 12:56:53 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.BindingRoot.
using OpenEdge.InjectABL.Binding.IBindingRoot.
using OpenEdge.InjectABL.Binding.IBinding.
using OpenEdge.InjectABL.Binding.Binding.
using OpenEdge.InjectABL.Binding.BindingBuilder.
using OpenEdge.InjectABL.Binding.IBindingSyntax.
using OpenEdge.InjectABL.Binding.IBindingResolver.
using OpenEdge.InjectABL.Binding.Modules.IInjectionModuleCollection.
using OpenEdge.InjectABL.Binding.Modules.IInjectionModule.
using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.InjectABL.Lifecycle.LifecycleContext.
using OpenEdge.InjectABL.ICache.
using OpenEdge.InjectABL.Lifecycle.IPipeline.
using OpenEdge.InjectABL.Lifecycle.StandardScopeEnum.
using OpenEdge.InjectABL.IInjectionRequest.
using OpenEdge.InjectABL.IKernel.
using OpenEdge.InjectABL.ComponentContainer.
using OpenEdge.InjectABL.KernelSettings.
using OpenEdge.Core.System.InvalidValueSpecifiedError.

using OpenEdge.Core.Collections.ICollection.
using OpenEdge.Core.Collections.IIterator.
using OpenEdge.Core.Collections.IList.
using OpenEdge.Core.Collections.List.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.Map.
using OpenEdge.Core.Assert.
using OpenEdge.Core.String.

using Progress.Lang.Class.
using Progress.Lang.AppError.
using Progress.Lang.SysError.
using Progress.Lang.Object.

class OpenEdge.InjectABL.KernelBase inherits BindingRoot 
        implements IKernel:        
    
    define public property Settings as KernelSettings no-undo get. private set.
    
    /** Gets the modules that have been loaded into the kernel. **/
    define public property Modules as IInjectionModuleCollection no-undo get. private set.
    
    /* Collection of bindings registered in this kernel  */
    define override public property Bindings as IMap no-undo get. private set.
    
    /** Gets the component container, which holds components that contribute to InjectABL. **/
    define public property Components as ComponentContainer no-undo get. private set.
    
    /** Stack of unique services (as define by their LifecycleContext) being invoked. Used to prevent
        circular references. */
    @todo(task="implement", action="circ reference checks").
    define protected property InvocationStack as IList no-undo get. private set.
    
    destructor public KernelBase():
        /* Clean up all the singletons (ie those scoped to this Kernel) */
        cast(Components:Get(get-class(ICache)) , ICache)
            :Clear(this-object).
    end destructor.
    
    constructor public KernelBase():
        this-object(new ComponentContainer(this-object),
                    new IInjectionModuleCollection(),
                    new KernelSettings()).
    end constructor. 
    
    constructor public KernelBase(poModules as IInjectionModuleCollection):
        this-object(new ComponentContainer(this-object),
                    poModules,
                    new KernelSettings()).
    end constructor.
    
    constructor protected KernelBase(poComponents as ComponentContainer, 
                                     poModules as IInjectionModuleCollection,
                                     poSettings as KernelSettings):
        Assert:NotNull(poComponents, "components").
        Assert:NotNull(poModules, "modules").
        Assert:NotNull(poSettings, "settings").

        assign Components = poComponents
               Modules = poModules
               Settings = poSettings.

        AddComponents().
        
        Bindings = new Map().

        this-object:Load(Modules).
    end constructor.
    
    @method(virtual="true").
    method protected void AddComponents():
    end method.
    
    method override public void AddBinding(input poBinding as IBinding):
        define variable oBindings as IList no-undo.
        
        Assert:NotNull(input poBinding, "binding").
        
        oBindings = cast(Bindings:Get(input poBinding:Service), IList).
        if not valid-object(oBindings) then
        do:
            oBindings = new List().
            Bindings:Put(poBinding:Service, oBindings).
        end.
        
        oBindings:Add(input poBinding).
    end.
    
    /** Unregisters the specified binding.
        
        @param Ibinding The binding to remove. */
    method override public void RemoveBinding(input poBinding as IBinding):
        define variable oBindings as IList no-undo.
        
        Assert:NotNull(input poBinding, "binding").
        oBindings = cast(Bindings:Get(input poBinding:Service), IList).
        if valid-object(oBindings) then
            oBindings:Remove(input poBinding).
    end.
    
    method public void Load(input poModules as IInjectionModuleCollection):
        define variable oIterator as IIterator no-undo.
        
        oIterator = poModules:Values:Iterator().
        do while oIterator:HasNext():
            this-object:Load(cast(oIterator:Next(), IInjectionModule)).
        end.
    end method.
    
    method public logical HasModule(pcName as character):
        return Modules:ContainsKey(new String(pcName)).
    end method.
    
    method public void Load(input poModule as IInjectionModule):
        if not Modules:ContainsValue(poModule) then
            Modules:Add(poModule).
        poModule:OnLoad(this-object).
    end method.
    
    /* InjectABLModuleLoaderModule */
    /** Loads IInjectionModules from files matching the pattern. 
        
        @param character A file pattern */
    method protected void Load(input pcFilePattern as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable cOriginalExtension as character no-undo.
        define variable cFileBase as character no-undo.
        define variable cFolderBase as character no-undo.
        define variable cFile as character no-undo.
        define variable cPWD as character no-undo.
        define variable cFolder as character no-undo.
        define variable oModules as IInjectionModuleCollection no-undo.
        
        Assert:NotNullOrEmpty(pcFilePattern, 'file pattern').
        
        /* Remove the extension, since we may only have the .R present. */
        iMax = num-entries(pcFilePattern, '.').
        case iMax:
            when 1 then cFileBase = pcFilePattern.
            otherwise
            do:
                cOriginalExtension = entry(iMax, pcFilePattern, '.'). 
                do iLoop = (iMax - 1) to 1 by -1:
                    cFileBase = entry(iLoop, pcFilePattern, '.')
                              + '.' +
                              cFileBase.
                end.
            end.
        end case.
        
        /* Resolve the working folder into something meaningful, since
           SEARCH() is significantly faster with a fully-qualified path  */
        file-info:file-name = '.'.
        cPWD = file-info:full-pathname. 
        
        iMax = num-entries(propath).
        do iLoop = 1 to iMax on error undo, throw:
            cFolder = entry(iLoop, propath).
            
            if cFolder begins '.' and
               /* don't mess up relative pathing */
               not cFolder begins '..' then
            do:
                if cFolder eq '.' then
                    cFolder = cPWD.
                else
                    cFolder = cPWD + substring(cFolder, 2).
            end.
            
            /* Always looks for .R. We can write a specialised resolver here if we want 
               to get fancy and look for .r and .p */
            assign cFolderBase = right-trim(cFolder, '/') + '/' + cFileBase
                   cFile = search(cFolderBase + 'r').
            
            /*if cFile eq ? then
                cFile = search(cFolderBase + cOriginalExtension).*/
            
            if cFile ne ? then
                run value(cFile) (input this-object).
            
            catch eSysErr as SysError:             
                case eSysErr:GetMessageNum(1):
                /* Skip cases where we have a parameter mismatch. We cannot be sure that a file on the
                   propath that matches the file pattern is definitively ours. 
                   
                   Procedure <proc> passed parameters to <proc>, which didn't expect any. (1005) */
                when 1005 then . /* Ignore these */
                otherwise undo, throw eSysErr.                                                    
                end case.
            end catch.
        end.
    end method.
    
    /** Loads IInjectionModules from files matching the pattern. 
        
        @param character[] An array of file patterns */    
    method public void Load(input pcFilePatterns as character extent):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        Assert:HasDeterminateExtent(pcFilePatterns, 'file patterns').
        
        iMax = extent(pcFilePatterns).
        
        do iLoop = 1 to iMax:
            this-object:Load(pcFilePatterns[iLoop]).
        end.
    end method.                    
    
    @todo(task="implement", action="").
    method public void Unload(pcName as character):
    end method.
    
    method public Object Get(poService as Progress.Lang.Class):
        return this-object:Get(poService, '', ?).
    end method.
    
    method public Object Get(input poService as Progress.Lang.Class,
                             input poArguments as ICollection):
        return this-object:Get(poService, '', poArguments).                                 
    end method.
    
    /** Instantiates an instance of an object that matches the passed service,
        as determined by the bindings in a loaded module. 
    
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param character A name for the service   
        @return An instance of the requested service/interface    */
    method public Object Get(input poService as Progress.Lang.Class,
                             input pcName as character):
        return this-object:Get(poService, pcName, ?).
    end method.
    
    method protected Object Get(input poService as Progress.Lang.Class,
                                input pcName as character,
                                input poArguments as ICollection):
        define variable oBinding as IBinding no-undo.
        def var oContext as ILifecycleContext no-undo.
        
        Assert:NotNull(poService, 'Service').
        Assert:NotNull(pcName, 'Name').
        
        if poService:IsA(get-class(IKernel)) then
            return this-object.
        
        oBinding = SelectBinding(poService, pcName).
        
        if valid-object(poArguments) then
            oBinding:Arguments:AddAll(poArguments).

/*        return CreateContext(oBinding):Resolve().*/
        /* [PJ] something buggy */        
        oContext = CreateContext(oBinding).
        
        return oContext:Resolve().
    end method.
    
    /** Retrieve the binding to use for the service. */
    method protected IBinding SelectBinding(input poService as Progress.Lang.Class,
                                            input pcName as character):
        define variable oBindings as IList no-undo.
        define variable oBinding as IBinding no-undo.
        
        oBindings = GetBindings(poService, pcName).
        
        if oBindings:IsEmpty() then
            oBinding = CreateDefaultBinding(poService).
        else
        /* if there's only one matching binding, use that one. Ahem. */
        if oBindings:Size eq 1 then
            oBinding = cast(oBindings:Get(1), IBinding).
        else
            /* Always use the first matching binding, since we assume that the bindings
               are added in PROPATH order, and that the PROPATH is ordered in importance 
               from left to right.
               
               If this behaviour is undesirable, then a setting should be added to 
               the KernelSettings object to define it, or a BindingSelection component
               created and added to the kernel. */
            oBinding = cast(oBindings:Get(1), IBinding).
        
        Assert:NotNull(
                oBinding,
                substitute('Binding for service &1 &2', poService:TypeName, pcName)).
        
        /* Need to be able to invoke this type. */
        Assert:NotAbstract(oBinding:TargetType).
        Assert:NotInterface(oBinding:TargetType).
        
        return oBinding.
    end method.
    
    /** Injects (from outside) **/
    method public void Inject(poInstance as Object,
                              poArguments as ICollection):
        define variable oBinding as IBinding no-undo.
        define variable oCache as ICache no-undo.
        define variable oContext as ILifecycleContext no-undo. 
        
        Assert:NotNull(poInstance, "instance").
        Assert:NotNull(poArguments, "arguments").
        
        oContext = cast(Components:Get(get-class(ICache)), ICache)
                    :TryGetContext(poInstance).
        if not valid-object(oContext) then
            oContext = CreateContext(CreateDefaultBinding(poInstance:GetClass())).
          
        // [hb] original: oContext:Binding:Arguments:AddAll(poArguments).
        oContext:Arguments:AddAll(poArguments).
     
        cast(Components:Get(get-class(IPipeline)), IPipeline)
            :Activate(oContext, poInstance).
    end method.
    
    method public logical Release(poInstance as Object):
        Assert:NotNull(poInstance, "instance").
        
        return cast(Components:Get(get-class(ICache)), ICache)
                :Release(poInstance).
    end method.

    /** Indicates whether a service is cached or not. 
        
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param character A name for the service
        @return Logical Returns true if the service is being cached ; false if not in cache.
                Note that a true return value doesn't mean there isn't a running instance of the service -
                since transient instances aren't cached - but only that there are no cached instances. */        
    method public logical IsCached(input poService as Progress.Lang.Class,
                                   input pcName as character):
        return IsCached(poService, pcName, ?).
    end method.
        
    /** Indicates whether a service is cached or not. 
        
        @param Class A service represented by a Progress.Lang.Class type instance.
        @param character A name for the service
        @param ICollection A collection of arguments to add to the bindings for the
                            object being instantiated.        
        @return Logical Returns true if the service is being cached ; false if not in cache.        
                Note that a true return value doesn't mean there isn't a running instance of the service -
                since transient instances aren't cached - but only that there are no cached instances. */        
    method public logical IsCached(input poService as Progress.Lang.Class,
                                   input pcName as character,
                                   input poArguments as ICollection):
    
        define variable oBinding as IBinding no-undo.
        define variable oContext as ILifecycleContext no-undo.
        define variable lIsCached as logical no-undo.
        
        Assert:NotNull(poService, 'Service').
        Assert:NotNull(pcName, 'Name').
        
        if poService:IsA(get-class(IKernel)) then
            return true.
        
        oBinding = SelectBinding(poService, pcName).
        
        if valid-object(poArguments) then
            oBinding:Arguments:AddAll(poArguments).
        
        oContext = CreateContext(oBinding).
        
        lIsCached = valid-object(cast(Components:Get(get-class(ICache)), ICache)
                            :TryGet(oContext)).
        return lIsCached.
    end method.
    
    method public void Clear(poScope as Object):
        Assert:NotNull(poScope, "instance").
        
        cast(Components:Get(get-class(ICache)), ICache)
                :Clear(poScope).
    end method.
    
    method protected IList GetBindings(input poService as Progress.Lang.Class,
                                       input pcName as character):
        return cast(Components:Get(get-class(IBindingResolver)), IBindingResolver)
                    :Resolve(Bindings, poService, pcName).
    end method.

    method protected IBinding CreateDefaultBinding(input poService as Progress.Lang.Class):
        define variable oBinding as IBinding no-undo.
        define variable oBindings as IList     no-undo.
        define variable oBuilder as IBindingSyntax no-undo.
        
        if not TypeIsSelfBindable(poService) then
            undo, throw new InvalidValueSpecifiedError(
                                'default binding',
                                ': Type ' + poService:TypeName + ' cannot bind to itself').
       
        oBuilder = Bind(poService).
        oBuilder:ToSelf().
       
        oBindings = GetBindings(poService, '').          
        oBinding = cast(oBindings:Get(1), IBinding).
           
        return oBinding.
    end method. 
    
    method override protected IBindingSyntax CreateBindingBuilder(input poBinding as IBinding):
        return new BindingBuilder(poBinding, this-object).
    end method.    
    
    method protected ILifecycleContext CreateContext(input poBinding as IBinding):
        Assert:NotNull(input poBinding, "binding").
        
        return new LifecycleContext(this-object,
                                    poBinding,
                                    cast(Components:Get(get-class(IPipeline)), IPipeline),
                                    cast(Components:Get(get-class(ICache)), ICache)).
    end method.
    
    method protected logical TypeIsSelfBindable(poService as Progress.Lang.Class):
        return (not poService:IsAbstract() and not poService:IsInterface() ).
    end method.
    
end class.
