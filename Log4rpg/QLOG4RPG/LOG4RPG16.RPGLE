      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: LogEvent                                 *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  18.10.2006                                              *
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
      *  13.06.2008  Th.Raddatz    Changed Log4rpg to log empty messages.   *
      *                                                                     *
      *  09.06.2008  Th.Raddatz    Added optional parameter i_width to      *
      *                            LogEvent_getFirstLineOfText() and        *
      *                            LogEvent_getNextLineOfText().            *
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
      /COPY QLOG4RPG,PLOG4RPG16
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
 CPY  *COPY QLOG4RPG,PLOG4RPG                      Public interface & type definitions
      *
     D handle_t...
     D                 DS                  qualified               based(pDummy)
     D  logName                            like(LOG4RPG_loggerName_t   )
     D  time                           Z
     D  priority                           like(LOG4RPG_priority_t     )
     D  caller                             likeds(LOG4RPG_caller_t     )
     D  hPropList                          like(LOG4RPG_pPropertyList_t)
     D  startPos                     10U 0
     D  text                               like(LOG4RPG_formattedText_t)
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CLIB                          C-Library
      /COPY QLOG4RPG,CEELIB                        CEE-Procedures
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      *
      /COPY QLOG4RPG,PLOG4RPG07                    PropertyList
      /COPY QLOG4RPG,PLOG4RPG09                    Level
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
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
      *  Produces a new log event.
      *=========================================================================
      *  Parameters:
      *   i_name        -
      *   i_priority    -
      *   i_text        -
      *   i_caller      -
      *
      *  Returns:
      *   logEvent
      *=========================================================================
     P LogEvent_new...
     P                 B                   export
      *
     D LogEvent_new...
     D                 PI                         like(LOG4RPG_pLogEvent_t)
     D  i_logName                          const  like(LOG4RPG_loggerName_t    )
     D  i_priority                         const  like(LOG4RPG_priority_t      )
     D  i_text                             const  like(LOG4RPG_formattedText_t )
     D                                            options(*varsize)
     D  i_caller                           const  likeds(LOG4RPG_caller_t      )
      *
      *  Return value
     D logEvent        DS                  likeds(handle_t)
     D                                     based(pLogEvent)
      *
      *  Helper fields
     D tmpLogEvent     DS                  likeds(handle_t              ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P LogEvent_new...
     P                 E
      *
      *=========================================================================
      *  Returns the property list of the log event.
      *=========================================================================
      *  Parameters:
      *   i_logEvent    - Log event.
      *
      *  Returns:
      *   pPropList     - Handle of the property list.
      *=========================================================================
     P LogEvent_getPropertyList...
     P                 B                   export
      *
     D LogEvent_getPropertyList...
     D                 PI                         like(LOG4RPG_pPropertyList_t)
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t    )
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return logEvent.hPropList;
 
      /END-FREE
      *
     P LogEvent_getPropertyList...
     P                 E
      *
      *=========================================================================
      *  Sets the text of the log event.
      *=========================================================================
      *  Parameters:
      *   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
      *   i_text        - Text.
      *
      *  Returns:
      *   void
      *=========================================================================
     P LogEvent_setText...
     P                 B                   export
      *
     D LogEvent_setText...
     D                 PI
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
     D  i_text                             const  like(LOG4RPG_formattedText_t )
     D                                            options(*varsize)
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (%len(i_text) > 0);
            logEvent.text = %subst(i_text: 1: %len(i_text));
         else;
            logEvent.text = '';
         endif;
 
         return;
 
      /END-FREE
      *
     P LogEvent_setText...
     P                 E
      *
      *=========================================================================
      *  Appends the text of the log event.
      *=========================================================================
      *  Parameters:
      *   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
      *   i_text        - Text.
      *
      *  Returns:
      *   void
      *=========================================================================
     P LogEvent_appendText...
     P                 B                   export
      *
     D LogEvent_appendText...
     D                 PI
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
     D  i_text                             const  like(LOG4RPG_formattedText_t )
     D                                            options(*varsize)
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         logEvent.text = logEvent.text + %subst(i_text: 1: %len(i_text));
 
         return;
 
      /END-FREE
      *
     P LogEvent_appendText...
     P                 E
      *
      *=========================================================================
      *  Returns the name of the logger that produced the specified log event.
      *=========================================================================
      *  Parameters:
      *   i_logEvent    - Log event.
      *
      *  Returns:
      *   logName       - Name of the logger.
      *=========================================================================
     P LogEvent_getLoggerName...
     P                 B                   export
      *
     D LogEvent_getLoggerName...
     D                 PI                         like(LOG4RPG_loggerName_t    )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return logEvent.logName;
 
      /END-FREE
      *
     P LogEvent_getLoggerName...
     P                 E
      *
      *=========================================================================
      *  Returns the priority of the log event.
      *=========================================================================
      *  Parameters:
      *   i_logEvent    - Log event.
      *
      *  Returns:
      *   priority      - Priority of the log event.
      *=========================================================================
     P LogEvent_getPriority...
     P                 B                   export
      *
     D LogEvent_getPriority...
     D                 PI                         like(LOG4RPG_priority_t      )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return logEvent.priority;
 
      /END-FREE
      *
     P LogEvent_getPriority...
     P                 E
      *
      *=========================================================================
      *  Returns the level of the log event.
      *=========================================================================
      *  Parameters:
      *   i_logEvent    - Log event.
      *
      *  Returns:
      *   level         - Level of the log event.
      *=========================================================================
     P LogEvent_getLevel...
     P                 B                   export
      *
     D LogEvent_getLevel...
     D                 PI                         like(LOG4RPG_level_t         )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return Level_toString(logEvent.priority);
 
      /END-FREE
      *
     P LogEvent_getLevel...
     P                 E
      *
      *=========================================================================
      *  Returns the time at which the log event was produced.
      *=========================================================================
      *  Parameters:
      *   i_logEvent    - Log event.
      *
      *  Returns:
      *   time          - Time, the log event was produced.
      *=========================================================================
     P LogEvent_getTime...
     P                 B                   export
      *
     D LogEvent_getTime...
     D                 PI              Z
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return logEvent.time;
 
      /END-FREE
      *
     P LogEvent_getTime...
     P                 E
      *
      *=========================================================================
      *  Returns the qualified name of the procedure that called Log4rpg.
      *=========================================================================
      *  Parameters:
      *   i_logEvent    - Log event.
      *
      *  Returns:
      *   caller        - Procedure that called Log4rpg.
      *=========================================================================
     P LogEvent_getCaller...
     P                 B                   export
      *
     D LogEvent_getCaller...
     D                 PI                         likeds(LOG4RPG_caller_t      )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return logEvent.caller;
 
      /END-FREE
      *
     P LogEvent_getCaller...
     P                 E
      *
      *=========================================================================
      *  Resolves the name of the library of the program that called Log4rpg.
      *=========================================================================
      *  Parameters:
      *   i_logEvent    - Log event.
      *
      *  Returns:
      *   library       - Name of the library.
      *=========================================================================
     P LogEvent_resolveCallerPgmLibrary...
     P                 B                   export
      *
     D LogEvent_resolveCallerPgmLibrary...
     D                 PI            10A
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if logEvent.caller.pgm.lib = '';
            logEvent.caller = getCallingProcedure();
         endif;
 
         return logEvent.caller.pgm.lib;
 
      /END-FREE
      *
     P LogEvent_resolveCallerPgmLibrary...
     P                 E
      *
      *=========================================================================
      *  Returns the log event text.
      *=========================================================================
      *  Parameters:
      *   i_logEvent    - Log event.
      *
      *  Returns:
      *   text          - Text of the log event.
      *=========================================================================
     P LogEvent_getText...
     P                 B                   export
      *
     D LogEvent_getText...
     D                 PI                         like(LOG4RPG_formattedText_t )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return logEvent.text;
 
      /END-FREE
      *
     P LogEvent_getText...
     P                 E
      *
      *=========================================================================
      *  Returns a pointer to the log event text.
      *=========================================================================
      *  Parameters:
      *   i_logEvent    - Log event.
      *
      *  Returns:
      *   *             - NULL-terminated text string.
      *                   Info: Memory must be freed by calling procedure!)
      *=========================================================================
     P LogEvent_getTextPointer...
     P                 B                   export
      *
     D LogEvent_getTextPointer...
     D                 PI              *
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Return value
     D pText           S               *   inz
      *
      *  helper fields
     D size            S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         size = LogEvent_textLength(i_pLogEvent) + 1;
 
         pText = %alloc(size);
 
         %str(pText: size) = LogEvent_getText(i_pLogEvent);
 
         return pText;
 
      /END-FREE
      *
     P LogEvent_getTextPointer...
     P                 E
      *
      *=========================================================================
      *  Returns the length of the log event text.
      *=========================================================================
      *  Parameters:
      *   i_logEvent    - Log event.
      *
      *  Returns:
      *   length        - Length of the log event text.
      *=========================================================================
     P LogEvent_textLength...
     P                 B                   export
      *
     D LogEvent_textLength...
     D                 PI            10I 0
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return %len(logEvent.text);
 
      /END-FREE
      *
     P LogEvent_textLength...
     P                 E
      *
      *=========================================================================
      *  Returns the first line of text.
      *=========================================================================
      *  Parameters:
      *   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
      *
      *  Returns:
      *   text          - Text line.
      *=========================================================================
     P LogEvent_getFirstLineOfText...
     P                 B                   export
      *
     D LogEvent_getFirstLineOfText...
     D                 PI                         like(LOG4RPG_formattedText_t )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
     D  o_isText                       N
     D  i_width                      10U 0 const  options(*nopass)
      *
      *  Parameter positions
     D p_width         C                   3
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         logEvent.startPos = 1;
 
         if (%parms() >= p_width);
            return LogEvent_getNextLineOfText(i_pLogEvent: o_isText: i_width);
         else;
            return LogEvent_getNextLineOfText(i_pLogEvent: o_isText);
         endif;
 
 
      /END-FREE
      *
     P LogEvent_getFirstLineOfText...
     P                 E
      *
      *=========================================================================
      *  Returns the next line of text.
      *=========================================================================
      *  Parameters:
      *   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
      *
      *  Returns:
      *   text          - Text line.
      *=========================================================================
     P LogEvent_getNextLineOfText...
     P                 B                   export
      *
     D LogEvent_getNextLineOfText...
     D                 PI                         like(LOG4RPG_formattedText_t )
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
     D  o_isText                       N
     D  i_width                      10U 0 const  options(*nopass)
      *
      *  Parameter positions
     D p_width         C                   3
      *
      *  Fields for optional parameters
     D width           S                   like(i_width   ) inz
      *
      *  Return value
     D text            S                   like(LOG4RPG_formattedText_t ) inz
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (%parms() >= p_width);
            width = i_width;
         else;
            width = cLOG4RPG_MAX_TEXT_LENGTH;
         endif;
 
         if logEvent.startPos > 0;
            o_isText = cTrue;
            return f_wordWrap(logEvent.text
                              : i_width
                              : logEvent.startPos
                              : cWORDWRAP_PARAGRAPH_TEXT +
                                cWORDWRAP_PARAGRAPH_TRIMR);
         endif;
 
         o_isText = cFalse;
 
         return '';
 
      /END-FREE
      *
     P LogEvent_getNextLineOfText...
     P                 E
      *
      *=========================================================================
      *  Deletes a given log event.
      *=========================================================================
      *  Parameters:
      *   io_pLogEvent  - Handle of the Log event returned by LogEvent_new().
      *
      *  Returns:
      *   void
      *=========================================================================
     P LogEvent_delete...
     P                 B                   export
      *
     D LogEvent_delete...
     D                 PI
     D  io_pLogEvent                              like(LOG4RPG_pLogEvent_t     )
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(io_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_verbose('Deleting log event of logger [' +
                         logEvent.logName + '] ...');
 
         if not PropertyList_isNull(logEvent.hPropList);
            PropertyList_delete(logEvent.hPropList);
         endif;
 
         clear logEvent;
 
         dealloc(N) io_pLogEvent;
 
         io_pLogEvent = LogEvent_null();
 
         return;
 
      /END-FREE
      *
     P LogEvent_delete...
     P                 E
      *
      *=========================================================================
      *  Tests a given log event for a NULL value.
      *=========================================================================
      *  Parameters:
      *   i_pLogEvent   - Handle of the log event returned by LogEvent_new().
      *
      *  Returns:
      *   isNull        - Returns TRUE if the handle of the log event is a
      *                   NULL handle.
      *=========================================================================
     P LogEvent_isNull...
     P                 B                   export
      *
     D LogEvent_isNull...
     D                 PI              N
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t     )
      *
      *  Return value
     D isNull          S               N   inz(cFalse)
      *
      *  LogEvent handle
     D logEvent        DS                  likeds(handle_t)
     D                                     based(i_pLogEvent)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if i_pLogEvent = LogEvent_null();
            isNull = cTrue;
         else;
            isNull = cFalse;
         endif;
 
         return isNull;
 
      /END-FREE
      *
     P LogEvent_isNull...
     P                 E
      *
      *=========================================================================
      *  Returns a NULL log event.
      *=========================================================================
      *  Parameters:
      *   void
      *
      *  Returns:
      *   pLogEvent     - LogEvent NULL handle.
      *=========================================================================
     P LogEvent_null...
     P                 B                   export
      *
     D LogEvent_null...
     D                 PI                         like(LOG4RPG_pLogEvent_t     )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return *NULL;
 
      /END-FREE
      *
     P LogEvent_null...
     P                 E
      *
