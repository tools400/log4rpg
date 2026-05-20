**free
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: DailyRollingFileAppender                 *
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
//  16.11.2006  Th.Raddatz    Added properties 'writeHeader' and       *
//                            'writeFooter' that control whether a     *
//                            header or footer is appended to the      *
//                            log.                                     *
//                                                                     *
//  19.12.2006  Th.Raddatz    Fixed problem that Log4rpg crashed,      *
//                            when the appender could not be opened.   *
//                            (error on 'f_left(i_handle.dateValue: 1)'*
//                            due to missing dateValue)                *
//                                                                     *
//  16.05.2007  Th.Raddatz    Added property 'share' to specify        *
//                            whether to share the log file with       *
//                            jobs or not.                             *
//                                                                     *
//  05.06.2007  Th.Raddatz    Fixed problem that the log file could    *
//                            be renamed because 'getArchivePath'      *
//                            returned a path instead of a file name.  *
//                                                                     *
//  22.04.2008  Th.Raddatz    Now usinng the OptionConverter to        *
//                            convert properties.                      *
//                                                                     *
//  09.09.2008  Th.Raddatz    Improved performance when calling        *
//                            f_writeLineIfsFile().                    *
//                                                                     *
//  07.11.2008  Th.Raddatz    Fixed synchronisation problems, when     *
//                            sharing the log file with other jobs.    *
//                            Added properties:  syncObj               *
//                                               syncLogMode           *
//                                               syncText              *
//                                                                     *
//  20.11.2010  Th.Raddatz    Added parameter 'ccsid' to enable the    *
//                            user to specify the ccsid of the log     *
//                            file.                                    *
//                                                                     *
//  09.05.2015  Th.Raddatz    Changed *_doAppend() to better handle    *
//                            unexpected errors when renaming the      *
//                            log file.                                *
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
/copy QLOG4RPG,PLOG4RPG50

// -----------------------------------------
//  Type definitions
// -----------------------------------------
/copy QLOG4RPG,PLOG4RPG                     Public interface & type definitions

dcl-ds handle_t qualified based(pDummy);
  pSuper        like(LOG4RPG_pAppender_t);
  isOpen        ind;
  hFile         like(ifs_hFile_t);
  path          like(LOG4RPG_path_t);
  datePattern   varchar(32);
  dateValue     varchar(32);
  writeHeader   ind;
  writeFooter   ind;
  share         ind;
  fileID        likeds(ifs_fileID_t);
  qSyncObj      likeds(qObj_t);
  isSyncLogMode ind;
  syncText      varchar(50);
  ccsid         uns(10);
  lastRnmErr    timestamp;
end-ds;

// -----------------------------------------
//  Prototypes
// -----------------------------------------
/copy QIFS,PIFS                             IFS Stream File Support

/copy QLOG4RPG,PLOG4RPG07                   PropertyList
/copy QLOG4RPG,PLOG4RPG10                   LogLog
/copy QLOG4RPG,PLOG4RPG97                   Synchronisation
/copy QLOG4RPG,PLOG4RPG98                   OptionConverter
/copy QLOG4RPG,PLOG4RPG99                   Helper

// -----------------------------------------
//  Private prototypes
// -----------------------------------------

//  Opens a DailyRollingFileAppender for output.
dcl-pr openAppender ind;
  i_pHandle pointer const;
end-pr;

//  Closes a DailyRollingFileAppender.
dcl-pr closeAppender ind;
  i_pHandle pointer const;
end-pr;

//  Appends the header.
dcl-pr appendHeader;
  i_pHandle pointer const;
end-pr;

//  Appends the footer.
dcl-pr appendFooter;
  i_pHandle pointer const;
end-pr;

//  Writes text.
dcl-pr append;
  i_pHandle pointer const;
  i_text    like(LOG4RPG_formattedText_t) const;
end-pr;

//  Check if a new file must be started.
dcl-pr isNewFileCondition ind;
  i_handle likeds(handle_t) const;
end-pr;

//  Replace variables.
dcl-pr replaceVariables like(handle_t.datePattern);
  i_string like(handle_t.datePattern) const;
  i_time   timestamp const;
end-pr;

//  Returns *ON if there is a rename error. Resets the error after
//  a reasonable amount of time.
dcl-pr checkAndHandleRenameError ind;
  i_pHandle pointer const;
