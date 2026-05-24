**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: SimpleLayout                             *
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
//  27.10.2006  Th.Raddatz    Replaced data structure logEvent with    *
//                            object LogEvent.                         *
//                            Removed return value from procedure      *
//                            PatternLayout_format().                  *
//                            Fixed problem that properties were not   *
//                            found because auf case mismatch.         *
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
/copy QLOG4RPG,PLOG4RPG61

// -----------------------------------------
//  Type definitions
// -----------------------------------------
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG09 Level
/copy QLOG4RPG,PLOG4RPG10 LogLog
/copy QLOG4RPG,PLOG4RPG99 Helper

// -----------------------------------------
//  Private prototypes
// -----------------------------------------
//
// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cTHIS_CLASS 'SimpleLayout';

// -----------------------------------------
//  Global fields
// -----------------------------------------
//
// -----------------------------------------
//  Output to printer
// -----------------------------------------
//
//=========================================================================
//  Creates a new SimpleLayout.
//=========================================================================
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this SimpleLayout.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.
//
//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=========================================================================
dcl-proc SimpleLayout_new export;
  dcl-pi *n ind;
    i_pSuper    like(LOG4RPG_pLayout_t) const;
    io_pHandle  pointer;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

  //  Return value
  dcl-s isDone ind inz(*off);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LogLog_debug('Loaded instance of [' + cTHIS_CLASS + '].');

  return isDone;


end-proc;

//=========================================================================
//  Formats a logging event and returns the result as a string.
//=========================================================================
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this SimpleLayout.
//   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
//                   text of the log event that is formated.
//
//  Returns:
//   text          - Returns the formatted text of the log event.
//=========================================================================
dcl-proc SimpleLayout_format export;
  dcl-pi *n;
    i_pHandle   pointer const;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  Helper fields
  dcl-s string like(LOG4RPG_formattedText_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  string = Level_toString(LogEvent_getPriority(i_pLogEvent)) + ' - ' +
                          LogEvent_getText(i_pLogEvent);

  LogEvent_setText(i_pLogEvent: string);

  return;


end-proc;

//=====================================================================*
//  Used to set the properties of the layout.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this SimpleLayout.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.

//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc SimpleLayout_setProperties export;
  dcl-pi *n;
    i_pHandle   pointer const;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return;


end-proc;

//=====================================================================*
//  Deletes a given SimpleLayout.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this SimpleLayout.

//  Returns:
//   void
//=====================================================================*
dcl-proc SimpleLayout_delete export;
  dcl-pi *n ind;
    io_pHandle pointer;
  end-pi;

  //  Return value
  dcl-s isDone ind inz(*off);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LogLog_verbose('Deleted instance of [' + cTHIS_CLASS + '].');

  isDone = *on;

  return isDone;


end-proc;
