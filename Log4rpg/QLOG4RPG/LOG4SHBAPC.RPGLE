**FREE
/IF NOT DEFINED(PROTOTYPES_ONLY)
//=====================================================================*
//  SrvPgm: LOG4RPG - Object: XMLSocketHubAppender - Child Process     *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  14.11.2006                                              *
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
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                         *
//                              MODULE(&LI/&OB        +                *
//                                     &LI/LOG4SOCK ) +                *
//                              ACTGRP(*NEW) +                         *
//                              BNDDIR(QC2LE) +                        *
//                              BNDSRVPGM(*LIBL/LOG4RPG   +            *
//                                        *LIBL/BASICS1 ) +            *
//                              TEXT('Tools/400 - Log4rpg +            *
//                                    XMLSocketHubAppender       ') +  *
//                              DETAIL(*BASIC);                        *
//                                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
/DEFINE UNIT_TEST
/COPY QLOG4RPG,H_SPEC
/COPY QLOG4RPG,COPYRIGHT
//=====================================================================*
/ENDIF
//
//  Program entry point
dcl-pr PGM_ENTRY_POINT
       extpgm('LOG4SHBAPC');
  gi_pipe         char(10) const;
  gi_port         char(10) const;
  gi_debugMode    char(10) const;
  gi_output       char(10) const;
end-pr;
//
/IF DEFINED(PROTOTYPES_ONLY)
/EOF
/ENDIF
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
dcl-s buffer_t        char(2048) based(pDummy);
//
// -----------------------------------------
//  Prototypes
// -----------------------------------------
/COPY QLOG4RPG,CLIB                          C-Library
/COPY QBASICS1,PBASICS1                      Basic RPG Extensions
//
/COPY QLOG4RPG,PLOG4RPG                      Public interface & type definitions
/COPY QLOG4RPG,PLOG4RPG10                    LogLog
/COPY QLOG4RPG,PLOG4SOCK                     Socket Functions
//
// -----------------------------------------
//  Private prototypes
// -----------------------------------------
//
dcl-pr XMLSocketHubAppender_childProcess;
  i_pipe          int(10) value;
  i_port          int(10) value;
  i_debugMode     value  like(LOG4RPG_debugMode_t  );
  i_output        value  like(LOG4RPG_debugOutput_t);
end-pr;
//
//  Initializes client sockets.
dcl-pr initClients;
  io_clients      int(10) dim(cMAX_CLIENTS);
end-pr;
//
//  Forward data to clients.
dcl-pr doCLients;
  io_clients      int(10) dim(cMAX_CLIENTS);
  i_writeSet      const  like(socket_fdSet_t);
  i_pBuffer       pointer const;
  i_length        int(10) const;
end-pr;
//
//  Closes client sockets.
dcl-pr closeClients;
  io_clients      int(10) dim(cMAX_CLIENTS);
end-pr;
//
//  Closes client socket.
dcl-pr closeClient
       int(10);
  io_client       int(10);
end-pr;
//
//  Creates a new listener socket.
dcl-pr createListener
       int(10);
  i_port          int(10) value;
end-pr;
//
//  Produces a new client.
dcl-pr acceptClient;
  i_listener      int(10) const;
  io_clients      int(10) dim(cMAX_CLIENTS);
end-pr;
//
//  Make descritor sets for client descriptors.
dcl-pr makeDescSets
       int(10);
  i_pipe          int(10) const;
  i_listener      int(10) const;
  i_clients       int(10) const  dim(cMAX_CLIENTS);
  o_readSet       like(socket_fdSet_t);
  o_writeSet      like(socket_fdSet_t);
  o_excpSet       like(socket_fdSet_t);