end-pr;

//  Sets the date and time of an error during renaming the output file.
dcl-pr setRenameError;
  i_pHandle pointer const;
end-pr;

//  Clears the date and time of an error during renaming the output file.
dcl-pr clearRenameError;
  i_pHandle pointer const;
end-pr;

//  Loads the configuration parameters from the specified property list.
dcl-pr loadConfiguration;
  io_handle   likeds(handle_t);
  i_pPropList like(LOG4RPG_pPropertyList_t) const;
  i_prefix    like(LOG4RPG_prefix_t) const;
end-pr;

//  Returns the name of the archive for the current log file.
dcl-pr getArchivePath like(LOG4RPG_path_t);
  i_handle likeds(handle_t) const;
end-pr;

// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cTHIS_CLASS;
     D                                            'DailyRollingFileAppender')
//
dcl-c cDEFAULT_WRITE_HEADER
      const('1');
dcl-c cDEFAULT_WRITE_FOOTER '1';
dcl-c cDEFAULT_SHARE '0';
dcl-c cDEFAULT_SYNC_OBJ_NAME 'LOG4RPG50';
dcl-c cDEFAULT_SYNC_OBJ_LIB 'QGPL';
dcl-c cDEFAULT_SYNC_LOG_MODE '0';
dcl-c cDEFAULT_SYNC_TEXT 'Log4rpg DailyRollingFileAppender Sync. Object';
dcl-c cDEFAULT_CCSID 850;

dcl-c cPARAMETER_PATH 'path';
dcl-c cPARAMETER_DATE_PATTERN 'datepattern';
dcl-c cPARAMETER_WRITE_HEADER 'writeheader';
dcl-c cPARAMETER_WRITE_FOOTER 'writefooter';
dcl-c cPARAMETER_SHARE 'share';
dcl-c cPARAMETER_SYNC_OBJ 'syncobj';
dcl-c cPARAMETER_SYNC_LOG_MODE 'synclogmode';
dcl-c cPARAMETER_SYNC_TEXT 'synctext';
dcl-c cPARAMETER_CCSID 'ccsid';

dcl-c cDATE_PATTERN_DAYS 'dd';
dcl-c cDATE_PATTERN_MONTHS 'MM';
dcl-c cDATE_PATTERN_YEARS 'yyyy';
dcl-c cDATE_PATTERN_MINUTES 'mm';
dcl-c cDATE_PATTERN_HOURS 'HH';

// -----------------------------------------
//  Global fields
// -----------------------------------------

//=====================================================================*
//  Creates a new DailyRollingFileAppender.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this DailyRollingFileAppender.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.

//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc DailyRollingFileAppender_new export;
  dcl-pi *n ind;
    i_pSuper    like(LOG4RPG_pAppender_t) const;
    io_pHandle  pointer;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Helper fields
  dcl-ds tempHandle likeds(handle_t) inz;
  dcl-ds emptyFileID likeds(ifs_fileID_t) inz;

