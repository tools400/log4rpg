      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: SimpleLayout                             *
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
      *  27.10.2006  Th.Raddatz    Replaced data structure logEvent with    *
      *                            object LogEvent.                         *
      *                            Removed return value from procedure      *
      *                            PatternLayout_format().                  *
      *                            Fixed problem that properties were not   *
      *                            found because auf case mismatch.         *
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
      /COPY QLOG4RPG,PLOG4RPG61
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG09                    Level
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      /COPY QLOG4RPG,PLOG4RPG99                    Helper
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cTHIS_CLASS...
     D                 C                          const(
     D                                            'SimpleLayout')
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Output to printer
      * -----------------------------------------
      *
      *=========================================================================
      *  Creates a new SimpleLayout.
      *=========================================================================
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this SimpleLayout.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=========================================================================
     P SimpleLayout_new...
     P                 B                   export
      *
     D SimpleLayout_new...
     D                 PI              N
     D  i_pSuper                           const  like(LOG4RPG_pLayout_t       )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Return value
     D isDone          S               N                         inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_debug('Loaded instance of [' + cTHIS_CLASS + '].');
 
         return isDone;
 
      /END-FREE
      *
     P SimpleLayout_new...
     P                 E
      *
      *=========================================================================
      *  Formats a logging event and returns the result as a string.
      *=========================================================================
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this SimpleLayout.
      *   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
      *                   text of the log event that is formated.
      *
      *  Returns:
      *   text          - Returns the formatted text of the log event.
      *=========================================================================
     P SimpleLayout_format...
     P                 B                   export
      *
     D SimpleLayout_format...
     D                 PI
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const  like(LOG4RPG_pLogEvent_t )
      *
      *  Helper fields
     D string          S                   like(LOG4RPG_formattedText_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         string = Level_toString(LogEvent_getPriority(i_pLogEvent)) + ' - ' +
                                 LogEvent_getText(i_pLogEvent);
 
         LogEvent_setText(i_pLogEvent: string);
 
         return;
 
      /END-FREE
      *
     P SimpleLayout_format...
     P                 E
      *
      *=====================================================================*
      *  Used to set the properties of the layout.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this SimpleLayout.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P SimpleLayout_setProperties...
     P                 B                   export
      *
     D SimpleLayout_setProperties...
     D                 PI
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return;
 
      /END-FREE
      *
     P SimpleLayout_setProperties...
     P                 E
      *
      *=====================================================================*
      *  Deletes a given SimpleLayout.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this SimpleLayout.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P SimpleLayout_delete...
     P                 B                   export
      *
     D SimpleLayout_delete...
     D                 PI              N
     D  io_pHandle                     *
      *
      *  Return value
     D isDone          S               N                         inz(cFalse)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         LogLog_verbose('Deleted instance of [' + cTHIS_CLASS + '].');
 
         isDone = cTrue;
 
         return isDone;
 
      /END-FREE
      *
     P SimpleLayout_delete...
     P                 E
      *
