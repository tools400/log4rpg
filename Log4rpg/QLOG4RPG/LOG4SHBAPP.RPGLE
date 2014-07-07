      /IF NOT DEFINED(PROTOTYPES_ONLY)
      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: XMLSocketHubAppender                     *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  17.10.2006                                              *
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
      *                              MODULE(&LI/&OB) +                      *
      *                              EXPORT(*ALL) +                         *
      *                              ACTGRP(*CALLER) +                      *
      *                              ALWUPD(*YES) +                         *
      *                              ALWLIBUPD(*YES) +                      *
      *                              BNDDIR(QC2LE) +                        *
      *                              BNDSRVPGM(*LIBL/LOG4RPG   +            *
      *                                        *LIBL/BASICS1 ) +            *
      *                              TEXT('Tools/400 - Log4rpg +            *
      *                                    XMLSocketHubAppender       ') +  *
      *                              DETAIL(*BASIC);                        *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      /COPY QLOG4RPG,COPYRIGHT
      *=====================================================================*
      /ENDIF
      *
      *  Creates a new XMLSocketHubAppender.
     D XMLSocketHubAppender_new...
     D                 PR              N   extproc('XMLSocketHubAppender+
     D                                     _new')
     D  i_pSuper                           const  like(LOG4RPG_pAppender_t     )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Returns TRUE if the appender requires a layout.
     D XMLSocketHubAppender_requiresLayout...
     D                 PR              N   extproc('XMLSocketHubAppender+
     D                                     _requiresLayout')
     D  i_pHandle                      *   const
      *
      *  Appends a message to the XMLSocketHubAppender.
     D XMLSocketHubAppender_doAppend...
     D                 PR              N   extproc('XMLSocketHubAppender+
     D                                     _doAppend')
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const like(LOG4RPG_pLogEvent_t )
      *
      *  Used to set the properties of the appender.
     D XMLSocketHubAppender_setProperties...
     D                 PR                  extproc('XMLSocketHubAppender+
     D                                     _setProperties')
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Deletes a given XMLSocketHubAppender.
     D XMLSocketHubAppender_delete...
     D                 PR              N   extproc('XMLSocketHubAppender+
     D                                     _delete')
     D  io_pHandle                     *
      *
      /IF DEFINED(PROTOTYPES_ONLY)
      /EOF
      /ENDIF
      *
      * -----------------------------------------
      *  Exported functions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG52
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4RPG                     Public interface & type definitions
      /COPY QLOG4RPG,FDQJOB
      *
     D handle_t...
     D                 DS                  qualified           based(pDummy)
     D  pSuper                             like(LOG4RPG_pAppender_t)
     D  isOpen                         N
     D  port                               like(port_t   )
     D  pipeWrite                          like(desc_t   )
     D  ccsid                        10I 0
     D  isIconv                        N
     D  hIconv                             likeds(iconv_t )
     D  childProcess                       likeds(qJob_t  )
      *
     D port_t          S             10U 0                     based(pDummy)
     D desc_t          S             10I 0                     based(pDummy)
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CLIB                         C-Library
      *
      /COPY QLOG4RPG,PLOG4RPG07                   PropertyList
      /COPY QLOG4RPG,PLOG4RPG10                   LogLog
      /COPY QLOG4RPG,PLOG4RPG98                   OptionConverter
      /COPY QLOG4RPG,PLOG4RPG99                   Helper
      *
      /COPY QLOG4RPG,PLOG4SOCK                    Socket prototypes
      *
      * -----------------------------------------------------------------------
      *  spawn()--Spawn Process
      *    value  spawn() was successful.
      *           The value returned is the process ID of the child process.
      *    -1     spawn() was not successful.
      *           The errno variable is set to indicate the error.
      * -----------------------------------------------------------------------
     D spawn...
     D                 PR            10I 0 extproc('Qp0zSpawn')
     D  i_path                         *   value  options(*string)
     D  i_fd_count                   10I 0 value
     D  i_fd_map                       *   value
     D  i_inheritance                      const  likeds(inheritance_t)
     D  i_argv                         *   value
     D  i_envp                         *   value
      *
     D inheritance_t...
     D                 DS                  qualified               based(pDummy)
     D  flags                        10U 0
     D  pGroup                       10I 0
     D  sigMask                            likeds(sigmask_t)
     D  sigDefault                         likeds(sigmask_t)
      *
     D sigmask_t...
     D                 DS                  qualified               based(pDummy)
     D  lomask                       10U 0
     D  himask                       10U 0
      *
      * -----------------------------------------------------------------------
      *  pipe()--Create an Interprocess Channel
      *     0     pipe() was successful.
      *    -1     pipe() was not successful. The errno variable is set to indicate the error
      * -----------------------------------------------------------------------
     D pipe...
     D                 PR            10I 0 extproc('pipe')
     D  o_fildes                     10I 0        dim(2)
      *
     D cPIPE_READ      C                   const(1)
     D cPIPE_WRITE     C                   const(2)
      *
      * -----------------------------------------------------------------------
      *  Qp0wGetJobID()--Get Qualified Job Name and ID for Process ID
      *     0     Qp0wGetJobID() was successful.
      *    value  Qp0wGetJobID() was not successful.
      *           The value returned indicates one of the following errors.
      * -----------------------------------------------------------------------
     D Qp0wGetJobID...
     D                 PR            10I 0 extproc('Qp0wGetJobID')
     D  i_pid                        10I 0 value
     D  o_jobInfo                                 likeds(QP0W_Job_ID_t)
      *
     D QP0W_Job_ID_t...
     D                 DS                  qualified               based(pDummy)
     D  name                         10A
     D  user                         10A
     D  nbr                           6A
     D  ID                           16A
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Opens a XMLSocketHubAppender for output.
     D openAppender...
     D                 PR              N
     D  i_pHandle                      *   const
      *
      *  Closes a XMLSocketHubAppender.
     D closeAppender...
     D                 PR              N
     D  i_pHandle                      *   const
      *
      *  Initializes charcater translation.
     D initIconv...
     D                 PR              N
     D  io_handle                                 likeds(handle_t )
      *
      *  Create child process.
     D createChildProcess...
     D                 PR              N
     D  io_handle                                 likeds(handle_t )
      *
      *  Ends child process.
     D endChildProcess...
     D                 PR              N
     D  io_handle                                 likeds(handle_t )
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
     D                                            'XMLSocketHubAppender')
      *
     D cDEFAULT_PORT...
     D                 C                          const(4449)
     D cDEFAULT_CCSID...
     D                 C                          const(819)
      *
     D cPARAMETER_PORT...
     D                 C                          const('port')
     D cPARAMETER_CCSID...
     D                 C                          const('ccsid')
      *
     D cDESC_NULL...
     D                 C                          const(-1)
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
      *  Creates a new XMLSocketHubAppender.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this XMLSocketHubAppender.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P XMLSocketHubAppender_new...
     P                 B                   export
      *
     D XMLSocketHubAppender_new...
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
     D tmpHIconv       DS                  likeds(iconv_t  ) inz
     D tmpHandle       DS                  likeds(handle_t ) inz
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(io_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear tmpHandle;
         clear tmpHIconv;
 
         // Initialize handle
         tmpHandle.pSuper          = i_pSuper;   // Handle of the super class 'Appender'
         tmpHandle.isOpen          = cFalse;
         tmpHandle.port            = cDEFAULT_PORT;
         tmpHandle.pipeWrite       = cDESC_NULL;
         tmpHandle.ccsid           = cDEFAULT_CCSID;
         tmpHandle.isIconv         = cFalse;
         tmpHandle.hIconv          = tmpHIconv;
         tmpHandle.childProcess.nbr  = '';
         tmpHandle.childProcess.user = '';
         tmpHandle.childProcess.name = '';
 
         // Initialize handle from configuration properties
         if (i_pPropList <> *NULL) and not PropertyList_isNull(i_pPropList);
            loadConfiguration(tmpHandle: i_pPropList: i_prefix);
         endif;
 
         // Initialize Character Conversion
         initIconv(tmpHandle);
 
         // Create appender handle
         io_pHandle = %alloc(%size(tmpHandle));
         handle = tmpHandle;
 
         LogLog_debug('Loaded instance of [' + cTHIS_CLASS + '].');
 
         return isDone;
 
      /END-FREE
      *
     P XMLSocketHubAppender_new...
     P                 E
      *
      *=====================================================================*
      *  Returns TRUE if the appender requires a layout.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this XMLSocketHubAppender.
      *
      *  Returns:
      *   isDone        - Returns TRUE if the appender requires a layout,
      *                   else FALSE.
      *=====================================================================*
     P XMLSocketHubAppender_requiresLayout...
     P                 B                   export
      *
     D XMLSocketHubAppender_requiresLayout...
     D                 PI              N
     D  i_pHandle                      *   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return cTrue;
 
      /END-FREE
      *
     P XMLSocketHubAppender_requiresLayout...
     P                 E
      *
      *=====================================================================*
      *  Appends a message to the XMLSocketHubAppender.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this XMLSocketHubAppender.
      *   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P XMLSocketHubAppender_doAppend...
     P                 B                   export
      *
     D XMLSocketHubAppender_doAppend...
     D                 PI              N
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const like(LOG4RPG_pLogEvent_t )
      *
      *  Helper fields
     D rc              S             10I 0 inz
     D rc_iconv        S             10U 0 inz
     D errno           S             10I 0 inz
     D pInpBuf         S               *   inz
     D pOutBuf         S               *   inz
     D inpLength       S             10U 0 inz
     D outLength       S             10U 0 inz
     D inBufLen        S             10U 0 inz
     D outBufLen       S             10U 0 inz
     D pOutBufStart    S               *   inz
     D pInpBufStart    S               *   inz
     D msg             DS                  likeds(msg_t    ) inz
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      *
     D CRLF            C                   const(x'0D25')
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Return if there is no text
         if LogEvent_textLength(i_pLogEvent) = 0;
            return cTrue;
         endif;
 
         // Open the appender for output if it is not yet open
         if not handle.isOpen;
            if not openAppender(i_pHandle);
               return cFalse;
            endif;
         endif;
 
         monitor;
 
            // Add CRLF to log Event
            LogEvent_appendText(i_pLogEvent: CRLF);
 
            // Copy log event text to buffer
            inpLength = LogEvent_textLength(i_pLogEvent);
            pInpBuf   = LogEvent_getTextPointer(i_pLogEvent);
            outLength = %int(inpLength * 2);  // Ensure enough memory for UTF-8
            pOutBuf   = %alloc(outLength);
            inBufLen  = inpLength;
            pInpBufStart = pInpBuf;
            outBufLen = outLength;
            pOutBufStart = pOutBuf;
            rc_iconv = iconv(handle.hIconv: pInpBufStart: inBufLen
                                          : pOutBufStart: outBufLen);
            if rc_iconv <> 0;
               LogLog_error('iconv() returned with rc = ' + %char(rc_iconv));
            endif;
 
            // Write to pipe => child process.
            rc = write(handle.pipeWrite: pOutBuf: outLength - outBufLen);
         on-error;
            // Do nothing here
         endmon;
 
         // Free temporary working area
         if pInpBuf <> *NULL;
            dealloc(N) pInpBuf;
         endif;
 
         if pOutBuf <> *NULL;
            dealloc(N) pOutBuf;
         endif;
 
         // Check return code of send() procedure
         if rc < 0;
            errno = f_errno();
            LogLog_error('Failed to write logEevent to child process');
            msg = f_cvtErrnoToMsg(errno);
            LogLog_errorMsg(msg);
            if handle.isOpen;
               closeAppender(i_pHandle);
            endif;
            return cFalse;
         endif;
 
         return cTrue;
 
      /END-FREE
      *
     P XMLSocketHubAppender_doAppend...
     P                 E
      *
      *=====================================================================*
      *  Used to set the properties of the appender.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this XMLSocketHubAppender.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P XMLSocketHubAppender_setProperties...
     P                 B                   export
      *
     D XMLSocketHubAppender_setProperties...
     D                 PI
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Helper fields
     D oldCcsid        S                   like(handle.ccsid) inz
      *
      *  XMLSocketHubAppender-Handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         oldCcsid = handle.ccsid;
 
         loadConfiguration(handle: i_pPropList: i_prefix);
 
         if oldCcsid <> handle.ccsid;
 
            if handle.isIconv;
               if iconv_close(handle.hIconv) = 0;
                  handle.isIconv = cFalse;
               endif;
            endif;
 
            if not handle.isIconv;
               initIconv(handle);
            endif;
 
         endif;
 
         return;
 
      /END-FREE
      *
     P XMLSocketHubAppender_setProperties...
     P                 E
      *
      *=====================================================================*
      *  Deletes a given XMLSocketHubAppender.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this XMLSocketHubAppender.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P XMLSocketHubAppender_delete...
     P                 B                   export
      *
     D XMLSocketHubAppender_delete...
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
 
         // Close socket if it is left open
         if handle.isOpen;
            closeAppender(io_pHandle);
         endif;
 
         // End character conversion
         if handle.isIconv;
            iconv_close(handle.hIconv);
            handle.isIconv = cFalse;
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
     P XMLSocketHubAppender_delete...
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Opens a XMLSocketHubAppender for output.
      *=====================================================================*
     P openAppender...
     P                 B
      *
     D openAppender...
     D                 PI              N
     D  i_pHandle                      *   const
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      *
      *  Helper fields
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if not createChildProcess(handle);
            return cFalse;
         endif;
 
         handle.isOpen = cTrue;
 
         return cTrue;
 
      /END-FREE
      *
     P openAppender...
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Closes a XMLSocketHubAppender.
      *=====================================================================*
     P closeAppender...
     P                 B
      *
     D closeAppender...
     D                 PI              N
     D  i_pHandle                      *   const
      *
      *  Appender handle
     D handle          DS                  likeds(handle_t ) based(i_pHandle)
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         if not endChildProcess(handle);
            return cFalse;
         endif;
 
         handle.isOpen = cFalse;
 
         return cTrue;
 
      /END-FREE
      *
     P closeAppender...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Initializes charcater translation.
      *=========================================================================
     P initIconv...
     P                 B
      *
     D initIconv...
     D                 PI              N
     D  io_handle                                 likeds(handle_t )
      *
      *  Return value
     D isIconv         S               N   inz(cFalse)
      *
      *  Local fields
     D tmpHIconv       DS                  likeds(iconv_t  ) inz
     D fromCode        DS                  likeds(QtqCode_t) inz
     D toCode          DS                  likeds(QtqCode_t) inz
     D msg             DS                  likeds(msg_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         clear tmpHIconv;
 
         clear fromCode;
         fromCode.ccsid         = 0;
         fromCode.conversionA   = 0;
         fromCode.substitutionA = 0;
         fromCode.shiftStateA   = 1;
         fromCode.inpLenOpt     = 0;
         fromCode.errOptMxdDta  = 1;
         fromCode.reserved      = *ALLx'00';
 
         clear toCode;
         toCode.ccsid         = io_handle.ccsid;
         toCode.conversionA   = 0;
         toCode.substitutionA = 0;
         toCode.shiftStateA   = 0;
         toCode.inpLenOpt     = 0;
         toCode.errOptMxdDta  = 0;
         toCode.reserved      =   *ALLx'00';
 
         tmpHIconv = QtqIconv_open(toCode: fromCode);
         if tmpHIconv.return_value = -1;
            LogLog_error('Failed to initialize character conversion');
            msg = f_cvtErrnoToMsg(f_errno());
            LogLog_errorMsg(msg);
            io_handle.isIconv = cFalse;
         else;
            LogLog_debug('Initialized character translation for CCSID=' +
                         %char(io_handle.ccsid));
            io_handle.isIconv = cTrue;
            io_handle.hIconv  = tmpHIconv;
         endif;
 
         isIconv = io_handle.isIconv;
 
         return isIconv;
 
      /END-FREE
      *
     P initIconv...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Creates a new child process.
      *=========================================================================
     P createChildProcess...
     P                 B
      *
     D createChildProcess...
     D                 PI              N
     D  io_handle                                 likeds(handle_t )
      *
      *  Return value
     D isCreated       S               N   inz(cFalse)
      *
      *  Local fields
     D rc              S             10I 0 inz
     D pid             S             10I 0 inz
      *
     D inheritance     DS                  likeds(inheritance_t   ) inz
      *
     D argv            DS                  qualified
     D  pipe                         10A
     D  port                         10A
     D  debugMode                    10A
     D  output                       10A
      *
     D spw             DS                  qualified
     D  path                        128A   varying         inz
     D  fd_count                     10I 0                 inz
     D  fd_map                       10I 0 dim(32)         inz
     D  pArgv                          *   dim(32)         inz
     D  pEnvp                          *   dim(32)         inz
      *
     D tmpFildes       S                   like(desc_t           ) dim(2) inz
     D tmpChildProcess...
     D                 DS                  likeds(QP0W_Job_ID_t  )        inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         tmpFildes(cPIPE_READ)  = -1;
         tmpFildes(cPIPE_WRITE) = -1;
 
         clear tmpChildProcess;
 
         dou 1=1;
 
            // Create communication pipe to child process:
            // ... create pipe
            if pipe(tmpFildes) < 0;
               LogLog_error('Failed to create pipe: ' +
                             %char(f_errno()) + ' : ' +
                             f_strerror(f_errno()));
               leave;
            endif;
 
            LogLog_verbose('Created pipe: ' +
                              'read  = ' + %char(tmpFildes(cPIPE_READ )) + ' ' +
                              'write = ' + %char(tmpFildes(cPIPE_WRITE)));
 
            // Set write descriptor to non-blocking mode
            rc = fcntl(tmpFildes(cPIPE_WRITE): F_SETFL: O_NONBLOCK);
            if rc < 0;
               LogLog_error('Failed to set pipe to non-blocking mode: ' +
                             %char(f_errno()) + ' : ' +
                             f_strerror(f_errno()));
               leave;
            endif;
 
            // Create child process:
            // ... set inheritance
            inheritance = *ALLx'00';
            inheritance.pGroup = 0;
 
            // ... prepare program parameter values
            argv.pipe      = '0';
            argv.port      = %char(io_handle.port);
            argv.debugMode = Logger_getInternalDebugMode();
            argv.output    = Logger_getInternalDebugOutput();
 
            spw.path = '/QSYS.LIB/' +
                        %trimR(sds.pgmLib) + '.LIB/LOG4SHBAPC.PGM' + x'00';
            spw.fd_count  = 1;
            spw.fd_map(1) = tmpFildes(cPIPE_READ);
 
            spw.pArgv(1) = %addr(spw.path);
            spw.pArgv(2) = %addr(argv.pipe);
            spw.pArgv(3) = %addr(argv.port);
            spw.pArgv(4) = %addr(argv.debugMode);
            spw.pArgv(5) = %addr(argv.output);
            spw.pArgv(6) = *NULL;
 
            // ... set environment variables
            spw.pEnvp(1) = *NULL;
 
            // ... spawn child process
            pid = spawn(spw.path: spw.fd_count: %addr(spw.fd_map)
                        : inheritance
                        : %addr(spw.pArgv(1)): %addr(spw.pEnvp(1)));
            if pid < 0;
               LogLog_error('Failed to spawn child process: ' +
                             %char(f_errno()) + ' : ' +
                             f_strerror(f_errno()));
               leave;
            endif;
 
            // ... retrieve qualified job name of child process
            Qp0wGetJobID(pid: tmpChildProcess);
 
            io_handle.childProcess.nbr  = tmpChildProcess.nbr;
            io_handle.childProcess.user = tmpChildProcess.user;
            io_handle.childProcess.name = tmpChildProcess.name;
            clear tmpChildProcess;
 
            io_handle.pipeWrite    = tmpFildes(cPIPE_WRITE);
            tmpFildes(cPIPE_WRITE) = cDESC_NULL;
 
            rc = close(tmpFildes(cPIPE_READ));
            tmpFildes(cPIPE_READ ) = cDESC_NULL;
 
            LogLog_debug('Spawned child process. [' +
                          io_handle.childProcess.nbr + '/' +
                          %trim(io_handle.childProcess.user) + '/' +
                          %trim(io_handle.childProcess.name) +
                          ']');
 
            isCreated = cTrue;
         enddo;
 
         return isCreated;
 
      /END-FREE
      *
     P createChildProcess...
     P                 E
      *
      *=========================================================================
    R *  *** Private ***
      *  Closes the listener socket.
      *=========================================================================
     P endChildProcess...
     P                 B
      *
     D endChildProcess...
     D                 PI              N
     D  io_handle                                 likeds(handle_t )
      *
      *  Return value
     D isStopped       S               N   inz(cFalse)
      *
      *  Helper fields
     D rc              S             10I 0 inz
     D cmd             S            128A   varying inz
      *
     D msg             DS                  likeds(msg_t    ) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Close pipe
         if io_handle.pipeWrite <> cDESC_NULL;
            rc = close(io_handle.pipeWrite);
            io_handle.pipeWrite = cDESC_NULL;
         endif;
 
         // End child process
         if io_handle.childProcess.name <> '';
 
            cmd = 'ENDJOB JOB(' + io_handle.childProcess.nbr         + '/' +
                                  %trim(io_handle.childProcess.user) + '/' +
                                  %trim(io_handle.childProcess.name) + ') ' +
                     'OPTION(*CNTRLD) LOGLMT(0) DELAY(60)';
 
            if not f_execute(cmd: *omit: msg);
               LogLog_errorMsg(msg);
            endif;
 
            LogLog_debug('Stopped child process. [' +
                          io_handle.childProcess.nbr + '/' +
                          %trim(io_handle.childProcess.user) + '/' +
                          %trim(io_handle.childProcess.name) +
                          ']');
 
            clear io_handle.childProcess;
         endif;
 
         return isStopped;
 
      /END-FREE
      *
     P endChildProcess...
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
               when parameter = cPARAMETER_PORT;
                  io_handle.port =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_PORT);
               when parameter = cPARAMETER_CCSID;
                  io_handle.ccsid =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_CCSID);
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
