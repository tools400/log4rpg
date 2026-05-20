**FREE
/IF NOT DEFINED(PROTOTYPES_ONLY)
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: XMLSocketHubAppender                     *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  17.10.2006                                              *
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
//     >>CMD<<     CRTSRVPGM    SRVPGM(&LI/&OB) +                      *
//                              MODULE(&LI/&OB) +                      *
//                              EXPORT(*ALL) +                         *
//                              ACTGRP(*CALLER) +                      *
//                              ALWUPD(*YES) +                         *
//                              ALWLIBUPD(*YES) +                      *
//                              BNDDIR(QC2LE) +                        *
//                              BNDSRVPGM(*LIBL/LOG4RPG   +            *
//                                        *LIBL/BASICS1 ) +            *
//                              TEXT('Tools/400 - Log4rpg +            *
//                                    XMLSocketHubAppender       ') +  *
//                              DETAIL(*BASIC);                        *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
/COPY QLOG4RPG,H_SPEC
/COPY QLOG4RPG,COPYRIGHT
//=====================================================================*
/ENDIF
//
//  Creates a new XMLSocketHubAppender.
dcl-pr XMLSocketHubAppender_new
       ind extproc('XMLSocketHubAppender+
       _new');
  i_pSuper        const  like(LOG4RPG_pAppender_t     );
  io_pHandle      pointer;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pr;
//
//  Returns TRUE if the appender requires a layout.
dcl-pr XMLSocketHubAppender_requiresLayout
       ind extproc('XMLSocketHubAppender+
       _requiresLayout');
  i_pHandle       pointer const;
end-pr;
//
//  Appends a message to the XMLSocketHubAppender.
dcl-pr XMLSocketHubAppender_doAppend
       ind extproc('XMLSocketHubAppender+
       _doAppend');
  i_pHandle       pointer const;
  i_pLogEvent     const like(LOG4RPG_pLogEvent_t );
end-pr;
//
//  Used to set the properties of the appender.
dcl-pr XMLSocketHubAppender_setProperties
       extproc('XMLSocketHubAppender+
       _setProperties');
  i_pHandle       pointer const;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pr;
//
//  Deletes a given XMLSocketHubAppender.
dcl-pr XMLSocketHubAppender_delete
       ind extproc('XMLSocketHubAppender+
       _delete');
  io_pHandle      pointer;
end-pr;
//
/IF DEFINED(PROTOTYPES_ONLY)
/EOF
/ENDIF
//
// -----------------------------------------
//  Exported functions
// -----------------------------------------
/COPY QLOG4RPG,PLOG4RPG52
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
/COPY QLOG4RPG,PLOG4RPG                     Public interface & type definitions
//
dcl-ds handle_t
       qualified template;
  pSuper          like(LOG4RPG_pAppender_t);
  isOpen          ind;
  port            like(port_t);
  pipeWrite       like(desc_t);
  ccsid           int(10);
  isIconv         ind;
  hIconv          likeds(iconv_t);
childProcess    likeds(LOG4RPG_qJob_t);
end-ds;
//
dcl-s port_t          uns(10) template;
dcl-s desc_t          int(10) template;
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
/COPY QLOG4RPG,CLIB                         C-Library
//
/COPY QLOG4RPG,PLOG4RPG07                   PropertyList
/COPY QLOG4RPG,PLOG4RPG10                   LogLog
/COPY QLOG4RPG,PLOG4RPG98                   OptionConverter
/COPY QLOG4RPG,PLOG4RPG99                   Helper
//
/COPY QLOG4RPG,PLOG4SOCK                    Socket prototypes
//
// -----------------------------------------------------------------------
//  spawn()--Spawn Process
//    value  spawn() was successful.
//           The value returned is the process ID of the child process.
//    -1     spawn() was not successful.
//           The errno variable is set to indicate the error.
// -----------------------------------------------------------------------
dcl-pr spawn
       int(10) extproc('Qp0zSpawn');
  i_path          pointer value  options(*string);
  i_fd_count      int(10) value;
  i_fd_map        pointer value;
  i_inheritance   const  likeds(inheritance_t);
i_argv          pointer value;
i_envp          pointer value;
end-pr;
//
dcl-ds inheritance_t
       qualified               based(pDummy);
  flags           uns(10);
  pGroup          int(10);
  sigMask         likeds(sigmask_t);
sigDefault      likeds(sigmask_t);
end-ds;
//
dcl-ds sigmask_t
       qualified               based(pDummy);
  lomask          uns(10);
  himask          uns(10);
end-ds;
//
// -----------------------------------------------------------------------
//  pipe()--Create an Interprocess Channel
//     0     pipe() was successful.
//    -1     pipe() was not successful. The errno variable is set to indicate the error
// -----------------------------------------------------------------------
dcl-pr pipe
       int(10) extproc('pipe');
  o_fildes        int(10) dim(2);
end-pr;
//
dcl-c cPIPE_READ const(1);
dcl-c cPIPE_WRITE const(2);
//
// -----------------------------------------------------------------------
//  Qp0wGetJobID()--Get Qualified Job Name and ID for Process ID
//     0     Qp0wGetJobID() was successful.
//    value  Qp0wGetJobID() was not successful.
//           The value returned indicates one of the following errors.
// -----------------------------------------------------------------------
dcl-pr Qp0wGetJobID
       int(10) extproc('Qp0wGetJobID');
  i_pid           int(10) value;
  o_jobInfo       likeds(QP0W_Job_ID_t);
end-pr;
//
dcl-ds QP0W_Job_ID_t
       qualified               based(pDummy);
  name            char(10);
  user            char(10);
  nbr             char(6);
  ID              char(16);
end-ds;
//
// -----------------------------------------
//  Private prototypes
// -----------------------------------------
//
//  Opens a XMLSocketHubAppender for output.
dcl-pr openAppender
       ind;
  i_pHandle       pointer const;
end-pr;
//
//  Closes a XMLSocketHubAppender.
dcl-pr closeAppender
       ind;
  i_pHandle       pointer const;
end-pr;
//
//  Initializes charcater translation.
dcl-pr initIconv
       ind;
  io_handle       likeds(handle_t );
end-pr;
//
//  Create child process.
dcl-pr createChildProcess
       ind;
  io_handle       likeds(handle_t );
end-pr;
//
//  Ends child process.
dcl-pr endChildProcess
       ind;
  io_handle       likeds(handle_t );
end-pr;
//
//  Loads the configuration parameters from the specified property list.
dcl-pr loadConfiguration;
  io_handle       likeds(handle_t              );
i_pPropList     const  like(LOG4RPG_pPropertyList_t );
i_prefix        const  like(LOG4RPG_prefix_t        );
end-pr;
//
// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cTHIS_CLASS
      const(;
     D                                            'XMLSocketHubAppender')
//
dcl-c cDEFAULT_PORT
      const(4449);
dcl-c cDEFAULT_CCSID
      const(819);
//
dcl-c cPARAMETER_PORT
      const('port');
dcl-c cPARAMETER_CCSID
      const('ccsid');
//
dcl-c cDESC_NULL
      const(-1);
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
//
// -----------------------------------------
//  Program status data structure
// -----------------------------------------
/DEFINE SDS_EXTENDED
/COPY QLOG4RPG,SDS
/UNDEFINE SDS_EXTENDED
//
//=====================================================================*
//  Creates a new XMLSocketHubAppender.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this XMLSocketHubAppender.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.
//
//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc XMLSocketHubAppender_new export;
//
dcl-pi XMLSocketHubAppender_new
       ind;
  i_pSuper        const  like(LOG4RPG_pAppender_t     );
  io_pHandle      pointer;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pi;
//
//  Return value
dcl-s isDone          ind inz(*off);
//
//  Helper fields
dcl-ds tmpHIconv likeds(iconv_t  ) inz;
dcl-ds tmpHandle likeds(handle_t ) inz;
//
//  Appender handle
dcl-ds handle likeds(handle_t ) based(io_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

clear tmpHandle;
clear tmpHIconv;

// Initialize handle
tmpHandle.pSuper          = i_pSuper;   // Handle of the super class 'Appender'
tmpHandle.isOpen          = *off;
tmpHandle.port            = cDEFAULT_PORT;
tmpHandle.pipeWrite       = cDESC_NULL;
tmpHandle.ccsid           = cDEFAULT_CCSID;
tmpHandle.isIconv         = *off;
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

//
end-proc XMLSocketHubAppender_new;
//
//=====================================================================*
//  Returns TRUE if the appender requires a layout.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this XMLSocketHubAppender.
//
//  Returns:
//   isDone        - Returns TRUE if the appender requires a layout,
//                   else FALSE.
//=====================================================================*
dcl-proc XMLSocketHubAppender_requiresLayout export;
//
dcl-pi XMLSocketHubAppender_requiresLayout
       ind;
  i_pHandle       pointer const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return *on;

//
end-proc XMLSocketHubAppender_requiresLayout;
//
//=====================================================================*
//  Appends a message to the XMLSocketHubAppender.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this XMLSocketHubAppender.
//   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
//
//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc XMLSocketHubAppender_doAppend export;
//
dcl-pi XMLSocketHubAppender_doAppend
       ind;
  i_pHandle       pointer const;
  i_pLogEvent     const like(LOG4RPG_pLogEvent_t );
end-pi;
//
//  Helper fields
dcl-s rc              int(10) inz;
dcl-s rc_iconv        uns(10) inz;
dcl-s errno           int(10) inz;
dcl-s pInpBuf         pointer inz;
dcl-s pOutBuf         pointer inz;
dcl-s inpLength       uns(10) inz;
dcl-s outLength       uns(10) inz;
dcl-s inBufLen        uns(10) inz;
dcl-s outBufLen       uns(10) inz;
dcl-s pOutBufStart    pointer inz;
dcl-s pInpBufStart    pointer inz;
dcl-ds msg likeds(msg_t    ) inz;
//
//  Appender handle
dcl-ds handle likeds(handle_t ) based(i_pHandle);
//
dcl-c CRLF const(x'0D25');
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Return if there is no text
if LogEvent_textLength(i_pLogEvent) = 0;
   return *on;
endif;

// Open the appender for output if it is not yet open
if not handle.isOpen;
   if not openAppender(i_pHandle);
      return *off;
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
   return *off;
endif;

return *on;

//
end-proc XMLSocketHubAppender_doAppend;
//
//=====================================================================*
//  Used to set the properties of the appender.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this XMLSocketHubAppender.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.
//
//  Returns:
//   void
//=====================================================================*
dcl-proc XMLSocketHubAppender_setProperties export;
//
dcl-pi XMLSocketHubAppender_setProperties;
  i_pHandle       pointer const;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pi;
//
//  Helper fields
dcl-s oldCcsid        like(handle.ccsid) inz;
//
//  XMLSocketHubAppender-Handle
dcl-ds handle likeds(handle_t ) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

oldCcsid = handle.ccsid;

loadConfiguration(handle: i_pPropList: i_prefix);

if oldCcsid <> handle.ccsid;

   if handle.isIconv;
      if iconv_close(handle.hIconv) = 0;
         handle.isIconv = *off;
      endif;
   endif;

   if not handle.isIconv;
      initIconv(handle);
   endif;

endif;

return;

//
end-proc XMLSocketHubAppender_setProperties;
//
//=====================================================================*
//  Deletes a given XMLSocketHubAppender.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this XMLSocketHubAppender.
//
//  Returns:
//   void
//=====================================================================*
dcl-proc XMLSocketHubAppender_delete export;
//
dcl-pi XMLSocketHubAppender_delete
       ind;
  io_pHandle      pointer;
end-pi;
//
//  Return value
dcl-s isDone          ind inz(*off);
//
//  Appender handle
dcl-ds handle likeds(handle_t ) based(io_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Close socket if it is left open
if handle.isOpen;
   closeAppender(io_pHandle);
endif;

// End character conversion
if handle.isIconv;
   iconv_close(handle.hIconv);
   handle.isIconv = *off;
endif;

// Clear handle data
clear handle;

// Free handle memory
dealloc(N) io_pHandle;

LogLog_verbose('Deleted instance of [' + cTHIS_CLASS + '].');

isDone = *on;

return isDone;

//
end-proc XMLSocketHubAppender_delete;
//
//=====================================================================*
//  *** Private ***
//  Opens a XMLSocketHubAppender for output.
//=====================================================================*
dcl-proc openAppender;
//
dcl-pi openAppender
       ind;
  i_pHandle       pointer const;
end-pi;
//
//  Appender handle
dcl-ds handle likeds(handle_t ) based(i_pHandle);
//
//  Helper fields
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if not createChildProcess(handle);
   return *off;
endif;

handle.isOpen = *on;

return *on;

//
end-proc openAppender;
//
//=====================================================================*
//  *** Private ***
//  Closes a XMLSocketHubAppender.
//=====================================================================*
dcl-proc closeAppender;
//
dcl-pi closeAppender
       ind;
  i_pHandle       pointer const;
end-pi;
//
//  Appender handle
dcl-ds handle likeds(handle_t ) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if not endChildProcess(handle);
   return *off;
endif;

handle.isOpen = *off;

return *on;

//
end-proc closeAppender;
//
//=========================================================================
//  *** Private ***
//  Initializes charcater translation.
//=========================================================================
dcl-proc initIconv;
//
dcl-pi initIconv
       ind;
  io_handle       likeds(handle_t );
end-pi;
//
//  Return value
dcl-s isIconv         ind inz(*off);
//
//  Local fields
dcl-ds tmpHIconv likeds(iconv_t  ) inz;
dcl-ds fromCode likeds(QtqCode_t) inz;
dcl-ds toCode likeds(QtqCode_t) inz;
dcl-ds msg likeds(msg_t    ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
   io_handle.isIconv = *off;
else;
   LogLog_debug('Initialized character translation for CCSID=' +
                %char(io_handle.ccsid));
   io_handle.isIconv = *on;
   io_handle.hIconv  = tmpHIconv;
endif;

isIconv = io_handle.isIconv;

return isIconv;

//
end-proc initIconv;
//
//=========================================================================
//  *** Private ***
//  Creates a new child process.
//=========================================================================
dcl-proc createChildProcess;
//
dcl-pi createChildProcess
       ind;
  io_handle       likeds(handle_t );
end-pi;
//
//  Return value
dcl-s isCreated       ind inz(*off);
//
//  Local fields
dcl-s rc              int(10) inz;
dcl-s pid             int(10) inz;
//
dcl-ds inheritance likeds(inheritance_t   ) inz;
//
dcl-ds argv qualified;
  pipe            char(10);
  port            char(10);
  debugMode       char(10);
  output          char(10);
end-ds;
//
dcl-ds spw qualified;
  path            varchar(128) inz;
  fd_count        int(10) inz;
  fd_map          int(10) dim(32)         inz;
  pArgv           pointer dim(32)         inz;
  pEnvp           pointer dim(32)         inz;
end-ds;
//
dcl-s tmpFildes       like(desc_t           ) dim(2) inz;
dcl-ds tmpChildProcess
       likeds(QP0W_Job_ID_t  )        inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

   isCreated = *on;
enddo;

return isCreated;

//
end-proc createChildProcess;
//
//=========================================================================
//  *** Private ***
//  Closes the listener socket.
//=========================================================================
dcl-proc endChildProcess;
//
dcl-pi endChildProcess
       ind;
  io_handle       likeds(handle_t );
end-pi;
//
//  Return value
dcl-s isStopped       ind inz(*off);
//
//  Helper fields
dcl-s rc              int(10) inz;
dcl-s cmd             varchar(128) inz;
//
dcl-ds msg likeds(msg_t    ) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

//
end-proc endChildProcess;
//
//=========================================================================
//  *** Private ***
//  Loads the configuration parameters from the specified property list.
//=========================================================================
dcl-proc loadConfiguration;
//
dcl-pi loadConfiguration;
  io_handle       likeds(handle_t              );
i_pPropList     const  like(LOG4RPG_pPropertyList_t );
i_prefix        const  like(LOG4RPG_prefix_t        );
end-pi;
//
//  Local fields
dcl-s parameter       like(property.key        ) inz;
dcl-s prefix          like(i_prefix            ) inz;
dcl-ds property likeds(LOG4RPG_property_t) inz;
dcl-ds propIter        DS                  likeds(LOG4RPG_Property
ListIterator_t) inz;
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
      when parameter = cPARAMETER_PORT;
         io_handle.port =
            OptionConverter_toInt(
               property.value: cDEFAULT_PORT);
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

//
end-proc loadConfiguration;
//
