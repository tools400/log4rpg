      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: DebugMode                                *
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
      /COPY QLOG4RPG,PLOG4RPG14
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
      *  Converts the string passed as argument to an integer debug mode.
      *=========================================================================
      *  Parameters:
      *   i_debugMode   - Debug mode as string.
      *
      *  Returns:
      *   debugMode     - Debug mode, converted to an integer value.
      *=========================================================================
     P DebugMode_toInt...
     P                 B                   export
      *
     D DebugMode_toInt...
     D                 PI             5I 0
     D  i_debugMode                        const  like(LOG4RPG_debugMode_t  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         select;
         when i_debugMode = cLOG4RPG_DEBUG_QUIET;
            return cLOG4RPG_INT_DEBUG_QUIET;
         when i_debugMode = cLOG4RPG_DEBUG_OFF;
            return cLOG4RPG_INT_DEBUG_OFF;
         when i_debugMode = cLOG4RPG_DEBUG_ON;
            return cLOG4RPG_INT_DEBUG_ON;
         when i_debugMode = cLOG4RPG_DEBUG_VERBOSE;
            return cLOG4RPG_INT_DEBUG_VERBOSE;
         other;
            return cLOG4RPG_INT_DEBUG_OFF;
         endsl;
 
      /END-FREE
      *
     P DebugMode_toInt...
     P                 E
      *
      *=========================================================================
      *  Converts the integer passed as argument to a string debug mode.
      *=========================================================================
      *  Parameters:
      *   i_debugMode   - Debug mode as integer.
      *
      *  Returns:
      *   debugMode     - Debug mode, converted to a string value.
      *=========================================================================
     P DebugMode_toString...
     P                 B                   export
      *
     D DebugMode_toString...
     D                 PI                         like(LOG4RPG_debugMode_t  )
     D  i_debugMode                   5I 0 const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         select;
         when i_debugMode = cLOG4RPG_INT_DEBUG_QUIET;
            return cLOG4RPG_DEBUG_QUIET;
         when i_debugMode = cLOG4RPG_INT_DEBUG_OFF;
            return cLOG4RPG_DEBUG_OFF;
         when i_debugMode = cLOG4RPG_INT_DEBUG_ON;
            return cLOG4RPG_DEBUG_ON;
         when i_debugMode = cLOG4RPG_INT_DEBUG_VERBOSE;
            return cLOG4RPG_DEBUG_VERBOSE;
         other;
            return '';
         endsl;
 
      /END-FREE
      *
     P DebugMode_toString...
     P                 E
      *
      *=========================================================================
      *  Tests, if the specified debug mode is valid (well known).
      *=========================================================================
      *  Parameters:
      *   i_debugMode   - Debug mode as string.
      *
      *  Returns:
      *   isValid       - Returns TRUE if the debug mode is known, else FALSE.
      *=========================================================================
     P DebugMode_isValid...
     P                 B                   export
      *
     D DebugMode_isValid...
     D                 PI              N
     D  i_debugMode                        const  like(LOG4RPG_debugMode_t  )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (i_debugMode = cLOG4RPG_DEBUG_QUIET) or
 B01        (i_debugMode = cLOG4RPG_DEBUG_OFF  ) or
            (i_debugMode = cLOG4RPG_DEBUG_ON   ) or
            (i_debugMode = cLOG4RPG_DEBUG_VERBOSE);
            return cTrue;
         else;
            return cFalse;
         endif;
 
      /END-FREE
      *
     P DebugMode_isValid...
     P                 E
      *
