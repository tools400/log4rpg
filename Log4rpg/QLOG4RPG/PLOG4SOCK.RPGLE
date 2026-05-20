**FREE
/IF NOT DEFINED(PLOG4SOCK)
/DEFINE PLOG4SOCK
//
// -----------------------------------------
//  Type definitions
// -----------------------------------------
dcl-s socket_fd_t
      int(10) based(pDummy);
dcl-s socket_fdSet_t
      char(28) based(pDummy);
//
// -----------------------------------------
//  RPG implementations of C macros
// -----------------------------------------
//
//  Set bit in file descriptor set.
dcl-pr FD_SET
       extproc('LOG4SOCK+
       _FD_SET+
       ');
  i_FD            const  like(socket_fd_t   );
  io_FDSet        like(socket_fdSet_t);
end-pr;
//
//  Clear bit in file descriptor set.
dcl-pr FD_CLR
       extproc('LOG4SOCK+
       _FD_CLR+
       ');
  i_FD            const  like(socket_fd_t   );
  io_FDSet        like(socket_fdSet_t);
end-pr;
//
//  Test bit in file descriptor set.
dcl-pr FD_ISSET
       ind
       extproc('LOG4SOCK+
       _FD_ISSET+
       ');
  i_FD            value  like(socket_fd_t   );
  i_FDSet         value  like(socket_fdSet_t);
end-pr;
//
//  Initialize file descriptor set with x'00'.
dcl-pr FD_ZERO
       extproc('LOG4SOCK+
       _FD_ZERO+
       ');
  io_FDSet        like(socket_fdSet_t);
end-pr;
//
//  Returns the IP address of the 5250 client of the
//  specified job.
dcl-pr Job_getTcpIpAddr
       varchar(15)
       extproc('LOG4SOCK+
       _Job_getTcpIpAddr+
       ');
  i_qJob          const  likeds(LOG4RPG_qJob_t)
options(*nopass);
end-pr;
//
// -----------------------------------------
//  Constants:
// -----------------------------------------
//
//  Error code
dcl-c SOCKET_ERROR const(-1);
//
//  Socket NULL
dcl-c SOCKET_NULL const(-2);
//
// -----------------------------------------
//  Constants:   QSYSINC/NETINET.IN
// -----------------------------------------
//
//  Macros to denote protocols
dcl-c IPPROTO_IP const(0);
dcl-c IPPROTO_ICMP const(1);
dcl-c IPPROTO_TCP const(6);
dcl-c IPPROTO_UDP const(17);
dcl-c IPPROTO_IPV6 const(41);
dcl-c IPPROTO_ROUTING
      const(43);
dcl-c IPPROTO_FRAGMENT
      const(44);
dcl-c IPPROTO_RAW const(255);
dcl-c IPPROTO_ICMPV6 const(58);
dcl-c IPPROTO_NONE const(59);
dcl-c IPPROTO_MAX const(256);
//
//  Macros for IP level options (via setsockopt() and getsockopt())
dcl-c IP_OPTIONS const( 5);
dcl-c IP_TOS const(10);
dcl-c IP_TTL const(15);
//
dcl-c IP_MULTICAST_IF
      const(20);
dcl-c IP_MULTICAST_TTL
      const(25);
dcl-c IP_MULTICAST_LOOP
      const(30);
dcl-c IP_ADD_MEMBERSHIP
      const(35);
dcl-c IP_DROP_MEMBERSHIP
      const(40);
dcl-c IP_DONTFRAG
      const(55);
dcl-c IP_RECVLCLIFADDR
      const(99);
//
//  Macros for Internet address specifications
dcl-c INADDR_ANY
      const(x'00000000');
dcl-c INADDR_BROADCAST
      const(x'FFFFFFFF');
dcl-c INADDR_LOOPBACK
      const(x'7F000001');
dcl-c INADDR_NONE
      const(x'FFFFFFFF');
//
dcl-c INADDR_UNSPEC_GROUP
      const(x'E0000000');                                                // 224.0.0.0
dcl-c INADDR_ALLHOSTS_GROUP
      const(x'E0000001');                                                // 224.0.0.1
dcl-c INADDR_MAX_LOCAL_GROUP
      const(x'E00000FF');                                                // 224.0.0.255
//
dcl-c INET_ADDRSTRLEN
      const(16);
dcl-c INET6_ADDRSTRLEN
      const(46);
//
//  Macros for port numbers
dcl-c IPPORT_RESERVED
      const(1024);
//
//  Macros defining multicast operation
dcl-c IP_DEFAULT_MULTICAST_TTL
      const(1);
dcl-c IP_DEFAULT_MULTICAST_LOOP
      const(1);
dcl-c IP_MAX_MEMBERSHIPS
      const(20);
//
// -----------------------------------------
//  Constants:   QSYSINC/SYS.SOCKET
// -----------------------------------------
//
//  Macros to denote address families
dcl-c AF_UNSPEC const( 0);
dcl-c AF_UNIX const( 1);
dcl-c AF_INET const( 2);
dcl-c AF_NS const( 6);
dcl-c AF_INET6 const(24);
dcl-c AF_UNIX_CCSID const(98);
dcl-c AF_TELEPHONY const(99);
//
//  Macros to denote type of socket
dcl-c SOCK_STREAM const(1);
dcl-c SOCK_DGRAM const(2);
dcl-c SOCK_RAW const(3);
dcl-c SOCK_SEQPACKET const(5);
//
//  Macros for socket level options (via setsockopt() & getsockopt())
dcl-c SO_BROADCAST const( 5);
dcl-c SO_DEBUG const(10);
dcl-c SO_DONTROUTE const(15);
dcl-c SO_ERROR const(20);
dcl-c SO_KEEPALIVE const(25);
//
dcl-c SO_LINGER const(30);
dcl-c SO_OOBINLINE const(35);
//
dcl-c SO_RCVBUF const(40);
dcl-c SO_RCVLOWAT const(45);
dcl-c SO_RCVTIMEO const(50);
dcl-c SO_REUSEADDR const(55);
dcl-c SO_SNDBUF const(60);
dcl-c SO_SNDLOWAT const(65);
dcl-c SO_SNDTIMEO const(70);
dcl-c SO_TYPE const(75);
dcl-c SO_USELOOPBACK const(80);
//
//  Macros to be used for the flag parameter of input/output routines
dcl-c MSG_DONTROUTE const(x'0001');
dcl-c MSG_OOB const(x'0004');
dcl-c MSG_PEEK const(x'0008');
dcl-c MSG_TRUNC const(x'0010');
dcl-c MSG_CTRUNC const(x'0020');
dcl-c MSG_WAITALL const(x'0040');
dcl-c MSG_EOR const(x'0080');
//
//  Miscellaneous macros
dcl-c MSG_MAXIOVLEN const(16);
dcl-c SOL_SOCKET const(-1);
dcl-c SOMAXCONN const(512);
//
//  Macros to be used for the flag parameter on send_file()
dcl-c SF_CLOSE const(1);
dcl-c SF_REUSE const(2);
//
//  Macros to be used for the how parameter on shutdown()
dcl-c SHUT_RD const(0);
dcl-c SHUT_WR const(1);
dcl-c SHUT_RDWR const(2);
//
//  Structures
dcl-ds linger
       qualified               based(pDummy);
  l_onoff         int(10);
  l_linger        int(10);
end-ds;
//
//  Generic socket address
dcl-ds sockaddr_t
       qualified               based(pDummy);
  sa_family       uns(5);
  sa_data         char(14);
end-ds;
//
//  Internet socket address
dcl-ds sockaddr_in_t
       qualified               based(pDummy);
  sin_family      uns(5);
  sin_port        uns(5);
  sin_addr        uns(10);
  sin_zero        char(8);
end-ds;
//
// -----------------------------------------
//  Constants:   QSYSINC/H.FCNTL
// -----------------------------------------
//
//  cmd Values for fcntl()
dcl-c F_DUPFD const(0);
dcl-c F_GETFD const(1);
dcl-c F_SETFD const(2);
dcl-c F_GETLK const(3);
dcl-c F_SETLK const(4);
dcl-c F_SETLKW const(5);
dcl-c F_GETFL const(6);
dcl-c F_SETFL const(7);
dcl-c F_GETOWN const(8);
dcl-c F_SETOWN const(9);
//
//  File Status Flags for open() and fcntl()
dcl-c O_NONBLOCK const(128);
dcl-c O_NDELAY const(128);
dcl-c FNDELAY const(128);
dcl-c FASYNC const(512);
//
// -----------------------------------------
//  Constants:   QSYSINC/SYS.TIME
// -----------------------------------------
//
dcl-ds timeval_t
       qualified               based(pDummy);
  tv_sec          int(10);
  tv_usec         int(10);
end-ds;
//
// -----------------------------------------
//  Socket Functions
// -----------------------------------------
//
// -----------------------------------------------------------------------
//  accept()--Wait for Connection Request and Make Connection
//    -1     (unsuccessful)
//     n     (successful), where n is a socket descriptor.
//
//  The accept() function is used to wait for connection requests.
//  accept() takes the first connection request on the queue of
//  pending connection requests and creates a new socket to service
//  the connection request.
// -----------------------------------------------------------------------
dcl-pr accept
       int(10) extproc('accept');
  i_sockDesc      int(10) value;
  o_pAddress      pointer value;
  io_pAddrLen     int(10);
end-pr;
//
// -----------------------------------------------------------------------
//  bind()--Set Local Address for Socket
//    -1     (unsuccessful)
//     0     (successful)
//
//  The bind() function is used to associate a local address with a
//  socket.
// -----------------------------------------------------------------------
dcl-pr bind
       int(10) extproc('bind');
  i_sockDesc      int(10) value;
  i_pAddress      pointer value;
  i_AddressLen    int(10) value;
end-pr;
//
// -----------------------------------------------------------------------
//  close()--Close File or Socket Descriptor
//     0      close() was successful.
//    -1      close() was not successful.
//            The errno global variable is set to indicate the error.
//
//  The close() function closes a descriptor, fildes. This frees the
//  descriptor to be returned by future open() calls and other calls
//  that create descriptors.
// -----------------------------------------------------------------------
/IF NOT DEFINED(c_close_function)
/DEFINE c_close_function
dcl-pr close
       int(10) extproc('close');
  i_fd            int(10) value;
end-pr;
/ENDIF
//
// -----------------------------------------------------------------------
//  connect()--Establish Connection or Destination Address
//    -1      (unsuccessful)
//     0      (successful)
//
//  The connect() function is used to establish a connection on a
//  connection-oriented socket or establish the destination address
//  on a connectionless socket.
// -----------------------------------------------------------------------
dcl-pr connect
       int(10) extproc('connect');
  i_fd            int(10) value;
  i_pAddress      pointer value;
  i_AddressLen    int(10) value;
end-pr;
//
// -----------------------------------------------------------------------
//  fcntl()--Perform File Control Command
//    value  fcntl() was successful.
//           The value returned depends on the command that was specified.
//    -1     fcntl() was not successful.
//           The errno global variable is set to indicate the error.
//
//  The fcntl() function performs various actions on open
//  descriptors, such as obtaining or changing the attributes of a
//  file or socket descriptor.
// -----------------------------------------------------------------------
dcl-pr fcntl
       int(10) extproc('fcntl');
  i_fd            int(10) value;
  i_command       int(10) value;
  i_arg           int(10) value options(*nopass);
end-pr;
//
// -----------------------------------------------------------------------
//  listen()--Invite Incoming Connections Requests
//    -1     (unsuccessful)
//     0     (successful)
//
//  The listen() function is used to indicate a willingness to accept
//  incoming connection requests. If a listen() is not done, incoming
//  connections are silently discarded.
// -----------------------------------------------------------------------
dcl-pr listen
       int(10) extproc('listen');
  i_socketDesc    int(10) value;
  i_BackLog       int(10) value;
end-pr;
//
// -----------------------------------------------------------------------
//  select()--Wait for Events on Multiple Sockets
//    -1     (unsuccessful)
//     0     (if the time limit expires)
//     n     (total number of descriptors in all sets that met selection criteria)
//
//  The select() function is used to enable an application to
//  multiplex I/O. By using select(), an application with multiple
//  interactive I/O sources avoids blocking on one I/O stream while
//  the other stream is ready. Thus, for example, an application that
//  receives inputs from two distinct communication endpoints (using
//  sockets) can use select() to sleep until input is available from
//  either of the sources. When input is available, the application
//  wakes up and receives an indication as to which descriptor is
//  ready for reading.
//
//  The application identifies descriptors to be checked for read,
//  write, and exception status and specifies a timeout value. If any
//  of the specified descriptors is ready for the specified event
//  (read, write, or exception), select() returns, indicating which
//  descriptors are ready. Otherwise, the process waits until one of
//  the specified events occur or the wait times out.
// -----------------------------------------------------------------------
dcl-pr select
       int(10) extproc('select');
  i_maxDesc       int(10) value;
  io_readSet      pointer value;
  io_writeSet     pointer value;
  io_excpSet      pointer value;
  i_waitTime      pointer value;
end-pr;
//
// -----------------------------------------------------------------------
//  send()--Send Data
//    -1     (unsuccessful)
//     n     (successful), where n is the number of bytes sent.
//
//  The send() function is used to send data through a connected
//  socket.
// -----------------------------------------------------------------------
dcl-pr send
       int(10) extproc('send');
  i_socketDesc    int(10) value;
  i_pBuffer       pointer value  options(*string);
  i_length        int(10) value;
  i_flags         int(10) value;
end-pr;
//
// -----------------------------------------------------------------------
//  setsockopt()--Set Socket Options
//    -1     (unsuccessful)
//     0     (successful)
//
//  The setsockopt() function is used to set socket options.
// -----------------------------------------------------------------------
dcl-pr setsockopt
       int(10) extproc('setsockopt');
  i_socketDesc    int(10) value;
  i_optLevel      int(10) value;
  i_optName       int(10) value;
  i_optValue      pointer value;
  i_optLen        int(10) value;
end-pr;
//
// -----------------------------------------------------------------------
//  getsockopt()--Retrieve Information about Socket Options
//    -1     (unsuccessful)
//     0     (successful)
//
//  The setsockopt() function is used to set socket options.
// -----------------------------------------------------------------------
dcl-pr getsockopt
       int(10) extproc('getsockopt');
  i_socketDesc    int(10) value;
  i_optLevel      int(10) value;
  i_optName       int(10) value;
  o_optValue      pointer value;
  io_optLen       int(10);
end-pr;
//
// -----------------------------------------------------------------------
//  socket()--Create Socket
//    -1     (unsuccessful)
//     n     (successful), where n is a socket descriptor.
//
//  The socket() function is used to create an end point for
//  communications. The end point is represented by the socket
//  descriptor returned by the socket() function.
// -----------------------------------------------------------------------
dcl-pr socket
       int(10) extproc('socket');
  i_addrFamily    int(10) value;
  i_socketType    int(10) value;
  i_protocol      int(10) value;
end-pr;
//
// -----------------------------------------------------------------------
//  gethostbyname()--Get Host Information for Host Name
//    NULL   (unsuccessful)
//       p   (successful), where p is a pointer to struct hostent.
//
//  The gethostbyname() function is used to retrieve information about a host.
// -----------------------------------------------------------------------
dcl-pr gethostbyname
       pointer extproc('gethostbyname');
  i_hostName      pointer value options(*string);
end-pr;
//
dcl-ds hostent_t
       qualified               based(pDummy);
  h_name          pointer;
  h_aliases       pointer;
  h_addrtype      int(5);
  h_length        int(5);
  h_addrlist      pointer;
end-ds;
//
// -----------------------------------------------------------------------
//  inet_addr()--Translate Full Address to 32-bit IP Address
//      -1   (unsuccessful)
//       n   (where n is the 32-bit IP address)
//
//  The inet_addr() function is used to translate an Internet address
//  from dotted decimal format to a 32-bit IP address.
// -----------------------------------------------------------------------
dcl-pr inet_addr
       uns(10) extproc('inet_addr');
  i_charAddr      pointer value options(*string);
end-pr;
//
/ENDIF
