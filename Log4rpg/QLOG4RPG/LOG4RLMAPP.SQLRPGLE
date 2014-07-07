      /IF NOT DEFINED(PROTOTYPES_ONLY)
      *=====================================================================*
      *  SrvPgm: LOG4RLMAPP - Object: RollingMemberAppender (experimental)  *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  13.11.2010                                              *
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
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *                                                                     *
      *     >>CRTCMD<<  CRTSQLRPGI  OBJ(&LI/&OB) +                          *
      *                             SRCFILE(&SL/&SF) +                      *
      *                             SRCMBR(&SM);                            *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< OPTION(*SYS *EVENTF);                                *
      *       >>PARM<< COMMIT(*NONE);                                       *
      *       >>PARM<< RDB(*LOCAL);                                         *
      *       >>PARM<< OBJTYPE(*MODULE);                                    *
      *       >>PARM<< OUTPUT(*NONE );                                      *
      *       >>PARM<< RPGPPOPT(*LVL2);                                     *
      *       >>PARM<< DATFMT(*ISO);                                        *
      *       >>PARM<< TIMFMT(*ISO);                                        *
      *       >>PARM<< DBGVIEW(*NONE);                                      *
      *       >>PARM<< TGTRLS(V5R3M0  );                                    *
      *       >>PARM<< COMPILEOPT('DBGVIEW(*LIST)');                        *
      *     >>END-COMPILE<<                                                 *
      *                                                                     *
      *     >>EXECUTE<<                                                     *
      *                                                                     *
      *     >>CMD<<     CRTSRVPGM    SRVPGM(&LI/&OB) +                      *
      *                              MODULE(&LI/LOG4RLMAPP  +               *
      *                                     &LI/LOG4RPG97 ) +               *
      *                              EXPORT(*ALL) +                         *
      *                              ACTGRP(*CALLER) +                      *
      *                              ALWUPD(*YES) +                         *
      *                              ALWLIBUPD(*YES) +                      *
      *                              BNDSRVPGM(*LIBL/LOG4RPG   +            *
      *                                        *LIBL/BASICS1 ) +            *
      *                              TEXT('Tools/400 - Log4rpg +            *
      *                                    RollingMemberAppender        ') +*
      *                              DETAIL(*BASIC);                        *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      /COPY QLOG4RPG,COPYRIGHT
      *=====================================================================*
      /ENDIF
      *
      *  Creates a new RollingMemberAppender.
     D RollingMemberAppender_new...
     D                 PR              N   extproc('RollingMemberAppender+
     D                                     _new')
     D  i_pSuper                           const  like(LOG4RPG_pAppender_t     )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Returns TRUE if the appender requires a layout.
     D RollingMemberAppender_requiresLayout...
     D                 PR              N   extproc('RollingMemberAppender+
     D                                     _requiresLayout')
     D  i_pHandle                      *   const
      *
      *  Appends a message to the RollingMemberAppender.
     D RollingMemberAppender_doAppend...
     D                 PR              N   extproc('RollingMemberAppender+
     D                                     _doAppend')
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const like(LOG4RPG_pLogEvent_t )
      *
      *  Used to set the properties of the appender.
     D RollingMemberAppender_setProperties...
     D                 PR                  extproc('RollingMemberAppender+
     D                                     _setProperties')
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Deletes a given RollingMemberAppender.
     D RollingMemberAppender_delete...
     D                 PR              N   extproc('RollingMemberAppender+
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
     D  qFile                              likeds(qObj_t )
     D  maxNumRcds                   10I 0
     D  maxFileSize                  20I 0
     D  textLength                    5I 0
     D  ovrflwCnt...
     D                               10I 0
     D  dftOvrflwCnt...
     D                               10I 0
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG07                   PropertyList
      /COPY QLOG4RPG,PLOG4RPG10                   LogLog
      /COPY QLOG4RPG,PLOG4RPG98                   OptionConverter
      /COPY QLOG4RPG,PLOG4RPG99                   Helper
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Opens a RollingMemberAppender for output.
     D openAppender...
     D                 PR              N
     D                                     extproc('openAppender')
     D  i_pHandle                      *   const
      *
      *  Closes a RollingMemberAppender.
     D closeAppender...
     D                 PR              N
     D                                     extproc('closeAppender')
     D  i_pHandle                      *   const
      *
      *  Returns the current user or the job.
     D getCurrentUser...
     D                 PR            10A
     D                                     extproc('getCurrentUser')
      *
      *  Check for a file overflow condition.
     D isNewFileCondition...
     D                 PR              N   extproc('isNewFileCondition')
     D  io_handle                                 likeds(handle_t )
      *
      *  Check SQL error state.
     D isSQLError...
     D                 PR              N   extproc('isSQLError')
      *
      *  Returns the qualified file name.
     D qualifiedFileName...
     D                 PR            21A   varying
     D                                     extproc('qualifiedFileName')
     D  i_handle                           const  likeds(handle_t )
      *
      *  Reduces the file size by deleting records.
     D reduceFileSize...
     D                 PR                  extproc('reduceFileSize')
     D  i_handle                           const  likeds(handle_t )
      *
      *  Loads the configuration parameters from the specified property list.
     D loadConfiguration...
     D                 PR                  extproc('loadConfiguration')
     D  io_handle                                 likeds(handle_t              )
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cTHIS_CLASS...
     D                 C                          const(
     D                                            'RollingMemberAppender')
      *
     D cDEFAULT_MAX_NUM_RECORDS...
     D                 C                          -1
     D cDEFAULT_MAX_FILE_SIZE...
     D                 C                          -1
     D cDEFAULT_TEXT_LENGTH...
     D                 C                          256
     D cDEFAULT_OVERFLOW_COUNTER...
     D                 C                          10
      *
     D cPARAMETER_FILE_NAME...
     D                 C                          'file.name'
     D cPARAMETER_LIBRARY_NAME...
     D                 C                          'file.library'
     D cPARAMETER_MAX_NUM_RECORDS...
     D                 C                          'maxnumrcds'
     D cPARAMETER_MAX_FILE_SIZE...
     D                 C                          'maxfilesize'
     D cPARAMETER_TEXT_LENGTH...
     D                 C                          'textlength'
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      * -----------------------------------------
      *  Program status data structure
      * -----------------------------------------
      /DEFINE SDS_EXTENDED
      /COPY QLOG4RPG,SDS
      /UNDEFINE SDS_EXTENDED
      *
      *=====================================================================*
      *  Creates a new RollingMemberAppender.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this RollingMemberAppender.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P RollingMemberAppender_new...
     P                 B                   export
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
     D emptyMbrID      DS                  likeds(uuid_t            ) inz
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(io_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         clear tempHandle;

         // Initialize handle
         tempHandle.pSuper          = i_pSuper;   // Handle of the super class 'Appender'
         tempHandle.isOpen          = cFalse;
         tempHandle.qFile.name      = 'LOG4RPG';
         tempHandle.qFile.lib       = 'QGPL';
         tempHandle.maxNumRcds      = cDEFAULT_MAX_NUM_RECORDS;
         tempHandle.maxFileSize     = cDEFAULT_MAX_FILE_SIZE;
         tempHandle.textLength      = cDEFAULT_TEXT_LENGTH;
         tempHandle.dftOvrflwCnt    = cDEFAULT_OVERFLOW_COUNTER;

         // Initialize handle from configuration properties
         if (i_pPropList <> *NULL) and not PropertyList_isNull(i_pPropList);
            loadConfiguration(tempHandle: i_pPropList: i_prefix);
         endif;

         io_pHandle = %alloc(%size(tempHandle));
         handle = tempHandle;

         LogLog_debug('Loaded instance of [' + cTHIS_CLASS + '].');

         return isDone;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Returns TRUE if the appender requires a layout.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this RollingMemberAppender.
      *
      *  Returns:
      *   isDone        - Returns TRUE if the appender requires a layout,
      *                   else FALSE.
      *=====================================================================*
     P RollingMemberAppender_requiresLayout...
     P                 B                   export
     D                 PI              N
     D  i_pHandle                      *   const
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(io_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return cFalse;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Appends a message to the RollingMemberAppender.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this RollingMemberAppender.
      *   i_pLogEvent   - Handle of the Log event.
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P RollingMemberAppender_doAppend...
     P                 B                   export
     D                 PI              N
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const like(LOG4RPG_pLogEvent_t )
      *
      *  Helper fields
     D caller          DS                  likeds(LOG4RPG_caller_t  ) inz
      *
     D tTimestamp      S               Z
     D tLogger         S            128A   varying
     D tPriority       S             10I 0
     D tLevel          S             10A   varying
     D tLine           S             10A   varying
     D tMethod         S            128A   varying
     D tFile           S             10A   varying
     D tClass          S             10A   varying
     D tUser           S             10A   varying
     D tCurUser        S             10A   varying
     D tThread         S             28A   varying
     D tMessage        S           4096A   varying
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

         // Check for a file overflow condition.
         if isNewFileCondition(handle);
            reduceFileSize(handle);
         endif;

         // Write to file.
         caller = LogEvent_getCaller(i_pLogEvent);

         tTimestamp = LogEvent_getTime(i_pLogEvent);
         tLogger    = %trimR(LogEvent_getLoggerName(i_pLogEvent));
         tPriority  = LogEvent_getPriority(i_pLogEvent);
         tLevel     = %trimR(LogEvent_getLevel(i_pLogEvent));
         tLine      = %trim(caller.stmtID);
         tMethod    = %trimR(caller.procedure);
         tFile      = %trimR(caller.module.name);
         tClass     = %trimR(caller.pgm.name);
         tUser      = %trimR(sds.user);
         tCurUser   = %trimR(getCurrentUser());
         tThread    = %editc(sds.nbr: 'X') + '/' + %trimR(sds.user)
                                           + '/' + %trimR(sds.job );
         tMessage   = %trimR(LogEvent_getText(i_pLogEvent));

         EXEC SQL
            EXECUTE SQL_INSERT USING :tTimestamp,
                                     :tLogger,
                                     :tPriority,
                                     :tLevel,
                                     :tLine,
                                     :tMethod,
                                     :tFile,
                                     :tClass,
                                     :tUser,
                                     :tCurUser,
                                     :tThread,
                                     :tMessage;

         if (isSQLError());
            return cFalse;
         endif;

         return cTrue;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Used to set the properties of the appender.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this RollingMemberAppender.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P RollingMemberAppender_setProperties...
     P                 B                   export
     D                 PI
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  RollingMemberAppender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         loadConfiguration(handle: i_pPropList: i_prefix);

         return;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  Deletes a given RollingMemberAppender.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this RollingMemberAppender.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P RollingMemberAppender_delete...
     P                 B                   export
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
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Opens a RollingMemberAppender for output.
      *=====================================================================*
     P openAppender...
     P                 B
     D                 PI              N
     D  i_pHandle                      *   const
      *
      *  Helper fields
     D sqlCmd          S           1024A   varying inz
     D insertStmt      S           1024A   varying inz
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         // Check, whether the  file already exists
         if (not f_exist(handle.qFile.lib: *omit: '*LIB'));
            LogLog_error('Library [' + %trim(handle.qFile.lib) + '] +
                          does not exist. Failed to open appender.');
            return cFalse;
         endif;

         if (not f_exist(handle.qFile.name: handle.qFile.lib: '*FILE'));
            // Create file
            sqlCmd =
               'CREATE TABLE ' + qualifiedFileName(handle) + ' ( +
                   "TIMESTAMP" TIMESTAMP        NOT NULL WITH DEFAULT,         +
                   LOGGER      CHARACTER (128)  NOT NULL WITH DEFAULT,         +
                   "SEQUENCE"  INTEGER          GENERATED ALWAYS AS IDENTITY,  +
                   PRIORITY    INTEGER          NOT NULL WITH DEFAULT,         +
                   LEVEL       CHARACTER (10)   NOT NULL WITH DEFAULT,         +
                   LINE        CHARACTER (10)   NOT NULL WITH DEFAULT,         +
                   METHOD      CHARACTER (128)  NOT NULL WITH DEFAULT,         +
                   "FILE"      CHARACTER (10)   NOT NULL WITH DEFAULT,         +
                   CLASS       CHARACTER (10)   NOT NULL WITH DEFAULT,         +
                   "USER"      CHARACTER (10)   NOT NULL WITH DEFAULT,         +
                   CUR_USER    CHARACTER (10)   NOT NULL WITH DEFAULT,         +
                   THREAD      CHARACTER (28)   NOT NULL WITH DEFAULT,         +
                   MESSAGE     VARCHAR   (2048) ALLOCATE (%TEXT_LENGTH%)       +
                                                NOT NULL WITH DEFAULT,         +
                   CONSTRAINT %LIB%/%FILE%_PRIKEY PRIMARY KEY (SEQUENCE))';

            sqlCmd = f_replace(
                           '%TEXT_LENGTH%': %char(handle.textLength): sqlCmd);
            EXEC SQL
               EXECUTE IMMEDIATE :sqlCmd;

            if (isSQLError());
               LogLog_error('Failed to create log file [' +
                             qualifiedFileName(handle) + '].');
               return cFalse;
            endif;
         endif;

         p_rmvPgmMsg(cMsg_Rmv_All: *omit: cMsg_Same: cMsg_ToMyself);

         // Open file
         insertStmt =
            'INSERT INTO ' + qualifiedFileName(handle) + ' (+
               "TIMESTAMP", +
               LOGGER, +
               PRIORITY, +
               LEVEL, +
               LINE, +
               METHOD, +
               "FILE", +
               CLASS, +
               "USER", +
               CUR_USER, +
               THREAD, +
               MESSAGE) +
             VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)';

         EXEC SQL
            PREPARE SQL_INSERT FROM :insertStmt;

         if (isSQLError());
            LogLog_error('Failed to prepare INSERT statement for log file +
                          [' + qualifiedFileName(handle) + '].');
            return cFalse;
         endif;

         // Mark file as "open"
         handle.isOpen = cTrue;

         return cTrue;

      /END-FREE
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Closes a RollingMemberAppender.
      *=====================================================================*
     P closeAppender...
     P                 B
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

         handle.isOpen = cFalse;

         return isDone;

      /END-FREE
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Returns the current user or the job.
      *=========================================================================
     P getCurrentUser...
     P                 B
     D                 PI            10A
      *
      *  Local fields
     D qJob            DS                  qualified
     D  name                         10A   inz
     D  user                         10A   inz
     D  nbr                           6A   inz
     D errCode         DS                  likeds(errCode_t   ) inz
     D jobi0600        DS                  likeds(jobi0600_t  ) inz
      *
      *  Retrieve Job Information (QUSRJOBI) API
     D QUSRJOBI        PR                  extpgm('QUSRJOBI')
     D  o_rcvVar                  32767A          options(*varsize)
     D  i_lenRcvVar                  10I 0 const
     D  i_format                      8A   const
     D  i_qJob                       26A   const
     D  i_intJobID                   16A   const
     D  io_errCode                                like(errCode_t )
      *
     D jobi0600_t      DS                  qualified           based(pDummy)
     D  bytRet                       10I 0
     D  bytAvl                       10I 0
     D  curUser               92    101A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         qjob.name = '*';
         qjob.user = '';
         qjob.nbr  = '';
         errCode = f_newApiErrCode(cTrue);
         QUSRJOBI(jobi0600: %size(jobi0600): 'JOBI0600': qJob: '': errCode);
         if (f_isApiError(errCode));
            clear jobi0600;
         endif;

         return jobi0600.curUser;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  *** private ***
      *  Check for a file overflow condition.
      *=====================================================================*
     P isNewFileCondition...
     P                 B
     D                 PI              N
     D  io_handle                                 likeds(handle_t )
      *
      *  Return value
     D isNewFile       S               N   inz(cFalse)
      *
      *  Helper fields
     D currentFileSize...
     D                 S             20U 0 inz
     D errCode         DS                  likeds(errCode_t   ) inz
      *
      *  Retrieve Member Description (QUSRMBRD) API
     D QUSRMBRD...
     D                 PR                         extpgm('QUSRMBRD')
     D  o_rcvVar                  65535A          options(*varsize)
     D  i_lenRcvVar                  10I 0 const
     D  i_format                      8A   const
     D  i_qFile                      20A   const
     D  i_mbr                        10A   const
     D  i_ovrPrc                      1A   const
     D  io_errCode                65535A          options(*nopass: *varsize)    | OptGrp 1
     D  i_findMbrPrc                  1A   const  options(*nopass)              | OptGrp 2
      *
      *  MBRD0200 Format
     D mbrd0200...
     D                 DS                  qualified
     D  bytRet                       10I 0
     D  bytAvl                       10I 0
     D  qFile                              likeds(qObj_t )
     D  mbr                          10A
     D  attr                         10A
     D  srcType                      10A
     D  crtDatTim                    13A
     D  srcChgDatTim                 13A
     D  text                         50A
     D  isSrcFile                      N
     D  isRemoteFile                   N
     D  isLogicalFile                  N
     D  isODPShareAlw                  N
     D  reserved_1                    2A
     D  numTotRcds                   10I 0
     D  numDltRcds                   10I 0
     D  dtaSpcSize                   10I 0
     D  accPathSize                  10I 0
     D  numBasedMbr                  10I 0
     D  chgDatTim                    13A
     D  savDatTim                    13A
     D  rstDatTim                    13A
     D  expDate                       7A
     D  reserved_2                    6A
     D  numDaysUsed                  10I 0
     D  dateLastUsed                  7A
     D  useResetDate                  7A
     D  reserved_3                    2A
     D  dtaSpcSizeMlt                10I 0
     D  accPathSizeMlt...
     D                               10I 0
     D  textCcsid                    10I 0
     D  ofsAddInf                    10I 0
     D  lenAddInf                    10I 0
     D  numTotRcdsU                  10U 0
     D  numDltRcdsU                  10U 0
     D  reserved_4                    6A
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (io_handle.ovrflwCnt > 0);
            io_handle.ovrflwCnt = io_handle.ovrflwCnt - 1;
            return cFalse;
         else;
            io_handle.ovrflwCnt = io_handle.dftOvrflwCnt;
         endif;

         errCode = f_newApiErrCode(cTrue);
         QUSRMBRD(mbrd0200: %size(mbrd0200): 'MBRD0200'
                  : io_handle.qFile: '*FIRST': '0'
                  : errCode);
         if (f_isApiError(errCode));
            return cFalse;
         endif;

         if (io_handle.maxNumRcds > 0 and
             mbrd0200.numTotRcds >= io_handle.maxNumRcds);
            return cTrue;
         endif;

         if (io_handle.maxFileSize > 0);
            currentFileSize = mbrd0200.dtaSpcSize * mbrd0200.dtaSpcSizeMlt;
            if (currentFileSize >= io_handle.maxFileSize);
               return cTrue;
            endif;
         endif;

         return cFalse;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  *** private ***
      *  Check for a file overflow condition.
      *=====================================================================*
     P reduceFileSize...
     P                 B
     D                 PI
     D  i_handle                           const  likeds(handle_t )
      *
      *  Helper fields
     D count           S                   like(i_handle.ovrflwCnt ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         count = %abs(i_handle.dftOvrflwCnt * 1.1);
         if (count = i_handle.dftOvrflwCnt);
            count = count + 2;
         endif;

         // TODO: delete rows
         // delete from raddatz.log4_log
         //    where sequence in
         //    (select sequence from raddatz.log4_log
         //     order by sequence fetch first 3 rows only)

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  *** private ***
      *  Check SQL error state.
      *=====================================================================*
     P isSQLError...
     P                 B
     D                 PI              N
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         if (%subst(sqlca.sqlstate: 1: 2) = '00' or    // OK
             %subst(sqlca.sqlstate: 1: 2) = '01');     // Warning
            return cFalse;
         endif;

         return cTrue;

      /END-FREE
     P                 E
      *
      *=====================================================================*
      *  *** private ***
      *  Returns the qualified file name.
      *=====================================================================*
     P qualifiedFileName...
     P                 B
     D                 PI            21A   varying
     D  i_handle                           const  likeds(handle_t )
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE

         return %trim(i_handle.qFile.lib) + '/' + %trim(i_handle.qFile.name);

      /END-FREE
     P                 E
      *
      *=========================================================================
      *  *** Private ***
      *  Loads the configuration parameters from the specified property list.
      *=========================================================================
     P loadConfiguration...
     P                 B
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
               when parameter = cPARAMETER_FILE_NAME;
                  io_handle.qFile.name = property.value;
               when parameter = cPARAMETER_LIBRARY_NAME;
                  io_handle.qFile.lib  = property.value;
               when parameter = cPARAMETER_MAX_NUM_RECORDS;
                  io_handle.maxNumRcds =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_MAX_NUM_RECORDS);
               when parameter = cPARAMETER_MAX_FILE_SIZE;
                  io_handle.maxFileSize =
                     OptionConverter_toFileSize(
                        property.value: cDEFAULT_MAX_FILE_SIZE);
               when parameter = cPARAMETER_TEXT_LENGTH;
                  io_handle.textLength =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_TEXT_LENGTH);
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
     P                 E
      *
