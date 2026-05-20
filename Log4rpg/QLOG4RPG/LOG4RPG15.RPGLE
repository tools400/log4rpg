**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: DebugOutput                              *
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
/copy QLOG4RPG,PLOG4RPG15

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
//  Converts the string passed as argument to an integer debug output.
//=========================================================================
//  Parameters:
//   i_debugOutput - Debug output as string.
//
//  Returns:
//   debugOutput   - Debug output, converted to an integer value.
//=========================================================================
dcl-proc DebugOutput_toInt export;
  dcl-pi *n int(5);
    i_debugOutput like(LOG4RPG_debugOutput_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

select;
when i_debugOutput = cLOG4RPG_DEBUG_OUTPUT_PRINTER;
   return cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER;
when i_debugOutput = cLOG4RPG_DEBUG_OUTPUT_STDOUT;
   return cLOG4RPG_INT_DEBUG_OUTPUT_STDOUT;
other;
   return cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER;
endsl;


end-proc;

//=========================================================================
//  Converts the integer passed as argument to a string debug output.
//=========================================================================
//  Parameters:
//   i_debugOutput - Debug output as integer.
//
//  Returns:
//   debugOutput   - Debug output, converted to a string value.
//=========================================================================
dcl-proc DebugOutput_toString export;
  dcl-pi *n like(LOG4RPG_debugOutput_t);
    i_debugOutput int(5) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

select;
when i_debugOutput = cLOG4RPG_INT_DEBUG_OUTPUT_PRINTER;
   return cLOG4RPG_DEBUG_OUTPUT_PRINTER;
when i_debugOutput = cLOG4RPG_INT_DEBUG_OUTPUT_STDOUT;
   return cLOG4RPG_DEBUG_OUTPUT_STDOUT;
other;
   return '';
endsl;


end-proc;

//=========================================================================
//  Tests, if the specified debug output is valid (well known).
//=========================================================================
//  Parameters:
//   i_debugOutput - Debug output as string.
//
//  Returns:
//   isValid       - Returns TRUE if the debug output is known, else FALSE.
//=========================================================================
dcl-proc DebugOutput_isValid export;
  dcl-pi *n ind;
    i_debugOutput like(LOG4RPG_debugOutput_t) const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (i_debugOutput = cLOG4RPG_DEBUG_OUTPUT_PRINTER) or
   (i_debugOutput = cLOG4RPG_DEBUG_OUTPUT_STDOUT);
   return *on;
else;
   return *off;
endif;


end-proc;

