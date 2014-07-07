      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: DailyRollingPrintAppender                *
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
      *  25.10.2006  Th.Raddatz    Replaced data structure logEvent with    *
      *                            object LogEvent.                         *
      *                                                                     *
      *  26.10.2006  Th.Raddatz    Moved wordWrap processing to Appender    *
      *                            implementation objects.                  *
      *                                                                     *
      *  27.10.2006  Th.Raddatz    Fixed problem that properties were not   *
      *                            found because auf case mismatch.         *
      *                                                                     *
      *  22.04.2008  Th.Raddatz    Now usinng the OptionConverter to        *
      *                            convert properties.                      *
      *                                                                     *
      *  09.09.2008  Th.Raddatz    Change doAppend() procedure to call      *
      *                            LogEvent_getFirstLineOfText() and        *
      *                            LogEvent_getNextLineOfText() instead     *
      *                            utilizing f_wordwrap().                  *
      *                            Improving performance by passing a       *
      *                            pointer instead of a field to Rwrite().  *
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
      /COPY QLOG4RPG,PLOG4RPG51
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG                     Public interface & type definitions
      /COPY QLOG4RPG,PLOG4RPG12                   ClassLoader
      *
     D handle_t...
     D                 DS                  qualified           based(pDummy)
     D  pSuper                             like(LOG4RPG_pAppender_t)
     D  isOpen                         N
     D  hFile                          *
     D  outQ                               like(LOG4RPG_path_t  )
     D  splfname                     10A
     D  usrDta                       10A
     D  length                       10I 0
     D  width                        10I 0
     D  lpi                          10I 0
     D  cpi                          10I 0
     D  ovrflw                       10I 0
     D  leftMargin                   10I 0
     D  rightMargin                  10I 0
     D  datePattern                  32A   varying
     D  dateValue                    32A   varying
     D  layoutImpl                         likeds(LOG4RPG_classLayout_t)
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CLIB                         C-Library
      /COPY QLOG4RPG,CLIB2                        C-Library 2 (Record IO)
      *
      /COPY QLOG4RPG,PLOG4RPG07                   PropertyList
      /COPY QLOG4RPG,PLOG4RPG10                   LogLog
      /COPY QLOG4RPG,PLOG4RPG98                   OptionConverter
      /COPY QLOG4RPG,PLOG4RPG99                   Helper
      *
      *  Execute Command (QCMDEXC) API
     D QCMDEXC...
     D                 PR                  extpgm('QCMDEXC')
     D  i_cmd                     32702A   const  options(*varsize)
     D  i_length                     15P 5 const
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Opens a DailyRollingPrintAppender for output.
     D openAppender...
     D                 PR              N
     D  i_pHandle                      *   const
      *
      *  Closes a DailyRollingPrintAppender.
     D closeAppender...
     D                 PR              N
     D  i_pHandle                      *   const
      *
      *  Check if a new file must be started.
     D isNewFileCondition...
     D                 PR              N
     D  i_handle                           const  likeds(handle_t )
      *
      *  Replace variables.
     D replaceVariables...
     D                 PR                         like(handle_t.datePattern )
     D  i_string                           const  like(handle_t.datePattern )
      *
      *  Returns the overwrite command for the printer file.
     D getOverwriteCmd...
     D                 PR           512A          varying
     D  i_handle                           const  likeds(handle_t      )
      *
      *  Returns the output queue from handle.outQ.
     D getOutQ...
     D                 PR                         like(qObj_t          )
     D  i_path                             const  like(LOG4RPG_path_t  )
      *
      *  Loads the configuration parameters from the specified property list.
     D loadConfiguration...
     D                 PR
     D  io_handle                                 likeds(handle_t              )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cTHIS_CLASS...
     D                 C                          const(
     D                                            'DailyRollingPrintAppender')
      *
     D cDEFAULT_LENGTH...
     D                 C                          const(70)
     D cDEFAULT_WIDTH...
     D                 C                          const(132)
     D cDEFAULT_LPI...
     D                 C                          const(6)
     D cDEFAULT_CPI...
     D                 C                          const(10)
     D cDEFAULT_OVRFLW...
     D                 C                          const(60)
     D cDEFAULT_LEFT_MARGIN...
     D                 C                          const(10)
     D cDEFAULT_RIGHT_MARGIN...
     D                 C                          const(10)
      *
     D cPARAMETER_OUTQ...
     D                 C                          const('outq')
     D cPARAMETER_SPLFNAME...
     D                 C                          const('splfname')
     D cPARAMETER_USRDTA...
     D                 C                          const('usrdta')
     D cPARAMETER_PAGE_LENGTH...
     D                 C                          const('length')
     D cPARAMETER_PAGE_WIDTH...
     D                 C                          const('width')
     D cPARAMETER_LPI...
     D                 C                          const('lpi')
     D cPARAMETER_CPI...
     D                 C                          const('cpi')
     D cPARAMETER_OVERFLOW...
     D                 C                          const('ovrflw')
     D cPARAMETER_LEFT_MARGIN...
     D                 C                          const('leftmargin')
     D cPARAMETER_RIGHT_MARGIN...
     D                 C                          const('rightmargin')
     D cPARAMETER_DATE_PATTERN...
     D                 C                          const('datepattern')
      *
     D cDATE_PATTERN_DAYS...
     D                 C                          const('dd')
     D cDATE_PATTERN_MONTHS...
     D                 C                          const('MM')
     D cDATE_PATTERN_YEARS...
     D                 C                          const('yyyy')
     D cDATE_PATTERN_MINUTES...
     D                 C                          const('mm')
     D cDATE_PATTERN_HOURS...
     D                 C                          const('HH')
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=====================================================================*
      *  Creates a new DailyRollingPrintAppender.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this DailyRollingPrintAppender.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P DailyRollingPrintAppender_new...
     P                 B                   export
      *
     D DailyRollingPrintAppender_new...
     D                 PI              N
     D  i_pSuper                           const  like(LOG4RPG_pAppender_t     )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Return value
     D isDone          S               N                         inz(cFalse)
      *
      *  Helper fields
     D tempHandle      DS                  likeds(handle_t          ) inz
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(io_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear tempHandle;
 
         // Initialize handle
         tempHandle.pSuper          = i_pSuper;
         tempHandle.isOpen          = cFalse;
         tempHandle.hFile           = *NULL;
         tempHandle.outQ            = '*N/LOG4RPG';
         tempHandle.splfname        = 'LOG4RPG';
         tempHandle.usrdta          = 'LOG';
         tempHandle.length          = cDEFAULT_LENGTH;
         tempHandle.width           = cDEFAULT_WIDTH;
         tempHandle.lpi             = cDEFAULT_LPI;
         tempHandle.cpi             = cDEFAULT_CPI;
         tempHandle.ovrflw          = cDEFAULT_OVRFLW;
         tempHandle.leftMargin      = cDEFAULT_LEFT_MARGIN;
         tempHandle.rightMargin     = cDEFAULT_RIGHT_MARGIN;
         tempHandle.datePattern     = 'yyyy-MM-dd';
         tempHandle.dateValue       = '';
 
         // Initialize handle from configuration properties
         if (i_pPropList <> *NULL) and not PropertyList_isNull(i_pPropList);
            loadConfiguration(tempHandle: i_pPropList: i_prefix);
         endif;
 
         io_pHandle = %alloc(%size(tempHandle));
         handle = tempHandle;
 
         LogLog_debug('Loaded instance of [' + cTHIS_CLASS + '].');
 
         return isDone;
 
      /END-FREE
      *
     P DailyRollingPrintAppender_new...
     P                 E
      *
      *=====================================================================*
      *  Returns TRUE if the appender requires a layout.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this DailyRollingPrintAppender.
      *
      *  Returns:
      *   isDone        - Returns TRUE if the appender requires a layout,
      *                   else FALSE.
      *=====================================================================*
     P DailyRollingPrintAppender_requiresLayout...
     P                 B                   export
      *
     D DailyRollingPrintAppender_requiresLayout...
     D                 PI              N
     D  i_pHandle                      *   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return cTrue;
 
      /END-FREE
      *
     P DailyRollingPrintAppender_requiresLayout...
     P                 E
      *
      *=====================================================================*
      *  Appends a message to the PrinterAppender.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this DailyRollingPrintAppender.
      *   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P DailyRollingPrintAppender_doAppend...
     P                 B                   export
      *
     D DailyRollingPrintAppender_doAppend...
     D                 PI              N
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const like(LOG4RPG_pLogEvent_t )
      *
      *  Return value
     D isDone          S               N   inz(cFalse)
      *
      *  Helper fields
     D isText          S               N   inz
     D pageWidth       S             10U 0 inz
     D text            S                   like(LOG4RPG_formattedText_t) inz
     D msg             DS                  likeds(msg_t          ) inz
     D RIOFB           DS                  likeds(RIOFB_t        ) based(pRIOFB)
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return if there is no text
         if LogEvent_textLength(i_pLogEvent) = 0;
            return cTrue;
         endif;
 
         // Open the appender for output is it is not yet open
         if not handle.isOpen;
            openAppender(i_pHandle);
         endif;
 
         // Check if a new file must be started.
         if isNewFileCondition(handle);
            if handle.isOpen;
               closeAppender(i_pHandle);
            endif;
            openAppender(i_pHandle);
         endif;
 
         // Write to file
         f_clrErrno();
 
         pageWidth = handle.width - handle.leftMargin - handle.rightMargin;
         text = LogEvent_getFirstLineOfText(i_pLogEvent: isText: pageWidth);
         dow isText;
 
            if handle.leftMargin > 0;
               text = f_space(handle.leftMargin) + text;
            endif;
 
            %len(text) = handle.width;   // Add trailing blanks to clear
                                         // print line of QSYSPRT
 
            monitor;
               text = text;
               pRIOFB = Rwrite(handle.hFile: %addr(text)+2: %len(text));
               if RIOFB.numByt = 0;
                  isDone = cFalse;
               else;
                  isDone = cTrue;
               endif;
            on-error;
               p_rmvPgmMsg(cMsg_Rmv_All: *omit: cMsg_Same: cMsg_ToMyself);
               isDone = cFalse;
            endmon;
 
            text = LogEvent_getNextLineOfText(i_pLogEvent: isText: pageWidth);
         enddo;
 
         if not isDone;
            LogLog_error('Failed to write logEevent to file [' +
                          handle.outQ + ']');
            if f_errno() <> 0;
               LogLog_errorMsg(f_cvtErrnoToMsg(f_errno));
            endif;
         endif;
 
         return isDone;
 
      /END-FREE
      *
     P DailyRollingPrintAppender_doAppend...
     P                 E
      *
      *=====================================================================*
      *  Used to set the properties of the appender.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this DailyRollingFileAppender.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P DailyRollingPrintAppender_setProperties...
     P                 B                   export
      *
     D DailyRollingPrintAppender_setProperties...
     D                 PI
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  DailyRollingPrintAppender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         loadConfiguration(handle: i_pPropList: i_prefix);
 
         return;
 
      /END-FREE
      *
     P DailyRollingPrintAppender_setProperties...
     P                 E
      *
      *=====================================================================*
      *  Deletes a given DailyRollingPrintAppender.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this DailyRollingPrintAppender.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P DailyRollingPrintAppender_delete...
     P                 B                   export
      *
     D DailyRollingPrintAppender_delete...
     D                 PI              N
     D  io_pHandle                     *
      *
      *  Return value
     D isDone          S               N                         inz(cFalse)
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(io_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Close file if it is left open
         if handle.isOpen;
            closeAppender(io_pHandle);
         endif;
 
         // Clear handle data
         clear handle;
 
         // Free handle memory
         dealloc(N) io_pHandle;
 
         LogLog_verbose('Deleted instance of [' + cTHIS_CLASS + '].');
 
         isDone = cTrue;
 
         return isDone;
 
      /END-FREE
      *
     P DailyRollingPrintAppender_delete...
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Opens a DailyRollingPrintAppender for output.
      *=====================================================================*
     P openAppender...
     P                 B
      *
     D openAppender...
     D                 PI              N
     D  i_pHandle                      *   const
      *
      *  Return value
     D isDone          S               N                         inz(cFalse)
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      *
      *  Helper fields
     D cmd             S            512A   inz varying
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Set end of livetime of file
         handle.dateValue = replaceVariables(handle.datePattern);
 
         // Open new instance of file
         if handle.hFile = *NULL;
            cmd   = getOverwriteCmd(handle);
 
            monitor;
               p_rmvPgmMsg(cMsg_Rmv_All: *omit: cMsg_Same: cMsg_ToMyself);
               qcmdexc(cmd: %len(cmd));
            on-error;
               p_rmvPgmMsg(cMsg_Rmv_All: *omit: cMsg_Same: cMsg_ToMyself);
               LogLog_error('Error on OVRPRTF with command ' + cmd);
            endmon;
 
            handle.hFile = Ropen('*LIBL/QSYSPRT': 'wr');
 
            if handle.hFile = *NULL;
               isDone = cFalse;
            else;
               isDone = cTrue;
               handle.isOpen = cTrue;
            endif;
 
         endif;
 
         return isDone;
 
      /END-FREE
      *
     P openAppender...
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Closes a DailyRollingPrintAppender.
      *=====================================================================*
     P closeAppender...
     P                 B
      *
     D closeAppender...
     D                 PI              N
     D  i_pHandle                      *   const
      *
      *  Return value
     D isDone          S               N                         inz(cFalse)
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if Rclose(handle.hFile) = 0;
            handle.isOpen = cFalse;
            handle.hFile  = *NULL;
            isDone = cTrue;
         else;
            isDone = cFalse;
         endif;
 
         return isDone;
 
      /END-FREE
      *
     P closeAppender...
     P                 E
      *
      *=====================================================================*
    R *  *** private ***
      *  Check overflow condition.
      *=====================================================================*
     P isNewFileCondition...
     P                 B
      *
     D isNewFileCondition...
     D                 PI              N
     D  i_handle                           const  likeds(handle_t )
      *
      *  Return value
     D isNewFile       S               N   inz(cFalse)
      *
      *  Helper fields
     D cmpDateValue    S                   like(i_handle.dateValue  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         cmpdateValue = replaceVariables(i_handle.datePattern);
 
         if i_handle.dateValue <> cmpDateValue;
            isNewFile = cTrue;
         else;
            isNewFile = cFalse;
         endif;
 
         return isNewFile;
 
      /END-FREE
      *
     P isNewFileCondition...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Replace variables.
      *=========================================================================
     P replaceVariables...
     P                 B
      *
     D replaceVariables...
     D                 PI                         like(handle_t.datePattern )
     D  i_string                           const  like(handle_t.datePattern )
      *
      *  Return value
     D string          S                   like(handle_t.datePattern ) inz
      *
      *  Helper fields
     D timestamp       S               Z   inz
     D days            S              2S 0 inz
     D months          S              2S 0 inz
     D years           S              4S 0 inz
     D minutes         S              2S 0 inz
     D hours           S              2S 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         timestamp = %timestamp();
         days    = %subdt(timestamp: *DAYS    );
         months  = %subdt(timestamp: *MONTHS  );
         years   = %subdt(timestamp: *YEARS   );
         minutes = %subdt(timestamp: *MINUTES );
         hours   = %subdt(timestamp: *HOURS   );
 
         string = i_string;
 
         string = f_replace(cDATE_PATTERN_DAYS
                            : %editc(days   : 'X'): string);
         string = f_replace(cDATE_PATTERN_MONTHS
                            : %editc(months : 'X'): string);
         string = f_replace(cDATE_PATTERN_YEARS
                            : %editc(years  : 'X'): string);
         string = f_replace(cDATE_PATTERN_MINUTES
                            : %editc(minutes: 'X'): string);
         string = f_replace(cDATE_PATTERN_HOURS
                            : %editc(hours  : 'X'): string);
 
         return string;
 
      /END-FREE
      *
     P replaceVariables...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Returns the overwrite command for the printer file.
      *=========================================================================
     P getOverwriteCmd...
     P                 B
      *
     D getOverwriteCmd...
     D                 PI           512A          varying
     D  i_handle                           const  likeds(handle_t      )
      *
      *  Return value
     D cmd             S            512A   inz  varying
      *
      *  Helper fields
     D qOutq           DS                  likeds(qObj_t   ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         qOutQ = getOutQ(i_handle.outQ);
 
         cmd = 'OVRPRTF ' +
                  'FILE(QSYSPRT) ' +
                  'TOFILE(*FILE) ' +
                  'PAGESIZE('   + %char(i_handle.length)  + ' ' +
                                  %char(i_handle.width )  + ') ' +
                  'LPI('        + %char(i_handle.lpi)     + ') ' +
                  'CPI('        + %char(i_handle.cpi)     + ') ' +
                  'OVRFLW('     + %char(i_handle.ovrflw)  + ') ' +
                  'OUTQ('       + %trim(qOutQ.lib)  + '/' +
                                  %trim(qOutQ.name)       + ') ' +
                  'USRDTA('''   + i_handle.usrDta         + ''') ' +
                  'SPLFNAME('   + i_handle.splfname       + ') ' +
                  'OVRSCOPE(*CALLLVL)';
 
         return cmd;
 
      /END-FREE
      *
     P getOverwriteCmd...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Returns the output queue from handle.outQ.
      *=========================================================================
     P getOutQ...
     P                 B
      *
     D getOutQ...
     D                 PI                         like(qObj_t          )
     D  i_outQ                             const  like(LOG4RPG_path_t  )
      *
      *  Return value
     D qOutQ           DS                  likeds(qObj_t   ) inz
      *
      *  Local fields
     D x               S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
            if i_outQ = '';
               qOutQ.name = '*N';
               qOutQ.lib  = '*N';
               return qOutQ;
            endif;
 
            x = %scan('/': i_outQ);
 
            if (x > 1) and (x < %len(i_outQ));
               qOutQ.name = %subst(i_outQ: x+1);
               qOutQ.lib  = f_left(i_outQ: x-1);
            else;
               qOutQ.name = i_outQ;
               qOutQ.lib  = '*N';
            endif;
 
         return qOutQ;
 
      /END-FREE
      *
     P getOutQ...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Loads the configuration parameters from the specified property list.
      *=========================================================================
     P loadConfiguration...
     P                 B
      *
     D loadConfiguration...
     D                 PI
     D  io_handle                                 likeds(handle_t              )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Local fields
     D parameter       S                   like(property.key        ) inz
     D prefix          S                   like(i_prefix            ) inz
     D property        DS                  likeds(LOG4RPG_property_t) inz
     D propIter        DS                  likeds(LOG4RPG_Property...
     D                                                    ListIterator_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         prefix = f_lcase(i_prefix);
 
         propIter = PropertyList_getIterator(i_pPropList);
 
         property = PropertyList_getFirst(propIter);
 
         dow property.key <> '';
 
            if (prefix = '') or (f_startsWith(prefix: property.key) and
 B03                             %len(property.key) > %len(prefix));
 
               parameter = f_lcase(%subst(property.key: %len(prefix) + 1));
 
               select;
               when parameter = cPARAMETER_OUTQ;
                  io_handle.outQ        = property.value;
               when parameter = cPARAMETER_SPLFNAME;
                  io_handle.splfname    = property.value;
               when parameter = cPARAMETER_USRDTA;
                  io_handle.usrdta      = property.value;
               when parameter = cPARAMETER_PAGE_LENGTH;
                  io_handle.length =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_LENGTH);
               when parameter = cPARAMETER_PAGE_WIDTH;
                  io_handle.width =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_WIDTH);
               when parameter = cPARAMETER_LPI;
                  io_handle.lpi =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_LPI);
               when parameter = cPARAMETER_CPI;
                  io_handle.cpi =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_CPI);
               when parameter = cPARAMETER_OVERFLOW;
                  io_handle.ovrflw =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_OVRFLW);
               when parameter = cPARAMETER_LEFT_MARGIN;
                  io_handle.leftMargin =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_LEFT_MARGIN);
               when parameter = cPARAMETER_RIGHT_MARGIN;
                  io_handle.rightMargin =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_RIGHT_MARGIN);
               when parameter = cPARAMETER_DATE_PATTERN;
                  io_handle.datePattern = property.value;
               when Appender_knowsProperty(parameter);
 B03              // Ignore all parameters known by super Appender class
               other;
                  LogLog_warning('No such property ['     +
                                  property.key            +
                                 '] in [' + cTHIS_CLASS + ']');
               endsl;
 
            endif;
 
            property = PropertyList_getNext(propIter);
         enddo;
 
         return;
 
      /END-FREE
      *
     P loadConfiguration...
     P                 E
      *