//  Appender handle
  dcl-ds handle likeds(handle_t) based(io_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

clear tempHandle;

// Initialize handle
tempHandle.pSuper          = i_pSuper;   // Handle of the super class 'Appender'
tempHandle.isOpen          = *off;
tempHandle.hFile           = 0;
tempHandle.path            = 'log4rpg.log';
tempHandle.datePattern     = '.yyyy-MM-dd';
tempHandle.dateValue       = '';
tempHandle.writeHeader     = cDEFAULT_WRITE_HEADER;
tempHandle.writeFooter     = cDEFAULT_WRITE_FOOTER;
tempHandle.share           = cDEFAULT_SHARE;
tempHandle.fileID          = emptyFileID;
tempHandle.qSyncObj.name   = cDEFAULT_SYNC_OBJ_NAME;
tempHandle.qSyncObj.lib    = cDEFAULT_SYNC_OBJ_LIB;
tempHandle.isSyncLogMode   = cDEFAULT_SYNC_LOG_MODE;
tempHandle.syncText        = cDEFAULT_SYNC_TEXT;
tempHandle.ccsid           = cDEFAULT_CCSID;
tempHandle.lastRnmErr      = *LOVAL;

// Initialize handle from configuration properties
if (i_pPropList <> *NULL) and not PropertyList_isNull(i_pPropList);
   loadConfiguration(tempHandle: i_pPropList: i_prefix);
endif;

io_pHandle = %alloc(%size(tempHandle));
handle = tempHandle;

LogLog_debug('Loaded instance of [' + cTHIS_CLASS + '].');

return isDone;


end-proc;

//=====================================================================*
//  Returns TRUE if the appender requires a layout.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this DailyRollingFileAppender.

//  Returns:
//   isDone        - Returns TRUE if the appender requires a layout,
//                   else FALSE.
//=====================================================================*
dcl-proc DailyRollingFileAppender_requiresLayout export;
  dcl-pi *n ind;
    i_pHandle pointer const;
  end-pi;

//  Appender handle
  dcl-ds handle likeds(handle_t) based(io_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return *on;


end-proc;

//=====================================================================*
//  Appends a message to the DailyRollingFileAppender.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this DailyRollingFileAppender.
//   i_pLogEvent   - Handle of the Log event.

//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc DailyRollingFileAppender_doAppend export;
  dcl-pi *n ind;
    i_pHandle   pointer const;
    i_pLogEvent like(LOG4RPG_pLogEvent_t) const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Helper fields
  dcl-s archive like(LOG4RPG_path_t) inz;
  dcl-s bufLength int(10) inz;
  dcl-s lineLength int(10) inz;
  dcl-s text like(LOG4RPG_formattedText_t) inz;
  dcl-s isText ind inz;
  dcl-s isNewFile ind inz;
  dcl-s isRenameError ind inz;
  dcl-ds ticket likeds(LOG4RPG_syncTicket_t) inz;
  dcl-ds msg likeds(msg_t) inz;

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Return if there is no text
if LogEvent_textLength(i_pLogEvent) = 0;
   return *on;
endif;

// Open the appender for output is it is not yet open
if not handle.isOpen;
   if not openAppender(i_pHandle);
      return *off;
   endif;
endif;

// Check if a new file must be started.
if (not checkAndHandleRenameError(i_pHandle) and
    isNewFileCondition(handle));

   dou '1';

      isRenameError = *off;

      // Start synchronisation with concurrent jobs
      if (handle.share);
         if (not Synchronisation_start(handle.qSyncObj.name
                                       : handle.qSyncObj.lib
                                       : ticket: msg));
            LogLog_errorMsg(msg);
            isRenameError = *on;
            leave;
         endif;
      endif;

      // Determine, whether this job has to create a new file or not.
      // If a new file has been created by anther job, this job only
      // has to switch to the new file.
      if (not handle.share or
          f_getIfsFileID(handle.path) = handle.fileID);
         isNewFile = *on;
      else;
         isNewFile = *off;
      endif;

      if handle.isOpen;
         if (isNewFile);
            appendFooter(i_pHandle);
         endif;
         closeAppender(i_pHandle);
      endif;

      if (isNewFile and f_isIfsFile(handle.path: *omit));
         archive =%trimR(f_rtvIfsFileFromPath(getArchivePath(handle)));
         if (f_renameIfsFile(handle.path: archive: msg) <> 0);
            LogLog_errorMsg(msg);
            isRenameError = *on;
         endif;
      endif;

      openAppender(i_pHandle);

      // End synchronisation
      if (handle.share);
         Synchronisation_end(ticket);
      endif;

   enddo;

   if (isRenameError);
      setRenameError(i_pHandle);
   else;
      clearRenameError(i_pHandle);
   endif;

   if (not handle.isOpen);
      return *off;
   endif;

endif;

// Write to file. Asking the LogEvent to do wordWrap.
lineLength = cLOG4RPG_MAX_TEXT_LENGTH - %len(cIFS_EOL_CRLF);
text = LogEvent_getFirstLineOfText(i_pLogEvent: isText: lineLength);
dow isText;
   text = text + cIFS_EOL_CRLF;
   bufLength = %len(text);
   if f_writeLineIfsFile(handle.hFile: %addr(text)+2
                                     : bufLength
                                     : ''
                                     : msg            ) <> bufLength;
      LogLog_error('Failed to write logEevent to file [' +
                   handle.path + ']');
      LogLog_errorMsg(msg);
      isDone = *off;
   else;
      isDone = *on;
   endif;
   text = LogEvent_getNextLineOfText(i_pLogEvent: isText: lineLength);
enddo;

return isDone;


end-proc;

//=====================================================================*
//  Used to set the properties of the appender.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this DailyRollingFileAppender.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.

//  Returns:
//   void
//=====================================================================*
dcl-proc DailyRollingFileAppender_setProperties export;
  dcl-pi *n;
    i_pHandle   pointer const;
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

//  DailyRollingFileAppender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

loadConfiguration(handle: i_pPropList: i_prefix);

return;


end-proc;

//=====================================================================*
//  Deletes a given DailyRollingFileAppender.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this DailyRollingFileAppender.

//  Returns:
//   void
//=====================================================================*
dcl-proc DailyRollingFileAppender_delete export;
  dcl-pi *n ind;
    io_pHandle pointer;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Appender handle
  dcl-ds handle likeds(handle_t) based(io_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Close file if it is left open
if handle.isOpen;
   closeAppender(io_pHandle);
endif;

// Clear handle data
clear handle;

// Free handle memory
dealloc(N) io_pHandle;

LogLog_verbose('Deleted instance of [' + cTHIS_CLASS + '].');

isDone = *on;

return isDone;


end-proc;

//=====================================================================*
//  *** Private ***
//  Opens a DailyRollingFileAppender for output.
//=====================================================================*
dcl-proc openAppender;
  dcl-pi *n ind;
    i_pHandle pointer const;
  end-pi;

//  Helper fields
  dcl-s isNewFile ind inz(*off);
  dcl-s crtTime timestamp inz;
  dcl-s SHARE_MODE int(10) inz;
  dcl-ds msg likeds(msg_t) inz;

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Set sync logging mode. Enables or disables the
// logging of the sync lock holder.
Synchronisation_setLogMode(handle.isSyncLogMode);
Synchronisation_setObjectDesc(handle.syncText);

// Check, whether the  file already exists
isNewFile = not f_isIfsFile(handle.path: *omit);

// Open new instance of file
if not handle.share;
   SHARE_MODE = O_SHARE_RDONLY;
else;
   SHARE_MODE = O_SHARE_RDWR;
endif;

handle.hFile = f_openIfsFile(handle.path: O_CREAT + O_APPEND
                                                  + O_TEXTDATA
                                                  + O_TEXT_CREAT
                                                  + SHARE_MODE
                                                  + O_WRONLY
                                                  + O_CCSID
                                        : handle.ccsid
                                        : *omit: msg);
if handle.hFile = cIFS_ERROR;
   LogLog_errorMsg(msg);
   return *off;
endif;

// Set end of livetime of file
crtTime = f_getIfsFileCrtTime(handle.path: *omit);
handle.dateValue = replaceVariables(handle.datePattern: crtTime);

// Mark file as "open"
handle.isOpen = *on;

// Remember the unique file ID
handle.fileID = f_getIfsFileIDH(handle.hFile);

// Write header to file
if isNewFile;
   appendHeader(i_pHandle);
endif;

return *on;


end-proc;

//=====================================================================*
//  *** Private ***
//  Closes a DailyRollingFileAppender.
//=====================================================================*
dcl-proc closeAppender;
  dcl-pi *n ind;
    i_pHandle pointer const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if f_closeIfsFile(handle.hFile) = 0;
   handle.isOpen = *off;
   handle.hFile  = 0;
   isDone = *on;
else;
   isDone = *off;
endif;

return isDone;


end-proc;

//=====================================================================*
//  *** Private ***
//  Appends the header.
//=====================================================================*
dcl-proc appendHeader;
  dcl-pi *n;
    i_pHandle pointer const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Helper fields
  dcl-s header like(LOG4RPG_header_t) inz;
  dcl-s pLayout like(LOG4RPG_pLayout_t) inz;
  dcl-ds msg likeds(msg_t) inz;

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if not handle.writeHeader;
   return;
endif;

// Get layout to write footer string of layout
pLayout = Appender_getLayout(handle.pSuper);

if not Layout_isNull(pLayout);
   header = Layout_getHeader(pLayout);
   append(i_pHandle: header);
endif;

return;


end-proc;

//=====================================================================*
//  *** Private ***
//  Appends the footer.
//=====================================================================*
dcl-proc appendFooter;
  dcl-pi *n;
    i_pHandle pointer const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Helper fields
  dcl-s footer like(LOG4RPG_footer_t) inz;
  dcl-s pLayout like(LOG4RPG_pLayout_t) inz;
  dcl-ds msg likeds(msg_t) inz;

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if not handle.writeFooter;
   return;
endif;

// Get layout to write footer string of layout
pLayout = Appender_getLayout(handle.pSuper);

if not Layout_isNull(pLayout);
   footer = Layout_getFooter(pLayout);
   append(i_pHandle: footer);
endif;

return;


end-proc;

//=====================================================================*
//  *** Private ***
//  Writes text.
//=====================================================================*
dcl-proc append;
  dcl-pi *n;
    i_pHandle pointer const;
    i_text    like(LOG4RPG_formattedText_t) const;
  end-pi;

//  Return value
  dcl-s isDone ind inz(*off);

//  Helper fields
  dcl-s text like(i_text) inz;
  dcl-s bufLength int(10) inz;
  dcl-s startPos uns(10) inz;
  dcl-s pLayout like(LOG4RPG_pLayout_t) inz;
  dcl-ds msg likeds(msg_t) inz;

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if i_text = '';
   return;
endif;

startPos = 1;
dow startPos > 0;
   text = f_wordWrap(i_text
                     : %len(i_text)
                     : startPos
                     : cWORDWRAP_PARAGRAPH_TEXT +
                       cWORDWRAP_PARAGRAPH_TRIMR);
   bufLength = %len(text);
   if f_writeLineIfsFile(handle.hFile: text
                                     : bufLength
                                     : cIFS_EOL_CRLF
                                     : msg) <> bufLength;
      LogLog_error('Failed to write text to file [' +
                    handle.path + ']');
      LogLog_errorMsg(msg);
   endif;
enddo;

return;


end-proc;

//=====================================================================*
//  *** private ***
//  Check overflow condition.
//=====================================================================*
dcl-proc isNewFileCondition;
  dcl-pi *n ind;
    i_handle likeds(handle_t) const;
  end-pi;

//  Return value
  dcl-s isNewFile ind inz(*off);

//  Helper fields
  dcl-s cmpDateValue like(i_handle.dateValue) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cmpDateValue = replaceVariables(i_handle.datePattern: %timestamp());

if i_handle.dateValue <> cmpDateValue or
   not f_isIfsFile(i_handle.path: *omit);
   isNewFile = *on;
else;
   isNewFile = *off;
endif;

return isNewFile;


end-proc;

//=========================================================================
//  *** Private ***
//  Replace variables.
//=========================================================================
dcl-proc replaceVariables;
  dcl-pi *n like(handle_t.datePattern);
    i_string like(handle_t.datePattern) const;
    i_time   timestamp const;
  end-pi;

//  Return value
  dcl-s string like(handle_t.datePattern) inz;

//  Helper fields
  dcl-s timestamp timestamp inz;
  dcl-s days zoned(2) inz;
  dcl-s months zoned(2) inz;
  dcl-s years zoned(4) inz;
  dcl-s minutes zoned(2) inz;
  dcl-s hours zoned(2) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

timestamp = i_time;
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


end-proc;

//=====================================================================*
//  *** Private ***
//  Returns *ON if there is a rename error. Resets the error after
//  a reasonable amount of time.
//=====================================================================*
dcl-proc checkAndHandleRenameError;
  dcl-pi *n ind;
    i_pHandle pointer const;
  end-pi;

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (handle.lastRnmErr = *LOVAL);
   return *off;
endif;

if (%diff(%timestamp(): handle.lastRnmErr: *DAYS) > 1 or
    %diff(%timestamp(): handle.lastRnmErr: *SECONDS) > 600);
   // try again
   clearRenameError(i_pHandle);
   return *off;
endif;

return *on;

end-proc;

//=====================================================================*
//  *** Private ***
//  Sets the date and time of an error during renaming the output file.
//=====================================================================*
dcl-proc setRenameError;
  dcl-pi *n;
    i_pHandle pointer const;
  end-pi;

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if (handle.lastRnmErr = *LOVAL);
   handle.lastRnmErr = %timestamp();
endif;

end-proc;

//=====================================================================*
//  *** Private ***
//  Clears the date and time of an error during renaming the output file.
//=====================================================================*
dcl-proc clearRenameError;
  dcl-pi *n;
    i_pHandle pointer const;
  end-pi;

//  Appender handle
  dcl-ds handle likeds(handle_t) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

handle.lastRnmErr = *LOVAL;

end-proc;

//=========================================================================
//  *** Private ***
//  Loads the configuration parameters from the specified property list.
//=========================================================================
dcl-proc loadConfiguration;
  dcl-pi *n;
    io_handle   likeds(handle_t);
    i_pPropList like(LOG4RPG_pPropertyList_t) const;
    i_prefix    like(LOG4RPG_prefix_t) const;
  end-pi;

//  Local fields
  dcl-s parameter like(property.key) inz;
  dcl-s prefix like(i_prefix) inz;
  dcl-ds property likeds(LOG4RPG_property_t) inz;
  dcl-ds propIter DS likeds(LOG4RPG_Property: ListIterator_t) inz;
  end-ds;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

prefix = f_lcase(i_prefix);

propIter = PropertyList_getIterator(i_pPropList);

property = PropertyList_getFirst(propIter);

dow property.key <> '';

   if (prefix = '') or (f_startsWith(prefix: property.key) and
                        %len(property.key) > %len(prefix));

      parameter = f_lcase(%subst(property.key: %len(prefix) + 1));

      select;
      when parameter = cPARAMETER_PATH;
         io_handle.path = property.value;
      when parameter = cPARAMETER_DATE_PATTERN;
         io_handle.datePattern = property.value;
      when parameter = cPARAMETER_WRITE_HEADER;
         io_handle.writeHeader =
            OptionConverter_toBoolean(
               property.value: cDEFAULT_WRITE_HEADER);
      when parameter = cPARAMETER_WRITE_FOOTER;
         io_handle.writeFooter =
            OptionConverter_toBoolean(
               property.value: cDEFAULT_WRITE_FOOTER);
      when parameter = cPARAMETER_SHARE;
         io_handle.share =
            OptionConverter_toBoolean(
               property.value: cDEFAULT_SHARE);
      when parameter = cPARAMETER_SYNC_OBJ;
         io_handle.qSyncObj = getObject(property.value);
      when parameter = cPARAMETER_SYNC_LOG_MODE;
         io_handle.isSyncLogMode =
            OptionConverter_toBoolean(
               property.value: cDEFAULT_SYNC_LOG_MODE);
      when parameter = cPARAMETER_SYNC_TEXT;
         io_handle.syncText = property.value;
      when parameter = cPARAMETER_CCSID;
         io_handle.ccsid =
            OptionConverter_toInt(
               property.value: cDEFAULT_CCSID);
      when Appender_knowsProperty(parameter);
         // Ignore all parameters known by super Appender class
      other;
         LogLog_warning('No such property ['     +
                         property.key            +
                        '] in [' + cTHIS_CLASS + ']');
      endsl;

   endif;

   property = PropertyList_getNext(propIter);
enddo;

return;


end-proc;

//=========================================================================
//  *** Private ***
//  Returns the name of the archive for the current log file.
//=========================================================================
dcl-proc getArchivePath;
  dcl-pi *n like(LOG4RPG_path_t);
    i_handle likeds(handle_t) const;
  end-pi;

//  Return value
  dcl-s archive like(LOG4RPG_path_t) inz;

//  Local fields
  dcl-s start int(10) inz;
  dcl-s dir like(LOG4RPG_path_t) inz;
  dcl-s file like(LOG4RPG_path_t) inz;
  dcl-s extension int(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dou not f_isIfsFile(archive);

   dir  = %trimR(f_rtvIfsDirFromPath(i_handle.path));
   file = %trimR(f_rtvIfsFileFromPath(i_handle.path));

   select;

      // Append date pattern to file name.
   when f_left(i_handle.dateValue: 1) = '.';
      file = file + i_handle.dateValue;

      // Insert date pattern before '.' of file name
   when f_right(i_handle.dateValue: 1) = '.';
      start = f_scanR('.': file);
      if start > 0;
         file = %replace(i_handle.dateValue: file: start: 1);
      else;
         // Append date pattern if the is no '.' in file name
         file = file + i_handle.dateValue;
      endif;

      // Append date pattern to file name
   other;
      file = file + i_handle.dateValue;
   endsl;

   if extension = 0;
      archive = dir + file;
   else;
      archive = dir + file + '(' + %char(extension) + ')';
   endif;
   extension = extension + 1;
enddo;

return archive;


end-proc;

