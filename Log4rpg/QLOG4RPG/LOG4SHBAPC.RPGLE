      /IF NOT DEFINED(PROTOTYPES_ONLY)
      *=====================================================================*
      *  SrvPgm: LOG4RPG - Object: XMLSocketHubAppender - Child Process     *
      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  14.11.2006                                              *
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
      *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                         *
      *                              MODULE(&LI/&OB        +                *
      *                                     &LI/LOG4SOCK ) +                *
      *                              ACTGRP(*NEW) +                         *
      *                              BNDDIR(QC2LE) +                        *
      *                              BNDSRVPGM(*LIBL/LOG4RPG   +            *
      *                                        *LIBL/BASICS1 ) +            *
      *                              TEXT('Tools/400 - Log4rpg +            *
      *                                    XMLSocketHubAppender       ') +  *
      *                              DETAIL(*BASIC);                        *
      *                                                                     *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
      /DEFINE UNIT_TEST
      /COPY QLOG4RPG,H_SPEC
      /COPY QLOG4RPG,COPYRIGHT
      *=====================================================================*
      /ENDIF
      *
      *  Program entry point
     D PGM_ENTRY_POINT...
     D                 PR                  extpgm('LOG4SHBAPC')
     D  gi_pipe                      10A   const
     D  gi_port                      10A   const
     D  gi_debugMode                 10A   const
     D  gi_output                    10A   const
      *
      /IF DEFINED(PROTOTYPES_ONLY)
      /EOF
      /ENDIF
      *
      * -----------------------------------------
      *  Type definitions
      * -----------------------------------------
     D buffer_t        S           2048A                           based(pDummy)
      *
      * -----------------------------------------
      *  Prototypes
      * -----------------------------------------
      /COPY QLOG4RPG,CLIB                          C-Library
      /COPY QBASICS1,PBASICS1                      Basic RPG Extensions
      *
      /COPY QLOG4RPG,PLOG4RPG                      Public interface & type definitions
      /COPY QLOG4RPG,PLOG4RPG10                    LogLog
      /COPY QLOG4RPG,PLOG4SOCK                     Socket Functions
      *
      * -----------------------------------------
      *  Private prototypes
      * -----------------------------------------
      *
     D XMLSocketHubAppender_childProcess...
     D                 PR
     D  i_pipe                       10I 0 value
     D  i_port                       10I 0 value
     D  i_debugMode                        value  like(LOG4RPG_debugMode_t  )
     D  i_output                           value  like(LOG4RPG_debugOutput_t)
      *
      *  Initializes client sockets.
     D initClients...
     D                 PR
     D  io_clients                   10I 0        dim(cMAX_CLIENTS)
      *
      *  Forward data to clients.
     D doCLients...
     D                 PR
     D  io_clients                   10I 0        dim(cMAX_CLIENTS)
     D  i_writeSet                         const  like(socket_fdSet_t)
     D  i_pBuffer                      *   const
     D  i_length                     10I 0 const
      *
      *  Closes client sockets.
     D closeClients...
     D                 PR
     D  io_clients                   10I 0        dim(cMAX_CLIENTS)
      *
      *  Closes client socket.
     D closeClient...
     D                 PR            10I 0
     D  io_client                    10I 0
      *
      *  Creates a new listener socket.
     D createListener...
     D                 PR            10I 0
     D  i_port                       10I 0 value
      *
      *  Produces a new client.
     D acceptClient...
     D                 PR
     D  i_listener                   10I 0 const
     D  io_clients                   10I 0        dim(cMAX_CLIENTS)
      *
      *  Make descritor sets for client descriptors.
     D makeDescSets...
     D                 PR            10I 0
     D  i_pipe                       10I 0 const
     D  i_listener                   10I 0 const
     D  i_clients                    10I 0 const  dim(cMAX_CLIENTS)
     D  o_readSet                                 like(socket_fdSet_t)
     D  o_writeSet                                like(socket_fdSet_t)
     D  o_excpSet                                 like(socket_fdSet_t)
      *
      * -----------------------------------------
      *  Global constants
      * -----------------------------------------
     D cMAX_CLIENTS    C                   const(32)
      *
      * -----------------------------------------
      *  Global fields
      * -----------------------------------------
      *
      *=====================================================================*
      *  XMLSocketHubAppender - Program Entry Point
      *=====================================================================*
      *  Parameters:
      *   gi_pipe       - Read descriptor of pipe of parent process.
      *   gi_port       - Listener port.
      *=====================================================================*
     D PGM_ENTRY_POINT...
     D                 PI
     D  gi_pipe                      10A   const
     D  gi_port                      10A   const
     D  gi_debugMode                 10A   const
     D  gi_output                    10A   const
      *
      *  Helper fields
     D pipe            S             10I 0 inz
     D port            S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         pipe = atoi(gi_pipe);
         port = atoi(gi_port);
 
         XMLSocketHubAppender_childProcess(pipe: port: gi_debugMode: gi_output);
 
         *inlr = *ON;
 
      /END-FREE
      *
      *=====================================================================*
      *  XMLSocketHubAppender - Child Process
      *=====================================================================*
     P XMLSocketHubAppender_childProcess...
     P                 B
      *
     D XMLSocketHubAppender_childProcess...
     D                 PI
     D  i_pipe                       10I 0 value
     D  i_port                       10I 0 value
     D  i_debugMode                        value  like(LOG4RPG_debugMode_t  )
     D  i_output                           value  like(LOG4RPG_debugOutput_t)
      *
      *  Helper fields
     D rc              S             10I 0 inz
     D maxDesc         S             10I 0 inz
     D readSet         S                   like(socket_fdSet_t) inz
     D writeSet        S                   like(socket_fdSet_t) inz
     D excpSet         S                   like(socket_fdSet_t) inz
     D wait            DS                  likeds(timeval_t   ) inz
      *
     D numBytes        S             10I 0 inz
     D buffer          S                   like(buffer_t  )  inz
      *
      *  Helper fields (house keeping)
     D listener        S             10I 0 inz(SOCKET_NULL)
     D clients         S             10I 0 dim(cMAX_CLIENTS) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         // Set internal logging to: ON
         Logger_setInternalDebugging(i_debugMode: i_output);
 
         // Show pipe read descriptor and listener port
         LogLog_verbose('Parameter: debug mode      = ' + i_debugMode);
         LogLog_verbose('Parameter: debug output    = ' + i_output   );
         LogLog_verbose('Parameter: pipe descriptor = ' + %char(i_pipe));
         LogLog_verbose('Parameter: listener port   = ' + %char(i_port));
 
         // Create listener socket
         listener = createListener(i_port);
         if listener = SOCKET_NULL;
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
 
      /END-FREE
      *
     P XMLSocketHubAppender_childProcess...
     P                 E
      *
      *=====================================================================*
      *  Initializes client sockets.
      *=====================================================================*
     P initClients...
     P                 B
      *
     D initClients...
     D                 PI
     D  io_clients                   10I 0        dim(cMAX_CLIENTS)
      *
      *  Helper fields
     D x               S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         for x = 1 to cMAX_CLIENTS;
            io_clients(x) = SOCKET_NULL;
         endfor;
 
         return;
 
      /END-FREE
      *
     P initClients...
     P                 E
      *
      *=====================================================================*
      *  Forward data to clients.
      *=====================================================================*
     P doClients...
     P                 B
      *
     D doCLients...
     D                 PI
     D  io_clients                   10I 0        dim(cMAX_CLIENTS)
     D  i_writeSet                         const  like(socket_fdSet_t)
     D  i_pBuffer                      *   const
     D  i_length                     10I 0 const
      *
      *  Helper fields
     D x               S             10I 0 inz
     D rc              S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P doClients...
     P                 E
      *
      *=====================================================================*
      *  Closes client sockets.
      *=====================================================================*
     P closeClients...
     P                 B
      *
     D closeClients...
     D                 PI
     D  io_clients                   10I 0        dim(cMAX_CLIENTS)
      *
      *  Helper fields
     D x               S             10I 0 inz
     D rc              S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
         for x = 1 to cMAX_CLIENTS;
            if io_clients(x) <> SOCKET_NULL;
               rc = closeClient(io_clients(x));
            endif;
         endfor;
 
         return;
 
      /END-FREE
      *
     P closeClients...
     P                 E
      *
      *=====================================================================*
      *  Closes client socket.
      *=====================================================================*
     P closeClient...
     P                 B
      *
     D closeClient...
     D                 PI            10I 0
     D  io_client                    10I 0
      *
      *  Return value
     D rc              S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
            rc = close(io_client);
 
            LogLog_debug('Closed client: ' + %char(io_client));
 
            io_client = SOCKET_NULL;
 
         return rc;
 
      /END-FREE
      *
     P closeClient...
     P                 E
      *
      *=====================================================================*
      *  Creates a new listener socket.
      *=====================================================================*
     P createListener...
     P                 B
      *
     D createListener...
     D                 PI            10I 0
     D  i_port                       10I 0 value
      *
      *  Return value
     D listener        S             10I 0 inz(SOCKET_ERROR)
      *
      *  Helper fields
     D rc              S             10I 0 inz
     D tmpListener     S                   like(listener    ) inz(SOCKET_NULL)
      *
     D sockAddr        DS                  likeds(sockaddr_in_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P createListener...
     P                 E
      *
      *=====================================================================*
      *  Produces a new client.
      *=====================================================================*
     P acceptClient...
     P                 B
      *
     D acceptClient...
     D                 PI
     D  i_listener                   10I 0 const
     D  io_clients                   10I 0        dim(cMAX_CLIENTS)
      *
      *  Helper fields
     D x               S             10I 0 inz
     D rc              S             10I 0 inz
     D client          S             10I 0 inz
     D addrLength      S             10I 0 inz
      *
     D clientAddr      DS                  likeds(sockaddr_in_t) inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P acceptClient...
     P                 E
      *
      *=====================================================================*
      *  Make descritor sets for client descriptors.
      *=====================================================================*
     P makeDescSets...
     P                 B
      *
     D makeDescSets...
     D                 PI            10I 0
     D  i_pipe                       10I 0 const
     D  i_listener                   10I 0 const
     D  i_clients                    10I 0 const  dim(cMAX_CLIENTS)
     D  o_readSet                                 like(socket_fdSet_t)
     D  o_writeSet                                like(socket_fdSet_t)
     D  o_excpSet                                 like(socket_fdSet_t)
      *
      *  Return value
     D maxDesc         S             10I 0 inz
      *
      *  Helper fields
     D x               S             10I 0 inz
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      /FREE
 
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
 
      /END-FREE
      *
     P makeDescSets...
     P                 E
      *
