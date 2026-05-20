**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: DebugMode                                *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  13.06.2006                                              *
//  E-mail  :  thomas.raddatz@tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//                                                                     *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) +                     *
//                              SRCMBR(&SM);                           *
//                                                                     *
//     >>COMPILE<<                                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< OPTION(*EVENTF);                                     *
//       >>PARM<< TGTRLS(V7R3M0  );                                    *
//     >>END-COMPILE<<                                                 *
//                                                                     *
//     >>EXECUTE<<                                                     *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
/copy QLOG4RPG,H_SPEC
//=====================================================================*
//
// -----------------------------------------
//  Exported functions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG14

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG                      Public interface & type definitions

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QBASICS1,PBASICS1                      Basic RPG Extensions

// -----------------------------------------
//  Private prototypes
// -----------------------------------------
//
// -----------------------------------------
//  Global constants
// -----------------------------------------
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
//
//=========================================================================
//  Converts the string passed as argument to an integer debug mode.
//=========================================================================
//  Parameters:
//   i_debugMode   - Debug mode as string.
//
//  Returns:
//   debugMode     - Debug mode, converted to an integer value.
//=========================================================================
dcl-proc DebugMode_toInt export;
  dcl-pi *n int(5);
    i_debugMode like(LOG4RPG_debugMode_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Converts the integer passed as argument to a string debug mode.
//=========================================================================
//  Parameters:
//   i_debugMode   - Debug mode as integer.
//
//  Returns:
//   debugMode     - Debug mode, converted to a string value.
//=========================================================================
dcl-proc DebugMode_toString export;
  dcl-pi *n like(LOG4RPG_debugMode_t);
    i_debugMode int(5) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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


end-proc;

//=========================================================================
//  Tests, if the specified debug mode is valid (well known).
//=========================================================================
//  Parameters:
//   i_debugMode   - Debug mode as string.
//
//  Returns:
//   isValid       - Returns TRUE if the debug mode is known, else FALSE.
//=========================================================================
dcl-proc DebugMode_isValid export;
  dcl-pi *n ind;
    i_debugMode like(LOG4RPG_debugMode_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (i_debugMode = cLOG4RPG_DEBUG_QUIET) or
   (i_debugMode = cLOG4RPG_DEBUG_OFF  ) or
   (i_debugMode = cLOG4RPG_DEBUG_ON   ) or
   (i_debugMode = cLOG4RPG_DEBUG_VERBOSE);
   return *on;
else;
   return *off;
endif;


end-proc;

