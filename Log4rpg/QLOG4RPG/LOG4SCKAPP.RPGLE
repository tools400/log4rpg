**FREE
/IF NOT DEFINED(PROTOTYPES_ONLY)
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: XMLSocketAppender                        *
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
//  15.11.2006  Th.Raddatz    Fixed probem that parameter 'ccsid'      *
//                            was not properly handled. Changed        *
//                            XMLSocketAppender_setProperties()        *
//                            to correctly call initIconv().           *
//                                                                     *
//  08.01.2007  Th.Raddatz    Added property 'reconnectionDelay' to    *
//                            XMLSocketAppender. Default reconnection  *
//                            delay is 30.000 milliseconds = 30        *
//                            seconds.                                 *
//                                                                     *
//  07.03.2007  Th.Raddatz    Added property 'connectTimeout' to       *
//                            XMLSocketAppender. Default connection    *
//                            timeout is 5.000 milliseconds = 5        *
//                            seconds.                                 *
//                                                                     *
//  22.04.2008  Th.Raddatz    Now usinng the OptionConverter to        *
//                            convert properties.                      *
//                                                                     *
//  13.10.2010  Th.Raddatz    Added special host name 'localclient'    *
//                            to retrieve the TCP/IP address of a      *
//                            5250 client.                             *
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
//                              MODULE(&LI/&OB  +                      *
//                                     &LI/LOG4SOCK) +                 *
//                              EXPORT(*ALL) +                         *
//                              ACTGRP(*CALLER) +                      *
//                              ALWUPD(*YES) +                         *
//                              ALWLIBUPD(*YES) +                      *
//                              BNDDIR(QC2LE) +                        *
//                              BNDSRVPGM(&LI/LOG4RPG   +              *
//                                        &LI/BASICS1 ) +              *
//                              TEXT('Tools/400 - Log4rpg +            *
//                                    XMLSocketAppender          ') +  *
//                              DETAIL(*BASIC);                        *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
/COPY QLOG4RPG,H_SPEC
/COPY QLOG4RPG,COPYRIGHT
//=====================================================================*
/ENDIF
//
//  Creates a new XMLSocketAppender.
dcl-pr XMLSocketAppender_new
       ind extproc('XMLSocketAppender+
       _new');
  i_pSuper        const  like(LOG4RPG_pAppender_t     );
  io_pHandle      pointer;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pr;
//
//  Returns TRUE if the appender requires a layout.
dcl-pr XMLSocketAppender_requiresLayout
       ind extproc('XMLSocketAppender+
       _requiresLayout');
  i_pHandle       pointer const;
end-pr;
//
//  Appends a message to the XMLSocketAppender.
dcl-pr XMLSocketAppender_doAppend
       ind extproc('XMLSocketAppender+
       _doAppend');
  i_pHandle       pointer const;
  i_pLogEvent     const like(LOG4RPG_pLogEvent_t );
end-pr;
//
//  Used to set the properties of the appender.
dcl-pr XMLSocketAppender_setProperties
       extproc('XMLSocketAppender+
       _setProperties');
  i_pHandle       pointer const;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pr;
//
//  Deletes a given XMLSocketAppender.
dcl-pr XMLSocketAppender_delete
       ind extproc('XMLSocketAppender+
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
       qualified           based(pDummy);
  pSuper          like(LOG4RPG_pAppender_t);
  isOpen          ind;
  host            varchar(128);
  IP              uns(10);
  port            uns(10);
  sockDesc        int(10);
  ccsid           int(10);
  connTimeout     int(10);
  reConnDelay     int(10);
  lastConnTime    timestamp;
  isIconv         ind;
  hIconv          likeds(iconv_t );
end-ds;
//
// -----------------------------------------
//  Socket type definitions
// -----------------------------------------
/COPY QLOG4RPG,PLOG4SOCK
//
//  close()--Close File or Socket Descriptor
//     returns:     0  close() was successful.
//                 -1  close() was not successful.
//                     The errno global variable is set to indicate the error.
dcl-pr closeSocket
       int(10) extproc('close');
  i_sockDesc      int(10) value;
end-pr;
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
// -----------------------------------------
//  Private prototypes
// -----------------------------------------
//
//  Opens a XMLSocketAppender for output.
dcl-pr openAppender
       ind;
  i_pHandle       pointer const;
end-pr;
//
//  Closes a XMLSocketAppender.
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
     D                                            'XMLSocketAppender')
//
dcl-c cDEFAULT_PORT
      const(4448);
dcl-c cDEFAULT_CCSID
      const(819);
dcl-c cDEFAULT_CONNECTION_TIMEOUT
      const(5000);
dcl-c cDEFAULT_RECONNECTION_DELAY
      const(30000);
//
dcl-c cPARAMETER_REMOTE_HOST
      const('remotehost');
dcl-c cPARAMETER_PORT
      const('port');
dcl-c cPARAMETER_CCSID
      const('ccsid');
dcl-c cPARAMETER_RECONNECTION_DELAY
      const('reconnectiondelay');
dcl-c cPARAMETER_CONNECT_TIMEOUT
      const('connecttimeout');
//
dcl-c cSOCKET_NULL
      const(-1);
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
//
//=====================================================================*
//  Creates a new XMLSocketAppender.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this XMLSocketAppender.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.
//
//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc XMLSocketAppender_new export;
//
dcl-pi XMLSocketAppender_new
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
tmpHandle.host            = '';
tmpHandle.IP              = 0;
tmpHandle.port            = 4448;
tmpHandle.sockDesc        = cSOCKET_NULL;
tmpHandle.ccsid           = 819;
tmpHandle.connTimeout     = 5000;      // measured in milliseconds
tmpHandle.reConnDelay     = 30000;     // measured in milliseconds
tmpHandle.lastConnTime    = *loval;
tmpHandle.isIconv         = *off;
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

//
end-proc XMLSocketAppender_new;
//
//=====================================================================*
//  Returns TRUE if the appender requires a layout.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this XMLSocketAppender.
//
//  Returns:
//   isDone        - Returns TRUE if the appender requires a layout,
//                   else FALSE.
//=====================================================================*
dcl-proc XMLSocketAppender_requiresLayout export;
//
dcl-pi XMLSocketAppender_requiresLayout
       ind;
  i_pHandle       pointer const;
end-pi;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

return *on;

//
end-proc XMLSocketAppender_requiresLayout;
//
//=====================================================================*
//  Appends a message to the XMLSocketAppender.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this XMLSocketAppender.
//   i_pLogEvent   - Handle of the Log event returned by LogEvent_new().
//
//  Returns:
//   isDone        - Returns TRUE on success, else FALSE.
//=====================================================================*
dcl-proc XMLSocketAppender_doAppend export;
//
dcl-pi XMLSocketAppender_doAppend
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
   if (handle.lastConnTime +
       %mseconds(handle.reConnDelay * 1000) <= %timestamp());
      if not openAppender(i_pHandle);
         LogLog_error('Trying to connect to host again in ' +
                      %char(%int(handle.reConnDelay)) + ' ms.');
         handle.lastConnTime = %timestamp();
         return *off;
      endif;
   else;
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

   return *off;
endif;

return *on;

//
end-proc XMLSocketAppender_doAppend;
//
//=====================================================================*
//  Used to set the properties of the appender.
//=====================================================================*
//  Parameters:
//   i_pHandle     - Handle that is passed around the various calls to
//                   this XMLSocketAppender.
//   i_pPropsList  - Handle of the property list that contains the
//                   properties for the appender.
//   i_prefix      - Prefix of the relevant property keys.
//
//  Returns:
//   void
//=====================================================================*
dcl-proc XMLSocketAppender_setProperties export;
//
dcl-pi XMLSocketAppender_setProperties;
  i_pHandle       pointer const;
  i_pPropList     const  like(LOG4RPG_pPropertyList_t );
  i_prefix        const  like(LOG4RPG_prefix_t        );
end-pi;
//
//  Helper fields
dcl-s oldCcsid        like(handle.ccsid) inz;
//
//  XMLSocketAppender-Handle
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
end-proc XMLSocketAppender_setProperties;
//
//=====================================================================*
//  Deletes a given XMLSocketAppender.
//=====================================================================*
//  Parameters:
//   io_pHandle    - Handle that is passed around the various calls to
//                   this XMLSocketAppender.
//
//  Returns:
//   void
//=====================================================================*
dcl-proc XMLSocketAppender_delete export;
//
dcl-pi XMLSocketAppender_delete
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
   if closeAppender(io_pHandle);
      handle.lastConnTime = *loval;
   endif;
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
end-proc XMLSocketAppender_delete;
//
//=====================================================================*
//  *** Private ***
//  Opens a XMLSocketAppender for output.
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
dcl-s rc              int(10) inz;
dcl-s tmpIPLong       uns(10) inz;
dcl-s tmpSockDesc     int(10) inz;
dcl-s flags           int(10) inz;
dcl-s errVal          int(10) inz;
dcl-s optLen          int(10) inz;
dcl-ds waittime likeds(timeval_t     ) inz;
dcl-s writeSet        like(socket_fdSet_t  ) inz;
dcl-s tmpHost         like(handle.host     ) inz;
//
dcl-ds hostent likeds(hostent_t) based(pHostent);
dcl-s p1HostAdr       pointer based(hostent.h_addrlist);
dcl-s hostAdr         uns(10) based(p1HostAdr);
//
dcl-ds sockAddr likeds(sockaddr_in_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
            return *off;
         endif;
         tmpIPLong = inet_addr(tmpHost);
      else;
         pHostent = gethostbyname(handle.host);
         if pHostent = *NULL;
            LogLog_error('Failed to resolve  host [' +
                          handle.host + ']');
            return *off;
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
   return *off;
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
         return *off;
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
            return *off;
         endif;
      other;         // Error
         closeSocket(tmpSockDesc);
         LogLog_error('Failed to connect to host [' +
                       handle.host + ':' + %char(handle.port) + ']');
         LogLog_error('--> ' + %char(f_errno()) + ': ' +
                               f_strerror(f_errno()) );
         return *off;
      endsl;
   else;
      closeSocket(tmpSockDesc);
      LogLog_error('Failed to connect to host [' +
                    handle.host + ':' + %char(handle.port) + ']');
      LogLog_error('--> ' + %char(f_errno()) + ': ' +
                            f_strerror(f_errno()) );
      return *off;
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
handle.isOpen   = *on;

return *on;

//
end-proc openAppender;
//
//=====================================================================*
//  *** Private ***
//  Closes a XMLSocketAppender.
//=====================================================================*
dcl-proc closeAppender;
//
dcl-pi closeAppender
       ind;
  i_pHandle       pointer const;
end-pi;
//
//  Return value
dcl-s isDone          ind inz(*off);
//
//  Appender handle
dcl-ds handle likeds(handle_t ) based(i_pHandle);
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if closeSocket(handle.sockDesc) = 0;
   handle.isOpen   = *off;
   handle.sockDesc = cSOCKET_NULL;
   isDone = *on;
   LogLog_debug('Disconnected from host [' + handle.host  + ':' +
                                             %char(handle.port) + ']');
else;
   LogLog_error('Failed to disconnect from host [' +
                 handle.host + ':' + %char(handle.port) + ']');
   LogLog_error('--> ' + %char(f_errno()) + ': ' +
                         f_strerror(f_errno()) );
   isDone = *off;
endif;

return isDone;

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
