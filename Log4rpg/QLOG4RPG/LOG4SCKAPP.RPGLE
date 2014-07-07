      /IF NOT DEFINED(PROTOTYPES_ONLY)
      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: XMLSocketAppender                        *
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
      *  15.11.2006  Th.Raddatz    Fixed probem that parameter 'ccsid'      *
      *                            was not properly handled. Changed        *
      *                            XMLSocketAppender_setProperties()        *
      *                            to correctly call initIconv().           *
      *                                                                     *
      *  08.01.2007  Th.Raddatz    Added property 'reconnectionDelay' to    *
      *                            XMLSocketAppender. Default reconnection  *
      *                            delay is 30.000 milliseconds = 30        *
      *                            seconds.                                 *
      *                                                                     *
      *  07.03.2007  Th.Raddatz    Added property 'connectTimeout' to       *
      *                            XMLSocketAppender. Default connection    *
      *                            timeout is 5.000 milliseconds = 5        *
      *                            seconds.                                 *
      *                                                                     *
      *  22.04.2008  Th.Raddatz    Now usinng the OptionConverter to        *
      *                            convert properties.                      *
      *                                                                     *
      *  13.10.2010  Th.Raddatz    Added special host name 'localclient'    *
      *                            to retrieve the TCP/IP address of a      *
      *                            5250 client.                             *
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
      *                              MODULE(&LI/&OB  +                      *
      *                                     &LI/LOG4SOCK) +                 *
      *                              EXPORT(*ALL) +                         *
      *                              ACTGRP(*CALLER) +                      *
      *                              ALWUPD(*YES) +                         *
      *                              ALWLIBUPD(*YES) +                      *
      *                              BNDDIR(QC2LE) +                        *
      *                              BNDSRVPGM(&LI/LOG4RPG   +              *
      *                                        &LI/BASICS1 ) +              *
      *                              TEXT('Tools/400 - Log4rpg +            *
      *                                    XMLSocketAppender          ') +  *
      *                              DETAIL(*BASIC);                        *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /COPY QLOG4RPG,H_SPEC
      /COPY QLOG4RPG,COPYRIGHT
      *=====================================================================*
      /ENDIF
      *
      *  Creates a new XMLSocketAppender.
     D XMLSocketAppender_new...
     D                 PR              N   extproc('XMLSocketAppender+
     D                                     _new')
     D  i_pSuper                           const  like(LOG4RPG_pAppender_t     )
     D  io_pHandle                     *
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Returns TRUE if the appender requires a layout.
     D XMLSocketAppender_requiresLayout...
     D                 PR              N   extproc('XMLSocketAppender+
     D                                     _requiresLayout')
     D  i_pHandle                      *   const
      *
      *  Appends a message to the XMLSocketAppender.
     D XMLSocketAppender_doAppend...
     D                 PR              N   extproc('XMLSocketAppender+
     D                                     _doAppend')
     D  i_pHandle                      *   const
     D  i_pLogEvent                        const like(LOG4RPG_pLogEvent_t )
      *
      *  Used to set the properties of the appender.
     D XMLSocketAppender_setProperties...
     D                 PR                  extproc('XMLSocketAppender+
     D                                     _setProperties')
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Deletes a given XMLSocketAppender.
     D XMLSocketAppender_delete...
     D                 PR              N   extproc('XMLSocketAppender+
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
      *
     D handle_t...
     D                 DS                  qualified           based(pDummy)
     D  pSuper                             like(LOG4RPG_pAppender_t)
     D  isOpen                         N
     D  host                        128A   varying
     D  IP                           10U 0
     D  port                         10U 0
     D  sockDesc                     10I 0
     D  ccsid                        10I 0
     D  connTimeout                  10I 0
     D  reConnDelay                  10I 0
     D  lastConnTime                   Z
     D  isIconv                        N
     D  hIconv                             likeds(iconv_t )
      *
      * -----------------------------------------
      *  Socket type definitions
      * -----------------------------------------
      /COPY QLOG4RPG,PLOG4SOCK
      *
      *  close()--Close File or Socket Descriptor
      *     returns:     0  close() was successful.
      *                 -1  close() was not successful.
      *                     The errno global variable is set to indicate the error.
     D closeSocket...
     D                 PR            10I 0 extproc('close')
     D  i_sockDesc                   10I 0 value
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
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
      *  Opens a XMLSocketAppender for output.
     D openAppender...
     D                 PR              N
     D  i_pHandle                      *   const
      *
      *  Closes a XMLSocketAppender.
     D closeAppender...
     D                 PR              N
     D  i_pHandle                      *   const
      *
      *  Initializes charcater translation.
     D initIconv...
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
     D                                            'XMLSocketAppender')
      *
     D cDEFAULT_PORT...
     D                 C                          const(4448)
     D cDEFAULT_CCSID...
     D                 C                          const(819)
     D cDEFAULT_CONNECTION_TIMEOUT...
     D                 C                          const(5000)
     D cDEFAULT_RECONNECTION_DELAY...
     D                 C                          const(30000)
      *
     D cPARAMETER_REMOTE_HOST...
     D                 C                          const('remotehost')
     D cPARAMETER_PORT...
     D                 C                          const('port')
     D cPARAMETER_CCSID...
     D                 C                          const('ccsid')
     D cPARAMETER_RECONNECTION_DELAY...
     D                 C                          const('reconnectiondelay')
     D cPARAMETER_CONNECT_TIMEOUT...
     D                 C                          const('connecttimeout')
      *
     D cSOCKET_NULL...
     D                 C                          const(-1)
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=====================================================================*
      *  Creates a new XMLSocketAppender.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this XMLSocketAppender.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P XMLSocketAppender_new...
     P                 B                   export
      *
     D XMLSocketAppender_new...
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
         tmpHandle.host            = '';
         tmpHandle.IP              = 0;
         tmpHandle.port            = 4448;
         tmpHandle.sockDesc        = cSOCKET_NULL;
         tmpHandle.ccsid           = 819;
         tmpHandle.connTimeout     = 5000;      // measured in milliseconds
         tmpHandle.reConnDelay     = 30000;     // measured in milliseconds
         tmpHandle.lastConnTime    = *loval;
         tmpHandle.isIconv         = cFalse;
         tmpHandle.hIconv          = tmpHIconv;
 
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
     P XMLSocketAppender_new...
     P                 E
      *
      *=====================================================================*
      *  Returns TRUE if the appender requires a layout.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this XMLSocketAppender.
      *
      *  Returns:
      *   isDone        - Returns TRUE if the appender requires a layout,
      *                   else FALSE.
      *=====================================================================*
     P XMLSocketAppender_requiresLayout...
     P                 B                   export
      *
     D XMLSocketAppender_requiresLayout...
     D                 PI              N
     D  i_pHandle                      *   const
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         return cTrue;
 
      /END-FREE
      *
     P XMLSocketAppender_requiresLayout...
     P                 E
      *
      *=====================================================================*
      *  Appends a message to the XMLSocketAppender.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this XMLSocketAppender.
      *   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
      *
      *  Returns:
      *   isDone        - Returns TRUE on success, else FALSE.
      *=====================================================================*
     P XMLSocketAppender_doAppend...
     P                 B                   export
      *
     D XMLSocketAppender_doAppend...
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
            if (handle.lastConnTime +
                %mseconds(handle.reConnDelay * 1000) <= %timestamp());
               if not openAppender(i_pHandle);
                  LogLog_error('Trying to connect to host again in ' +
                               %char(%int(handle.reConnDelay)) + ' ms.');
                  handle.lastConnTime = %timestamp();
                  return cFalse;
               endif;
            else;
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
 
            // Write to socket.
            rc = send(handle.sockDesc: pOutBuf: outLength - outBufLen: 0);
            p_assert(rc = outLength - outBufLen
                     : 'Not all bytes send to network');
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
            LogLog_error('Failed to send logEevent to host [' +
                         handle.host + ':' + %char(handle.port) + ']');
            msg = f_cvtErrnoToMsg(errno);
            LogLog_errorMsg(msg);
 
            if errno = EPIPE_C;   // Broken pipe
               if handle.isOpen;
                  if closeAppender(i_pHandle);
                     handle.lastConnTime = *loval;
                  endif;
               endif;
            endif;
 
            return cFalse;
         endif;
 
         return cTrue;
 
      /END-FREE
      *
     P XMLSocketAppender_doAppend...
     P                 E
      *
      *=====================================================================*
      *  Used to set the properties of the appender.
      *=====================================================================*
      *  Parameters:
      *   i_pHandle     - Handle that is passed around the various calls to
      *                   this XMLSocketAppender.
      *   i_pPropsList  - Handle of the property list that contains the
      *                   properties for the appender.
      *   i_prefix      - Prefix of the relevant property keys.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P XMLSocketAppender_setProperties...
     P                 B                   export
      *
     D XMLSocketAppender_setProperties...
     D                 PI
     D  i_pHandle                      *   const
     D  i_pPropList                        const  like(LOG4RPG_pPropertyList_t )
     D  i_prefix                           const  like(LOG4RPG_prefix_t        )
      *
      *  Helper fields
     D oldCcsid        S                   like(handle.ccsid) inz
      *
      *  XMLSocketAppender-Handle
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
     P XMLSocketAppender_setProperties...
     P                 E
      *
      *=====================================================================*
      *  Deletes a given XMLSocketAppender.
      *=====================================================================*
      *  Parameters:
      *   io_pHandle    - Handle that is passed around the various calls to
      *                   this XMLSocketAppender.
      *
      *  Returns:
      *   void
      *=====================================================================*
     P XMLSocketAppender_delete...
     P                 B                   export
      *
     D XMLSocketAppender_delete...
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
            if closeAppender(io_pHandle);
               handle.lastConnTime = *loval;
            endif;
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
     P XMLSocketAppender_delete...
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Opens a XMLSocketAppender for output.
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
     D rc              S             10I 0 inz
     D tmpIPLong       S             10U 0 inz
     D tmpSockDesc     S             10I 0 inz
     D flags           S             10I 0 inz
     D errVal          S             10I 0 inz
     D optLen          S             10I 0 inz
     D waittime        DS                  likeds(timeval_t     ) inz
     D writeSet        S                   like(socket_fdSet_t  ) inz
     D tmpHost         S                   like(handle.host     ) inz
      *
     D hostent         DS                  likeds(hostent_t) based(pHostent)
     D p1HostAdr       S               *   based(hostent.h_addrlist)
     D hostAdr         S             10U 0 based(p1HostAdr)
      *
     D sockAddr        DS                  likeds(sockaddr_in_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Resolve host name to IP address long
         if handle.IP = 0;
            tmpIPLong = inet_addr(handle.host);
            if tmpIPLong = INADDR_NONE;
               tmpIPLong = 0;
 
               if (f_lcase(handle.host) = 'localclient');
                  tmpHost = Job_getTcpIpAddr();
                  if (tmpHost = '');
                     LogLog_error('Failed to resolve  host [' +
                                   handle.host + ']');
                     return cFalse;
                  endif;
                  tmpIPLong = inet_addr(tmpHost);
               else;
                  pHostent = gethostbyname(handle.host);
                  if pHostent = *NULL;
                     LogLog_error('Failed to resolve  host [' +
                                   handle.host + ']');
                     return cFalse;
                  endif;
 
                  tmpIPLong = hostAdr;
               endif;
 
            endif;
 
            handle.IP = tmpIPLong;
         endif;
 
         // Create socket
         rc = socket(AF_INET: SOCK_STREAM: IPPROTO_IP);
         if rc < 0;
            LogLog_error('Failed to create socket for connection to host [' +
                          handle.host + ':' + %char(handle.port) + ']');
            return cFalse;
         endif;
 
         tmpSockDesc = rc;
 
         LogLog_debug('Created socket [' + %char(tmpSockDesc) +
                      '] to host [' + handle.host  + ':' +
                                      %char(handle.port) + ']');
 
         // Turn socket into non-blocking mode
         flags = fcntl(tmpSockDesc: F_GETFL);
         if flags < 0;
            LogLog_warning('Failed to retrieve socket flags');
         endif;
 
         flags = %bitor(flags: O_NONBLOCK);
 
         if fcntl(tmpSockDesc: F_SETFL: flags) < 0;
            LogLog_warning('Failed to set socket flags');
         endif;
 
         // Connect to host
         sockAddr.sin_Family = AF_INET;
         sockAddr.sin_Port   = handle.port;
         sockAddr.sin_addr   = handle.IP;
         sockAddr.sin_zero   = *ALLx'00';
         rc = connect(tmpSockDesc: %addr(sockAddr): %size(sockAddr));
         if rc < 0;
            if f_errno() = EINPROGRESS_C;
               waittime.tv_sec  = handle.connTimeout / 1000;
               waittime.tv_usec = %rem(handle.connTimeout: 1000) * 1000;
               FD_ZERO(writeSet);
               FD_SET(tmpSockDesc: writeSet);
               rc = select(tmpSockDesc + 1: *NULL
                                          : %addr(writeSet)
                                          : *NULL
                                          : %addr(waittime));
               select;
               when rc = 0;   // Timeout
                  closeSocket(tmpSockDesc);
                  LogLog_error('Time limit expired after ' +
                                          %char(handle.connTimeout) +
                               ' ms when trying to connect to +
                                host [' + handle.host + ':' +
                                          %char(handle.port) + ']');
                  return cFalse;
               when rc > 0;   // Connected!
                  optLen = %size(errVal);
                  getsockopt(tmpSockDesc: SOL_SOCKET: SO_ERROR
                             : %addr(errVal): optLen);
                  if errVal <> 0;
                     closeSocket(tmpSockDesc);
                     LogLog_error('Failed to connect to host [' +
                                   handle.host + ':' + %char(handle.port) +']');
                     LogLog_error('--> ' + %char(errVal) + ': ' +
                                           f_strerror(errVal) );
                     return cFalse;
                  endif;
               other;         // Error
                  closeSocket(tmpSockDesc);
                  LogLog_error('Failed to connect to host [' +
                                handle.host + ':' + %char(handle.port) + ']');
                  LogLog_error('--> ' + %char(f_errno()) + ': ' +
                                        f_strerror(f_errno()) );
                  return cFalse;
               endsl;
            else;
               closeSocket(tmpSockDesc);
               LogLog_error('Failed to connect to host [' +
                             handle.host + ':' + %char(handle.port) + ']');
               LogLog_error('--> ' + %char(f_errno()) + ': ' +
                                     f_strerror(f_errno()) );
               return cFalse;
            endif;
         endif;
 
         LogLog_debug('Connected to host [' + handle.host  + ':' +
                                              %char(handle.port) + ']');
 
         // Turn socket into blocking mode
         flags = fcntl(tmpSockDesc: F_GETFL);
         if flags < 0;
            LogLog_warning('Failed to retrieve socket flags');
         endif;
 
         flags = %bitand(flags: %bitnot(O_NONBLOCK));
 
         if fcntl(tmpSockDesc: F_SETFL: flags) < 0;
            LogLog_warning('Failed to set socket flags');
         endif;
 
         // Set return value
         handle.sockDesc = tmpSockDesc;
         handle.isOpen   = cTrue;
 
         return cTrue;
 
      /END-FREE
      *
     P openAppender...
     P                 E
      *
      *=====================================================================*
    R *  *** Private ***
      *  Closes a XMLSocketAppender.
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
 
         if closeSocket(handle.sockDesc) = 0;
            handle.isOpen   = cFalse;
            handle.sockDesc = cSOCKET_NULL;
            isDone = cTrue;
            LogLog_debug('Disconnected from host [' + handle.host  + ':' +
                                                      %char(handle.port) + ']');
         else;
            LogLog_error('Failed to disconnect from host [' +
                          handle.host + ':' + %char(handle.port) + ']');
            LogLog_error('--> ' + %char(f_errno()) + ': ' +
                                  f_strerror(f_errno()) );
            isDone = cFalse;
         endif;
 
         return isDone;
 
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
               when parameter = cPARAMETER_REMOTE_HOST;
                  io_handle.host        = property.value;
               when parameter = cPARAMETER_PORT;
                  io_handle.port =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_PORT);
               when parameter = cPARAMETER_CCSID;
                  io_handle.ccsid =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_CCSID);
               when parameter = cPARAMETER_RECONNECTION_DELAY;
                  io_handle.reConnDelay =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_RECONNECTION_DELAY);
               when parameter = cPARAMETER_CONNECT_TIMEOUT;
                  io_handle.connTimeout =
                     OptionConverter_toInt(
                        property.value: cDEFAULT_CONNECTION_TIMEOUT);
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
