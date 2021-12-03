 
 /*------------------------------------------------------------------------
    File        : ConstructorInjectionProvider
    Purpose     : Generic constructor Injection provider
    Syntax      : 
    Description :  
    Author(s)   : Boehme_A
    Created     : Fri Dec 14 22:14:08 CET 2018
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.InjectABL.Lifecycle.ILifecycleContext.
using OpenEdge.InjectABL.Binding.Parameters.IParameter.
using OpenEdge.InjectABL.Binding.Parameters.Parameter.
using OpenEdge.InjectABL.Binding.Parameters.Routine.
using OpenEdge.Core.RoutineTypeEnum.
using OpenEdge.InjectABL.Lifecycle.StandardProvider.
using OpenEdge.Core.Assert.
using Progress.Lang.Class.
using Progress.Lang.Object.

block-level on error undo, throw.

class OpenEdge.InjectABL.Lifecycle.ConstructorInjectionProvider inherits StandardProvider: 
  
   define temp-table ttConstructors
     field OrderIdx      as integer
     field NoParams      as integer
     field NoInterfaces  as integer
     field NoObjects     as integer
     field ConStr        as Progress.Lang.Object
   
     index Main
       OrderIdx
     
    .
     
    constructor public ConstructorInjectionProvider(poClass as Progress.Lang.Class):
        super(poClass).
    end constructor.  
    
    method override public Object Create(poContext as ILifecycleContext):
      
        define variable oConstructors as Progress.Reflect.Constructor extent no-undo.
        define variable oParameters   as Progress.Reflect.Parameter extent no-undo.
        define variable iCounter as integer no-undo.
        define variable iParamCnt as integer no-undo.
        define variable oNewParams as IParameter extent no-undo.
        define variable oRoutine as Routine no-undo.
        define variable lAddParams as logical initial no.
        define variable oNewInstance as progress.Lang.Object no-undo.
        
        
        /* ##anb: actually this code could also be moved into StandardProvider */
      
        oRoutine  = new Routine(poContext:Binding:TargetType, '', RoutineTypeEnum:Constructor).
        poContext:Arguments:Add(oRoutine).
        oConstructors = poContext:Binding:TargetType:GetConstructors().

        /* evaluate all constructors of the target class. constructors with primitive */
        /* params cannot be supported. we also create some statistics on the params   */
        /* as these may be used to determine the best constructor to use              */                   

        FindConstructors:
        do iCounter = 1 to extent(oConstructors):
          extent(oParameters) = ?.
          oParameters = oConstructors[iCounter]:GetParameters().
          
          create ttConstructors.
          
          /* for constructors containing elementary data types we can skip */
          /* this here... They have no binding.  ##anb IsPrimitive         */
          
          do iParamCnt = 1 to extent(oParameters):
          if (oParameters[iParamCnt]:DataTypeName = ?) then
          do:
            delete ttConstructors.
            next FindConstructors.
          end. /* do */  

            if Progress.Lang.Class:GetClass(oParameters[iParamCnt]:DataTypeName):IsInterface() then
              ttConstructors.NoInterfaces = ttConstructors.NoInterfaces + 1.
            else
         
              ttConstructors.NoObjects = ttConstructors.NoObjects + 1.
              
          end.
          
          /* sort by number of parameters (at this time) */
          
          assign            
            ttConstructors.OrderIdx = oConstructors[iCounter]:NumParameters
            ttConstructors.NoParams = oConstructors[iCounter]:NumParameters
            ttConstructors.ConStr   = oConstructors[iCounter].
            
        end.

        /* Build the parameters to call the constructor and try to */
        /* create a new instance.                                  */

        BuildInstance:
        for each ttConstructors
          by ttConstructors.OrderIdx descending:
            
          extent(oParameters) = ?.
          extent(oNewParams)  = ?.
          
          oParameters = (cast(ttConstructors.ConStr, Progress.Reflect.Constructor)):GetParameters().
          
          extent(oNewParams)  = extent(oParameters).
          
          do iParamCnt = 1 to extent(oParameters):

             lAddParams = yes.
             oNewParams[iParamCnt] = new Parameter(Progress.Lang.Class:GetClass(oParameters[iParamCnt]:DataTypeName)).
             
          end.
          
          extent(oRoutine:Parameters) = ?.
          oRoutine:Parameters         = oNewParams.
          oNewInstance                = super:Create(poContext).
        
          /* If we get up to here, the constructor has been executed successfully */
          /* we do not have to try more constructors                              */
        
          leave BuildInstance.
        
          catch oError as progress.Lang.Error:

          /*            message                             */
          /*              "Contructor execution error." skip*/
          /*              oError:GetMessage(1)              */
          /*              view-as alert-box                 */
          /*              title program-name(1).            */
          
          /* constructor execution may fail if a binding is missing. This is */
          /* expected to happen here (or may not in other cases).            */
            
          end catch.
        
        end.
       
        return oNewInstance.
        
    end method.
end class.