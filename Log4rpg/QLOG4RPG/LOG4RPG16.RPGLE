**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: LogEvent                                 *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  18.10.2006                                              *
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
//  13.06.2008  Th.Raddatz    Changed Log4rpg to log empty messages.   *
//                                                                     *
//  09.06.2008  Th.Raddatz    Added optional parameter i_width to      *
//                            LogEvent_getFirstLineOfText() and        *
//                            LogEvent_getNextLineOfText().            *
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
/copy QLOG4RPG,PLOG4RPG16

// -----------------------------------------
//  Type definitions
// -----------------------------------------
//COPY QLOG4RPG,PLOG4RPG                      Public interface & type definitions

dcl-ds handle_t qualified based(pDummy);
  logName   like(LOG4RPG_loggerName_t);
  time      timestamp;
  priority  like(LOG4RPG_priority_t);
  caller    likeds(LOG4RPG_caller_t);
  hPropList like(LOG4RPG_pPropertyList_t);
  startPos  uns(10);
  text      like(LOG4RPG_formattedText_t);
end-ds;

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QLOG4RPG,CLIB C-Library
/copy QLOG4RPG,CEELIB CEE-Procedures
/copy QBASICS1,PBASICS1 Basic RPG Extensions

/copy QLOG4RPG,PLOG4RPG07 PropertyList
/copy QLOG4RPG,PLOG4RPG09 Level
/copy QLOG4RPG,PLOG4RPG10 LogLog

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
//  Produces a new log event.
//=========================================================================
//  Parameters:
//   i_name        -
//   i_priority    -
//   i_text        -
//   i_caller      -
//
//  Returns:
//   logEvent
//=========================================================================
dcl-proc LogEvent_new export;
  dcl-pi *n like(LOG4RPG_pLogEvent_t);
    i_logName  like(LOG4RPG_loggerName_t) const;
    i_priority like(LOG4RPG_priority_t) const;
    i_text     like(LOG4RPG_formattedText_t) options(*varsize) const;
    i_caller   likeds(LOG4RPG_caller_t) const;
  end-pi;

  //  Return value
  dcl-ds logEvent likeds(handle_t) based(pLogEvent);

  //  Helper fields
  dcl-ds tmpLogEvent likeds(handle_t) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LogLog_verbose('Creating log event for logger [' +
                 i_logName + '] ...');

  pLogEvent = LogEvent_null();

  // Initialize log event
  clear tmpLogEvent;
  tmpLogEvent.logName     = i_logName;
  tmpLogEvent.time        = %timestamp();
  tmpLogEvent.priority    = i_priority;
  if %len(i_text) > 0;
    tmpLogEvent.text = %subst(i_text: 1: %len(i_text));
  else;
    tmpLogEvent.text = '';
  endif;
  tmpLogEvent.caller      = i_caller;
  tmpLogEvent.hPropList   = PropertyList_new();

  // Return layout to caller
  pLogEvent = %alloc(%size(handle_t));
  logEvent = tmpLogEvent;

  return pLogEvent;


end-proc;

//=========================================================================
//  Returns the property list of the log event.
//=========================================================================
//  Parameters:
//   i_logEvent    - Log event.
//
//  Returns:
//   pPropList     - Handle of the property list.
//=========================================================================
dcl-proc LogEvent_getPropertyList export;
  dcl-pi *n like(LOG4RPG_pPropertyList_t);
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return logEvent.hPropList;


end-proc;

//=========================================================================
//  Sets the text of the log event.
//=========================================================================
//  Parameters:
//   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
//   i_text        - Text.
//
//  Returns:
//   void
//=========================================================================
dcl-proc LogEvent_setText export;
  dcl-pi *n;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
    i_text      like(LOG4RPG_formattedText_t) options(*varsize) const;
  end-pi;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (%len(i_text) > 0);
    logEvent.text = %subst(i_text: 1: %len(i_text));
  else;
    logEvent.text = '';
  endif;

  return;


