**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: NullAppender                             *
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
//  25.10.2006  Th.Raddatz    Replaced data structure logEvent with    *
//                            object LogEvent.                         *
//                                                                     *
//  26.10.2006  Th.Raddatz    Moved wordWrap processing to Appender    *
//                            implementation objects.                  *
//                                                                     *
//  27.10.2006  Th.Raddatz    Fixed problem that properties were not   *
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
/copy QLOG4RPG,PLOG4RPG52

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG                     Public interface & type definitions

dcl-ds handle_t qualified based(pDummy);
  pSuper like(LOG4RPG_pAppender_t);
  dummy  char(1);
end-ds;

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG10                   LogLog
/copy QLOG4RPG,PLOG4RPG99                   Helper

// -----------------------------------------
//  Private prototypes
// -----------------------------------------
//
// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cTHIS_CLASS;
     D                                            'NullAppender')
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
//
//=====================================================================*
//  Creates a new NullAppender.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this NullAppender.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.
//
//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc NullAppender_new export;
dcl-pi NullAppender_new ind;
  i_pSuper    like(LOG4RPG_pAppender_t) const;
  io_pHandle  pointer;
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pi;

//  Return value
dcl-s isDone ind inz(*off);

//  Appender handle
dcl-ds handle likeds(handle_t) based(io_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

io_pHandle = *NULL;

LogLog_debug('Loaded instance of [' + cTHIS_CLASS + '].');

return isDone;


end-proc;

//=====================================================================*
//  Returns TRUE if the appender requires a layout.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this NullAppender.

//  Returns:
//   isDone        - Returns TRUE if the appender requires a layout,
//                   else FALSE.
//=====================================================================*
dcl-proc NullAppender_requiresLayout export;
  dcl-pi *n ind;
    i_pHandle pointer const;
  end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return *off;


end-proc;

//=====================================================================*
//  Appends a message to the PrinterAppender.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this NullAppender.
//   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().

//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc NullAppender_doAppend export;
  dcl-pi *n ind;
    i_pHandle   pointer const;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

isDone = *on;

return isDone;


end-proc;

//=====================================================================*
//  Used to set the properties of the appender.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this NullAppender.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.

//  Returns:
//   void
//=====================================================================*
dcl-proc NullAppender_setProperties export;
  dcl-pi *n;
    i_pHandle   pointer const;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

//  NullAppender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return;


end-proc;

//=====================================================================*
//  Deletes a given NullAppender.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this NullAppender.

//  Returns:
//   void
//=====================================================================*
dcl-proc NullAppender_delete export;
  dcl-pi *n ind;
    io_pHandle pointer;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Appender handle
  dcl-ds handle likeds(handle_t) based(io_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

LogLog_verbose('Deleted instance of [' + cTHIS_CLASS + '].');

isDone = *on;

return isDone;


end-proc;

