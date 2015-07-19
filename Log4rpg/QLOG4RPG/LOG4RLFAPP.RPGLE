      /IF NOT DEFINED(PROTOTYPES_ONLY)
      *=====================================================================*
      *  SrvPgm: LOG4RLFAPP - Object: RollingFileAppender                   *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  21.04.2008                                              *
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
      *  31.08.2008  Th.Raddatz    Now correctly passing a file name to     *
      *                            f_renameIfsFile().                       *
      *                                                                     *
      *  09.09.2008  Th.Raddatz    Improved performance when calling        *
      *                            f_writeLineIfsFile().                    *
      *                                                                     *
      *  07.11.2008  Th.Raddatz    Fixed synchronisation problems, when     *
      *                            sharing the log file with other jobs.    *
      *                            Added properties:  syncObj               *
      *                                               syncLogMode           *
      *                                               syncText              *
      *                                                                     *
      *  20.11.2010  Th.Raddatz    Added parameter 'ccsid' to enable the    *
      *                            user to specify the ccsid of the log     *
      *                            file.                                    *
      *                                                                     *
      *  10.05.2015  Th.Raddatz    Changed *_doAppend() to better handle    *
      *                            unexpected errors when renaming the      *
      *                            log file.                                *
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
      *     >>CMD<<     CRTSRVPGM    SRVPGM(&LI/&OB) +                      *
      *                              MODULE(&LI/LOG4RLFAPP  +               *
      *                                     &LI/LOG4RPG97 ) +               *
      *                              EXPORT(*ALL) +                         *
      *                              ACTGRP(*CALLER) +                      *
      *                              ALWUPD(*YES) +                         *
      *                              ALWLIBUPD(*YES) +                      *
      *                              BNDDIR(QC2LE) +                        *
      *                              BNDSRVPGM(*LIBL/LOG4RPG   +            *
      *                                        *LIBL/BASICS1   +            *
      *                                        *LIBL/IFS     ) +            *
      *                              TEXT('Tools/400 - Log4rpg +            *
      *                                    RollingFileAppender          ') +*
      *                              DETAIL(*BASIC);                        *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      /COPY QLOG4RPG,COPYRIGHT
      *=====================================================================*
      /ENDIF
      *
      *  Creates a new RollingFileAppender.
     D RollingFileAppender_new...
     D                 PR              N   extproc('RollingFileAppender+
     D                                     _new')
     D  i_pSuper                           const  like(LOG4RPG_pAppender_t     )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Returns TRUE if the appender requires a layout.
     D RollingFileAppender_requiresLayout...
     D                 PR              N   extproc('RollingFileAppender+
     D                                     _requiresLayout')
     D  i_pHandle                      *   const
      *
      *  Appends a message to the RollingFileAppender.
     D RollingFileAppender_doAppend...
     D                 PR              N   extproc('RollingFileAppender+
     D                                     _doAppend')
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const like(LOG4RPG_pLogEvent_t )
      *
      *  Used to set the properties of the appender.
     D RollingFileAppender_setProperties...
     D                 PR                  extproc('RollingFileAppender+
     D                                     _setProperties')
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Deletes a given RollingFileAppender.
     D RollingFileAppender_delete...
     D                 PR              N   extproc('RollingFileAppender+
     D                                     _delete')
     D  io_pHandle                     *
      *
      /IF DEFINED(PROTOTYPES_ONLY)
      /EOF
      /ENDIF
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG                     Public interface & type definitions
      *
     D handle_t...
     D                 DS                  qualified           based(pDummy)
     D  pSuper                             like(LOG4RPG_pAppender_t)
     D  isOpen                         N
     D  hFile                              like(ifs_hFile_t     )
     D  path                               like(LOG4RPG_path_t  )
     D  maxFileSize                  20I 0
     D  maxBackupIndex...
     D                               10I 0
     D  writeHeader                    N
     D  writeFooter                    N
     D  share                          N
     D  fileID                             likeds(ifs_fileID_t  )
     D  qSyncObj                           likeds(qObj_t )
     D  isSyncLogMode                  N
     D  syncText                     50A   varying
     D  ccsid                        10U 0
     D  lastRnmErr                     Z
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QIFS,PIFS                             IFS Stream File Support
      *
      /COPY QLOG4RPG,PLOG4RPG07                   PropertyList
      /COPY QLOG4RPG,PLOG4RPG10                   LogLog
      /COPY QLOG4RPG,PLOG4RPG97                   Synchronisation
      /COPY QLOG4RPG,PLOG4RPG98                   OptionConverter
      /COPY QLOG4RPG,PLOG4RPG99                   Helper
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Opens a RollingFileAppender for output.
     D openAppender...
     D                 PR              N
     D  i_pHandle                      *   const
      *
      *  Closes a RollingFileAppender.
     D closeAppender...
     D                 PR              N
     D  i_pHandle                      *   const
      *
      *  Appends the header.
     D appendHeader...
     D                 PR
     D  i_pHandle                      *   const
      *
      *  Appends the footer.
     D appendFooter...
     D                 PR
     D  i_pHandle                      *   const
      *
      *  Writes text.
     D append...
     D                 PR
     D  i_pHandle                      *   const
     D  i_text                             const  like(LOG4RPG_formattedText_t )
      *
      *  Check if a new file must be started.
     D isNewFileCondition...
     D                 PR              N
     D  i_handle                           const  likeds(handle_t )
      *
      *  Returns cTrue if there is a rename error. Resets the error after
      *  a reasonable amount of time.
     D checkAndHandleRenameError...
     D                 PR              N
     D  i_pHandle                      *   const
      *
      *  Sets the date and time of an error during renaming the output file.
     D setRenameError...
     D                 PR
     D  i_pHandle                      *   const
      *
      *  Clears the date and time of an error during renaming the output file.
     D clearRenameError...
     D                 PR
     D  i_pHandle                      *   const
      *
      *  Loads the configuration parameters from the specified property list.
     D loadConfiguration...
     D                 PR
     D  io_handle                                 likeds(handle_t              )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Renames exiting log files.
     D renameFiles...
     D                 PR              N
     D  i_handle                           const  likeds(handle_t        )
     D  o_msg                                     likeds(msg_t           )
      *
      *  Produces a backup file name.
     D getBackupFileName...
     D                 PR                         like(LOG4RPG_path_t  )
     D  i_path                             const  like(LOG4RPG_path_t  )
     D  i_index                      10I 0 const
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cTHIS_CLASS...
     D                 C                          const(
     D                                            'RollingFileAppender')
      *
     D cDEFAULT_MAX_FILE_SIZE...
     D                 C                          const(10485760)
     D cDEFAULT_MAX_BACKUP_INDEX...
     D                 C                          const(1)
     D cDEFAULT_WRITE_HEADER...
     D                 C                          const('1')
     D cDEFAULT_WRITE_FOOTER...
     D                 C                          const('1')
     D cDEFAULT_SHARE...
     D                 C                          const('0')
     D cDEFAULT_SYNC_OBJ_NAME...
     D                 C                          const('LOG4RLFAPP')
     D cDEFAULT_SYNC_OBJ_LIB...
     D                 C                          const('QGPL')
     D cDEFAULT_SYNC_LOG_MODE...
     D                 C                          const('0')
     D cDEFAULT_SYNC_TEXT...
     D                 C                          const('Log4rpg +
     D                                            RollingFileAppender +
     D                                            Sync. Object')
     D cDEFAULT_CCSID...
     D                 C                          const(850)
      *
     D cPARAMETER_PATH...
     D                 C                          const('path')
     D cPARAMETER_MAX_FILE_SIZE...
     D                 C                          const('maxfilesize')
     D cPARAMETER_MAX_BACKUP_INDEX...
     D                 C                          const('maxbackupindex')
     D cPARAMETER_WRITE_HEADER...
     D                 C                          const('writeheader')
     D cPARAMETER_WRITE_FOOTER...
     D                 C                          const('writefooter')
     D cPARAMETER_SHARE...
     D                 C                          const('share')
     D cPARAMETER_SYNC_OBJ...
     D                 C                          const('syncobj')
     D cPARAMETER_SYNC_LOG_MODE...
     D                 C                          const('synclogmode')
     D cPARAMETER_SYNC_TEXT...
     D                 C                          const('synctext')
     D cPARAMETER_CCSID...
     D                 C                          const('ccsid')
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
      *  Creates a new RollingFileAppender.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this RollingFileAppender.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P RollingFileAppender_new...
     P                 B                   export
      *
     D RollingFileAppender_new...
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
     D emptyFileID     DS                  likeds(ifs_fileID_t      ) inz
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(io_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear tempHandle;
 
         // Initialize handle
         tempHandle.pSuper          = i_pSuper;   // Handle of the super class 'Appender'
         tempHandle.isOpen          = cFalse;
         tempHandle.hFile           = 0;
         tempHandle.path            = 'log4rpg.log';
         tempHandle.maxFileSize     = cDEFAULT_MAX_FILE_SIZE;
         tempHandle.maxBackupIndex  = cDEFAULT_MAX_BACKUP_INDEX;
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
 
      /END-FREE
      *
     P RollingFileAppender_new...
     P                 E
      *
      *=====================================================================*
      *  Returns TRUE if the appender requires a layout.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this RollingFileAppender.
      *
      *  Returns:
      *   isDone        - Returns TRUE if the appender requires a layout,
      *                   else FALSE.
      *=====================================================================*
     P RollingFileAppender_requiresLayout...
     P                 B                   export
      *
     D RollingFileAppender_requiresLayout...
     D                 PI              N
     D  i_pHandle                      *   const
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(io_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return cTrue;
 
      /END-FREE
      *
     P RollingFileAppender_requiresLayout...
     P                 E
      *
      *=====================================================================*
      *  Appends a message to the RollingFileAppender.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this RollingFileAppender.
      *   i_pLogEvent   - Handle of the Log event.
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P RollingFileAppender_doAppend...
     P                 B                   export
      *
     D RollingFileAppender_doAppend...
     D                 PI              N
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const like(LOG4RPG_pLogEvent_t )
      *
      *  Return value
     D isDone          S               N   inz(cFalse)
      *
      *  Helper fields
     D archive         S                   like(LOG4RPG_path_t)           inz
     D bufLength       S             10I 0                                inz
     D lineLength      S             10I 0                                inz
     D text            S                   like(LOG4RPG_formattedText_t ) inz
     D isText          S               N                                  inz
     D isNewFile       S               N                                  inz
     D isRenameError   S               N                                  inz
     D ticket          DS                  likeds(LOG4RPG_syncTicket_t  ) inz
     D msg             DS                  likeds(msg_t       )           inz
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
            if not openAppender(i_pHandle);
               return cFalse;
            endif;
         endif;
 
         // Check if a new file must be started.
         if (not checkAndHandleRenameError(i_pHandle) and
             isNewFileCondition(handle));
 
            dou '1';
 
               isRenameError = cFalse;
 
               // Start synchronisation with concurrent jobs
               if (handle.share);
                  if (not Synchronisation_start(handle.qSyncObj.name
                                                : handle.qSyncObj.lib
                                                : ticket: msg));
                     LogLog_errorMsg(msg);
                     isRenameError = cTrue;
                     leave;
                  endif;
               endif;
 
               // Determine, whether this job has to create a new file or not.
               // If a new file has been created by anther job, this job only
               // has to switch to the new file.
               if (not handle.share or
                   f_getIfsFileID(handle.path) = handle.fileID);
                  isNewFile = cTrue;
               else;
                  isNewFile = cFalse;
               endif;
 
               if handle.isOpen;
                  if (isNewFile);
                     appendFooter(i_pHandle);
                  endif;
                  closeAppender(i_pHandle);
               endif;
 
               if (isNewFile);
                  if (not renameFiles(handle: msg));
                     LogLog_errorMsg(msg);
                     isRenameError = cTrue;
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
               return cFalse;
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
               isDone = cFalse;
            else;
               isDone = cTrue;
            endif;
            text = LogEvent_getNextLineOfText(i_pLogEvent: isText: lineLength);
         enddo;
 
         return isDone;
 
      /END-FREE
      *
     P RollingFileAppender_doAppend...
     P                 E
      *
      *=====================================================================*
      *  Used to set the properties of the appender.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this RollingFileAppender.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P RollingFileAppender_setProperties...
     P                 B                   export
      *
     D RollingFileAppender_setProperties...
     D                 PI
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  RollingFileAppender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         loadConfiguration(handle: i_pPropList: i_prefix);
 
         return;
 
      /END-FREE
      *
     P RollingFileAppender_setProperties...
     P                 E
      *
      *=====================================================================*
      *  Deletes a given RollingFileAppender.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this RollingFileAppender.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P RollingFileAppender_delete...
     P                 B                   export
      *
     D RollingFileAppender_delete...
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
     P RollingFileAppender_delete...
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Opens a RollingFileAppender for output.
      *=====================================================================*
     P openAppender...
     P                 B
      *
     D openAppender...
     D                 PI              N
     D  i_pHandle                      *   const
      *
      *  Helper fields
     D isNewFile       S               N   inz(cFalse)
     D SHARE_MODE      S             10I 0 inz
     D msg             DS                  likeds(msg_t          ) inz
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
                                                           + SHARE_MODE
                                                           + O_WRONLY
                                                           + O_CCSID
                                                 : handle.ccsid
                                                 : *omit: msg);
         if handle.hFile = cIFS_ERROR;
            LogLog_errorMsg(msg);
            return cFalse;
         endif;
 
         // Mark file as "open"
         handle.isOpen = cTrue;
 
         // Remember the unique file ID
         handle.fileID = f_getIfsFileIDH(handle.hFile);
 
         // Write header to file
         if isNewFile;
            appendHeader(i_pHandle);
         endif;
 
         return cTrue;
 
      /END-FREE
      *
     P openAppender...
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Closes a RollingFileAppender.
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
 
         if f_closeIfsFile(handle.hFile) = 0;
            handle.isOpen = cFalse;
            handle.hFile  = 0;
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
    R *  *** Private ***
      *  Appends the header.
      *=====================================================================*
     P appendHeader...
     P                 B
      *
     D appendHeader...
     D                 PI
     D  i_pHandle                      *   const
      *
      *  Helper fields
     D header          S                   like(LOG4RPG_header_t ) inz
     D pLayout         S                   like(LOG4RPG_pLayout_t) inz
     D msg             DS                  likeds(msg_t          ) inz
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P appendHeader...
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Appends the footer.
      *=====================================================================*
     P appendFooter...
     P                 B
      *
     D appendFooter...
     D                 PI
     D  i_pHandle                      *   const
      *
      *  Helper fields
     D footer          S                   like(LOG4RPG_footer_t ) inz
     D pLayout         S                   like(LOG4RPG_pLayout_t) inz
     D msg             DS                  likeds(msg_t          ) inz
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P appendFooter...
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Writes text.
      *=====================================================================*
     P append...
     P                 B
      *
     D append...
     D                 PI
     D  i_pHandle                      *   const
     D  i_text                             const  like(LOG4RPG_formattedText_t )
      *
      *  Helper fields
     D text            S                   like(i_text           ) inz
     D bufLength       S             10I 0                         inz
     D startPos        S             10U 0                         inz
     D pLayout         S                   like(LOG4RPG_pLayout_t) inz
     D msg             DS                  likeds(msg_t          ) inz
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P append...
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
     D rc              S             10I 0 inz
     D st_stat         DS                  likeds(st_stat_t ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         rc = fstat(i_handle.hFile: st_stat);
 
         if (st_stat.size >= i_handle.maxFileSize);
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
      *=====================================================================*
    R *  *** Private ***
      *  Returns cTrue if there is a rename error. Resets the error after
      *  a reasonable amount of time.
      *=====================================================================*
     P checkAndHandleRenameError...
     P                 B
     D                 PI              N
     D  i_pHandle                      *   const
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (handle.lastRnmErr = *LOVAL);
            return cFalse;
         endif;
 
         if (%diff(%timestamp(): handle.lastRnmErr: *DAYS) > 1 or
             %diff(%timestamp(): handle.lastRnmErr: *SECONDS) > 600);
            // try again
            clearRenameError(i_pHandle);
            return cFalse;
         endif;
 
         return cTrue;
 
      /END-FREE
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Sets the date and time of an error during renaming the output file.
      *=====================================================================*
     P setRenameError...
     P                 B
     D                 PI
     D  i_pHandle                      *   const
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if (handle.lastRnmErr = *LOVAL);
            handle.lastRnmErr = %timestamp();
         endif;
 
      /END-FREE
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Clears the date and time of an error during renaming the output file.
      *=====================================================================*
     P clearRenameError...
     P                 B
     D                 PI
     D  i_pHandle                      *   const
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         handle.lastRnmErr = *LOVAL;
 
      /END-FREE
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
                                 %len(property.key) > %len(prefix));
 
               parameter = f_lcase(%subst(property.key: %len(prefix) + 1));
 
               select;
               when parameter = cPARAMETER_PATH;
                  io_handle.path = property.value;
               when parameter = cPARAMETER_MAX_FILE_SIZE;
                  io_handle.maxFileSize =
                     OptionConverter_toFileSize(
                        property.value: cDEFAULT_MAX_FILE_SIZE);
               when parameter = cPARAMETER_MAX_BACKUP_INDEX;
                  io_handle.maxBackupIndex =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_MAX_BACKUP_INDEX);
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
 
      /END-FREE
      *
     P loadConfiguration...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Renames exiting log files.
      *=========================================================================
     P renameFiles...
     P                 B
      *
     D renameFiles...
     D                 PI              N
     D  i_handle                           const  likeds(handle_t        )
     D  o_msg                                     likeds(msg_t           )
      *
      *  Helper fields
     D rc              S             10I 0 inz(0)
     D x               S             10I 0 inz
     D tmpPath         S                   like(LOG4RPG_path_t  ) inz
     D target          S                   like(LOG4RPG_path_t  ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         o_msg = f_newMsg(cMsg_ID_OK);
 
         // If maxBackups <= 0, then there is no file renaming to be done.
         if (i_handle.maxBackupIndex <= 0);
            // Instead delete/truncate current log file.
            if (f_deleteIfsFile(i_handle.path: o_msg) <> 0);
               return cFalse;
            else;
               return cTrue;
            endif;
         endif;
 
         // Delete the oldest file
         tmpPath = getBackupFileName(i_handle.path: i_handle.maxBackupIndex);
         if (f_isIfsFile(tmpPath: *omit));
            rc = f_deleteIfsFile(tmpPath: o_msg);
         endif;
 
         // Rename remaining files
         x = i_handle.maxBackupIndex - 1;
         dow (x > 0 and rc <> cIFS_ERROR);
            tmpPath = getBackupFileName(i_handle.path: x);
            if (f_isIfsFile(tmpPath: *omit));
               target =
                  f_rtvIfsFileFromPath(getBackupFileName(i_handle.path: x + 1));
               rc = f_renameIfsFile(tmpPath: target: o_msg);
            endif;
            x = x - 1;
         enddo;
 
         // Rename current log file
         if (rc <> cIFS_ERROR);
            target = f_rtvIfsFileFromPath(getBackupFileName(i_handle.path: 1));
            rc = f_renameIfsFile(i_handle.path: target: o_msg);
            if (rc <> 0);
               return cFalse;
            endif;
         endif;
 
         return cTrue;
 
      /END-FREE
      *
     P renameFiles...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Produces a backup file name.
      *=========================================================================
     P getBackupFileName...
     P                 B
      *
     D getBackupFileName...
     D                 PI                         like(LOG4RPG_path_t  )
     D  i_path                             const  like(LOG4RPG_path_t  )
     D  i_index                      10I 0 const
      *
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return i_path + '.' + %char(i_index);
 
      /END-FREE
      *
     P getBackupFileName...
     P                 E
      *
