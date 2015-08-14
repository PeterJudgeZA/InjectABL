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
    File        : Cache
    Purpose     : Tracks instances for re-use in certain scopes. 
    Syntax      : 
    Description : 
    @Author   : pjudge
    Created     : Thu Mar 04 17:08:02 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.InjectABL.ICache.
using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.InjectABL.Lifecycle.IPipeline.
using OpenEdge.Core.DateTimeAddIntervalEnum.
using OpenEdge.Core.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

class OpenEdge.InjectABL.Cache use-widget-pool
        implements ICache:
    
    define private temp-table InstanceCache no-undo
        field Binding as Object                 /* IBinding */
        
        field LifecycleContext  as Object
        field Instance          as Object
        field Scope             as integer      /* weak reference */
        
        field CachedAt          as datetime-tz
        
        index idx1 as unique Instance
        index idx2 Scope CachedAt
        index idx3 Binding.
    
    /** Gets the activation pipeline in use for this kernel */
    define public property Pipeline as IPipeline no-undo get. private set.
    
    /** Gets the number of entries currently stored in the cache. */
    define public property Count as integer no-undo 
        get():
            define variable iCount as integer no-undo.
            
            define buffer lbCache for InstanceCache.
            define query qryCache for lbCache.
            
            open query qryCache preselect each lbCache.
            iCount = query qryCache:num-results.
            close query qryCache.
            
            return iCount.
        end get.
    
    define public property PruningInterval as integer no-undo get. set.    
    define public property PruningUnit as DateTimeAddIntervalEnum no-undo get. set.
    
    constructor public Cache(poPipeline as IPipeline,
                             piLifespan as integer,
                             poLifespanUnit as DateTimeAddIntervalEnum):
        Assert:NotNull(poLifespanUnit, 'Lifespan unit').
        Assert:NotNull(poPipeline, 'Pipeline').
        
        assign PruningInterval = piLifespan
               PruningUnit = poLifespanUnit
               Pipeline = poPipeline.
    end constructor.

    /** Stores the specified context in the cache.
        
        @param context The context to store.
        @param reference The instance reference.    */
    method public void Remember(poContext as ILifecycleContext, poInstance as Object):
        define buffer lbCache for InstanceCache.
        
        Assert:NotNull(poContext, "Context").
        Assert:NotNull(poInstance, "Instance").
        
        create lbCache.
        assign lbCache.LifecycleContext =  poContext
               lbCache.Scope = integer(poContext:GetScope())
               lbCache.Binding = poContext:Binding
               lbCache.Instance = poInstance
               lbCache.CachedAt = now.
    end method.
    
    /** Tries to retrieve an instance to re-use in the specified context.
    
        @param ILifecycleContext The context that is being activated.
        @return Object The instance for re-use, or unknown if none has been stored. */
    method public Object TryGet(input poContext as ILifecycleContext):
        define variable oInstance as Object no-undo.
        define variable oScope as Object no-undo.
        
        define buffer lbCache for InstanceCache.
        
        Assert:NotNull(poContext, "Context").
        oScope = poContext:GetScope().
        
        for each lbCache where 
                 lbCache.Scope eq int(oScope)
                 while not valid-object(oInstance):
            if lbCache.Binding:Equals(poContext:Binding) then
                oInstance = lbCache.Instance.
        end.
        
        return oInstance.
    end method.
    
    /** Tries to find an ILifecycleContext object for a running instance.
        
        @param Object The running instance on which to check.
        @return ILifecycleContext The lifecycle context for the running object, if available */
    method public ILifecycleContext TryGetContext(poInstance as Object):
        define variable oContext as ILifecycleContext no-undo.
        
        define buffer lbCache for InstanceCache.
        
        Assert:NotNull(poInstance, "Instance").
        
        find first lbCache where lbCache.Instance eq poInstance no-error.
        if available lbCache then
            oContext = cast(lbCache.LifecycleContext, ILifecycleContext).
        
        return oContext.
    end method.
    
    /** Deactivates and releases the specified instance from the cache.
    
        @param Object The instance to release.
        @return logical True if the instance was found and released; otherwise false. */
    method public logical Release(poInstance as Object):
        /* When releasing this object, make sure we let go of anything
           scoped to this instance. */
        this-object:Clear(poInstance).
        
        return Forget(poInstance).
    end method.
    
    /** Removes instances from the cache which should no longer be re-used. */
    method public void Prune():
        if PruningInterval ne -1 then
            ForgetAllWhere('CachedAt lt ' + quoter(add-interval(now, PruningInterval * -1, PruningUnit:ToString()))).
    end method.
    
    /** Immediately deactivates and removes all instances in the cache that are owned by
        the specified scope.
        @param scope The scope whose instances should be deactivated.
     */
    method public void Clear(poScope as Object):
        ForgetAllWhere('Scope eq ' + quoter(int(poScope)) ).
    end method.
    
    /** Immediately deactivates and removes all instances in the cache, regardless of scope. */
    method public void Clear():
        ForgetAllWhere('true').
    end.
    
    method private void ForgetAllWhere(pcClause as char):
        define variable hQuery as handle no-undo.
        
        define buffer lbCache for InstanceCache.
        define query qryCache for lbCache.
        
        hQuery = query qryCache:handle.
        /* Use preselect since we're deleting records */
        hQuery:query-prepare('preselect each lbCache where ' + pcClause).
        hQuery:query-open().
        
        hQuery:get-first().
        do while not hQuery:query-off-end:
            Forget(buffer lbCache).
            hQuery:get-next().
        end.
        hQuery:query-close().
    end.
    
    method private logical Forget(buffer pbCache for InstanceCache):
        define variable lCached as logical no-undo.
        
        lCached = available pbCache.
        
        if lCached then
        do:
            Pipeline:Deactivate(cast(pbCache.LifecycleContext, ILifecycleContext),
                                pbCache.Instance).
            /* Don't explicitly delete the object; let garbage colleciton take care of it. */
            delete pbCache.
        end.
        
        return lCached.
    end method.
    
    method private logical Forget(poInstance as Object):
        define buffer lbCache for InstanceCache.
        
        find lbCache where lbCache.Instance eq poInstance no-error.
        return Forget(buffer lbCache).
    end.
    
end class.
