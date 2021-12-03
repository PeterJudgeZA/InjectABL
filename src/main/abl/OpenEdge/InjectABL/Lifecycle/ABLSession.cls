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
    File        : ABLSession
    Purpose     : An extension of the SESSION system handle. 
    Syntax      : 
    Description : ABLSession object : this object lives for the lifespan of 
                  an AVM Session. 
    @author pjudge
    Created     : Fri Jun 04 15:00:56 EDT 2010
    Notes       : * Store customer properties for a session in the SessionProperties 
                    IMap property
                  * Discover handle- and object- references for given names
                  * Resolves weak references
  ---------------------------------------------------------------------- */
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.Core.Collections.IMap.
using OpenEdge.Core.Collections.Map.
using OpenEdge.Core.Collections.Array.
using OpenEdge.Core.Session.
using OpenEdge.Core.String.
using OpenEdge.Core.WidgetHandle.
using OpenEdge.InjectABL.Lifecycle.ABLSession.
using Progress.Lang.Class.
using Progress.Lang.Object.


class OpenEdge.InjectABL.Lifecycle.ABLSession:
    
    /** Information regarding session lifespan. */    
    define public property ActiveSince as datetime-tz no-undo get. private set.
    
    /** A unique identifier for this session. The SESSION:HANDLE tends to be the
        same every time; this gives us the opportunity to identify this session across all time and space */
    define public property Id as character no-undo get. private set.
    
    /** A collection of user-defined properties. These
        can be any key/value set of objects. */
    define public property SessionProperties as IMap no-undo get. private set.

    /** An optional session type identifier. Defaults to SESSION:CLIENT-TYPE, but we have
        need for more complex session identifiers ('Development' or 'ClientRuntime'), which
        are not limited to simple client types. */
    define public property Name as character no-undo
        get():
            /* Simple default to client type */
            if this-object:Name eq '' or this-object:Name  eq ? then
                this-object:Name = session:client-type.
            
            return this-object:Name.
        end get.
        set.
    
    define static public property Instance as ABLSession no-undo  
        get():
            if not valid-object(Instance) then
                Instance = new ABLSession().
            
            return Instance.
        end get.
        private set.
    
    constructor private ABLSession():
        assign this-object:Id = guid(generate-uuid)
               ActiveSince = now
               SessionProperties = new Map().
        CacheStartupProperties().
    end constructor.
    
    method private void CacheStartupProperties():
        /* cache the value of -param on startup */
        SessionProperties:Put(new String('SESSION_PARAM'), new String(session:parameter)). 
        SessionProperties:Put(new String('SESSION_ICFPARAM'), new String(session:parameter)).
    end method.
    
    /** Returns the first running persistent procedure instance found
        for a given name.
        
        @param character The (relative) path name for a procedure.
        @return WidgetHandle The handle to that procedure, if any. Unknown value if
                       there's no running instance of that name. */
    method public WidgetHandle GetFirstRunningProc (input pcName as character):
        return OpenEdge.Core.Session:GetFirstRunningProc(pcName).
    end method.

    /** Returns all the running persistent procedure instances found
        for a given name.
        
        @param character The (relative) path name for a procedure.
        @return Array An array of WidgetHandles to that procedure, if any.
                       If there's no running instance of that name, then
                       the array has an extent of 1 (one) which contains the 
                       unknown value.       */ 
    method public Array GetAllRunningProcs (input pcName as character):
        return OpenEdge.Core.Session:GetAllRunningProcs(pcName).
    end method.
    
    /** Resolves a weak reference into an object instance. A weak reference is an integer
        representation of an object reference. This method is analogous to the WIDGET-HANDLE()
        function.
        
        Notes: * Based on http://msdn.microsoft.com/en-us/library/ms404247(v=VS.90).aspx
               * Performance of ResolveWeakReference() will probably suck.
               * An ABL statement "OBJECT-REFERENCE(int)" would entirely replace this method.    
        @param integer A weak reference to an object.
        @return Object The object instance corresponding to that reference. The unknown value/null
                is returned if the referecen cannot be resolved.  */
    method public Object ResolveWeakReference(input piReference as integer):
        return OpenEdge.Core.Session:ResolveWeakReference(piReference).
    end method.
    
    /** Returns the first object instance found that is of the type given.
        
        @param Class The type. This can be a class or an interface. 
        @return Object The reference to that type, if any. Unknown value if
                       there's no running instance of that name. */
    method public Object GetFirstClassInstance(input poType as Progress.Lang.Class):
        return OpenEdge.Core.Session:GetFirstClassInstance(poType).
    end method.
    
    /** Returns all the object instances found that are of the type given.
        
        @param Class The type. This can be a class or an interface.
        @return Array The reference to that type, if any. Unknown value if
                       there's no running instance of that name. */
    method public Array GetAllInstances(input poType as Progress.Lang.Class):
        return OpenEdge.Core.Session:GetAllInstances(poType).
    end method.
    
end class.
