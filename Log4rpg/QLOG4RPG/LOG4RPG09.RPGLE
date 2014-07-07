      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: Level                                    *
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
      /COPY QLOG4RPG,PLOG4RPG09
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
      *  Converts the string passed as argument to an integer level.
      *=========================================================================
      *  Parameters:
      *   i_level       - Level.
      *
      *  Returns:
      *   level         - Level, converted to an integer value (= priority).
      *=========================================================================
     P Level_toInt...
     P                 B                   export
      *
     D Level_toInt...
     D                 PI                         like(LOG4RPG_priority_t      )
     D  i_level                            const  like(LOG4RPG_level_t         )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         select;
         when i_level = cLOG4RPG_LEVEL_DEBUG;
            return cLOG4RPG_PRIORITY_DEBUG;
         when i_level = cLOG4RPG_LEVEL_INFO;
            return cLOG4RPG_PRIORITY_INFO;
         when i_level = cLOG4RPG_LEVEL_WARN;
            return cLOG4RPG_PRIORITY_WARN;
         when i_level = cLOG4RPG_LEVEL_ERROR;
            return cLOG4RPG_PRIORITY_ERROR;
         when i_level = cLOG4RPG_LEVEL_FATAL;
            return cLOG4RPG_PRIORITY_FATAL;
         other;
            return cLOG4RPG_PRIORITY_NONE;
         endsl;
 
      /END-FREE
      *
     P Level_toInt...
     P                 E
      *
      *=========================================================================
      *  Converts the integer passed as argument to a string level.
      *=========================================================================
      *  Parameters:
      *   i_level       - Level as integer value (= priority).
      *
      *  Returns:
      *   level         - Level, converted to a string value.
      *=========================================================================
     P Level_toString...
     P                 B                   export
      *
     D Level_toString...
     D                 PI                         like(LOG4RPG_level_t         )
     D  i_priority                         const  like(LOG4RPG_priority_t      )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         select;
         when i_priority = cLOG4RPG_PRIORITY_DEBUG;
            return cLOG4RPG_LEVEL_DEBUG;
         when i_priority = cLOG4RPG_PRIORITY_INFO;
            return cLOG4RPG_LEVEL_INFO;
         when i_priority = cLOG4RPG_PRIORITY_WARN;
            return cLOG4RPG_LEVEL_WARN;
         when i_priority = cLOG4RPG_PRIORITY_ERROR;
            return cLOG4RPG_LEVEL_ERROR;
         when i_priority = cLOG4RPG_PRIORITY_FATAL;
            return cLOG4RPG_LEVEL_FATAL;
         other;
            return '';
         endsl;
 
      /END-FREE
      *
     P Level_toString...
     P                 E
      *
