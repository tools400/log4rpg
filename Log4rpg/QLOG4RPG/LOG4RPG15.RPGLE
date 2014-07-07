      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: DebugOutput                              *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  13.06.2006                                              *
      *  E-mail  :  thomas.raddatz@tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) +                     *
      *                              SRCMBR(&SM);                           *
      *                                                                     *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V6R1M0  );                                    *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      *=====================================================================*
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG15
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG                      Public interface & type definitions
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=========================================================================
      *  Converts the string passed as argument to an integer debug output.
      *=========================================================================
      *  Parameters:
      *   i_debugOutput - Debug output as string.
      *
      *  Returns:
      *   debugOutput   - Debug output, converted to an integer value.
      *=========================================================================
     P DebugOutput_toInt...
     P                 B                   export
      *
     D DebugOutput_toInt...
     D                 PI             5I 0
     D  i_debugOutput                      const  like(LOG4RPG_debugOutput_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         select;
         when i_debugOutput = cLOG4RPG_DEBUG_OUTPUT_PRINTER;
            return cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER;
         when i_debugOutput = cLOG4RPG_DEBUG_OUTPUT_STDOUT;
            return cLOG4RPG_INT_DEBUG_OUTPUT_STDOUT;
         other;
            return cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER;
         endsl;
 
      /END-FREE
      *
     P DebugOutput_toInt...
     P                 E
      *
      *=========================================================================
      *  Converts the integer passed as argument to a string debug output.
      *=========================================================================
      *  Parameters:
      *   i_debugOutput - Debug output as integer.
      *
      *  Returns:
      *   debugOutput   - Debug output, converted to a string value.
      *=========================================================================
     P DebugOutput_toString...
     P                 B                   export
      *
     D DebugOutput_toString...
     D                 PI                         like(LOG4RPG_debugOutput_t)
     D  i_debugOutput                 5I 0 const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         select;
         when i_debugOutput = cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER;
            return cLOG4RPG_DEBUG_OUTPUT_PRINTER;
         when i_debugOutput = cLOG4RPG_INT_DEBUG_OUTPUT_STDOUT;
            return cLOG4RPG_DEBUG_OUTPUT_STDOUT;
         other;
            return '';
         endsl;
 
      /END-FREE
      *
     P DebugOutput_toString...
     P                 E
      *
      *=========================================================================
      *  Tests, if the specified debug output is valid (well known).
      *=========================================================================
      *  Parameters:
      *   i_debugOutput - Debug output as string.
      *
      *  Returns:
      *   isValid       - Returns TRUE if the debug output is known, else FALSE.
      *=========================================================================
     P DebugOutput_isValid...
     P                 B                   export
      *
     D DebugOutput_isValid...
     D                 PI              N
     D  i_debugOutput                      const  like(LOG4RPG_debugOutput_t)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (i_debugOutput = cLOG4RPG_DEBUG_OUTPUT_PRINTER) or
            (i_debugOutput = cLOG4RPG_DEBUG_OUTPUT_STDOUT);
            return cTrue;
         else;
            return cFalse;
         endif;
 
      /END-FREE
      *
     P DebugOutput_isValid...
     P                 E
      *
