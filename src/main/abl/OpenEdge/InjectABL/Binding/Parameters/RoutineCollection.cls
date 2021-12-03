/*------------------------------------------------------------------------
    File        : RoutineCollection
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 11 15:16:59 EST 2013
    Notes       : 
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.InjectABL.Binding.Parameters.Routine.

{OpenEdge/Core/Collections/typedcollectionclass.i
    &Package        = OpenEdge.InjectABL.Binding.Parameters
    &CollectionType = RoutineCollection
    &ValueType      = Routine
} 
