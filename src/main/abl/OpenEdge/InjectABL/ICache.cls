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
    File        : ICache
    Purpose     : 
    Syntax      : Tracks instances for re-use in certain scopes. 
    Description : 
    @author pjudge
    Created     : Thu Mar 04 17:03:02 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
using OpenEdge.InjectABL.Lifecycle.IPipeline.
using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.Core.DateTimeAddIntervalEnum.
using Progress.Lang.Object.

interface OpenEdge.InjectABL.ICache:
    /** The interval between pruning attempts; the unit in which this is denominated is
        defined by the PruningUnit property. */
    define public property PruningInterval as integer no-undo get. set.
    
    /** Defines the uniit of measure for the PruningInterval proeprty. */
    define public property PruningUnit as DateTimeAddIntervalEnum no-undo get. set.
    
    /** Gets the activation pipeline in use for this kernel */
    define public property Pipeline as IPipeline no-undo get.
    
    /** Gets the number of entries currently stored in the cache. */
    define public property Count as integer no-undo get.
    
    /** Stores the specified instance in the cache.
         
        @param ILifecycleContext The context to store.
        @param Object The instance reference.    */
    method public void Remember(input poContext as ILifecycleContext, input poReference as Object).
    
    /** Tries to retrieve an instance to re-use in the specified context.
         
        @param ILifecycleContext The context that is being activated.
        @returns The instance for re-use, or unknown if none has been stored. */
    method public Object TryGet(input poContext as ILifecycleContext).
    
    /** Tries to get an instance's Context for use with additional decoration/injection. **/
    method public ILifecycleContext TryGetContext(input poInstance as Object).
    
    /** Deactivates and releases the specified instance from the cache. 
        @param Object The instance to release.
        @return true if the instance was found and released. otherwise false. */
    method public logical Release(input poInstance as Object).

    /** Removes instances from the cache which should no longer be re-used. */
    method public void Prune().
    
    /** Immediately deactivates and removes all instances in the cache that are owned by
        the specified scope.
        
        @param Object The scope whose instances should be deactivated. */
    method public void Clear(poScope as Object).
    
    /** Immediately deactivates and removes all instances in the cache, regardless of scope. */
    method public void Clear().
    
end interface.
