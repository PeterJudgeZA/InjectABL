/*------------------------------------------------------------------------
    File        : bitness.p
    Description : Returns the current AVM's bitness 
    Author(s)   : pjudge
    Created     : Fri May 28 11:59:27 EDT 2021
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

return string(process-architecture).

/* EOF */