end-proc;

//=========================================================================
//  Appends the text of the log event.
//=========================================================================
//  Parameters:
//   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
//   i_text        - Text.
//
//  Returns:
//   void
//=========================================================================
dcl-proc LogEvent_appendText export;
  dcl-pi *n;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
    i_text      like(LOG4RPG_formattedText_t) options(*varsize) const;
  end-pi;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logEvent.text = logEvent.text + %subst(i_text: 1: %len(i_text));

  return;


end-proc;

//=========================================================================
//  Returns the name of the logger that produced the specified log event.
//=========================================================================
//  Parameters:
//   i_logEvent    - Log event.
//
//  Returns:
//   logName       - Name of the logger.
//=========================================================================
dcl-proc LogEvent_getLoggerName export;
  dcl-pi *n like(LOG4RPG_loggerName_t);
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return logEvent.logName;


end-proc;

//=========================================================================
//  Returns the priority of the log event.
//=========================================================================
//  Parameters:
//   i_logEvent    - Log event.
//
//  Returns:
//   priority      - Priority of the log event.
//=========================================================================
dcl-proc LogEvent_getPriority export;
  dcl-pi *n like(LOG4RPG_priority_t);
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return logEvent.priority;


end-proc;

//=========================================================================
//  Returns the level of the log event.
//=========================================================================
//  Parameters:
//   i_logEvent    - Log event.
//
//  Returns:
//   level         - Level of the log event.
//=========================================================================
dcl-proc LogEvent_getLevel export;
  dcl-pi *n like(LOG4RPG_level_t);
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return Level_toString(logEvent.priority);


end-proc;

//=========================================================================
//  Returns the time at which the log event was produced.
//=========================================================================
//  Parameters:
//   i_logEvent    - Log event.
//
//  Returns:
//   time          - Time, the log event was produced.
//=========================================================================
dcl-proc LogEvent_getTime export;
  dcl-pi *n timestamp;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return logEvent.time;


end-proc;

//=========================================================================
//  Returns the qualified name of the procedure that called Log4rpg.
//=========================================================================
//  Parameters:
//   i_logEvent    - Log event.
//
//  Returns:
//   caller        - Procedure that called Log4rpg.
//=========================================================================
dcl-proc LogEvent_getCaller export;
  dcl-pi *n likeds(LOG4RPG_caller_t);
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return logEvent.caller;


end-proc;

//=========================================================================
//  Resolves the name of the library of the program that called Log4rpg.
//=========================================================================
//  Parameters:
//   i_logEvent    - Log event.
//
//  Returns:
//   library       - Name of the library.
//=========================================================================
dcl-proc LogEvent_resolveCallerPgmLibrary export;
  dcl-pi *n char(10);
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if logEvent.caller.pgm.lib = '';
    logEvent.caller = getCallingProcedure();
  endif;

  return logEvent.caller.pgm.lib;


end-proc;

//=========================================================================
//  Returns the log event text.
//=========================================================================
//  Parameters:
//   i_logEvent    - Log event.
//
//  Returns:
//   text          - Text of the log event.
//=========================================================================
dcl-proc LogEvent_getText export;
  dcl-pi *n like(LOG4RPG_formattedText_t);
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return logEvent.text;


end-proc;

//=========================================================================
//  Returns a pointer to the log event text.
//=========================================================================
//  Parameters:
//   i_logEvent    - Log event.
//
//  Returns:
//   *             - NULL-terminated text string.
//                   Info: Memory must be freed by calling procedure!)
//=========================================================================
dcl-proc LogEvent_getTextPointer export;
  dcl-pi *n pointer;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  Return value
  dcl-s pText pointer inz;

  //  helper fields
  dcl-s size int(10) inz;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  size = LogEvent_textLength(i_pLogEvent) + 1;

  pText = %alloc(size);

  %str(pText: size) = LogEvent_getText(i_pLogEvent);

  return pText;


end-proc;

