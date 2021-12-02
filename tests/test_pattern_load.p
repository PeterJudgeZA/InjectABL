
/*------------------------------------------------------------------------
    File        : test_pattern_load.p
    Purpose     :

    Syntax      :

    Description :

    Author(s)   : pjudge
    Created     : Mon Dec 13 14:06:46 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
block-level on error undo, throw.

using OpenEdge.Core.Assert.
using OpenEdge.InjectABL.Binding.Modules.IInjectionModuleCollection.

function Load return logical (input pcFilePattern as character):
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
        do iLoop = 1 to iMax:
            cFolder = entry(iLoop, propath).

            if cFolder begins '.' then
            do:
                if cFolder  eq '.' then
                    cFolder = cPWD.
                else
                    cFolder = cPWD + substring(cFolder, 2).
            end.

            /* Always looks for .R. We can write a specialised resolver here if we want
               to get fancy and look for .r and .p
            if cFile eq ? then
                cFile = search(cFolderBase + pcFilePattern). */
            assign cFolderBase = right-trim(cFolder, '/') + '/' + cFileBase
                   cFile = search(cFolderBase + '.r').
            if cFile eq ? then
                cFile = search(cFolderBase + '.' + cOriginalExtension).
            if cFile ne ? then
            do:
            end.
        end.
end.

dynamic-function('Load' in this-procedure, 'load_injectabl_modules').
dynamic-function('Load' in this-procedure, 'load_injectabl_modules.p').
dynamic-function('Load' in this-procedure, 'foo/load_injectabl_modules.p.old').
dynamic-function('Load' in this-procedure, './foo/load_injectabl_modules.p.old').