end-pr;
//
// -----------------------------------------
//  Global constants
// -----------------------------------------
dcl-c cMAX_CLIENTS const(32);
//
// -----------------------------------------
//  Global fields
// -----------------------------------------
//
//=====================================================================*
//  XMLSocketHubAppender - Program Entry Point
//=====================================================================*
//  Parameters:
//   gi_pipe       - Read descriptor of pipe of parent process.
//   gi_port       - Listener port.
//=====================================================================*
dcl-pi PGM_ENTRY_POINT;
  gi_pipe         char(10) const;
  gi_port         char(10) const;
  gi_debugMode    char(10) const;
  gi_output       char(10) const;
end-pi;
//
//  Helper fields
dcl-s pipe            int(10) inz;
dcl-s port            int(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pipe = atoi(gi_pipe);
port = atoi(gi_port);

XMLSocketHubAppender_childProcess(pipe: port: gi_debugMode: gi_output);

*inlr = *ON;

//
//=====================================================================*
//  XMLSocketHubAppender - Child Process
//=====================================================================*
dcl-proc XMLSocketHubAppender_childProcess;
//
dcl-pi XMLSocketHubAppender_childProcess;
  i_pipe          int(10) value;
  i_port          int(10) value;
  i_debugMode     value  like(LOG4RPG_debugMode_t  );
  i_output        value  like(LOG4RPG_debugOutput_t);
end-pi;
//
//  Helper fields
dcl-s rc              int(10) inz;
dcl-s maxDesc         int(10) inz;
dcl-s readSet         like(socket_fdSet_t) inz;
dcl-s writeSet        like(socket_fdSet_t) inz;
dcl-s excpSet         like(socket_fdSet_t) inz;
dcl-ds wait likeds(timeval_t   ) inz;
//
dcl-s numBytes        int(10) inz;
dcl-s buffer          like(buffer_t  )  inz;
//
//  Helper fields (house keeping)
dcl-s listener        int(10) inz(SOCKET_NULL);
dcl-s clients         int(10) dim(cMAX_CLIENTS) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

// Set internal logging to: ON
Logger_setInternalDebugging(i_debugMode: i_output);

// Show pipe read descriptor and listener port
LogLog_verbose('Parameter: debug mode      = ' + i_debugMode);
LogLog_verbose('Parameter: debug output    = ' + i_output   );
LogLog_verbose('Parameter: pipe descriptor = ' + %char(i_pipe));
LogLog_verbose('Parameter: listener port   = ' + %char(i_port));

// Create listener socket
listener = createListener(i_port);
if listener = SOCKET_ERROR;
   LogLog_error('createListener(' + %char(i_port) + ')-error: '
               + f_strerror(f_errno()));
   return;
endif;

if listener = SOCKET_NULL;
   LogLog_error('createListener(' + %char(i_port) + ')-error: '
               + f_strerror(f_errno())
               + '. Socket is NULL.'
               );
   return;
endif;

// Initialize client sockets
initClients(clients);

dou %shtdn();

   // Wait for incoming requests
   maxDesc = makeDescSets(i_pipe: listener
                          : clients: readSet: writeSet: excpSet);

   clear wait;
   wait.tv_sec  = 10;
   wait.tv_usec = 0;
   rc = select(maxDesc + 1
               : %addr(readSet): *NULL: %addr(excpSet): %addr(wait));
   if rc = SOCKET_ERROR;
      LogLog_error('select()-error: ' + f_strerror(f_errno()));
      leave;
   endif;

   // Test SHUTDOWN requested
   if %shtdn();
      leave;
   endif;

   // Make new client
   if FD_ISSET(listener: readSet);
      acceptClient(listener: clients);
   endif;

   // Receive incoming log event and pass it forward to clients
   if FD_ISSET(i_pipe: readSet);

      // Receive data ...
      clear buffer;
      numBytes = read(i_pipe: %addr(buffer): %size(buffer));
      if numBytes = 0;   // END-OF-FILE ==> shutdown
         leave;
      endif;

      LogLog_verbose(%char(numBytes) + ' received from pipe');
      LogLog_verbose('-> ' + %trimR(%subst(buffer: 1: 40)) + '...');

      // ... pass forward to clients
      doClients(clients: writeSet: %addr(buffer): numBytes);

   endif;

enddo;

if %shtdn();
   LogLog_verbose('Processing SHUTDOWN request ...');
endif;

// House keeping ...
// ... close listener socket
if listener <> SOCKET_NULL;
   rc = close(listener);
   LogLog_verbose('Listener socket closed: ' + %char(listener));
   listener = SOCKET_NULL;
endif;

// ... close client sockets
closeClients(clients);

// ... close pipe
rc = close(i_pipe);
LogLog_verbose('Pipe closed: ' + %char(i_pipe));

return;

//
end-proc XMLSocketHubAppender_childProcess;
//
//=====================================================================*
//  Initializes client sockets.
//=====================================================================*
dcl-proc initClients;
//
dcl-pi initClients;
  io_clients      int(10) dim(cMAX_CLIENTS);
end-pi;
//
//  Helper fields
dcl-s x               int(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

for x = 1 to cMAX_CLIENTS;
   io_clients(x) = SOCKET_NULL;
endfor;

return;

//
end-proc initClients;
//
//=====================================================================*
//  Forward data to clients.
//=====================================================================*
dcl-proc doClients;
//
dcl-pi doCLients;
  io_clients      int(10) dim(cMAX_CLIENTS);
  i_writeSet      const  like(socket_fdSet_t);
  i_pBuffer       pointer const;
  i_length        int(10) const;
end-pi;
//
//  Helper fields
dcl-s x               int(10) inz;
dcl-s rc              int(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

for x = 1 to cMAX_CLIENTS;
   if io_clients(x) <> SOCKET_NULL;

      // Test if client is ready
      if FD_ISSET(io_clients(x): i_writeSet);
         // Forward data to client
         rc = send(io_clients(x): i_pBuffer: i_length: 0);
      else;
         rc = SOCKET_ERROR;
      endif;

      // On error close client
      if rc = SOCKET_ERROR;
         closeClient(io_clients(x));
      endif;

   endif;
endfor;

return;

//
end-proc doClients;
//
//=====================================================================*
//  Closes client sockets.
//=====================================================================*
dcl-proc closeClients;
//
dcl-pi closeClients;
  io_clients      int(10) dim(cMAX_CLIENTS);
end-pi;
//
//  Helper fields
dcl-s x               int(10) inz;
dcl-s rc              int(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

for x = 1 to cMAX_CLIENTS;
   if io_clients(x) <> SOCKET_NULL;
      rc = closeClient(io_clients(x));
   endif;
endfor;

return;

//
end-proc closeClients;
//
//=====================================================================*
//  Closes client socket.
//=====================================================================*
dcl-proc closeClient;
//
dcl-pi closeClient
       int(10);
  io_client       int(10);
end-pi;
//
//  Return value
dcl-s rc              int(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rc = close(io_client);

LogLog_debug('Closed client: ' + %char(io_client));

io_client = SOCKET_NULL;

return rc;

//
end-proc closeClient;
//
//=====================================================================*
//  Creates a new listener socket.
//=====================================================================*
dcl-proc createListener;
//
dcl-pi createListener
       int(10);
  i_port          int(10) value;
end-pi;
//
//  Return value
dcl-s listener        int(10) inz(SOCKET_ERROR);
//
//  Helper fields
dcl-s rc              int(10) inz;
dcl-s tmpListener     like(listener    ) inz(SOCKET_NULL);
//
dcl-ds sockAddr likeds(sockaddr_in_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dou 1=1;

   LogLog_verbose('Creating listener socket ...');

   tmpListener = socket(AF_INET: SOCK_STREAM: IPPROTO_IP);
   if tmpListener = SOCKET_ERROR;
      LogLog_error('socket()-error: ' + f_strerror(f_errno()));
      leave;
   endif;

   LogLog_verbose('Setting socket option: SO_REUSEADDR');

   rc = setsockopt(tmpListener: SOL_SOCKET
                              : SO_REUSEADDR
                              : %addr(i_port)
                              : %size(i_port));
   if rc = SOCKET_ERROR;
      LogLog_error('setsockopt()-error: ' + f_strerror(f_errno()));
      leave;
   endif;

   LogLog_verbose('Binding socket to port: ' + %char(i_port));

   sockAddr.sin_Family = AF_INET;
   sockAddr.sin_Port   = i_port;
   sockAddr.sin_addr   = INADDR_ANY;
   sockAddr.sin_zero   = *ALLx'00';
   rc = bind(tmpListener: %addr(sockAddr): %size(sockAddr));
   if rc = SOCKET_ERROR;
      LogLog_error('bind()-error: ' + f_strerror(f_errno()));
      leave;
   endif;

   LogLog_verbose('Starting listening for port: ' + %char(i_port));

   rc = listen(tmpListener: 0);
   if rc = SOCKET_ERROR;
      LogLog_error('listen()-error: ' + f_strerror(f_errno()));
      leave;
   endif;

   listener = tmpListener;
   tmpListener = SOCKET_NULL;

   LogLog_verbose('Listener socket created: ' + %char(listener));
enddo;

if tmpListener <> SOCKET_NULL;
   rc = close(tmpListener);
   tmpListener = SOCKET_NULL;
endif;

return listener;

//
end-proc createListener;
//
//=====================================================================*
//  Produces a new client.
//=====================================================================*
dcl-proc acceptClient;
//
dcl-pi acceptClient;
  i_listener      int(10) const;
  io_clients      int(10) dim(cMAX_CLIENTS);
end-pi;
//
//  Helper fields
dcl-s x               int(10) inz;
dcl-s rc              int(10) inz;
dcl-s client          int(10) inz;
dcl-s addrLength      int(10) inz;
//
dcl-ds clientAddr likeds(sockaddr_in_t) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dou 1=1;

   // Accept incoming request
   addrLength = %size(clientAddr);
   rc = accept(i_listener: %addr(clientAddr): addrLength);
   if rc = SOCKET_ERROR;
      LogLog_error('accept()-error: ' + f_strerror(f_errno()));
      leave;
   endif;

   client = rc;

   // Lookup free client slot
   x = %lookup(SOCKET_NULL: io_clients);
   if x = 0;
      LogLog_debug('client-array-error: Array full');
      return;
   endif;

   // Add client to client list
   io_clients(x) = client;

   LogLog_debug('Accepted connection to client: ' + %char(client));
enddo;

return;

//
end-proc acceptClient;
//
//=====================================================================*
//  Make descritor sets for client descriptors.
//=====================================================================*
dcl-proc makeDescSets;
//
dcl-pi makeDescSets
       int(10);
  i_pipe          int(10) const;
  i_listener      int(10) const;
  i_clients       int(10) const  dim(cMAX_CLIENTS);
  o_readSet       like(socket_fdSet_t);
  o_writeSet      like(socket_fdSet_t);
  o_excpSet       like(socket_fdSet_t);
end-pi;
//
//  Return value
dcl-s maxDesc         int(10) inz;
//
//  Helper fields
dcl-s x               int(10) inz;
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

FD_ZERO(o_readSet);
FD_ZERO(o_writeSet);
FD_ZERO(o_excpSet);

// Build write set for client descriptors
for x = 1 to cMAX_CLIENTS;
   if i_clients(x) <> SOCKET_NULL;
      FD_SET(i_clients(x): o_writeSet);
      if i_clients(x) > maxDesc;
         maxDesc = i_clients(x);
      endif;
   endif;
endfor;

// Build read set for pipe and listener descriptor
FD_SET(i_pipe: o_readSet);
if i_pipe > maxDesc;
   maxDesc = i_pipe;
endif;

FD_SET(i_listener: o_readSet);
if i_listener > maxDesc;
   maxDesc = i_listener;
endif;

o_excpSet  = o_readSet;

return maxDesc;

//
end-proc makeDescSets;
//