//=========================================================================
//  Returns the length of the log event text.
//=========================================================================
//  Parameters:
//   i_logEvent    - Log event.
//
//  Returns:
//   length        - Length of the log event text.
//=========================================================================
dcl-proc LogEvent_textLength export;
  dcl-pi *n int(10);
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return %len(logEvent.text);


end-proc;

//=========================================================================
//  Returns the first line of text.
//=========================================================================
//  Parameters:
//   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
//
//  Returns:
//   text          - Text line.
//=========================================================================
dcl-proc LogEvent_getFirstLineOfText export;
  dcl-pi *n like(LOG4RPG_formattedText_t);
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
    o_isText    ind;
    i_width     uns(10) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_width 3;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  logEvent.startPos = 1;

  if (%parms() >= p_width);
    return LogEvent_getNextLineOfText(i_pLogEvent: o_isText: i_width);
  else;
    return LogEvent_getNextLineOfText(i_pLogEvent: o_isText);
  endif;



end-proc;

//=========================================================================
//  Returns the next line of text.
//=========================================================================
//  Parameters:
//   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
//
//  Returns:
//   text          - Text line.
//=========================================================================
dcl-proc LogEvent_getNextLineOfText export;
  dcl-pi *n like(LOG4RPG_formattedText_t);
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
    o_isText    ind;
    i_width     uns(10) options(*nopass) const;
  end-pi;

  //  Parameter positions
  dcl-c p_width 3;

  //  Fields for optional parameters
  dcl-s width like(i_width) inz;

  //  Return value
  dcl-s text like(LOG4RPG_formattedText_t) inz;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if (%parms() >= p_width);
    width = i_width;
  else;
    width = cLOG4RPG_MAX_TEXT_LENGTH;
  endif;

  if logEvent.startPos > 0;
    o_isText = *on;
    return f_wordWrap(logEvent.text
                      : i_width
                      : logEvent.startPos
                      : cWORDWRAP_PARAGRAPH_TEXT +
                        cWORDWRAP_PARAGRAPH_TRIMR);
  endif;

  o_isText = *off;

  return '';


end-proc;

//=========================================================================
//  Deletes a given log event.
//=========================================================================
//  Parameters:
//   io_pLogEvent  - Handle of the Log event returned by LogEvent_new().
//
//  Returns:
//   void
//=========================================================================
dcl-proc LogEvent_delete export;
  dcl-pi *n;
    io_pLogEvent like(LOG4RPG_pLogEvent_t);
  end-pi;

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(io_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  LogLog_verbose('Deleting log event of logger [' +
                  logEvent.logName + '] ...');

  if not PropertyList_isNull(logEvent.hPropList);
    PropertyList_delete(logEvent.hPropList);
  endif;

  clear logEvent;

  dealloc(N) io_pLogEvent;

  io_pLogEvent = LogEvent_null();

  return;


end-proc;

//=========================================================================
//  Tests a given log event for a NULL value.
//=========================================================================
//  Parameters:
//   i_pLogEvent   - Handle of the log event returned by LogEvent_new().
//
//  Returns:
//   isNull        - Returns TRUE if the handle of the log event is a
//                   NULL handle.
//=========================================================================
dcl-proc LogEvent_isNull export;
  dcl-pi *n ind;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

  //  Return value
  dcl-s isNull ind inz(*off);

  //  LogEvent handle
  dcl-ds logEvent likeds(handle_t) based(i_pLogEvent);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  if i_pLogEvent = LogEvent_null();
    isNull = *on;
  else;
    isNull = *off;
  endif;

  return isNull;


end-proc;

//=========================================================================
//  Returns a NULL log event.
//=========================================================================
//  Parameters:
//   void
//
//  Returns:
//   pLogEvent     - LogEvent NULL handle.
//=========================================================================
dcl-proc LogEvent_null export;
  dcl-pi *n like(LOG4RPG_pLogEvent_t);
  end-pi;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return *NULL;


end-proc;
